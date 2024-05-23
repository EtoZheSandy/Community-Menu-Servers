//-----------------------------------------------------
Msg("Activating BooM60\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

MutationOptions <-
{
	ActiveChallenge = 1
	BileMobSize = 35
	cm_CommonLimit = 35
	cm_MaxSpecials = 15
	cm_DominatorLimit = 15
	BoomerLimit = 15
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	cm_SpecialRespawnInterval = 0
	cm_AggressiveSpecials = 1
	SpecialInitialSpawnDelayMin = 5
	SpecialInitialSpawnDelayMax = 5
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	ProhibitBosses = true

	weaponsToRemove =
	{
		weapon_pistol = 0
		weapon_pistol_magnum = 0
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
		weapon_molotov = 0
		weapon_vomitjar = 0
		weapon_upgradepack_incendiary = 0
		weapon_upgradepack_explosive = 0
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
	//weaponsToConvert =
	//{
	//	weapon_pain_pills = 	"weapon_adrenaline_spawn"
	//}

	//function ConvertWeaponSpawn( classname )
	//{
	//	if ( classname in weaponsToConvert )
	//	{
	//		return weaponsToConvert[classname];
	//	}
	//	return 0;
	//}

	DefaultItems =
	[
		"weapon_pistol_magnum",
		"weapon_rifle_m60",
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
	EntFire( "tankdoorout_button", "Unlock" );
	EntFire( "tank_sound_timer", "Kill" );
}
