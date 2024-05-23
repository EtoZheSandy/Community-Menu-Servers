//-----------------------------------------------------
Msg("Activating VIP Escort: Tank Splitters\n");
Msg("Made by Rayman1103\n");

IncludeScript("tanksplitters");
IncludeScript("vip_base");

VIPOptions <-
{
	SurvivorMaxIncapacitatedCount = 1
	TempHealthDecayRate = 0.001
}

VIPState <-
{
	HasPermaWipe = false
	SaveVIPData = false
	VIPRules = "You must protect the Survivor at all cost! If his heart stops beating, so will yours!"
}

AddDefaultsToTable( "VIPOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "VIPState", g_ModeScript, "MutationState", g_ModeScript );

::VIPData.givemedkits <- false;
