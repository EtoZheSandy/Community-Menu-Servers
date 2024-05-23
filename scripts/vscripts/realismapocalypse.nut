//-----------------------------------------------------
Msg("Activating Realism Apocalypse\n");


MutationOptions <-
{
	ActiveChallenge = 1

	cm_WanderingZombieDensityModifier = 0.03
	cm_CommonLimit = 25
	cm_BaseCommonAttackDamage = 1
	cm_MaxSpecials = 2
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS

	HunterLimit = 1
	SmokerLimit = 1
	ChargerLimit = 1
	JockeyLimit = 1
	SpitterLimit = 1
	
	weaponsToRemove =
	{
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

	DefaultItems =
	[
		"weapon_pistol_magnum",
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

