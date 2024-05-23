//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: Uncommon Ambush\n");
Msg("Made by Rayman1103\n");

IncludeScript("uncommonambush");
IncludeScript("gungame_base");

GunGameState <-
{
	HPRegenTime = 3.0
}

AddDefaultsToTable( "GunGameState", g_ModeScript, "MutationState", g_ModeScript );

function OnGameEvent_revive_success( params )
{
	if ( !("subject" in params) )
		return;
	
	local player = GetPlayerFromUserID( params["subject"] );
	
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;
	
	player.SetHealth( 50 );
	player.SetHealthBuffer( 0 );
}
