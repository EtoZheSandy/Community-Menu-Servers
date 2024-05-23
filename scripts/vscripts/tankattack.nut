//-----------------------------------------------------
Msg("Activating Tank Attack\n");
Msg("Made by Rayman1103\n");

if ( !IsModelPrecached( "models/infected/hulk.mdl" ) )
	PrecacheModel( "models/infected/hulk.mdl" );
if ( !IsModelPrecached( "models/infected/hulk_dlc3.mdl" ) )
	PrecacheModel( "models/infected/hulk_dlc3.mdl" );
if ( !IsModelPrecached( "models/infected/hulk_l4d1.mdl" ) )
	PrecacheModel( "models/infected/hulk_l4d1.mdl" );

MutationOptions <-
{
	cm_ShouldHurry = true
	cm_AllowSurvivorRescue = false
	cm_InfiniteFuel = true
	cm_AggressiveSpecials = true
	cm_CommonLimit = 0
	cm_DominatorLimit = 0
	cm_MaxSpecials = 0
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	TankLimit = 8
	cm_TankLimit = 8
	
	EscapeSpawnTanks = true
	//ZombieTankHealth = 3500
	TempHealthDecayRate = 0.0

	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_pipe_bomb = 	"weapon_molotov_spawn"
		weapon_vomitjar = 	"weapon_molotov_spawn"
		ammo = "weapon_molotov_spawn"
	}

	function ConvertWeaponSpawn( classname )
	{
		if ( classname in weaponsToConvert )
		{
			return weaponsToConvert[classname];
		}
		return 0;
	}

	DefaultItems =
	[
		"weapon_pistol_magnum",
	]

	function GetDefaultItem( idx )
	{
		if ( idx < DefaultItems.len() )
		{
			return DefaultItems[idx];
		}
		return 0;
	}
}

MutationState <-
{
	TankModelsBase = [ "models/infected/hulk.mdl", "models/infected/hulk_dlc3.mdl", "models/infected/hulk_l4d1.mdl" ]
	TankModels = [ "models/infected/hulk.mdl", "models/infected/hulk_dlc3.mdl", "models/infected/hulk_l4d1.mdl" ]
	ModelCheck = false
	FinaleStarted = false
	FinaleStartTime = 0
	TriggerRescue = false
	RescueDelay = 240
	LastSpawnTime = 0
	SpawnInterval = 15
	TanksAlive = 0
	SpawnTankThink = false
	TriggerRescueThink = false
	FinaleType = -1
}

if ( IsMissionFinalMap() )
{
	local triggerFinale = Entities.FindByClassname( null, "trigger_finale" );
	if ( triggerFinale )
		MutationState.FinaleType = NetProps.GetPropInt( triggerFinale, "m_type" );

	if ( MutationState.FinaleType != 4 )
	{
		function GetNextStage()
		{
			if ( SessionState.TriggerRescue )
			{
				SessionOptions.ScriptedStageType = STAGE_ESCAPE;
				return;
			}
			if ( SessionState.FinaleStarted )
			{
				SessionOptions.ScriptedStageType = STAGE_DELAY;
				SessionOptions.ScriptedStageValue = -1;
			}
		}
	}

	function OnGameEvent_finale_start( params )
	{
		if ( SessionState.FinaleType == 4 )
			return;

		SessionState.FinaleStarted = true;
		SessionState.FinaleStartTime = Time();
		SessionState.TriggerRescueThink = true;
	}

	function OnGameEvent_finale_vehicle_leaving( params )
	{
		SessionState.SpawnTankThink = false;
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

function SpawnTankThink()
{
	if ( SessionOptions.cm_TankLimit == 0 )
		return;

	if ( (SessionState.TanksAlive < SessionOptions.cm_TankLimit) && ((Time() - SessionState.LastSpawnTime) >= SessionState.SpawnInterval || SessionState.LastSpawnTime == 0) )
	{
		if ( ZSpawn( { type = 8 } ) )
			SessionState.LastSpawnTime = Time();
	}
}

function OnGameEvent_round_start( params )
{
	Convars.SetValue( "pain_pills_decay_rate", 0.0 );
}

function OnGameEvent_round_start_post_nav( params )
{
	for ( local spawner; spawner = Entities.FindByClassname( spawner, "info_zombie_spawn" ); )
	{
		local population = NetProps.GetPropString( spawner, "m_szPopulation" );

		if ( population == "tank" || population == "river_docks_trap" )
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
	if ( SessionState.MapName == "c8m4_interior" )
	{
		EntFire( "elevator", "MoveToFloor", "bottom" );
		EntFire( "elevator_pulley", "Start" );
		EntFire( "elevator_pulley2", "Start" );
		EntFire( "elevbuttonoutsidefront", "Skin", "1" );
		EntFire( "sound_elevator_startup", "PlaySound" );
		EntFire( "elevator_start_shake", "StartShake" );
		EntFire( "elevator_number_relay", "Trigger" );
		EntFire( "elevator_breakwalls", "Kill" );
		EntFire( "elevator_game_event", "Kill" );
	}
	EntFire( "finale_cleanse_entrance_door", "Lock" );
	EntFire( "finale_cleanse_exit_door", "Unlock" );
	EntFire( "ceda_trailer_canopen_frontdoor_listener", "Kill" );
	EntFire( "finale_cleanse_backdoors_blocker", "Kill" );
	EntFire( "radio_fake_button", "Press" );
	EntFire( "drawbridge", "MoveToFloor", "bottom" );
	EntFire( "drawbridge_start_sound", "PlaySound" );
	EntFire( "startbldg_door_button", "Press" );
	EntFire( "startbldg_door", "Open" );
	
	EntFire( "spawn_church_zombie", "addoutput", "population tank" );

	SessionState.SpawnTankThink = true;
}

function OnGameEvent_mission_lost( params )
{
	SessionState.SpawnTankThink = false;
}

function OnGameEvent_tank_spawn( params )
{
	local tank = GetPlayerFromUserID( params["userid"] );
	if ( !tank )
		return;

	SessionState.TanksAlive++;
	local modelName = tank.GetModelName();

	if ( !SessionState.ModelCheck )
	{
		SessionState.ModelCheck = true;

		if ( SessionState.TankModelsBase.find( modelName ) == null )
		{
			SessionState.TankModelsBase.append( modelName );
			SessionState.TankModels.append( modelName );
		}
	}

	local tankModels = SessionState.TankModels;
	if ( tankModels.len() == 0 )
		SessionState.TankModels.extend( SessionState.TankModelsBase );
	local foundModel = tankModels.find( modelName );
	if ( foundModel != null )
	{
		tankModels.remove( foundModel );
		return;
	}

	local randomElement = RandomInt( 0, tankModels.len() - 1 );
	local randomModel = tankModels[ randomElement ];
	tankModels.remove( randomElement );

	tank.SetModel( randomModel );
}

function OnGameEvent_tank_killed( params )
{
	SessionState.TanksAlive--;
}

function Update()
{
	if ( SessionState.SpawnTankThink )
		SpawnTankThink();
	if ( SessionState.TriggerRescueThink )
		TriggerRescueThink();
	if ( Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
}
