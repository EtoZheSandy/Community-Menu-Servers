//-----------------------------------------------------
Msg("Activating ZSL Infestation\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

IncludeScript("zsl_survival_base");

ZSLOptions <-
{
	HunterLimit = 12
	TankLimit = 4
	cm_TankLimit = 4
	SurvivorMaxIncapacitatedCount = 0

	RandomPrimary =
	[
		"autoshotgun",
		"rifle",
		"rifle_desert",
		"sniper_military",
		"shotgun_spas",
		"rifle_ak47"
	]
	RandomSecondary =
	[
		"weapon_pistol_magnum",
	]
	
	RandomTertiary =
	[
		"weapon_adrenaline",
	]
	
	function GetDefaultItem(id)
	{
		local PRand = RandomInt(0,RandomPrimary.len()-1);
		local SRand = RandomInt(0,RandomSecondary.len()-1);
		local TRand = RandomInt(0,RandomTertiary.len()-1);
		if(id == 0) return RandomPrimary[PRand];
		else if(id == 1) return RandomSecondary[SRand];
		else if(id == 2) return RandomTertiary[TRand];
		return 0;
	}
}

AddDefaultsToTable( "ZSLOptions", g_ModeScript, "MutationOptions", g_ModeScript );
