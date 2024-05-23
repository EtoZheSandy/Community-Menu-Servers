//-----------------------------------------------------
Msg("Activating Low Gravity\n");
Msg("Made by Rayman1103\n");


MutationOptions <-
{
	ActiveChallenge = 1

	HunterLimit = 3
	SmokerLimit = 2
	ChargerLimit = 1
	JockeyLimit = 1
	SpitterLimit = 0
	BoomerLimit = 1
	SpecialInitialSpawnDelayMin = 20
	SpecialInitialSpawnDelayMax = 20

	weaponsToRemove =
	{
		weapon_first_aid_kit = 0
		weapon_pain_pills = 0
		weapon_adrenaline = 0
		weapon_defibrillator = 0
		weapon_pipe_bomb = 0
		weapon_molotov = 0
		weapon_vomitjar = 0
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
		"weapon_pistol",
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
