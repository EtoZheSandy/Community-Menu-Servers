//-----------------------------------------------------
Msg("Activating Swarm\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	cm_ShouldHurry = 1
	ProhibitBosses = 1
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0

	cm_BaseCommonAttackDamage = 6

	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS

	weaponsToRemove =
	{
		weapon_first_aid_kit = 0
		weapon_molotov = 0
		weapon_pipe_bomb = 0
		weapon_vomitjar = 0
		weapon_adrenaline = 0
		weapon_pain_pills = 0
		ammo = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return false;
		}
		return true;
	}
	
	DefaultItems =
	[
		"weapon_pistol_magnum",
	]

	function GetDefaultItem( idx )
	{
		if ( idx < DefaultItems.len() )
		{
			return DefaultItems[idx];
		}
		return 0;
	}
}

MutationState <-
{
	SpacerString = "  "
	KillsInfo = "Zombies Destroyed"
	AllSurvivors = []
	
	function DisplayName(ind)
	{
		local p = GetPlayerFromCharacter(ind)
		if(p)
		{
			return (p.GetPlayerName())
		}
		else
		{
			return ""
		}
	}
	
	function DisplayScore(ind)
	{
		local p = GetPlayerFromCharacter(ind)
		if( (p) && (GetCharacterDisplayName( p ) in g_ModeScript.SurvivorStats.score) )
		{
			return (g_ModeScript.SurvivorStats.score[GetCharacterDisplayName( p )])
		}
		else
		{
			return ""
		}
	}
}

::SurvivorStats <-
{
	score = {}
}

::SurvivorStatsBackup <-
{
	score = {}
}

function GetTotalScore()
{
	local total = 0;
	
	for ( local i = 0; i < 4; i++ )
	{
		if ( SessionState.DisplayScore(i).tostring() != "" )
			total += SessionState.DisplayScore(i);
	}
	
	return total;
}

function OnShutdown()
{
	if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_ROUND_RESTART )
	{
		if ( IsMissionFinalMap() )
		{
			SaveTable( "Stats", SurvivorStats );
			SaveTable( "StatsBackup", SurvivorStats );
		}
		else
		{
			RestoreTable( "StatsBackup", SurvivorStatsBackup );
			SaveTable( "StatsBackup", SurvivorStatsBackup );
			SaveTable( "Stats", SurvivorStatsBackup );
		}
	}
	else if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_LEVEL_TRANSITION )
	{
		local nextMap = "";
		local changelevel = null;
		if ( changelevel = Entities.FindByClassname( changelevel, "info_changelevel" ) )
			nextMap = NetProps.GetPropString( changelevel, "m_mapName" );
		else if ( changelevel = Entities.FindByClassname( changelevel, "trigger_changelevel" ) )
			nextMap = NetProps.GetPropString( changelevel, "m_mapName" );

		if ( SessionState.NextMap != nextMap )
			return;

		SaveTable( "Stats", SurvivorStats );
		SaveTable( "StatsBackup", SurvivorStats );
	}
}

function OnGameEvent_round_start_post_nav( params )
{
	RestoreTable( "Stats", SurvivorStats );
	RestoreTable( "StatsBackup", SurvivorStatsBackup );
}

function ForcePanicThink()
{
	EntFire( "info_director", "ForcePanicEvent" );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ForcePanicThink()", 15.0 );
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( NetProps.GetPropInt( damageTable.Victim, "m_iTeamNum" ) == 2 )
	{
		if ( damageTable.Attacker.GetClassname() == "infected" )
		{
			if ( damageTable.Victim.IsIncapacitated() )
				damageTable.DamageDone = 2;
			else
				damageTable.DamageDone = 45;
		}
		else if ( NetProps.GetPropInt( damageTable.Attacker, "m_iTeamNum" ) == 2 )
			return false;
	}

	return true;
}

function OnGameEvent_player_entered_checkpoint( params )
{
	local character = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( !character )
		return;

	if ( NetProps.GetPropInt( character, "m_iTeamNum" ) == 3 )
		character.TakeDamage( character.GetMaxHealth(), 0, Entities.First() );
}

function OnGameEvent_player_death( params )
{
	local victim = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( !victim )
		return;
	
	local attacker = GetPlayerFromUserID( params["attacker"] );
	if ( ( !attacker ) || ( !attacker.IsSurvivor() ) )
		return;
	
	if ( victim.GetClassname() == "infected" )
		SurvivorStats.score[GetCharacterDisplayName( attacker )]++;
}

function OnGameEvent_revive_success( params )
{
	local player = GetPlayerFromUserID( params["subject"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;
	
	player.SetHealth( 50 );
	player.SetHealthBuffer( 0 );
}

function OnGameEvent_player_left_safe_area( params )
{
	if ( !Entities.FindByClassname( null, "trigger_finale" ) )
		ForcePanicThink();
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.SetHealthBuffer( 0 );
	player.SetHealth( player.GetMaxHealth() );
	player.SetReviveCount( 0 );
	NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
	StopSoundOn( "Player.Heartbeat", player );
	if ( !(GetCharacterDisplayName( player ) in SurvivorStats.score) )
		SurvivorStats.score[GetCharacterDisplayName( player )] <- 0;
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) || (SessionState.AllSurvivors.find( player ) != null) )
		return;

	SessionState.AllSurvivors.append( player );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}

function SetupModeHUD()
{
	StatHUD <-
	{
		Fields =
		{
			info = 
			{
				slot = HUD_SCORE_TITLE ,
				datafunc = @() SessionState.KillsInfo,
				name = "info",
				flags = DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
			}
			total = 
			{
				slot = HUD_MID_BOX ,
				datafunc = @() g_ModeScript.GetTotalScore(),
				name = "total",
				flags = DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
			}
			name0 = 
			{
				slot = HUD_FAR_LEFT ,
				datafunc = @() SessionState.DisplayName(0) + SessionState.SpacerString + "(" + SessionState.DisplayScore(0) + ")",
				name = "name0",
				flags = DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
			name1 = 
			{
				slot = HUD_MID_TOP ,
				datafunc = @() SessionState.DisplayName(1) + SessionState.SpacerString + "(" + SessionState.DisplayScore(1) + ")",
				name = "name1",
				flags = DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
			name2 = 
			{
				slot = HUD_FAR_RIGHT ,
				datafunc = @() "(" + SessionState.DisplayScore(2) + ")" + SessionState.SpacerString + SessionState.DisplayName(2),
				name = "name2",
				flags = DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_NOBG,
			}
			name3 = 
			{
				slot = HUD_MID_BOT ,
				datafunc = @() "(" + SessionState.DisplayScore(3) + ")" + SessionState.SpacerString + SessionState.DisplayName(3),
				name = "name3",
				flags = DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_NOBG,
			}
		}
	}
	HUDPlace( HUD_FAR_LEFT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_TOP, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_FAR_RIGHT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOT, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOX, 0.0, 0.04, 1.0, 0.045 );
	HUDPlace( HUD_SCORE_TITLE, 0.0, 0.00, 1.0, 0.045 );
	HUDSetLayout( StatHUD );
}

function Update()
{
	foreach( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
		{
			if ( survivor.GetHealth() < survivor.GetMaxHealth() )
				survivor.SetHealth( survivor.GetHealth() + 1 );
		}
	}
}
