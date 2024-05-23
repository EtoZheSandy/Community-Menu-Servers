//-----------------------------------------------------
Msg("Activating Left 2 Survive\n");


MutationOptions <-
{
	ActiveChallenge = 1

	cm_NoSurvivorBots = 0

	cm_CommonLimit = 10
	cm_BaseCommonAttackDamage = 15
	cm_WanderingZombieDensityModifier = 0.015

	HunterLimit = 1
	SmokerLimit = 1
	ChargerLimit = 0
	JockeyLimit = 0
	SpitterLimit = 0

	weaponsToRemove =
	{
		weapon_pistol = 1
		weapon_smg = 1
		weapon_pumpshotgun = 1
		weapon_autoshotgun = 1
		weapon_rifle = 0
		weapon_hunting_rifle = 1
		weapon_smg_silenced = 1
		weapon_shotgun_chrome = 1
		weapon_rifle_desert = 1
		weapon_sniper_military = 1
		weapon_shotgun_spas = 1
		weapon_grenade_launcher = 1
		weapon_rifle_ak47 = 1
		weapon_smg_mp5 = 1		
		weapon_rifle_sg552 = 1		
		weapon_sniper_awp = 1	
		weapon_sniper_scout = 1
		weapon_rifle_m60 = 1
		weapon_melee = 1
		weapon_chainsaw = 1
		weapon_rifle_m60 = 1
		weapon_ammo = 1
		weapon_first_aid_kit = 1
		weapon_pain_pills = 1
		weapon_molotov = 1
		weapon_pipe_bomb = 1
		weapon_vomitjar = 1
		weapon_adrenaline = 1
		weapon_pistol_magnum = 1
		weapon_propanetank = 1
		weapon_oxygentank = 1
		weapon_upgradepack_incendiary = 1
		weapon_upgradepack_explosive = 1
		weapon_firework_crate = 1
		weapon_defibrilator = 1
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
		"weapon_first_aid_kit",
		"weapon_pain_pills",
		"weapon_molotov",
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
