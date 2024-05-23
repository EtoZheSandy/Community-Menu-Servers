//-----------------------------------------------------
Msg("Activating Melee Versus\n");


MutationOptions <-
{
	ActiveChallenge = 1

	cm_CommonLimit = 15
	//cm_MaxSpecials = 4
	//cm_DominatorLimit = 4
	BoomerLimit = 1
	SmokerLimit = 0
	HunterLimit = 2
	ChargerLimit = 0
	SpitterLimit = 1
	JockeyLimit = 0
	//TankLimit = 0
	//cm_TankLimit = 0

	weaponsToRemove =
	{
		weapon_pistol = 0
		//weapon_pistol_magnum = 0
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
		weapon_grenade_launcher = 0
		weapon_rifle_ak47 = 0
		weapon_smg_mp5 = 0		
		weapon_rifle_sg552 = 0		
		weapon_sniper_awp = 0	
		weapon_sniper_scout = 0
		weapon_rifle_m60 = 0
		weapon_chainsaw = 0
		//weapon_defibrillator = 0
		//weapon_pain_pills = 0
		//weapon_adrenaline = 0
		//weapon_first_aid_kit = 0
		weapon_molotov = 0
		weapon_pipe_bomb = 0
		weapon_vomitjar = 0
		weapon_upgradepack_incendiary = 0
		weapon_upgradepack_explosive = 0
		//weapon_melee = 0
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

	function ShouldAvoidItem( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return true;
		}
		return false;
	}
	
	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_melee = 	"weapon_pistol_magnum_spawn"
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
		"fireaxe",
		"frying_pan",
		"machete",
		"crowbar",
		"cricket_bat",
		"tonfa",
		"katana",
		"electric_guitar",
		"knife",
		"golfclub",
		"baseball_bat",
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

function OnGameEvent_round_start_post_nav( params )
{
	EntFire( "prop_minigun", "Kill" );
	EntFire( "prop_minigun_l4d1", "Kill" );
	EntFire( "prop_mounted_machine_gun", "Kill" );
}

function OnGameEvent_player_left_safe_area( params )
{
	EntFire( "weapon_pistol_magnum_spawn", "Kill" );
}
