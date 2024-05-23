//-----------------------------------------------------
Msg("Activating Special Force\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

IncludeScript("ass_base");

ASSOptions <-
{
	cm_DominatorLimit = 20
	cm_MaxSpecials = 20
	cm_SpecialRespawnInterval = 5
	ShouldAllowSpecialsWithTank = true
	
	SmokerLimit = 5
	BoomerLimit = 2
	HunterLimit = 3
	SpitterLimit = 2
	JockeyLimit = 3
	ChargerLimit = 5

	TempHealthDecayRate = 0.334 //0.001
}

AddDefaultsToTable( "ASSOptions", g_ModeScript, "MutationOptions", g_ModeScript );
