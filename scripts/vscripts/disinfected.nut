//-----------------------------------------------------
Msg("Activating Disinfected\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	cm_CommonLimit = 0
	cm_DominatorLimit = 14
	cm_MaxSpecials = 14
	cm_SpecialRespawnInterval = 7
	cm_TankLimit = 10
	cm_WitchLimit = 10
	BoomerLimit = 1
	SmokerLimit = 2
	HunterLimit = 4
	ChargerLimit = 3
	SpitterLimit = 1
	JockeyLimit = 3
	SpecialInitialSpawnDelayMin = 10
	SpecialInitialSpawnDelayMax = 10
	ShouldAllowSpecialsWithTank = true
	cm_AggressiveSpecials = 1
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	cm_AutoReviveFromSpecialIncap = 1

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
		weapon_defibrillator = 0
		weapon_pipe_bomb = 0
		weapon_vomitjar = 0
		weapon_molotov = 0
		weapon_adrenaline = 0
		weapon_pain_pills = 0
		weapon_first_aid_kit = 0
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
		"weapon_vomitjar",
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
	Spawn2ndTank = true
	AllSurvivors = []
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( NetProps.GetPropInt( damageTable.Attacker, "m_iTeamNum" ) == 3 && damageTable.Victim.IsPlayer() )
	{
		if ( damageTable.Victim.GetZombieType() > 0 && damageTable.Victim.GetZombieType() < 7 )
			damageTable.DamageDone = 1000;
	}

	return true;
}

function KillInfected( infectedID, attackerID )
{
	local infected = GetPlayerFromUserID( infectedID );
	local attacker = GetPlayerFromUserID( attackerID );
	if ( !infected || !attacker )
		return;

	infected.TakeDamage( infected.GetHealth(), 0, attacker );

	if ( NetProps.GetPropInt( infected, "m_lifeState" ) == 0 )
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillInfected(" + infectedID + "," + attackerID + ")", 0.1 );
}

function KillWitch( witchIndex, attackerID )
{
	local witch = EntIndexToHScript( witchIndex );
	local attacker = GetPlayerFromUserID( attackerID );
	if ( !witch || !attacker )
		return;

	witch.TakeDamage( witch.GetHealth(), 0, attacker );
}

function OnGameEvent_player_now_it( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (player.IsSurvivor()) )
		return;

	local KillTimer = 3.0;
	if ( player.GetZombieType() == DirectorScript.ZOMBIE_TANK )
		KillTimer = 20.0;

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillInfected(" + params["userid"] + "," + params["attacker"] + ")", KillTimer );
}

function OnGameEvent_witch_harasser_set( params )
{
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillWitch(" + params["witchid"] + "," + params["userid"] + ")", 6.9 );
}

function OnGameEvent_tank_spawn( params )
{
	local tank = GetPlayerFromUserID( params["userid"] );
	if ( !tank )
		return;

	tank.SetMaxHealth( 1000 );
	tank.SetHealth( 1000 );

	if ( SessionState.Spawn2ndTank )
	{
		SessionState.Spawn2ndTank = false;
		ZSpawn( { type = DirectorScript.ZOMBIE_TANK, pos = tank.GetOrigin() } );
	}
}

function OnGameEvent_tank_killed( params )
{
	SessionState.Spawn2ndTank = true;
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	
	if ( ( !victim ) || ( !victim.IsSurvivor() ) )
		return;
	
	EntFire( "survivor_death_model", "BecomeRagdoll" );
}

function OnGameEvent_round_start_post_nav( params )
{
	for ( local spawner; spawner = Entities.FindByClassname( spawner, "info_zombie_spawn" ); )
	{
		local population = NetProps.GetPropString( spawner, "m_szPopulation" );

		if ( population == "boomer" || population == "hunter" || population == "smoker" || population == "jockey"
			|| population == "charger" || population == "spitter" || population == "new_special" || population == "church"
				|| population == "tank" || population == "witch" || population == "witch_bride" || population == "river_docks_trap" )
			continue;
		else
			spawner.Kill();
	}

	if ( SessionState.MapName == "AirCrash" )
	{
		EntFire( "breakwall1", "Break" );
		EntFire( "breakwall2", "Break" );
		EntFire( "breakwall_stop", "Kill" );
	}

	EntFire( "weapon_spawn", "Kill" );
	foreach( wep, val in MutationOptions.weaponsToRemove )
		EntFire( wep + "_spawn", "Kill" );

	EntFire( "prop_minigun", "Kill" );
	EntFire( "prop_minigun_l4d1", "Kill" );
	EntFire( "prop_mounted_machine_gun", "Kill" );
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
	if ( (!player) || (!player.IsSurvivor()) || (SessionState.AllSurvivors.find( player ) != null) )
		return;

	SessionState.AllSurvivors.append( player );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
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
