//-----------------------------------------------------
Msg("Activating VIP Escort: Infestation\n");
Msg("Made by Rayman1103\n");

IncludeScript("infestation");
IncludeScript("vip_base");

VIPOptions <-
{
	SurvivorMaxIncapacitatedCount = 1
}

VIPState <-
{
	HasPermaWipe = false
	SaveVIPData = true
	VIPRules = "You must protect the Survivor at all cost! If his heart stops beating, so will yours!"
}

AddDefaultsToTable( "VIPOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "VIPState", g_ModeScript, "MutationState", g_ModeScript );
