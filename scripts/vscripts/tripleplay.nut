//-----------------------------------------------------
Msg("Activating Three Throws\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	ActiveChallenge = 1
	cm_AllowSurvivorRescue = 0
	cm_CommonLimit = 0
	cm_DominatorLimit = 14
	cm_MaxSpecials = 14
	cm_SpecialRespawnInterval = 3
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
		//"weapon_molotov",
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
	LastHPRegenTime = 0
	HPRegenDelay = 2.0
	AllSurvivors = []
	Throwables = [ "molotov", "pipe_bomb", "vomitjar" ]
}

function OnGameplayStart()
{
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SwitchThrowable()", 20.0 );
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	local victimTeam = NetProps.GetPropInt( damageTable.Victim, "m_iTeamNum" );
	if ( victimTeam == 3 )
	{
		if ( (damageTable.Inflictor) && (damageTable.Inflictor.GetClassname() == "pipe_bomb_projectile") )
		{
			if ( damageTable.Victim.GetClassname() == "infected" )
			{
				damageTable.DamageDone = 1000;
				return true;
			}
			else if ( damageTable.Victim.GetClassname() == "witch" )
			{
				damageTable.DamageDone = 200;
				return true;
			}
			else if ( damageTable.Victim.IsPlayer() )
			{
				if ( damageTable.Victim.GetZombieType() == DirectorScript.ZOMBIE_TANK )
				{
					damageTable.DamageDone = 600;
					return true;
				}
				else
				{
					damageTable.DamageDone = 1000;
					return true;
				}
			}
		}
	}
	else if ( victimTeam == 2 )
	{
		if ( (damageTable.Inflictor) && (damageTable.Inflictor.GetClassname() == "pipe_bomb_projectile") )
			return false;
		else if ( damageTable.Attacker.GetClassname() == "infected" )
		{
			if ( damageTable.Victim.IsIncapacitated() )
				damageTable.DamageDone = 25;
			else
				damageTable.DamageDone = 20;
		}
	}

	return true;
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

function SwitchThrowable()
{
	foreach( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
		{
			local invTable = {};
			GetInvTable( survivor, invTable );
			foreach( weapon in invTable )
				weapon.Kill();

			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveThrowable(" + survivor.GetPlayerUserId() + ")", 0.1 );
		}
	}
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SwitchThrowable()", 20.0 );
}

function GiveThrowable( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.GiveItem( SessionState.Throwables[ RandomInt( 0, SessionState.Throwables.len() - 1 ) ] );
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

	local invTable = {};
	GetInvTable( player, invTable );
	foreach( weapon in invTable )
		weapon.Kill();
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveThrowable(" + userid + ")", 0.1 );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) || (SessionState.AllSurvivors.find( player ) != null) )
		return;

	SessionState.AllSurvivors.append( player );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
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

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	
	if ( ( !victim ) || ( !victim.IsSurvivor() ) )
		return;
	
	EntFire( "survivor_death_model", "BecomeRagdoll" );
}

function Update()
{
	if ( (Time() - SessionState.LastHPRegenTime) >= SessionState.HPRegenDelay )
	{
		foreach( survivor in SessionState.AllSurvivors )
		{
			if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
			{
				if ( survivor.GetHealth() < survivor.GetMaxHealth() )
					survivor.SetHealth( survivor.GetHealth() + 1 );
			}
		}
		SessionState.LastHPRegenTime = Time();
	}
	if ( Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
}
