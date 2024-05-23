//-----------------------------------------------------
Msg("Activating VIP Escort: Dead End\n");
Msg("Made by Rayman1103\n");

IncludeScript("deadend");
IncludeScript("vip_base");

VIPState <-
{
	HasPermaWipe = true
	SaveVIPData = true
	VIPRules = "The Survivor's heartbeat is linked to yours, if he dies, everyone dies. However everyone has 1 life, you will reach your Dead End permanently if you die once."
}

AddDefaultsToTable( "VIPState", g_ModeScript, "MutationState", g_ModeScript );
