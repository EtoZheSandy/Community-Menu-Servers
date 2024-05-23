//-----------------------------------------------------
Msg("Activating Gun Game: Swarm\n");
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
		weapon_pistol = 0
		weapon_pistol_magnum = 0
		weapon_smg = 0
		weapon_pumpshotgun = 0
		weapon_autoshotgun = 0
		weapon_rifle = 0
		weapon_hunting_rifle = 0
		weapon_smg_silenced = 0
		weapon_shotgun_chrome = 0
		weapon_rifle_desert = 0
		weapon_sniper_military = 0
		weapon_shotgun_spas = 0
		weapon_grenade_launcher = 0
		weapon_rifle_ak47 = 0
		weapon_smg_mp5 = 0
		weapon_rifle_sg552 = 0
		weapon_sniper_awp = 0   
		weapon_sniper_scout = 0
		weapon_rifle_m60 = 0
		//weapon_melee = 0
		weapon_chainsaw = 0
		weapon_pipe_bomb = 0
		weapon_molotov = 0
		weapon_vomitjar = 0
		weapon_first_aid_kit = 0
		weapon_pain_pills = 0
		weapon_adrenaline = 0
		//weapon_defibrillator = 0
		//weapon_upgradepack_incendiary = 0
		//weapon_upgradepack_explosive = 0
		//upgrade_item = 0
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
	
	function ShouldAvoidItem( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return true;
		}
		return false;
	}
	
	DefaultItems =
	[
		
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
	PlayerGun = {}
	PlayerKills = {}
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

::GunState <-
{
	GunProgress = {}
}

::SurvivorStats <-
{
	score = {}
}

::SurvivorStatsBackup <-
{
	score = {}
}

::ListOfWeps <-
[
	"random_melee"
	"chainsaw"
	"pistol"
	"dual_pistols"
	"pistol_magnum"
	"sniper_scout"
	"pumpshotgun"
	"sniper_awp"
	"shotgun_chrome"
	"smg"
	"smg_silenced"
	"sniper_military"
	"hunting_rifle"
	"rifle_desert"
	"smg_mp5"
	"rifle_sg552"
	"shotgun_spas"
	"rifle_ak47"
	"autoshotgun"
	"rifle"
	"pipe_bomb"
	"molotov"
	"rifle_m60"
	"grenade_launcher"
]

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
				damageTable.DamageDone = 15; //45
		}
		else if ( damageTable.Attacker.IsPlayer() )
		{
			if ( damageTable.Attacker.IsSurvivor() && IsPlayerABot( damageTable.Attacker ) )
				return false;
		}
	}
	else
	{
		if ( damageTable.DamageType == ( DirectorScript.DMG_BLAST | DirectorScript.DMG_BLAST_SURFACE ) )
			damageTable.DamageDone = 1000;
	}

	return true;
}

function GiveWeapons( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	local invTable = {};
	GetInvTable( player, invTable );
	foreach( slot, weapon in invTable )
	{
		if ( slot == "slot0" || slot == "slot1" || slot == "slot2" )
			weapon.Kill();
	}
	
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveAdvancedGun(" + userid + ")", 0.1 );
}

function GiveAdvancedGun( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	local weapon = ListOfWeps[GunState.GunProgress[ GetCharacterDisplayName( player ) ]];
	if ( weapon == "dual_pistols" )
	{
		player.GiveItem( "pistol" );
		player.GiveItem( "pistol" );
	}
	else if ( weapon == "random_melee" )
	{
		local melee = SpawnMeleeWeapon( "any", Vector( 0, 0, 0 ), QAngle( 0, 0, 0 ) );
		if ( melee )
		{
			DoEntFire( "!self", "Use", "", 0, player, melee );
			DoEntFire( "!self", "Kill", "", 0.1, null, melee );
		}
	}
	else
	{
		player.GiveItem( weapon );
	
		local items = {};
		GetInvTable( player, items );
		foreach( item in items )
		{
			if ( item.GetClassname() == "weapon_" + weapon )
				SessionState.PlayerGun[ GetCharacterDisplayName( player ) ] <- item;
		}
	}
}

function AdvanceGun( player )
{
	local invTable = {};
	GetInvTable( player, invTable );

	local weapon = ListOfWeps[ GunState.GunProgress[ GetCharacterDisplayName( player ) ] ];
	if ( weapon == "dual_pistols" )
	{
		invTable["slot1"].Kill();
		//invTable["slot1"].Kill();
	}
	else if ( weapon == "random_melee" )
		invTable["slot1"].Kill();
	else
	{
		foreach( item in invTable )
		{
			if ( item.GetClassname() == "weapon_" + weapon )
				item.Kill();
		}
	}
	
	if ( weapon == "grenade_launcher" )
		GunState.GunProgress[ GetCharacterDisplayName( player ) ] = 0;
	else
		GunState.GunProgress[ GetCharacterDisplayName( player ) ]++;

	SessionState.PlayerKills[ GetCharacterDisplayName( player ) ] = 0;
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveAdvancedGun(" + player.GetPlayerUserId() + ")", 0.1 );
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
		SaveTable( "gungame_progress", GunState.GunProgress );
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
		SaveTable( "gungame_progress", GunState.GunProgress );
	}
}

function OnGameEvent_round_start_post_nav( params )
{
	RestoreTable( "Stats", SurvivorStats );
	RestoreTable( "StatsBackup", SurvivorStatsBackup );
	RestoreTable( "gungame_progress", GunState.GunProgress );

	EntFire( "weapon_spawn", "Kill" );
	foreach( wep, val in MutationOptions.weaponsToRemove )
		EntFire( wep + "_spawn", "Kill" );
	
	for ( local melee_spawn; melee_spawn = Entities.FindByClassname( melee_spawn, "weapon_melee_spawn" ); )
		melee_spawn.Kill();
	
	EntFire( "weapon_pipe_bomb", "Kill" );
	EntFire( "weapon_molotov", "Kill" );
	EntFire( "weapon_vomitjar", "Kill" );
}

function OnGameEvent_player_death( params )
{
	local victim = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( !victim )
		return;
	
	if ( NetProps.GetPropInt( victim, "m_iTeamNum" ) == 2 )
	{
		local weapon = ListOfWeps[ GunState.GunProgress[ GetCharacterDisplayName( victim ) ] ];
		if ( weapon != "pistol" && weapon != "dual_pistols" && weapon != "random_melee" && weapon != "chainsaw" )
			SessionState.PlayerGun[ GetCharacterDisplayName( victim ) ].Kill();
	}
	else
	{
		local attacker = GetPlayerFromUserID( params["attacker"] );
		if ( (attacker) && (attacker.IsSurvivor()) && (victim.GetClassname() == "infected") )
		{
			local weapon = params["weapon"];
			local weapon_progress = ListOfWeps[ GunState.GunProgress[ GetCharacterDisplayName( attacker ) ] ];

			if ( weapon == "entityflame" || weapon == "inferno" )
				weapon = "molotov";
			else if ( weapon == "grenade_launcher_projectile" )
				weapon = "grenade_launcher";
			else if ( weapon == "melee" )
				weapon = "random_melee";
			
			if ( weapon == weapon_progress )
				SessionState.PlayerKills[ GetCharacterDisplayName( attacker ) ]++;

			if ( SessionState.PlayerKills[ GetCharacterDisplayName( attacker ) ] >= 5 )
				AdvanceGun( attacker );
			
			g_ModeScript.SurvivorStats.score[ GetCharacterDisplayName( attacker ) ]++;
		}
	}
}

function OnGameEvent_player_entered_checkpoint( params )
{
	local character = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( !character )
		return;

	if ( NetProps.GetPropInt( character, "m_iTeamNum" ) == 3 )
		character.TakeDamage( character.GetMaxHealth(), 0, Entities.First() );
}

function OnGameEvent_revive_success( params )
{
	local player = GetPlayerFromUserID( params["subject"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;
	
	local weapon = ListOfWeps[ GunState.GunProgress[ GetCharacterDisplayName( player ) ] ];
	if ( weapon != "pistol" && weapon != "dual_pistols" )
	{
		local invTable = {};
		GetInvTable( player, invTable );
		if ( "slot1" in invTable )
			invTable["slot1"].Kill();
	}
	player.SetHealth( 50 );
	player.SetHealthBuffer( 0 );
}

function OnGameEvent_defibrillator_used( params )
{
	if ( !("subject" in params) )
		return;
	
	local player = GetPlayerFromUserID( params["subject"] );
	
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;
	
	local weapon = ListOfWeps[ GunState.GunProgress[ GetCharacterDisplayName( player ) ]] ;
	if ( weapon != "random_melee" && weapon != "chainsaw" )
		GiveWeapons( params["subject"] );
}

function OnGameEvent_survivor_rescued( params )
{
	if ( !("victim" in params) )
		return;

	GiveWeapons( params["victim"] );
}

function ForcePanicThink()
{
	EntFire( "info_director", "ForcePanicEvent" );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ForcePanicThink()", 15.0 );
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

	if ( !(GetCharacterDisplayName( player ) in GunState.GunProgress) )
		GunState.GunProgress[ GetCharacterDisplayName( player ) ] <- 0;
	
	SessionState.PlayerGun[ GetCharacterDisplayName( player ) ] <- null;
	SessionState.PlayerKills[ GetCharacterDisplayName( player ) ] <- 0;

	if ( !(GetCharacterDisplayName( player ) in SurvivorStats.score) )
		SurvivorStats.score[ GetCharacterDisplayName( player ) ] <- 0;

	player.SetHealthBuffer( 0 );
	player.SetHealth( player.GetMaxHealth() );
	player.SetReviveCount( 0 );
	NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
	StopSoundOn( "Player.Heartbeat", player );

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveWeapons(" + userid + ")", 0.1 );
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
