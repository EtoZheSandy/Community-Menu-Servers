//-----------------------------------------------------
Msg("Activating Witch Hunt\n");
Msg("Made by Rayman1103\n");

if ( !IsModelPrecached( "models/infected/witch.mdl" ) )
	PrecacheModel( "models/infected/witch.mdl" );
if ( !IsModelPrecached( "models/infected/witch_bride.mdl" ) )
	PrecacheModel( "models/infected/witch_bride.mdl" );

MutationOptions <-
{
	cm_CommonLimit = 0
	cm_DominatorLimit = 0
	cm_MaxSpecials = 0
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	WitchLimit = 50
	cm_WitchLimit = 50

	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_pipe_bomb = 	"weapon_molotov_spawn"
		weapon_vomitjar = 	"weapon_molotov_spawn"
	}

	function ConvertWeaponSpawn( classname )
	{
		if ( classname in weaponsToConvert )
		{
			return weaponsToConvert[classname];
		}
		return 0;
	}
}

MutationState <-
{
	CreatedWitchTimer = false
}

function SpawnWitchThink()
{
	if ( SessionState.MapName == "c6m1_riverbank" )
		ZSpawn( { type = 11 } );
	else
		ZSpawn( { type = 7 } );

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SpawnWitchThink()", 5.0 );
}

function OnGameEvent_round_start_post_nav( params )
{
	for ( local spawner; spawner = Entities.FindByClassname( spawner, "info_zombie_spawn" ); )
	{
		local population = NetProps.GetPropString( spawner, "m_szPopulation" );

		if ( population == "boomer" || population == "hunter" || population == "smoker" || population == "jockey"
			|| population == "charger" || population == "spitter" || population == "new_special" || population == "church"
				|| population == "tank" || population == "witch" || population == "witch_bride" || population == "river_docks_trap" )
			continue;
		else
			spawner.Kill();
	}

	if ( SessionState.MapName == "AirCrash" )
	{
		EntFire( "breakwall1", "Break" );
		EntFire( "breakwall2", "Break" );
		EntFire( "breakwall_stop", "Kill" );
	}
}

function OnGameEvent_player_left_safe_area( params )
{
	SpawnWitchThink();
}

function Update()
{
	if ( Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
}
