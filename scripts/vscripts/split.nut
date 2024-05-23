//-----------------------------------------------------
Msg("Activating Split Decision\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	cm_AggressiveSpecials = 1
	cm_AutoReviveFromSpecialIncap = 1
	cm_CommonLimit = 0
	cm_DominatorLimit = 12
	cm_MaxSpecials = 12
	cm_SpecialRespawnInterval = 0
	cm_SpecialSlotCountdownTime = 0
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	//cm_ProhibitBosses = true
	SpecialInfectedAssault = 1
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 5
	ShouldAllowSpecialsWithTank = true
	//ZombieTankHealth = 5000
	
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	TotalBoomers = 0
	TotalSmokers = 0
	TotalHunters = 0
	TotalChargers = 0
	TotalSpitters = 0
	TotalJockeys = 0
	TotalSpecials = 12
	PanicSpecialsOnly = true
	PanicWavePauseMax = 0
	PanicWavePauseMin = 0
	//SpawnSetRule = SPAWN_SURVIVORS
	
	weaponsToRemove =
	{
		ammo = 0
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
	AllowBoomerSplit = false
	AllowSmokerSplit = false
	AllowHunterSplit = false
	AllowChargerSplit = false
	AllowSpitterSplit = false
	AllowJockeySplit = false
	AllowTankSplit = false
	AllowWitchSplit = false
	BoomersSplit = 0
	SmokersSplit = 0
	HuntersSplit = 0
	ChargersSplit = 0
	SpittersSplit = 0
	JockeysSplit = 0
	TanksSplit = 0
	WitchesSplit = 0
	BoomerSplitLevel = 0
	SmokerSplitLevel = 0
	HunterSplitLevel = 0
	ChargerSplitLevel = 0
	SpitterSplitLevel = 0
	JockeySplitLevel = 0
	TankSplitLevel = 0
	WitchSplitLevel = 0
	SpecialCloned = {}
	NonClone = {}
	FirstClone = {}
	SecondClone = {}
	SpecialWave = null
	SpecialWave2 = null
	FinaleStarted = false
	FinaleStartTime = 0
	TriggerRescue = false
	RescueDelay = 300
	TriggerRescueThink = false
	LeftStart = false
	SpawnSpecials = false
	TankInPlay = false
	CurrentStage = -1
	AdvanceWaveTimer = 10.0
}

function GetNextStage()
{
	if ( !SessionState.LeftStart )
		return;
	
	if ( SessionState.FinaleStarted )
	{
		SessionState.CurrentStage++;

		if ( SessionState.CurrentStage == 0 )
		{
			SessionOptions.ScriptedStageType = STAGE_PANIC;
			SessionOptions.ScriptedStageValue = 2;
		}
		else if ( SessionState.CurrentStage == 1 )
		{
			SessionOptions.ScriptedStageType = STAGE_DELAY;
			SessionOptions.ScriptedStageValue = 10;
			SessionState.CurrentStage = -1;
		}
	}
	else
	{
		if ( SessionState.SpawnSpecials && !SessionState.TankInPlay )
		{
			SpawnSpecials();
			SessionOptions.ScriptedStageType = STAGE_PANIC;
			SessionOptions.ScriptedStageValue = 1;
			SessionState.SpawnSpecials = false;
		}
		else
		{
			SessionOptions.ScriptedStageType = STAGE_DELAY;
			SessionOptions.ScriptedStageValue = -1;
		}
	}
	if ( SessionState.TriggerRescue )
	{
		SessionOptions.ScriptedStageType = STAGE_ESCAPE;
		SessionState.TriggerRescue = false;
	}
}

function AdvanceWave()
{
	SessionState.SpawnSpecials = true;
	Director.ForceNextStage();
}

function SpawnSpecials()
{
	local function SetSpecialLimit( special )
	{
		if ( special == DirectorScript.ZOMBIE_SMOKER )
		{
			SessionOptions.SmokerLimit += 1;
			SessionOptions.TotalSmokers += 1;
		}
		else if ( special == DirectorScript.ZOMBIE_BOOMER )
		{
			SessionOptions.BoomerLimit += 1;
			SessionOptions.TotalBoomers += 1;
		}
		else if ( special == DirectorScript.ZOMBIE_HUNTER )
		{
			SessionOptions.HunterLimit += 1;
			SessionOptions.TotalHunters += 1;
		}
		else if ( special == DirectorScript.ZOMBIE_SPITTER )
		{
			SessionOptions.SpitterLimit += 1;
			SessionOptions.TotalSpitters += 1;
		}
		else if ( special == DirectorScript.ZOMBIE_JOCKEY )
		{
			SessionOptions.JockeyLimit += 1;
			SessionOptions.TotalJockeys += 1;
		}
		else if ( special == DirectorScript.ZOMBIE_CHARGER )
		{
			SessionOptions.ChargerLimit += 1;
			SessionOptions.TotalChargers += 1;
		}
	}
	
	local InfectedTypes =
	[
		ZOMBIE_SMOKER
		//ZOMBIE_BOOMER
		ZOMBIE_HUNTER
		ZOMBIE_SPITTER
		ZOMBIE_JOCKEY
		ZOMBIE_CHARGER
	]
	
	local random_wave = InfectedTypes[ RandomInt( 0, InfectedTypes.len() - 1 ) ];
	local random_wave2 = InfectedTypes[ RandomInt( 0, InfectedTypes.len() - 1 ) ];
	SessionState.SpecialWave = random_wave;
	SessionState.SpecialWave2 = random_wave2;
	SetSpecialLimit(random_wave);
	SetSpecialLimit(random_wave2);
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( (damageTable.Attacker.IsPlayer()) && (damageTable.Attacker.IsSurvivor()) )
	{
		local victimTeam = NetProps.GetPropInt( damageTable.Victim, "m_iTeamNum" );
		if ( victimTeam == 3 )
		{
			if ( (damageTable.Inflictor) && (damageTable.Inflictor.GetClassname() == "pipe_bomb_projectile") )
				damageTable.DamageDone = 1000;
		}
		else if ( victimTeam == 2 )
		{
			if ( damageTable.Attacker.GetClassname() == "witch" )
				damageTable.DamageDone = 35;
			else if ( damageTable.Attacker.IsPlayer() )
			{
				if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_CHARGER && damageTable.DamageType == (1 << 7) && !damageTable.Victim.IsDominatedBySpecialInfected() )
					damageTable.DamageDone = 5;
			}
		}
	}

	return true;
}

function OnGameEvent_player_left_safe_area( params )
{
	SessionState.LeftStart = true;
	SessionState.SpawnSpecials = true;
	Director.ForceNextStage();
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

function OnGameEvent_finale_start( params )
{
	SessionState.FinaleStarted = true;
	SessionState.FinaleStartTime = Time();
	SessionState.TriggerRescueThink = true;
}

function OnGameEvent_witch_spawn( params )
{
	local witch = EntIndexToHScript( params["witchid"] );
	local splitAmount = 0;
	if ( SessionState.AllowWitchSplit )
	{
		if ( SessionState.WitchSplitLevel == 1 )
		{
			SessionState.FirstClone[ params["witchid"] ] <- true;
			witch.SetHealth( 500 );
			splitAmount = 2;
		}
		else if ( SessionState.WitchSplitLevel == 2 )
		{
			SessionState.SpecialCloned[ params["witchid"] ]  <- true;
			witch.SetHealth( 250 );
			splitAmount = 3;
		}
		
		if ( SessionState.WitchesSplit < splitAmount )
		{
			SessionState.WitchesSplit++;
			
			if ( SessionState.WitchesSplit == splitAmount )
			{
				SessionState.AllowWitchSplit = false;
				SessionState.WitchesSplit = 0;
			}
		}
	}
	else
		SessionState.NonClone[ params["witchid"] ] <- true;
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (player.IsSurvivor()) )
		return;

	local splitAmount = 0;
	if ( player.GetZombieType() == DirectorScript.ZOMBIE_BOOMER )
	{
		if ( SessionState.AllowBoomerSplit )
		{
			if ( SessionState.BoomerSplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				splitAmount = 2;
			}
			else if ( SessionState.BoomerSplitLevel == 2 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				player.SetHealth( player.GetHealth() / 2 );
				splitAmount = 3;
			}
			
			if ( SessionState.BoomersSplit < splitAmount )
			{
				SessionState.BoomersSplit++;
				
				if ( SessionState.BoomersSplit == splitAmount )
				{
					SessionState.AllowBoomerSplit = false;
					SessionState.BoomersSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
		}
	}
	else if ( player.GetZombieType() == DirectorScript.ZOMBIE_SMOKER )
	{
		if ( SessionState.AllowSmokerSplit )
		{
			if ( SessionState.SmokerSplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				splitAmount = 2;
			}
			else if ( SessionState.SmokerSplitLevel == 2 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				player.SetHealth( player.GetHealth() / 2 );
				splitAmount = 3;
			}
			
			if ( SessionState.SmokersSplit < splitAmount )
			{
				SessionState.SmokersSplit++;
				
				if ( SessionState.SmokersSplit == splitAmount )
				{
					SessionState.AllowSmokerSplit = false;
					SessionState.SmokersSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
		}
	}
	else if ( player.GetZombieType() == DirectorScript.ZOMBIE_HUNTER )
	{
		if ( SessionState.AllowHunterSplit )
		{
			if ( SessionState.HunterSplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				player.SetHealth( 175 );
				splitAmount = 2;
			}
			else if ( SessionState.HunterSplitLevel == 2 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				player.SetHealth( 150 );
				splitAmount = 3;
			}
			
			if ( SessionState.HuntersSplit < splitAmount )
			{
				SessionState.HuntersSplit++;
				
				if ( SessionState.HuntersSplit == splitAmount )
				{
					SessionState.AllowHunterSplit = false;
					SessionState.HuntersSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
		}
	}
	else if ( player.GetZombieType() == DirectorScript.ZOMBIE_CHARGER )
	{
		if ( SessionState.AllowChargerSplit )
		{
			if ( SessionState.ChargerSplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				player.SetHealth( 300 );
				splitAmount = 2;
			}
			else if ( SessionState.ChargerSplitLevel == 2 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				player.SetHealth( 200 );
				splitAmount = 3;
			}
			
			if ( SessionState.ChargersSplit < splitAmount )
			{
				SessionState.ChargersSplit++;
				
				if ( SessionState.ChargersSplit == splitAmount )
				{
					SessionState.AllowChargerSplit = false;
					SessionState.ChargersSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
		}
	}
	else if ( player.GetZombieType() == DirectorScript.ZOMBIE_SPITTER )
	{
		if ( SessionState.AllowSpitterSplit )
		{
			if ( SessionState.SpitterSplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				splitAmount = 2;
			}
			else if ( SessionState.SpitterSplitLevel == 2 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				splitAmount = 3;
			}
			
			if ( SessionState.SpittersSplit < splitAmount )
			{
				SessionState.SpittersSplit++;
				
				if ( SessionState.SpittersSplit == splitAmount )
				{
					SessionState.AllowSpitterSplit = false;
					SessionState.SpittersSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
		}
	}
	else if ( player.GetZombieType() == DirectorScript.ZOMBIE_JOCKEY )
	{
		if ( SessionState.AllowJockeySplit )
		{
			if ( SessionState.JockeySplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				player.SetHealth( 175 );
				splitAmount = 2;
			}
			else if ( SessionState.JockeySplitLevel == 2 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				player.SetHealth( 150 );
				splitAmount = 3;
			}
			
			if ( SessionState.JockeysSplit < splitAmount )
			{
				SessionState.JockeysSplit++;
				
				if ( SessionState.JockeysSplit == splitAmount )
				{
					SessionState.AllowJockeySplit = false;
					SessionState.JockeysSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
		}
	}
	else if ( player.GetZombieType() == DirectorScript.ZOMBIE_TANK )
	{
		if ( SessionState.AllowTankSplit )
		{
			if ( SessionState.TankSplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				player.SetHealth( 1500 );
				splitAmount = 2;
			}
			else if ( SessionState.TankSplitLevel == 2 )
			{
				SessionState.SecondClone[player.GetEntityIndex()] <- true;
				player.SetHealth( 750 );
				splitAmount = 4;
			}
			else if ( SessionState.TankSplitLevel == 3 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				player.SetHealth( 500 );
				splitAmount = 3;
			}
			
			if ( SessionState.TanksSplit < splitAmount )
			{
				SessionState.TanksSplit++;
				
				if ( SessionState.TanksSplit == splitAmount )
				{
					SessionState.AllowTankSplit = false;
					SessionState.TanksSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
			SessionState.TankInPlay = true;
			player.SetHealth( 3000 );
		}
	}
}

function OnGameEvent_player_death( params )
{
	local victim = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( !victim )
		return;

	if ( (victim.IsPlayer()) && (victim.IsSurvivor()) )
		return;

	local nonClone = false;
	local firstClone = false;
	local secondClone = false;
	if ( (victim.GetEntityIndex() in SessionState.SpecialCloned) && (SessionState.SpecialCloned[victim.GetEntityIndex()]) )
	{
		SessionState.SpecialCloned[victim.GetEntityIndex()] <- false;
		return;
	}
	if ( (victim.GetEntityIndex() in SessionState.NonClone) && (SessionState.NonClone[victim.GetEntityIndex()]) )
	{
		SessionState.NonClone[victim.GetEntityIndex()] <- false;
		nonClone = true;
	}
	if ( (victim.GetEntityIndex() in SessionState.FirstClone) && (SessionState.FirstClone[victim.GetEntityIndex()]) )
	{
		SessionState.FirstClone[victim.GetEntityIndex()] <- false;
		firstClone = true;
	}
	if ( (victim.GetEntityIndex() in SessionState.SecondClone) && (SessionState.SecondClone[victim.GetEntityIndex()]) )
	{
		SessionState.SecondClone[victim.GetEntityIndex()] <- false;
		secondClone = true;
	}

	local splitAmount = 0;
	local spawnType = 7;
	if ( victim.GetClassname() == "witch" )
	{
		if ( nonClone )
		{
			SessionState.WitchSplitLevel = 1;
			SessionState.AllowWitchSplit = true;
			splitAmount = 2;
		}
		else if ( firstClone )
		{
			SessionState.WitchSplitLevel = 2;
			SessionState.AllowWitchSplit = true;
			splitAmount = 3;
		}
		else
		{
			SessionState.AllowWitchSplit = false;
			SessionState.WitchesSplit = 0;
			SessionState.WitchSplitLevel = 0;
		}
	}
	else if ( victim.IsPlayer() )
	{
		spawnType = victim.GetZombieType();
		if ( victim.GetZombieType() == DirectorScript.ZOMBIE_BOOMER )
		{
			if ( nonClone )
			{
				SessionState.BoomerSplitLevel = 1;
				SessionState.AllowBoomerSplit = true;
				SessionOptions.BoomerLimit = 12;
				SessionOptions.TotalBoomers = 12;
				splitAmount = 2;
			}
			else if ( firstClone )
			{
				SessionState.BoomerSplitLevel = 2;
				SessionState.AllowBoomerSplit = true;
				SessionOptions.BoomerLimit = 12;
				SessionOptions.TotalBoomers = 12;
				splitAmount = 3;
			}
			else
			{
				SessionState.AllowBoomerSplit = false;
				SessionState.BoomersSplit = 0;
				SessionState.BoomerSplitLevel = 0;
			}
		}
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_SMOKER )
		{
			if ( nonClone )
			{
				SessionState.SmokerSplitLevel = 1;
				SessionState.AllowSmokerSplit = true;
				SessionOptions.SmokerLimit = 12;
				SessionOptions.TotalSmokers = 12;
				splitAmount = 2;
			}
			else if ( firstClone )
			{
				SessionState.SmokerSplitLevel = 2;
				SessionState.AllowSmokerSplit = true;
				SessionOptions.SmokerLimit = 12;
				SessionOptions.TotalSmokers = 12;
				splitAmount = 3;
			}
			else
			{
				SessionState.AllowSmokerSplit = false;
				SessionState.SmokersSplit = 0;
				SessionState.SmokerSplitLevel = 0;
			}
		}
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_HUNTER )
		{
			if ( nonClone )
			{
				SessionState.HunterSplitLevel = 1;
				SessionState.AllowHunterSplit = true;
				SessionOptions.HunterLimit = 12;
				SessionOptions.TotalHunters = 12;
				splitAmount = 2;
			}
			else if ( firstClone )
			{
				SessionState.HunterSplitLevel = 2;
				SessionState.AllowHunterSplit = true;
				SessionOptions.HunterLimit = 12;
				SessionOptions.TotalHunters = 12;
				splitAmount = 3;
			}
			else
			{
				SessionState.AllowHunterSplit = false;
				SessionState.HuntersSplit = 0;
				SessionState.HunterSplitLevel = 0;
			}
		}
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_CHARGER )
		{
			if ( nonClone )
			{
				SessionState.ChargerSplitLevel = 1;
				SessionState.AllowChargerSplit = true;
				SessionOptions.ChargerLimit = 12;
				SessionOptions.TotalChargers = 12;
				splitAmount = 2;
			}
			else if ( firstClone )
			{
				SessionState.ChargerSplitLevel = 2;
				SessionState.AllowChargerSplit = true;
				SessionOptions.ChargerLimit = 12;
				SessionOptions.TotalChargers = 12;
				splitAmount = 3;
			}
			else
			{
				SessionState.AllowChargerSplit = false;
				SessionState.ChargersSplit = 0;
				SessionState.ChargerSplitLevel = 0;
			}
		}
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_SPITTER )
		{
			if ( nonClone )
			{
				SessionState.SpitterSplitLevel = 1;
				SessionState.AllowSpitterSplit = true;
				SessionOptions.SpitterLimit = 12;
				SessionOptions.TotalSpitters = 12;
				splitAmount = 2;
			}
			else if ( firstClone )
			{
				SessionState.SpitterSplitLevel = 2;
				SessionState.AllowSpitterSplit = true;
				SessionOptions.SpitterLimit = 12;
				SessionOptions.TotalSpitters = 12;
				splitAmount = 3;
			}
			else
			{
				SessionState.AllowSpitterSplit = false;
				SessionState.SpittersSplit = 0;
				SessionState.SpitterSplitLevel = 0;
			}
		}
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_JOCKEY )
		{
			if ( nonClone )
			{
				SessionState.JockeySplitLevel = 1;
				SessionState.AllowJockeySplit = true;
				SessionOptions.JockeyLimit = 12;
				SessionOptions.TotalJockeys = 12;
				splitAmount = 2;
			}
			else if ( firstClone )
			{
				SessionState.JockeySplitLevel = 2;
				SessionState.AllowJockeySplit = true;
				SessionOptions.JockeyLimit = 12;
				SessionOptions.TotalJockeys = 12;
				splitAmount = 3;
			}
			else
			{
				SessionState.AllowJockeySplit = false;
				SessionState.JockeysSplit = 0;
				SessionState.JockeySplitLevel = 0;
			}
		}
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_TANK )
		{
			if ( nonClone )
			{
				SessionState.TankSplitLevel = 1;
				SessionState.AllowTankSplit = true;
				splitAmount = 2;
			}
			else if ( firstClone )
			{
				SessionState.TankSplitLevel = 2;
				SessionState.AllowTankSplit = true;
				splitAmount = 4;
			}
			else if ( secondClone )
			{
				SessionState.TankSplitLevel = 3;
				SessionState.AllowTankSplit = true;
				splitAmount = 3;
			}
			else
			{
				SessionState.AllowTankSplit = false;
				SessionState.TanksSplit = 0;
				SessionState.TankSplitLevel = 0;
			}
		}
	}
	
	if ( splitAmount == 2 )
	{
		ZSpawn( { type = spawnType, pos = victim.GetOrigin() + Vector( 10, 0, 0 ) } );
		ZSpawn( { type = spawnType, pos = victim.GetOrigin() + Vector( -10, 0, 0 ) } );
	}
	else if ( splitAmount == 3 )
	{
		ZSpawn( { type = spawnType, pos = victim.GetOrigin() + Vector( 10, 0, 0 ) } );
		ZSpawn( { type = spawnType, pos = victim.GetOrigin() + Vector( -10, 0, 0 ) } );
		ZSpawn( { type = spawnType, pos = victim.GetOrigin() + Vector( 20, 0, 0 ) } );
	}
	else if ( splitAmount == 4 )
	{
		ZSpawn( { type = spawnType, pos = victim.GetOrigin() + Vector( 10, 0, 0 ) } );
		ZSpawn( { type = spawnType, pos = victim.GetOrigin() + Vector( -10, 0, 0 ) } );
		ZSpawn( { type = spawnType, pos = victim.GetOrigin() + Vector( 20, 0, 0 ) } );
		ZSpawn( { type = spawnType, pos = victim.GetOrigin() + Vector( -20, 0, 0 ) } );
	}
	
	SessionOptions.BoomerLimit = 0;
	SessionOptions.SmokerLimit = 0;
	SessionOptions.HunterLimit = 0;
	SessionOptions.ChargerLimit = 0;
	SessionOptions.SpitterLimit = 0;
	SessionOptions.JockeyLimit = 0;
	SessionOptions.TotalBoomers = 0;
	SessionOptions.TotalSmokers = 0;
	SessionOptions.TotalHunters = 0;
	SessionOptions.TotalChargers = 0;
	SessionOptions.TotalSpitters = 0;
	SessionOptions.TotalJockeys = 0;

	if ( victim.IsPlayer() )
	{
		local stats = {};
		GetInfectedStats( stats );
		if ( victim.GetZombieType() == DirectorScript.ZOMBIE_TANK && stats.Tanks == 0 )
		{
			SessionState.TankInPlay = false;
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.AdvanceWave()", SessionState.AdvanceWaveTimer );
		}
		else if ( victim.GetZombieType() != DirectorScript.ZOMBIE_TANK && stats.Specials == 0 )
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.AdvanceWave()", SessionState.AdvanceWaveTimer );
	}
}

function Update()
{
	if ( SessionState.TriggerRescueThink )
		TriggerRescueThink();
	if ( Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
}
