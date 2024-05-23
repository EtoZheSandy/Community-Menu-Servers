//-----------------------------------------------------
Msg("Activating Acid Trip\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

MutationOptions <-
{
	cm_ShouldHurry = 1
	cm_AllowSurvivorRescue = 0
	cm_CommonLimit = 0
	cm_DominatorLimit = 8 //10
	cm_MaxSpecials = 8 //10
	cm_TankLimit = 4
	cm_WitchLimit = 0
	cm_SpecialRespawnInterval = 10
	cm_AggressiveSpecials = 1
	SpecialInitialSpawnDelayMin = 5
	SpecialInitialSpawnDelayMax = 5
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	ShouldAllowSpecialsWithTank = true
	TankHitDamageModifierCoop = 0.5
	cm_BaseCommonAttackDamage = 0
	TempHealthDecayRate = 0.0
	
	SmokerLimit = 0
	BoomerLimit = 0 //2
	HunterLimit = 0
	SpitterLimit = 8
	JockeyLimit = 0
	ChargerLimit = 0
	TotalSpitters = 8
	//TotalBoomers = 2
	TotalSpecials = 8 //10
	PanicSpecialsOnly = true
	
	// convert items that aren't useful
	weaponsToConvert =
	{
		ammo = "weapon_pain_pills_spawn"
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
		weapon_pistol_magnum = 0
		weapon_smg = 0
		weapon_pumpshotgun = 0
		weapon_autoshotgun = 0
		weapon_rifle = 0
		weapon_hunting_rifle = 0
		weapon_smg_silenced = 0
		weapon_shotgun_chrome = 0
		weapon_rifle_desert = 0
		weapon_sniper_military = 0
		weapon_shotgun_spas = 0
		weapon_grenade_launcher = 0
		weapon_rifle_ak47 = 0
		weapon_smg_mp5 = 0		
		weapon_rifle_sg552 = 0		
		weapon_sniper_awp = 0	
		weapon_sniper_scout = 0
		weapon_rifle_m60 = 0
		weapon_melee = 0
		weapon_chainsaw = 0
		weapon_pipe_bomb = 0
		weapon_molotov = 0
		weapon_vomitjar = 0
		weapon_adrenaline = 0
		weapon_defibrillator = 0
		weapon_first_aid_kit = 0
		weapon_upgradepack_incendiary = 0
		weapon_upgradepack_explosive = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return false;
		}
		return true;
	}

	RandomPrimary =
	[
		"autoshotgun",
		"rifle",
		"rifle_desert",
		"sniper_military",
		"shotgun_spas",
		"rifle_ak47"
	]
	RandomSecondary =
	[
		"weapon_pistol_magnum",
	]
	
	RandomTertiary =
	[
		"weapon_pain_pills",
	]
	
	function GetDefaultItem(id)
	{
		local PRand = RandomInt(0,RandomPrimary.len()-1);
		local SRand = RandomInt(0,RandomSecondary.len()-1);
		local TRand = RandomInt(0,RandomTertiary.len()-1);
		if(id == 0) return RandomPrimary[PRand];
		else if(id == 1) return RandomSecondary[SRand];
		else if(id == 2) return RandomTertiary[TRand];
		return 0;
	}
}

MutationState <-
{
	FinaleStarted = false
	FinaleStartTime = 0
	TriggerRescue = false
	RescueDelay = 180
	TanksAlive = 0
	LastTankSpawnTime = 0
	TankSpawnInterval = 60
	SpawnTankThink = false
	TriggerRescueThink = false
	LeftSafeAreaThink = false
	SpawnedSurvivors = []
}

function GetNextStage()
{
	if ( SessionState.TriggerRescue )
	{
		SessionOptions.ScriptedStageType = STAGE_ESCAPE;
		return;
	}
	/*if ( SessionState.FinaleStarted )
	{
		SessionOptions.ScriptedStageType = STAGE_DELAY;
		SessionOptions.ScriptedStageValue = -1;
		return;
	}*/
	SessionOptions.ScriptedStageType = STAGE_PANIC;
	SessionOptions.ScriptedStageValue = 1;
}

if ( IsMissionFinalMap() )
{
	function OnGameEvent_finale_start( params )
	{
		SessionOptions.cm_MaxSpecials = 8;
		SessionOptions.cm_TankLimit = 4;
		SessionState.SpawnTankThink = true;

		SessionState.FinaleStarted = true;
		SessionState.FinaleStartTime = Time();
		SessionState.TriggerRescueThink = true;
	}

	function OnGameEvent_gauntlet_finale_start( params )
	{
		if ( Director.GetMapName() == "c5m5_bridge" )
		{
			SessionOptions.cm_MaxSpecials = 8;
			SessionOptions.cm_TankLimit = 4;
		}
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

	if ( (SessionState.TanksAlive < 4) && ((Time() - SessionState.LastTankSpawnTime) >= SessionState.TankSpawnInterval || SessionState.LastTankSpawnTime == 0) )
	{
		if ( ZSpawn( { type = 8 } ) )
			SessionState.LastTankSpawnTime = Time();
	}
}

function LeftSafeAreaThink()
{
	for ( local player; player = Entities.FindByClassname( player, "player" ); )
	{
		if ( NetProps.GetPropInt( player, "m_iTeamNum" ) != 2 )
			continue;

		if ( ResponseCriteria.GetValue( player, "instartarea" ) == "0" )
		{
			SessionOptions.cm_MaxSpecials = 8;
			SessionOptions.cm_TankLimit = 4;
			SessionState.LeftSafeAreaThink = false;
			SessionState.SpawnTankThink = true;
			break;
		}
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

		if ( population == "spitter" || population == "new_special" || population == "tank" || population == "river_docks_trap" )
			continue;
		else
			spawner.Kill();
	}

	if ( Director.GetMapName() == "c5m5_bridge" || Director.GetMapName() == "c6m3_port" )
		DirectorOptions.cm_MaxSpecials = 0;

	EntFire( "startbldg_door_button", "Press" );
	EntFire( "startbldg_door", "Open" );
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.SetHealthBuffer( 0 );
	player.SetHealth( player.GetMaxHealth() );
	player.SetReviveCount( 0 );
	NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
	StopSoundOn( "Player.Heartbeat", player );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( SessionState.SpawnedSurvivors.find( player ) == null )
	{
		SessionState.SpawnedSurvivors.append( player );
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
	}
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
		SessionState.SpawnTankThink = true;

	SessionOptions.TempHealthDecayRate = 0.27;
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

function OnGameEvent_bot_player_replace( params )
{
	local player = GetPlayerFromUserID( params["player"] );
	if ( !player )
		return;

	StopSoundOn( "Player.Heartbeat", player );
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
