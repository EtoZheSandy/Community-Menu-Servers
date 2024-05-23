//-----------------------------------------------------
Msg("Activating VIP Escort: Special Surprise\n");
Msg("Made by Rayman1103\n");

IncludeScript("specialsurprise");
IncludeScript("vip_base");

VIPState <-
{
	HasPermaWipe = false
	SaveVIPData = true
	VIPRules = "The Survivor's heartbeat is linked to yours, if he dies, everyone dies. There are no incaps, if you go down, you're dead."
}

AddDefaultsToTable( "VIPState", g_ModeScript, "MutationState", g_ModeScript );
