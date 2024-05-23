//-----------------------------------------------------
Msg("Activating The Last of Us\n");

MutationOptions <-
{
	cm_AllowSurvivorRescue = false
	cm_BaseCommonAttackDamage = 100
	cm_CommonLimit = 35 //25
	cm_HeadshotOnly = 1
	cm_ShouldHurry = 1
	cm_MaxSpecials = 0
	cm_DominatorLimit = 0
	AlwaysAllowWanderers = true
	NumReservedWanderers = 40 //30
	PreferredMobDirection = SPAWN_ANYWHERE
	//SurvivorMaxIncapacitatedCount = 4 //99
	//MegaMobSize = 15 //testing 15
	//MegaMobMinSize = 15 //testing 15
	//MegaMobMaxSize = 15 //testing 20
	//MobMinSize = 10 //15
	//MobMaxSize = 10 //15
	//MobSpawnMinTime = 999999
	//MobSpawnMaxTime = 999999
	//MobSpawnSize = 5 //15
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	
	weaponsToRemove =
	{
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
	CurrentStage = -1
	FinaleStarted = false
	FinaleStartTime = 0
	TriggerRescue = false
	RescueDelay = 300.0
	TriggerRescueThink = false
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

function GetNextStage()
{
	if ( SessionState.FinaleStarted )
	{
		SessionState.CurrentStage++;

		//  stage sequencing
		if ( SessionState.CurrentStage == 0 )
		{
			SessionOptions.ScriptedStageType = STAGE_PANIC
			SessionOptions.ScriptedStageValue = 1
		}
		else if ( SessionState.CurrentStage == 1 )
		{
			SessionOptions.ScriptedStageType = STAGE_DELAY
			SessionOptions.ScriptedStageValue = 15
			SessionState.CurrentStage = -1;
		}
		if ( SessionState.TriggerRescue )
		{
			SessionOptions.ScriptedStageType = STAGE_ESCAPE
			SessionState.TriggerRescue = false;
		}
	}
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( damageTable.Attacker.GetClassname() == "infected" && NetProps.GetPropInt( damageTable.Victim, "m_iTeamNum" ) == 2 )
	{
		if ( GetDifficulty() == 0 )
			damageTable.DamageDone = 15;
		else if ( GetDifficulty() == 1 )
			damageTable.DamageDone = 24;
		else if ( GetDifficulty() == 2 )
			damageTable.DamageDone = 33;
		else if ( GetDifficulty() == 3 )
			damageTable.DamageDone = 69;
	}

	return true;
}

function OnGameplayStart()
{
	Say( null, "You are THE LAST OF US. Dying in the game is dying forever...", false );
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

	DeadSurvivor[GetCharacterDisplayName( victim )] = true;
	AliveSurvivor.Amount--;

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
		player.TakeDamage( player.GetMaxHealth(), 0, null );
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
	EntFire( "info_director", "FireConceptToAny", "PlayerWarnCareful" );

	if ( Entities.FindByClassname( null, "game_scavenge_progress_display" ) )
	{
		for ( local info_director; info_director = Entities.FindByClassname( info_director, "info_director" ); )
		{
			if ( info_director.ValidateScriptScope() )
			{
				local directorScope = info_director.GetScriptScope();
				directorScope["LOU_AdjustScores"] <- function()
				{
					EntFire( "info_director", "RunScriptCode", DirectorScript.MapScript.LocalScript.AdjustGasCanPoured() );
				}
				info_director.ConnectOutput( "OnTeamScored", "LOU_AdjustScores" );
			}
		}
	}
}

function OnGameEvent_round_start_post_nav( params )
{
	RestoreTable( "DeadSurvivors", DeadSurvivor );

	EntFire( "tankdoorout_button", "Unlock" );
	EntFire( "tank_sound_timer", "Kill" );
	EntFire( "button_locker-*", "Kill" );
	EntFire( "locker-*", "Kill" );
	EntFire( "WorldFootLocker-*", "Kill" );
	for ( local wep_spawner; wep_spawner = Entities.FindByClassname( wep_spawner, "weapon_*" ); )
		NetProps.SetPropInt( wep_spawner, "m_itemCount", 1 );
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

function TriggerRescueThink()
{
	if ( (Time() - SessionState.FinaleStartTime) >= SessionState.RescueDelay )
	{
		SessionState.TriggerRescue = true;
		Director.ForceNextStage();
		SessionState.TriggerRescueThink = false;
	}
}

if ( IsMissionFinalMap() )
{
	function OnGameEvent_finale_start( params )
	{
		SessionState.FinaleStarted = true;
		SessionState.FinaleStartTime = Time();
		SessionState.TriggerRescueThink = true;
	}
}

function Update()
{
	if ( SessionState.TriggerRescueThink )
		TriggerRescueThink();
}
