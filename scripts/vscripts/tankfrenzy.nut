//-----------------------------------------------------
Msg("Activating Tank Frenzy\n");

IncludeScript("ass_base");

ASSOptions <-
{
	cm_MaxSpecials = 14
	cm_DominatorLimit = 14
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	SurvivorMaxIncapacitatedCount = 0
	TankHitDamageModifierCoop = 2.5 //100
	ZombieTankHealth = 100

	TankLimit = 14
	cm_TankLimit = 14
	
	TempHealthDecayRate = 0.001
	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 0.334 // pain_pills_decay_rate default 0.27
		}
	}
}

ASSState <-
{
	FinaleStarted = false
	FinaleStartTime = 0
	TriggerRescue = false
	RescueDelay = 180
	TriggerRescueThink = false
	TanksAlive = 0
	LastTankSpawnTime = 0
	TankSpawnInterval = 3
	SpawnTankThink = false
}

AddDefaultsToTable( "ASSOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ASSState", g_ModeScript, "MutationState", g_ModeScript );

if ( IsMissionFinalMap() )
{
	function GetNextStage()
	{
		if ( SessionState.TriggerRescue )
		{
			SessionOptions.ScriptedStageType = STAGE_ESCAPE
			SessionState.TriggerRescue = false;
		}
		else
		{
			SessionOptions.ScriptedStageType = STAGE_DELAY
			SessionOptions.ScriptedStageValue = -1
		}
	}

	function OnGameEvent_finale_start( params )
	{
		SessionState.FinaleStarted = true;
		SessionState.FinaleStartTime = Time();
		SessionState.TriggerRescueThink = true;
	}
}

function SpawnTankThink()
{
	if ( SessionOptions.cm_TankLimit == 0 )
		return;

	if ( (SessionState.TanksAlive < SessionOptions.cm_TankLimit) && ((Time() - SessionState.LastTankSpawnTime) >= SessionState.TankSpawnInterval || SessionState.LastTankSpawnTime == 0) )
	{
		if ( ZSpawn( { type = 8 } ) )
			SessionState.LastTankSpawnTime = Time();
	}
}

function TriggerRescueThink()
{
	if ( (Time() - SessionState.FinaleStartTime) >= SessionState.RescueDelay )
	{
		SessionState.TriggerRescue = true;
		Director.ForceNextStage();
		if ( Entities.FindByName( null, "relay_car_ready" ) )
			EntFire( "relay_car_ready", "Trigger" );
		SessionState.TriggerRescueThink = false;
	}
}

function OnGameEvent_player_left_safe_area( params )
{
	EntFire( "tankdoorout_button", "Unlock" );
	EntFire( "tank_sound_timer", "Kill" );
	
	EntFire( "finale_cleanse_exit_door", "Unlock" );
	EntFire( "finale_cleanse_exit_door", "Open" );
	EntFire( "ceda_trailer_canopen_frontdoor_listener", "Kill" );
	EntFire( "finale_cleanse_backdoors_blocker", "Kill" );
	EntFire( "radio_fake_button", "Press" );
	EntFire( "drawbridge", "MoveToFloor", "bottom" );
	EntFire( "drawbridge_start_sound", "PlaySound" );
	EntFire( "startbldg_door_button", "Press" );
	EntFire( "startbldg_door", "Open" );
	EntFire( "elevator", "MoveToFloor", "bottom" );
	EntFire( "elevator_pulley", "Start" );
	EntFire( "elevator_pulley2", "Start" );
	EntFire( "elevbuttonoutsidefront", "Skin", "1" );
	EntFire( "sound_elevator_startup", "PlaySound" );
	EntFire( "elevator_start_shake", "StartShake" );
	EntFire( "elevator_number_relay", "Trigger" );
	EntFire( "elevator_breakwalls", "Kill" );
	EntFire( "elevator_game_event", "Kill" );

	SessionState.SpawnTankThink = true;
}

function OnGameEvent_tank_spawn( params )
{
	local tank = GetPlayerFromUserID( params["userid"] );
	if ( !tank )
		return;

	SessionState.TanksAlive++;
}

function OnGameEvent_tank_killed( params )
{
	SessionState.TanksAlive--;
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
	if ( SessionState.SpawnTankThink )
		SpawnTankThink();
	if ( SessionState.TriggerRescueThink )
		TriggerRescueThink();
}
