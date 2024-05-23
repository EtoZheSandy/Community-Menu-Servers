//-----------------------------------------------------
Msg("Activating L4D1 Darkness Falls\n");
Msg("Made by ==Maverick==\n");

Skyboxes <- [
   "0"
]

worldspawn <- Entities.FindByClassname ( null, "worldspawn" );
local i = RandomInt( 0, Skyboxes.len()-1 );
printl("Skybox is "+Skyboxes[i]);
printl( worldspawn.__KeyValueFromString( "timeofday", Skyboxes[i] ) );


MutationOptions <-
{
	ActiveChallenge = 1
	
	SpitterLimit = 0
	JockeyLimit = 0
	ChargerLimit = 0
	
	weaponsToRemove =
	{
		upgrade_item = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return false;
		}
		return true;
	}
	
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
		weapon_sniper_awp = "weapon_hunting_rifle_spawn"
		weapon_sniper_scout = "weapon_hunting_rifle_spawn"
		weapon_adrenaline = "weapon_pain_pills_spawn"
		weapon_vomitjar = "weapon_molotov_spawn"
		weapon_defibrillator =	"weapon_first_aid_kit_spawn"
		weapon_upgradepack_incendiary = "weapon_first_aid_kit_spawn"
		weapon_upgradepack_explosive = "weapon_first_aid_kit_spawn"
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

function Update()
{
	if( Director.GetCommonInfectedCount() >= 1 )
	{
		u <- null;
		while( ( u = Entities.FindByModel( u, "models/infected/common_male_ceda.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, u );
		}
		while( ( u = Entities.FindByModel( u, "models/infected/common_male_clown.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, u );
		}
		while( ( u = Entities.FindByModel( u, "models/infected/common_male_fallen_survivor.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, u );
		}
		while( ( u = Entities.FindByModel( u, "models/infected/common_male_jimmy.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, u );
		}
		while( ( u = Entities.FindByModel( u, "models/infected/common_male_mud.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, u );
		}
		while( ( u = Entities.FindByModel( u, "models/infected/common_male_riot.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, u );
		}
		while( ( u = Entities.FindByModel( u, "models/infected/common_male_roadcrew.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, u );
		}
		while( ( u = Entities.FindByModel( u, "models/infected/common_male_roadcrew_rain.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, u );
		}
	}
}
