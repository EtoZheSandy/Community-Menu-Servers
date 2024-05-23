//-----------------------------------------------------
Msg("Activating Horror 4 Two: Mercenaries\n");


MutationOptions <-
{
	ActiveChallenge = 1

	

	cm_CommonLimit = 20
	cm_WanderingZombieDensityModifier = 0.015

	MaxSpecials = 2

	weaponsToRemove =
	{
		weapon_pistol = 0
		weapon_sniper_military = 0
		weapon_melee = 0
		weapon_chainsaw = 0
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

