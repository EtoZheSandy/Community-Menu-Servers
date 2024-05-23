//-----------------------------------------------------
Msg("Activating Sunday Night Suicide Sprint\n");
Msg("Made by ANG3Lskye\n");

IncludeScript("zsl_base");

ZSLOptions <-
{
	cm_CommonLimit = 0
	cm_AllowSurvivorRescue = 0
	cm_DominatorLimit = 12
	cm_MaxSpecials = 12
	cm_AggressiveSpecials = 1
	SpecialRespawnInterval = 5
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 5
	ShouldAllowSpecialsWithTank = true
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	BoomerLimit = 12
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	SurvivorMaxIncapacitatedCount = 0

	DefaultItems =
	[
		"baseball_bat",
	]

	function GetDefaultItem( idx )
	{
		if ( idx < DefaultItems.len() )
		{
			return DefaultItems[idx];
		}
		return 0;
	}
	
	TempHealthDecayRate = 0.001
}

ZSLState <-
{
	IsRaceEvent = false
}

AddDefaultsToTable( "ZSLOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ZSLState", g_ModeScript, "MutationState", g_ModeScript );

function InfernoRemove()
{
	for ( local inferno; inferno = Entities.FindByClassname( inferno, "inferno" ); )
	{
		if ( inferno.GetOwnerEntity() != null )
			inferno.Kill();
	}
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	if ( ( !victim ) || ( victim.GetZombieType() != DirectorScript.ZOMBIE_BOOMER ) )
		return;
	
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.InfernoRemove()" );
}

function OnGameEvent_player_left_safe_area( params )
{
	EntFire( "barricade_gas_can", "Ignite" );
}

function Update()
{
	if ( !SessionState.HasSurvivalFinale )
	{
		foreach( survivor in SessionState.AllSurvivors )
		{
			if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
			{
				if ( survivor.GetHealth() < survivor.GetMaxHealth() )
					survivor.SetHealth( survivor.GetHealth() + 1 );
			}
		}
	}
}
