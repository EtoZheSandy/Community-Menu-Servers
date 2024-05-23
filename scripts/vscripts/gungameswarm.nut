//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: Swarm\n");
Msg("Made by Rayman1103\n");

IncludeScript("swarm");
IncludeScript("gungame_base");

GunGameOptions <-
{
	SurvivorMaxIncapacitatedCount = 1
}

AddDefaultsToTable( "GunGameOptions", g_ModeScript, "MutationOptions", g_ModeScript );

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

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) || (SessionState.AllSurvivors.find( player ) != null) )
		return;

	if ( !(GetCharacterDisplayName( player ) in SurvivorStats.score) )
		SurvivorStats.score[GetCharacterDisplayName( player )] <- 0;
}
