//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: Special Delivery\n");
Msg("Made by Rayman1103\n");

IncludeScript("community1");
IncludeScript("gungame_base");

GunGameOptions <-
{
	cm_SpecialRespawnInterval = 5

	SpecialInitialSpawnDelayMin = 5
	SpecialInitialSpawnDelayMax = 10

	SmokerLimit = 1
	BoomerLimit = 2
	HunterLimit = 2
	SpitterLimit = 1
	JockeyLimit = 1
	ChargerLimit = 1
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
