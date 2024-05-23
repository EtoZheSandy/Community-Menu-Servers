//-----------------------------------------------------
Msg("Activating Hardcore Special Delivery\n");
Msg("Made by Rayman1103\n");

IncludeScript("community1");

HardcoreSDOptions <-
{
	cm_AggressiveSpecials = true
}

AddDefaultsToTable( "HardcoreSDOptions", g_ModeScript, "MutationOptions", g_ModeScript );
