//-----------------------------------------------------
Msg("Activating Special Delivery Versus\n");
Msg("Made by Rayman1103\n");

IncludeScript("community1");

VersusSDOptions <-
{
	cm_SpecialSlotCountdownTime = 0

	SmokerLimit = 1
	BoomerLimit = 1
	HunterLimit = 1
	SpitterLimit = 1
	JockeyLimit = 1
	ChargerLimit = 1
}

AddDefaultsToTable( "VersusSDOptions", g_ModeScript, "MutationOptions", g_ModeScript );
