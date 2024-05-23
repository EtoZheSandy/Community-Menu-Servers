//-----------------------------------------------------
Msg("Activating Mutation L4D2\n");
Msg("Made by Rayman1103\n");


MutationOptions <-
{
	ActiveChallenge = 1

	SmokerLimit = 0
	BoomerLimit = 0
	HunterLimit = 0

	weaponsToConvert =
	{
		weapon_autoshotgun				= "weapon_shotgun_spas_spawn"
		weapon_hunting_rifle			= "weapon_sniper_military_spawn"
		weapon_pumpshotgun				= "weapon_shotgun_chrome_spawn"
		weapon_rifle					= "weapon_rifle_ak47_spawn"
		weapon_smg						= "weapon_smg_silenced_spawn"
		weapon_pistol					= "weapon_pistol_magnum_spawn"
		weapon_pipe_bomb				= "weapon_vomitjar_spawn"
		weapon_molotov					= "weapon_vomitjar_spawn"
		weapon_pain_pills				= "weapon_adrenaline_spawn"
		weapon_first_aid_kit			= "weapon_defibrillator_spawn"
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
