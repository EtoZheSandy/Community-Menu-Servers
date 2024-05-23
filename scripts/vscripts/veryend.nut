//-----------------------------------------------------
Msg("Activating Your Eternal Slumber\n");

MutationOptions <-
{
	cm_AggressiveSpecials = 0
	cm_AllowSurvivorRescue = 0
	cm_CommonLimit = 0
	cm_DominatorLimit = 10
	cm_MaxSpecials = 10
	cm_SpecialRespawnInterval = 20
	
	MobMaxPending = 0
	ShouldAllowSpecialsWithTank = true
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 5
	
	SmokerLimit = 2
	BoomerLimit = 2
	HunterLimit = 2
	SpitterLimit = 2
	JockeyLimit = 1
	ChargerLimit = 1
	//WitchLimit = 0
	//cm_WitchLimit = 0
	
	weaponsToRemove =
	{
		weapon_pipe_bomb = 0
		weapon_defibrillator = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return false;
		}
		return true;
	}
}

MutationState <-
{
	AdjustGasCansPoured = 0
	AdjustNumCansNeeded = -1
	AllSurvivors = []
}

::DeadSurvivor <-
{
	Coach = false
	Ellis = false
	Nick = false
	Rochelle = false
	Bill = false
	Francis = false
	Louis = false
	Zoey = false
}

::AliveSurvivor <-
{
	Amount = 4
}

function OnGameplayStart()
{
	Say( null, "Your Eternal Slumber is at hand, don't be killed or you'll never ever be coming back... like ever.", false );
}

function OnShutdown()
{
	if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_ROUND_RESTART )
	{
		RestoreTable( "DeadSurvivors", DeadSurvivor );
		SaveTable( "DeadSurvivors", DeadSurvivor );
	}
	else if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_LEVEL_TRANSITION )
	{
		local nextMap = "";
		local changelevel = null;
		if ( changelevel = Entities.FindByClassname( changelevel, "info_changelevel" ) )
			nextMap = NetProps.GetPropString( changelevel, "m_mapName" );
		else if ( changelevel = Entities.FindByClassname( changelevel, "trigger_changelevel" ) )
			nextMap = NetProps.GetPropString( changelevel, "m_mapName" );

		if ( SessionState.NextMap != nextMap )
			return;

		SaveTable( "DeadSurvivors", DeadSurvivor );
	}
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( damageTable.Attacker.GetClassname() == "witch" && NetProps.GetPropInt( damageTable.Victim, "m_iTeamNum" ) == 2 )
		damageTable.DamageDone = 15;

	return true;
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	
	if ( ( !victim ) || ( !victim.IsSurvivor() ) )
		return;
	
	if ( Director.HasAnySurvivorLeftSafeArea() )
		EntFire( "survivor_death_model", "BecomeRagdoll" );
	else
		EntFire( "survivor_death_model", "Kill" );

	g_ModeScript.DeadSurvivor[GetCharacterDisplayName( victim )] = true;
	g_ModeScript.AliveSurvivor.Amount--;

	if ( Entities.FindByClassname( null, "game_scavenge_progress_display" ) )
	{
		if ( SessionState.AdjustNumCansNeeded == -1 )
			SessionState.AdjustNumCansNeeded = NumCansNeeded;

		if ( AliveSurvivor.Amount > 0 )
		{
			SessionState.AdjustNumCansNeeded -= 2;
			EntFire( "game_scavenge_progress_display", "SetTotalItems", SessionState.AdjustNumCansNeeded );
			SearchNumCansNeeded();
		}
	}

	if ( g_ModeScript.AliveSurvivor.Amount == 3 )
	{
		Convars.SetValue( "z_tank_health", "2000" );
		Convars.SetValue( "z_witch_health", "850" );
		
		local random_chance = RandomInt( 0, 1 );
		if ( random_chance == 0 )
		{
			SessionOptions.SmokerLimit = 1;
			SessionOptions.BoomerLimit = 1;
			SessionOptions.cm_DominatorLimit -= 2;
			SessionOptions.cm_MaxSpecials -= 2;
		}
		else if ( random_chance == 1 )
		{
			SessionOptions.HunterLimit = 1;
			SessionOptions.SpitterLimit = 1;
			SessionOptions.cm_DominatorLimit -= 2;
			SessionOptions.cm_MaxSpecials -= 2;
		}
	}
	else if ( g_ModeScript.AliveSurvivor.Amount == 2 )
	{
		Convars.SetValue( "z_tank_health", "1500" );
		Convars.SetValue( "z_witch_health", "700" );
		
		SessionOptions.SmokerLimit = 1;
		SessionOptions.BoomerLimit = 1;
		SessionOptions.HunterLimit = 1;
		SessionOptions.SpitterLimit = 1;
		SessionOptions.JockeyLimit = 1;
		SessionOptions.ChargerLimit = 1;
		SessionOptions.cm_DominatorLimit = 6;
		SessionOptions.cm_MaxSpecials = 6;
		SessionOptions.cm_SpecialRespawnInterval = 25;
	}
	else if ( g_ModeScript.AliveSurvivor.Amount == 1 )
	{
		Convars.SetValue( "z_tank_health", "1000" );
		Convars.SetValue( "z_witch_health", "500" );
		
		SessionOptions.SmokerLimit = 1;
		SessionOptions.BoomerLimit = 1;
		SessionOptions.HunterLimit = 1;
		SessionOptions.SpitterLimit = 1;
		SessionOptions.JockeyLimit = 1;
		SessionOptions.ChargerLimit = 1;
		SessionOptions.cm_DominatorLimit = 4;
		SessionOptions.cm_MaxSpecials = 4;
		SessionOptions.cm_SpecialRespawnInterval = 30;
	}

	if ( ResponseCriteria.GetValue( victim, "campaign" ) == "l4d2_7" && g_ModeScript.AliveSurvivor.Amount == 1 )
	{
		Say( null, "Survivors Failed: You need at least 2 living Survivors in order to complete this Campaign.", false );
		foreach( survivor in SessionState.AllSurvivors )
		{
			survivor.SetReviveCount( 2 );
			survivor.TakeDamage( survivor.GetMaxHealth(), 0, null );
		}
	}
}

function OnGameEvent_round_start_post_nav( params )
{
	RestoreTable( "DeadSurvivors", DeadSurvivor );

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
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( (GetCharacterDisplayName( player ) in DeadSurvivor) && (DeadSurvivor[GetCharacterDisplayName( player )]) )
	{
		local invTable = {};
		GetInvTable( player, invTable );
		foreach( weapon in invTable )
			weapon.Kill();
		player.SetReviveCount( 2 );
		player.TakeDamage( player.GetMaxHealth(), 0, Entities.First() );
		if ( !Director.HasAnySurvivorLeftSafeArea() )
			DoEntFire( "!self", "CancelCurrentScene", "", 0, null, player );
	}
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) || (SessionState.AllSurvivors.find( player ) != null) )
		return;

	SessionState.AllSurvivors.append( player );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}

function OnGameEvent_player_left_safe_area( params )
{
	if ( Entities.FindByClassname( null, "game_scavenge_progress_display" ) )
	{
		for ( local info_director; info_director = Entities.FindByClassname( info_director, "info_director" ); )
		{
			if ( info_director.ValidateScriptScope() )
			{
				local directorScope = info_director.GetScriptScope();
				directorScope["VEND_AdjustScores"] <- function()
				{
					EntFire( "info_director", "RunScriptCode", DirectorScript.MapScript.LocalScript.AdjustGasCanPoured() );
				}
				info_director.ConnectOutput( "OnTeamScored", "VEND_AdjustScores" );
			}
		}
	}
}

function AdjustScores()
{
	EntFire( "info_director", "RunScriptCode", DirectorScript.MapScript.LocalScript.AdjustGasCanPoured() );
}

::AdjustGasCanPoured <- function ()
{
	SessionState.AdjustGasCansPoured++

	if ( SessionState.AdjustGasCansPoured == SessionState.AdjustNumCansNeeded )
	{
		Msg(" needed: " + SessionState.AdjustNumCansNeeded + "\n") 
		EntFire( "relay_car_ready", "trigger" )
	}
}

function SearchNumCansNeeded()
{
	if ( SessionState.AdjustGasCansPoured >= SessionState.AdjustNumCansNeeded )
	{
		Msg(" needed: " + SessionState.AdjustNumCansNeeded + "\n") 
		EntFire( "relay_car_ready", "trigger" )
	}
}

function Update()
{
	if ( Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
}
