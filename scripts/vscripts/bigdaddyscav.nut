//-----------------------------------------------------
Msg("Activating Mutation 17\n");


MutationOptions <-
{
	ActiveChallenge = 1

	cm_NoSurvivorBots = 0

	cm_CommonLimit = 35
	cm_BaseCommonAttackDamage = 3
	
	HunterLimit = 0
	SmokerLimit = 0
	ChargerLimit = 1
	JockeyLimit = 0
	SpitterLimit = 3
	BoomerLimit = 0
	TankLimit = 0

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

	weaponsToRemove =
	{
		weapon_sniper_scout = 0
		weapon_rifle_m60 = 0
		weapon_chainsaw = 0
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
