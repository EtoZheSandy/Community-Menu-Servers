//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: Special Surprise\n");
Msg("Made by Rayman1103\n");

IncludeScript("specialsurprise");
IncludeScript("gungame_base");

function OnGameEvent_player_spawn( params )
{
	// Intentionally left blank to override function in specialsurprise.nut
}

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
