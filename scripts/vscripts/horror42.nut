//-----------------------------------------------------
Msg("Activating Horror 4 Two\n");


MutationOptions <-
{
	ActiveChallenge = 1

	

	cm_CommonLimit = 10
	cm_WanderingZombieDensityModifier = 0.015

	MaxSpecials = 1

	weaponsToRemove =
	{
		weapon_pistol = 0
		weapon_smg = 0
		weapon_autoshotgun = 0
		weapon_rifle = 0
		weapon_hunting_rifle = 0
		weapon_smg_silenced = 0
		weapon_rifle_desert = 0
		weapon_sniper_military = 0
		weapon_shotgun_spas = 0
		weapon_rifle_ak47 = 0
		weapon_smg_mp5 = 0		
		weapon_rifle_sg552 = 0		
		weapon_sniper_awp = 0	
		weapon_sniper_scout = 0
		weapon_rifle_m60 = 0
		weapon_melee = 0
		weapon_chainsaw = 0
		weapon_rifle_m60 = 0
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
		"weapon_pumpshotgun",
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

