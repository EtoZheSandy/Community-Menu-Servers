//-----------------------------------------------------
Msg("Activating Hunter Barrage\n");
Msg("Made by Rayman1103\n");


MutationOptions <-
{
	ActiveChallenge = 1

	cm_AggressiveSpecials = 1
	cm_CommonLimit = 0
	cm_AutoReviveFromSpecialIncap = 1
	cm_DominatorLimit = 14
	cm_MaxSpecials = 14
	cm_SpecialRespawnInterval = 8
	SpecialInitialSpawnDelayMin = 5
	SpecialInitialSpawnDelayMax = 5

	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 14
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0

	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_pipe_bomb = "weapon_molotov_spawn"
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
		weapon_defibrillator = 0
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
