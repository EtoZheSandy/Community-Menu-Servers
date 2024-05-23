//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: Hunter Barrage\n");
Msg("Made by Rayman1103\n");

IncludeScript("hunterbarrage");
IncludeScript("gungame_base");

GunGameOptions <-
{
	cm_AllowSurvivorRescue = false
	cm_SpecialRespawnInterval = 5
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
