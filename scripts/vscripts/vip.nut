//-----------------------------------------------------
Msg("Activating VIP Escort\n");
Msg("Made by Rayman1103\n");

IncludeScript("vip_base");

VIPState <-
{
	HasPermaWipe = false
	SaveVIPData = true
	VIPRules = "The Survivors heartbeat is linked to yours, if he dies everyone dies. There are no incaps, if you go down you're dead."
}

AddDefaultsToTable( "VIPState", g_ModeScript, "MutationState", g_ModeScript );

// TODO why is this here???
/*function OnGameEvent_heal_success( params )
{
	local player = GetPlayerFromUserID( params["subject"] );
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;
	
	if ( NetProps.GetPropInt( player, "m_survivorCharacter" ) == 9 )
	{
		player.SetReviveCount( 2 );
		NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
		NetProps.SetPropInt( player, "m_isGoingToDie", 0 );
	}
}*/
