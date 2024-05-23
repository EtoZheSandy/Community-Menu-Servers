//-----------------------------------------------------
Msg("Activating Versus Co-Op No Kits\n");
Msg("Made by Rayman1103\n");


MutationOptions <-
{
	// Challenge vars
	ActiveChallenge = 1
	cm_TempHealthOnly = 1
	cm_AllowPillConversion = 0

	weaponsToRemove =
	{
		weapon_first_aid_kit = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return false;
		}
		return true;
	}

	weaponsToConvert =
	{
		weapon_defibrillator = "weapon_pain_pills_spawn"
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

	TempHealthDecayRate = 0.001
	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 0.05 // pain_pills_decay_rate default 0.27
		}
	}
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
}
