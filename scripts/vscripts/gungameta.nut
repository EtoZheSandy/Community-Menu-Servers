//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: Tank Attack\n");
Msg("Made by Rayman1103\n");

IncludeScript("tankattack");
IncludeScript("gungame_base");

GunGameState <-
{
	HPRegenTime = 2.0
}

AddDefaultsToTable( "GunGameState", g_ModeScript, "MutationState", g_ModeScript );

// Remove the vomitjar from the Gun Game weapon list
local foundVomitjar = GunGameBase.ListOfRandomWeps.find( "vomitjar" );
if ( foundVomitjar != null )
	GunGameBase.ListOfRandomWeps.remove( foundVomitjar );

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
