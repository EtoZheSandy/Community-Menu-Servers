//-----------------------------------------------------
Msg("Activating VIP Escort: Split Decision\n");
Msg("Made by Rayman1103\n");

IncludeScript("split");
IncludeScript("vip_base");

VIPState <-
{
	HasPermaWipe = false
	SaveVIPData = true
	SaveVIPHealth = true
	VIPRules = "You must protect the Survivor at all cost! If his heart stops beating, so will yours"
}

AddDefaultsToTable( "VIPState", g_ModeScript, "MutationState", g_ModeScript );
