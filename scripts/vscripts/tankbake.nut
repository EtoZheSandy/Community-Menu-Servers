//-----------------------------------------------------
Msg("Activating Tank Bake\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

MutationOptions <-
{
	cm_ShouldHurry = true
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

	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_pipe_bomb = 	"weapon_molotov_spawn"
		weapon_vomitjar = 	"weapon_molotov_spawn"
		weapon_defibrillator =	"weapon_first_aid_kit_spawn"
		weapon_pistol = "weapon_molotov_spawn"
		weapon_pistol_magnum = "weapon_molotov_spawn"
		weapon_smg = "weapon_molotov_spawn"
		weapon_pumpshotgun = "weapon_molotov_spawn"
		weapon_autoshotgun = "weapon_molotov_spawn"
		weapon_rifle = "weapon_molotov_spawn"
		weapon_hunting_rifle = "weapon_molotov_spawn"
		weapon_smg_silenced = "weapon_molotov_spawn"
		weapon_shotgun_chrome = "weapon_molotov_spawn"
		weapon_rifle_desert = "weapon_molotov_spawn"
		weapon_sniper_military = "weapon_molotov_spawn"
		weapon_shotgun_spas = "weapon_molotov_spawn"
		weapon_grenade_launcher = "weapon_molotov_spawn"
		weapon_rifle_ak47 = "weapon_molotov_spawn"
		weapon_smg_mp5 = "weapon_molotov_spawn"		
		weapon_rifle_sg552 = "weapon_molotov_spawn"	
		weapon_sniper_awp = "weapon_molotov_spawn"	
		weapon_sniper_scout = "weapon_molotov_spawn"
		weapon_rifle_m60 = "weapon_molotov_spawn"
		weapon_chainsaw = "weapon_molotov_spawn"
		weapon_upgradepack_incendiary = "weapon_molotov_spawn"
		weapon_upgradepack_explosive = "weapon_molotov_spawn"
		weapon_melee = "weapon_molotov_spawn"
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

	weaponsToRemove =
	{
		weapon_pistol = 0
		weapon_smg = 0
		weapon_autoshotgun = 0
		weapon_rifle = 0
		weapon_hunting_rifle = 0
		weapon_smg_silenced = 0
		weapon_rifle_desert = 0
		weapon_sniper_military = 0
		weapon_shotgun_spas = 0
		weapon_rifle_ak47 = 0
		weapon_smg_mp5 = 0		
		weapon_rifle_sg552 = 0		
		weapon_sniper_awp = 0	
		weapon_sniper_scout = 0
		weapon_rifle_m60 = 0
		weapon_pistol_magnum = 0
		weapon_pumpshotgun = 0
		weapon_shotgun_chrome = 0
		weapon_grenade_launcher = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return false;
		}
		return true;
	}

	function ShouldAvoidItem( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return true;
		}
		return false;
	}

	DefaultItems =
	[
		"weapon_pistol_magnum",
		"weapon_molotov",
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

MutationState <-
{
	SpawnTank = false
	FinaleStarted = false
	FinaleStartTime = 0
	TriggerRescue = false
	RescueDelay = 180
	TanksAlive = 0
	LastTankSpawnTime = 0
	TankSpawnInterval = 20
	SpawnTankThink = false
	TriggerRescueThink = false
	LeftSafeAreaThink = false
}

function GetNextStage()
{
	if ( SessionState.SpawnTank )
	{
		SessionOptions.ScriptedStageType = STAGE_TANK
		SessionOptions.ScriptedStageValue = 1
		SessionState.SpawnTank = false;
	}
	else if ( !SessionState.SpawnTank )
	{
		SessionOptions.ScriptedStageType = STAGE_DELAY
		SessionOptions.ScriptedStageValue = -1
	}
	if ( SessionState.TriggerRescue )
	{
		SessionOptions.ScriptedStageType = STAGE_ESCAPE
		SessionState.TriggerRescue = false;
	}
}

if ( IsMissionFinalMap() )
{
	function OnGameEvent_finale_start( params )
	{
		SessionOptions.cm_TankLimit = 8;
		SessionState.SpawnTankThink = true;

		SessionState.FinaleStarted = true;
		SessionState.FinaleStartTime = Time();
		SessionState.TriggerRescueThink = true;
	}

	function OnGameEvent_gauntlet_finale_start( params )
	{
		if ( Director.GetMapName() == "c5m5_bridge" )
			SessionOptions.cm_TankLimit = 8;
	}
}

function TriggerRescueThink()
{
	if ( (Time() - SessionState.FinaleStartTime) >= SessionState.RescueDelay )
	{
		SessionState.TriggerRescue = true;
		Director.ForceNextStage();
		SessionState.TriggerRescueThink = false;

		if ( Entities.FindByName( null, "relay_car_ready" ) )
			EntFire( "relay_car_ready", "Trigger" );
	}
}

function SpawnTankThink()
{
	if ( SessionOptions.cm_TankLimit == 0 )
		return;

	if ( (SessionState.TanksAlive < 8) && ((Time() - SessionState.LastTankSpawnTime) >= SessionState.TankSpawnInterval || SessionState.LastTankSpawnTime == 0) )
	{
		SessionState.SpawnTank = true;
		Director.ForceNextStage();
		SessionState.LastTankSpawnTime = Time();
	}
}

function LeftSafeAreaFunc()
{
	EntFire( "finale_cleanse_entrance_door", "Lock" );
	EntFire( "finale_cleanse_exit_door", "Unlock" );
	EntFire( "ceda_trailer_canopen_frontdoor_listener", "Kill" );
	EntFire( "finale_cleanse_backdoors_blocker", "Kill" );
	EntFire( "radio_fake_button", "Press" );
	EntFire( "drawbridge", "MoveToFloor", "Bottom" );
	EntFire( "drawbridge_start_sound", "PlaySound" );
	EntFire( "startbldg_door_button", "Press" );
	EntFire( "startbldg_door", "Open" );
	EntFire( "elevator", "MoveToFloor", "Bottom" );
	EntFire( "elevator_pulley", "Start" );
	EntFire( "elevator_pulley2", "Start" );
	EntFire( "elevbuttonoutsidefront", "Skin", "1" );
	EntFire( "sound_elevator_startup", "PlaySound" );
	EntFire( "elevator_start_shake", "StartShake" );
	EntFire( "elevator_number_relay", "Trigger" );
	EntFire( "elevator_breakwalls", "Kill" );
	EntFire( "elevator_game_event", "Kill" );
	EntFire( "spawn_church_zombie", "AddOutput", "population tank" );
}

function LeftSafeAreaThink()
{
	for ( local player; player = Entities.FindByClassname( player, "player" ); )
	{
		if ( NetProps.GetPropInt( player, "m_iTeamNum" ) != 2 )
			continue;

		if ( ResponseCriteria.GetValue( player, "instartarea" ) == "0" )
		{
			SessionOptions.cm_TankLimit = 8;
			SessionState.LeftSafeAreaThink = false;
			SessionState.SpawnTankThink = true;
			LeftSafeAreaFunc();
			break;
		}
	}
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

	if ( Director.GetMapName() == "c5m5_bridge" || Director.GetMapName() == "c6m3_port" )
		DirectorOptions.cm_TankLimit = 0;
}

function OnGameEvent_player_left_safe_area( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( !player )
		return;

	if ( ResponseCriteria.GetValue( player, "instartarea" ) == "1" )
	{
		SessionOptions.cm_MaxSpecials = 0;
		SessionOptions.cm_TankLimit = 0;
		SessionState.LeftSafeAreaThink = true;
	}
	else
	{
		SessionState.SpawnTankThink = true;
		LeftSafeAreaFunc();
	}
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
	if ( SessionState.LeftSafeAreaThink )
		LeftSafeAreaThink();
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
