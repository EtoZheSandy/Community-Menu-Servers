//-----------------------------------------------------
Msg("Activating Sky Burst\n");
Msg("Made by Rayman1103\n");

// Various director settings
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
	SurvivorMaxIncapacitatedCount = 0

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
		"weapon_pipe_bomb",
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
	HPRegenDelay = 3.0
	AllSurvivors = []
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
				damageTable.DamageDone = 40;
		}
	}

	return true;
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

function OnGameEvent_round_start_post_nav( params )
{
	EntFire( "prop_minigun", "Kill" );
	EntFire( "prop_minigun_l4d1", "Kill" );
	EntFire( "prop_mounted_machine_gun", "Kill" );

	EntFire( "weapon_spawn", "Kill" );
	foreach( wep, val in MutationOptions.weaponsToRemove )
		EntFire( wep + "_spawn", "Kill" );
}

function OnGameEvent_player_death( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
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
}