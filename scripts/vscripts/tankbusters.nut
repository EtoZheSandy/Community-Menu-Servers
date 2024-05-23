//-----------------------------------------------------
Msg("Activating Tank Busters\n");


MutationOptions <-
{
	ActiveChallenge = 1

//	cm_frustrationTimer = 0
	cm_TankRun = 1
	cm_ShouldHurry = 1

	PreferredSpecialDirection = SPAWN_BEHIND_SURVIVORS
	BehindSurvivorsSpawnDistance = 2000
	TankRunSpawnDelay = 5

	MobMaxPending = 0

	// Always convert to the TANK!!!
	function ConvertZombieClass( iClass )
	{
		return 8;
	}	

	weaponsToRemove =
	{
		weapon_pistol = 0
		weapon_smg = 0
		weapon_pumpshotgun = 0
		weapon_autoshotgun = 0
		weapon_rifle = 0
		weapon_hunting_rifle = 0
		weapon_smg_silenced = 0
		weapon_shotgun_chrome = 0
		weapon_rifle_desert = 0
		weapon_sniper_military = 0
		weapon_shotgun_spas = 0
		weapon_pistol_magnum = 0
		weapon_rifle_ak47 = 0
		weapon_smg_mp5 = 0		
		weapon_rifle_sg552 = 0		
		weapon_sniper_awp = 0	
		weapon_sniper_scout = 0
		weapon_rifle_m60 = 0
		weapon_melee = 0
		weapon_chainsaw = 0
		weapon_rifle_m60 = 0
		weapon_ammo = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return false;
		}
		return true;
	}

	function ShouldAvoidItem( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return true;
		}
		return false;
	}

	DefaultItems =
	[
		"weapon_grenade_launcher",
	]

	function GetDefaultItem( idx )
	{
		if ( idx < DefaultItems.len() )
		{
			return DefaultItems[idx];
		}
		return 0;
	}

	weaponsToConvert =
	{
		weapon_first_aid_kit = "weapon_pain_pills_spawn"
	}

	function ConvertWeaponSpawn( classname )
	{
		if ( classname in weaponsToConvert )
		{
			return weaponsToConvert[classname];
		}
		return 0;
	}
}
