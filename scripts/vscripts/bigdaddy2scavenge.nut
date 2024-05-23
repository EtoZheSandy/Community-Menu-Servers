//-----------------------------------------------------
Msg("Activating Big Daddy Scavenge\n");
Msg("Made by Rayman1103\n");


MutationOptions <-
{
	ActiveChallenge = 1

	cm_AggressiveSpecials = 1
	//cm_CommonLimit = 35
	cm_DominatorLimit = 4
	//cm_NoSurvivorBots = 0
	cm_MaxSpecials = 4
	cm_SpecialRespawnInterval = 5
	SpecialInitialSpawnDelayMin = 20
	SpecialInitialSpawnDelayMax = 20
	InfectedFlags = INFECTED_FLAG_CANT_SEE_SURVIVORS | INFECTED_FLAG_CANT_HEAR_SURVIVORS | INFECTED_FLAG_CANT_FEEL_SURVIVORS
	
	HunterLimit = 0
	SmokerLimit = 0
	ChargerLimit = 1
	JockeyLimit = 0
	SpitterLimit = 0
	BoomerLimit = 3
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0

	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_autoshotgun	= "weapon_pumpshotgun_spawn"
		weapon_shotgun_spas	= "weapon_shotgun_chrome_spawn"
		weapon_sniper_awp	= "weapon_hunting_rifle_spawn"
		weapon_sniper_military	= "weapon_hunting_rifle_spawn"
		weapon_sniper_scout	= "weapon_hunting_rifle_spawn"
		weapon_rifle	= "weapon_smg_spawn"
		weapon_rifle_ak47	= "weapon_smg_silenced_spawn"
		weapon_rifle_desert	= "weapon_smg_spawn"
		weapon_rifle_sg552	= "weapon_smg_mp5_spawn"
	}

	function ConvertWeaponSpawn( classname )
	{
		if ( classname in weaponsToConvert )
		{
			return weaponsToConvert[classname];
		}
		return 0;
	}

	weaponsToRemove =
	{
		weapon_grenade_launcher = 0
		weapon_rifle_m60 = 0
		weapon_chainsaw = 0
		weapon_molotov = 0
		weapon_pipe_bomb = 0
		weapon_vomitjar = 0
		weapon_pain_pills = 0
		weapon_adrenaline = 0
		weapon_first_aid_kit = 0
		weapon_defibrillator = 0
		weapon_upgradepack_incendiary = 0
		weapon_upgradepack_explosive = 0
		weapon_melee = 0
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
		"weapon_first_aid_kit",
		"weapon_pain_pills",
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

function AllowTakeDamage( damageTable )
{
	local DMG_CLUB = 128;
	try
	{
		if( damageTable.Attacker.GetZombieType() == 2 && damageTable.Victim.IsSurvivor() )
		{
			ScriptedDamageInfo.DamageDone = 1
			return true
		}
		if( damageTable.Attacker.GetZombieType() !=6 && damageTable.DamageType == DMG_CLUB && damageTable.Victim.IsSurvivor() )
		{
			ScriptedDamageInfo.DamageDone = 0.5
			return true
		}
	}
	catch( error )
	{
		
	}
	return true
}

function OnGameEvent_charger_pummel_start( params )
{
	Charger <- null;
	while( ( Charger = Entities.FindByModel( Charger, "models/infected/charger.mdl" ) ) != null )
	{
		Msg("Charger pummelling survivor, setting health to 6000\n");
		Charger.SetHealth(6000);
	}
}

function OnGameEvent_charger_pummel_end( params )
{
	Charger <- null;
	while( ( Charger = Entities.FindByModel( Charger, "models/infected/charger.mdl" ) ) != null )
	{
		Msg("Charger not pummelling survivor, setting health to 99999\n");
		Charger.SetHealth(99999);
	}
}
