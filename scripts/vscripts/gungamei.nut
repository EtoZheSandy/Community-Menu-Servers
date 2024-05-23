//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: Infestation\n");
Msg("Made by Rayman1103\n");

IncludeScript("infestation");
IncludeScript("gungame_base");

GunGameOptions <-
{
	SurvivorMaxIncapacitatedCount = 1
}

GunGameState <-
{
	HPRegenTime = 3.0
}

AddDefaultsToTable( "GunGameOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "GunGameState", g_ModeScript, "MutationState", g_ModeScript );

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
