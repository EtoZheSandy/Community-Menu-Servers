//-----------------------------------------------------
Msg("Activating Immoral Support\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

MutationOptions <-
{
	cm_AggressiveSpecials = 1
	cm_AutoReviveFromSpecialIncap = 1
	//cm_CommonLimit = 40
	cm_DominatorLimit = 4
	cm_MaxSpecials = 4
	cm_SpecialRespawnInterval = 20
	SpecialInitialSpawnDelayMin = 10
	SpecialInitialSpawnDelayMax = 15
	ShouldAllowSpecialsWithTank = true
	SurvivorMaxIncapacitatedCount = 1
	ZombieTankHealth = 10
	MobMinSize = 15
	MobMaxSize = 20
	InfectedFlags = INFECTED_FLAG_CANT_SEE_SURVIVORS | INFECTED_FLAG_CANT_HEAR_SURVIVORS | INFECTED_FLAG_CANT_FEEL_SURVIVORS
	
	SmokerLimit = 1
	BoomerLimit = 1
	HunterLimit = 1
	SpitterLimit = 1
	JockeyLimit = 1
	ChargerLimit = 1
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
		"weapon_pistol",
		"weapon_pistol",
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
		if ( damageTable.Attacker.IsSurvivor() )
		{
			if ( (damageTable.Victim.IsPlayer()) && (!damageTable.Victim.IsSurvivor()) )
				return false;
		}
		else
		{
			if ( damageTable.Attacker.GetZombieType() > 0 && damageTable.Attacker.GetZombieType() < 7 )
			{
				if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_SPITTER && damageTable.DamageType != (1 << 7) )
					return true;
				else
				{
					ScriptedDamageInfo.DamageDone = 5;
					return true;
				}
			}
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

	SessionOptions.TankLimit <- 1;
	SessionOptions.cm_TankLimit <- 1;
	ZSpawn( { type = DirectorScript.ZOMBIE_TANK } );
}

function OnGameEvent_round_start_post_nav( params )
{
	EntFire( "weapon_spawn", "Kill" );
	foreach( wep, val in MutationOptions.weaponsToRemove )
		EntFire( wep + "_spawn", "Kill" );
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

function Update()
{
	for ( local jimmy; jimmy = Entities.FindByModel( jimmy, "models/infected/common_male_jimmy.mdl" ); )
		jimmy.Kill();
}
