Msg("Activating Mutation One Man Army \n");

MutationOptions <-
{
	ActiveChallenge = 1
	cm_NoSurvivorBots = 1
	cm_CommonLimit = 0
	cm_DominatorLimit = 6
	cm_MaxSpecials = 6
	cm_SpecialRespawnInterval = 25
	cm_AutoReviveFromSpecialIncap = 1
	cm_AllowPillConversion = 0
	MobMaxPending = 0
	SurvivorMaxIncapacitatedCount = 1
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 3
	//TankHitDamageModifierCoop = 0.5
	JockeyLimit = 1
	ChargerLimit = 1
	BoomerLimit = 1
	SmokerLimit = 0
	HunterLimit = 1
	SpitterLimit = 1
	ProhibitBosses = 1

	weaponsToConvert =
	{
		weapon_pistol = "weapon_hunting_rifle_spawn"
		weapon_smg = "weapon_rifle_spawn"
		weapon_smg_silenced = "weapon_rifle_ak47_spawn"
		weapon_pumpshotgun = "weapon_autoshotgun_spawn"
		weapon_shotgun_chrome = "weapon_shotgun_spas_spawn"

	}
	function ConvertWeaponSpawn( classname )
	{
		if ( classname in weaponsToConvert )
		{
			return weaponsToConvert[classname];
		}
		return 0;
	}
	
	DefaultItems =
	[
		"weapon_pistol",
		"weapon_pistol",
		"weapon_smg",
		"weapon_smg_silenced",
		"weapon_pumpshotgun",
		"weapon_shotgun_chrome",
		"weapon_pistol_magnum",
		"weapon_rifle_desert",
		"weapon_rifle_ak47",
		"weapon_autoshotgun",
		"weapon_shotgun_spas",
		"weapon_hunting_rifle",
		"weapon_sniper_military",
		"weapon_rifle",
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
}

function Update()
{
	if ( Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
}
