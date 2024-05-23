//-----------------------------------------------------
Msg("Activating VIP Escort: Three Throws\n");
Msg("Made by Rayman1103\n");

IncludeScript("tripleplay");
IncludeScript("vip_base");

VIPState <-
{
	HasPermaWipe = false
	SaveVIPData = false
	VIPRules = "You must protect the Survivor at all cost! If his heart stops beating, so will yours!"
}

AddDefaultsToTable( "VIPState", g_ModeScript, "MutationState", g_ModeScript );

::VIPData.givemedkits <- false;
