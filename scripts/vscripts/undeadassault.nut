//-----------------------------------------------------
Msg("Activating Undead Assault\n");
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
	SurvivorMaxIncapacitatedCount = 1

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
		weapon_molotov = 0
		weapon_pipe_bomb = 0
		weapon_vomitjar = 0
		weapon_chainsaw = 0
		weapon_defibrillator = 0
		weapon_adrenaline = 0
		weapon_pain_pills = 0
		weapon_first_aid_kit = 0
		weapon_melee = 0
		weapon_upgradepack_explosive = 0
		weapon_upgradepack_incendiary = 0
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
		"weapon_rifle_m60",
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
	
	TempHealthDecayRate = 0.001
	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 0.75 // pain_pills_decay_rate default 0.27
		}
	}
}

MutationState <-
{
	SpacerString = "  "
	KillsInfo = "Zombies Destroyed"
	PlayerKills = {}
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
		if( (p) && (GetCharacterDisplayName( p ) in PlayerKills) )
		{
			return (PlayerKills[GetCharacterDisplayName( p )])
		}
		else
		{
			return ""
		}
	}
}

function OnGameplayStart()
{
	Say( null, "Get hit and you will become infected, once your health reaches zero after being infected you will die.", false );
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
			damageTable.DamageDone = 1000;
	}

	return true;
}

function OnGameEvent_player_death( params )
{
	local victim = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( !victim )
		return;
	
	if ( (victim.IsPlayer()) && (victim.IsSurvivor()) )
	{
		EntFire( "survivor_death_model", "BecomeRagdoll" );
		return;
	}

	local attacker = GetPlayerFromUserID( params["attacker"] );
	if ( ( !attacker ) || ( !attacker.IsSurvivor() ) )
		return;
	
	if ( victim.GetClassname() == "infected" )
		SessionState.PlayerKills[GetCharacterDisplayName( attacker )]++;
}

function OnGameEvent_player_incapacitated( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.ReviveFromIncap();
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
	if ( !(GetCharacterDisplayName( player ) in SessionState.PlayerKills) )
		SessionState.PlayerKills[GetCharacterDisplayName( player )] <- 0;
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
				slot = HUD_MID_BOX ,
				datafunc = @() SessionState.KillsInfo,
				name = "info",
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
	HUDPlace( HUD_MID_BOX, 0.0, 0.00, 1.0, 0.045 );
	HUDSetLayout( StatHUD );
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
	foreach( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 && NetProps.GetPropInt( survivor, "m_currentReviveCount" ) > 0 )
		{
			if ( survivor.GetHealth() <= 1 )
				survivor.TakeDamage( survivor.GetMaxHealth(), 0, Entities.First() );
		}
	}
}

local undeadassault_rules =
[
	{
		name = "RevivedByFriendOverride",
		criteria = [ [ "concept", "RevivedByFriend" ] ],
		responses = [ { scenename = "" } ],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	},
	{
		name = "PlayerIncapacitatedOverride",
		criteria = [ [ "concept", "PlayerIncapacitated" ] ],
		responses = [ { scenename = "" } ],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	}
]
g_rr.rr_ProcessRules( undeadassault_rules );
