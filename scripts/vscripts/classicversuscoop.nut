//-----------------------------------------------------
Msg("Activating Classic Versus Co-Op\n");

Skyboxes <- [
   "0"
]

worldspawn <- Entities.FindByClassname (null, "worldspawn");
local i = RandomInt(0,Skyboxes.len()-1);
printl("Skybox is "+Skyboxes[i]);
printl( worldspawn.__KeyValueFromString("timeofday",Skyboxes[i]) );


MutationOptions <-
{
	ActiveChallenge = 1
	
	SpitterLimit = 0
	JockeyLimit = 0
	ChargerLimit = 0
	cm_SpitterLimit = 0
	cm_JockeyLimit = 0
	cm_ChargerLimit = 0
	
	weaponsToRemove =
	{
		weapon_pistol_magnum = 0
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
		weapon_upgradepack_incendiary = 0
		weapon_upgradepack_explosive = 0
		weapon_melee = 0
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

last_set <- 0
function Update()
{
	if(Time() >= last_set + 1 && Director.GetCommonInfectedCount() >= 1)
	{
		u <- null;
		while((u = Entities.FindByModel(u,"models/infected/common_male_ceda.mdl")) != null)
		{
			DoEntFire("!self", "kill", "", 0, null, u);
		}
		u <- null;
		while((u = Entities.FindByModel(u,"models/infected/common_male_clown.mdl")) != null)
		{
			DoEntFire("!self", "kill", "", 0, null, u);
		}
		u <- null;
		while((u = Entities.FindByModel(u,"models/infected/common_male_fallen_survivor.mdl")) != null)
		{
			DoEntFire("!self", "kill", "", 0, null, u);
		}
		u <- null;
		while((u = Entities.FindByModel(u,"models/infected/common_male_jimmy.mdl")) != null)
		{
			DoEntFire("!self", "kill", "", 0, null, u);
		}
		u <- null;
		while((u = Entities.FindByModel(u,"models/infected/common_male_mud.mdl")) != null)
		{
			DoEntFire("!self", "kill", "", 0, null, u);
		}
		u <- null;
		while((u = Entities.FindByModel(u,"models/infected/common_male_riot.mdl")) != null)
		{
			DoEntFire("!self", "kill", "", 0, null, u);
		}
		u <- null;
		while((u = Entities.FindByModel(u,"models/infected/common_male_roadcrew.mdl")) != null)
		{
			DoEntFire("!self", "kill", "", 0, null, u);
		}
		u <- null;
		while((u = Entities.FindByModel(u,"models/infected/common_male_roadcrew_rain.mdl")) != null)
		{
			DoEntFire("!self", "kill", "", 0, null, u);
		}
		last_set = Time();
	}
}
