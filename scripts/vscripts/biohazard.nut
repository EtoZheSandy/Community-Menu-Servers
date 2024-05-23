//-----------------------------------------------------
Msg("Activating Biohazard\n");
Msg("Made by Rayman1103\n");


MutationOptions <-
{
	ActiveChallenge = 1
	cm_DominatorLimit = 5
	cm_MaxSpecials = 5
	SpecialInitialSpawnDelayMin = 30
	SpecialInitialSpawnDelayMax = 30
	ShouldAllowSpecialsWithTank = true

	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_defibrillator =	"weapon_first_aid_kit_spawn"
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
		weapon_pipe_bomb = 0
		weapon_vomitjar = 0
		weapon_molotov = 0
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
	
}
