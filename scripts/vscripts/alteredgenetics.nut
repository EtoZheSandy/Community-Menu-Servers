//-----------------------------------------------------
Msg("Activating Altered Genetics\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	cm_CommonLimit = 0
	cm_DominatorLimit = 8
	cm_MaxSpecials = 12
	cm_AggressiveSpecials = 1
	SpecialRespawnInterval = 5
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 5
	ShouldAllowSpecialsWithTank = true
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	BoomerLimit = 2
	SmokerLimit = 2
	HunterLimit = 2
	ChargerLimit = 2
	SpitterLimit = 2
	JockeyLimit = 2
	TankLimit = 2
	cm_TankLimit = 2
	//WitchLimit = 0
	//cm_WitchLimit = 0
}

function SIPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (player.IsSurvivor()) )
		return;

	local SITypes =
	[
		1, //SMOKER
		2, //BOOMER
		3, //HUNTER
		4, //SPITTER
		5, //JOCKEY
		6, //CHARGER
		//8 //TANK
	]

	local foundType = SITypes.find( player.GetZombieType() );
	if ( foundType != null )
		SITypes.remove( foundType );
	NetProps.SetPropInt( player, "m_zombieClass", SITypes[ RandomInt( 0, SITypes.len() - 1 ) ] );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (player.IsSurvivor()) )
		return;

	if ( player.GetZombieType() != 8 )
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SIPostSpawn(" + params["userid"] + ")", 0.1 );
}
