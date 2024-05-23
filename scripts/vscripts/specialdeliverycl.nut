//-----------------------------------------------------
Msg("Activating Classic Special Delivery\n");
Msg("Made by Rayman1103\n");

IncludeScript("community1");

Entities.First().__KeyValueFromString( "timeofday", "0" );

ClassicSDOptions <-
{
	SmokerLimit = 3
	BoomerLimit = 2
	HunterLimit = 3
	SpitterLimit = 0
	JockeyLimit = 0
	ChargerLimit = 0
	
	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_pistol_magnum = "weapon_pistol_spawn"
		weapon_melee = "weapon_pistol_spawn"
		weapon_smg_silenced = "weapon_smg_spawn"
		weapon_shotgun_chrome = "weapon_pumpshotgun_spawn"
		weapon_sniper_military = "weapon_hunting_rifle_spawn"
		weapon_shotgun_spas = "weapon_autoshotgun_spawn"
		weapon_rifle_desert = "weapon_rifle_spawn"
		weapon_rifle_ak47 = "weapon_rifle_spawn"
		weapon_grenade_launcher = "weapon_autoshotgun_spawn"
		weapon_rifle_m60 = "weapon_rifle_spawn"
		weapon_smg_mp5 = "weapon_smg_spawn"
		weapon_rifle_sg552 = "weapon_rifle_spawn"
		weapon_sniper_awp =	"weapon_hunting_rifle_spawn"
		weapon_sniper_scout = "weapon_hunting_rifle_spawn"
		weapon_adrenaline =	"weapon_pain_pills_spawn"
		weapon_vomitjar = "weapon_molotov_spawn"
		weapon_pipe_bomb = "weapon_molotov_spawn"
		weapon_defibrillator = "weapon_first_aid_kit_spawn"
		weapon_upgradepack_incendiary = "weapon_first_aid_kit_spawn"
		weapon_upgradepack_explosive = "weapon_first_aid_kit_spawn"
	}
	
	DefaultItems =
	[
		"weapon_pistol",
		"weapon_pistol",
	]
}

AddDefaultsToTable( "ClassicSDOptions", g_ModeScript, "MutationOptions", g_ModeScript );
