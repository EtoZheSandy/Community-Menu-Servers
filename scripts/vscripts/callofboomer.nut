//-----------------------------------------------------
Msg("Activating Call of Boomer\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

MutationOptions <-
{
	cm_AggressiveSpecials = 1
	cm_CommonLimit = 40
	cm_DominatorLimit = 6
	cm_MaxSpecials = 6
	cm_SpecialRespawnInterval = 10
	SpecialInitialSpawnDelayMin = 10
	SpecialInitialSpawnDelayMax = 10
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	//ShouldAllowMobsWithTank = true
	ShouldAllowSpecialsWithTank = true
	SurvivorMaxIncapacitatedCount = 1
	ZombieTankHealth = 1 //10
	MobMinSize = 15
	MobMaxSize = 20
	InfectedFlags = INFECTED_FLAG_CANT_SEE_SURVIVORS | INFECTED_FLAG_CANT_HEAR_SURVIVORS | INFECTED_FLAG_CANT_FEEL_SURVIVORS
	
	SmokerLimit = 0
	BoomerLimit = 6
	HunterLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	ChargerLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0

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
		weapon_melee = 0
		weapon_chainsaw = 0
		weapon_pipe_bomb = 0
		weapon_molotov = 0
		weapon_vomitjar = 0
		weapon_first_aid_kit = 0
		weapon_pain_pills = 0
		weapon_adrenaline = 0
		weapon_defibrillator = 0
		weapon_upgradepack_incendiary = 0
		weapon_upgradepack_explosive = 0
		upgrade_item = 0
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
		"weapon_smg_silenced",
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
}

MutationState <-
{
	SpawnedSurvivors = []
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( damageTable.Attacker.IsPlayer() )
	{
		if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_BOOMER )
		{
			ScriptedDamageInfo.DamageDone = 1;
			return true;
		}
		else if ( damageTable.Attacker.IsSurvivor() && damageTable.Victim.IsPlayer() )
		{
			if ( damageTable.Victim.GetZombieType() == DirectorScript.ZOMBIE_BOOMER || damageTable.Victim.GetZombieType() == DirectorScript.ZOMBIE_TANK )
				return false;
		}
	}
	else
	{
		if ( damageTable.Attacker.GetClassname() == "infected" )
		{
			ScriptedDamageInfo.DamageDone = 1;
			return true;
		}
	}

	return true;
}

function AllowBash( basher, bashee )
{
	if ( basher.IsSurvivor() && bashee.GetClassname() == "infected" )
		return ALLOW_BASH_PUSHONLY;
}

function OnGameEvent_player_now_it( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	SessionOptions.TankLimit <- 6;
	SessionOptions.cm_TankLimit <- 6;
	ZSpawn( { type = DirectorScript.ZOMBIE_TANK } );
}

function OnGameEvent_player_incapacitated( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.ReviveFromIncap();
}

function OnGameEvent_round_start_post_nav( params )
{
	EntFire( "weapon_spawn", "Kill" );
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
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( SessionState.SpawnedSurvivors.find( player ) == null )
	{
		SessionState.SpawnedSurvivors.append( player );
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
	}
}
