//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: The Last of Us\n");

IncludeScript("lastofus");
IncludeScript("gungame_base");

GunGameOptions <-
{
	cm_CommonLimit = 45 //25
}

AddDefaultsToTable( "GunGameOptions", g_ModeScript, "MutationOptions", g_ModeScript );

function OnGameEvent_revive_success( params )
{
	if ( !("subject" in params) )
		return;
	
	local player = GetPlayerFromUserID( params["subject"] );
	
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;
	
	player.SetHealth( 25 );
	player.SetHealthBuffer( 0 );
}
