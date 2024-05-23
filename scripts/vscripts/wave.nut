//-----------------------------------------------------
Msg("Activating Wave\n");

if ( !IsModelPrecached( "models/survivors/survivor_namvet.mdl" ) )
	PrecacheModel( "models/survivors/survivor_namvet.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_biker.mdl" ) )
	PrecacheModel( "models/survivors/survivor_biker.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_manager.mdl" ) )
	PrecacheModel( "models/survivors/survivor_manager.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_teenangst.mdl" ) )
	PrecacheModel( "models/survivors/survivor_teenangst.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_gambler.mdl" ) )
	PrecacheModel( "models/survivors/survivor_gambler.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_producer.mdl" ) )
	PrecacheModel( "models/survivors/survivor_producer.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_mechanic.mdl" ) )
	PrecacheModel( "models/survivors/survivor_mechanic.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_coach.mdl" ) )
	PrecacheModel( "models/survivors/survivor_coach.mdl" );

MutationOptions <-
{
	cm_AllowSurvivorRescue = 0
	cm_CommonLimit = 0
	cm_DominatorLimit = 12
	cm_MaxSpecials = 0
	cm_SpecialRespawnInterval = 0
	//cm_WanderingZombieDensityModifier = 0
	WanderingZombieDensityModifier = 0
	AlwaysAllowWanderers = false
	PreferredMobDirection = SPAWN_ANYWHERE
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	MegaMobMaxSize = 0
	MegaMobMinSize = 0
	MegaMobSize = 0
	MobSpawnSize = 0
	MobMinSize = 0
	MobMaxSize = 0
	MobMaxPending = 0
	//PanicForever = 1
	SpecialInfectedAssault = 1
	SurvivorMaxIncapacitatedCount = 0
	
	SmokerLimit = 0
	BoomerLimit = 0
	HunterLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	ChargerLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	
	TotalSpecials = 0
	TotalSmokers = 0
	TotalBoomers = 0
	TotalHunters = 0
	TotalSpitters = 0
	TotalJockeys = 0
	TotalChargers = 0
	
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
		weapon_first_aid_kit = 0
		weapon_pain_pills = 0
		weapon_adrenaline = 0
		weapon_defibrillator = 0
		weapon_upgradepack_incendiary = 0
		weapon_upgradepack_explosive = 0
		//upgrade_item = 0
		ammo = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
			return false;
		
		return true;
	}
	
	DefaultItems =
	[
		"weapon_pistol",
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
	PlayerCash = {}
	CurrentWave = -1
	WaveActive = false
	AdvanceMiniWave = false
	ExtraMiniWave = false
	InfectedAlive = 0
	SpawnTank = false
	BossTank = null
	BossHealth = 10000
	BossAlive = false
	PlayerInTrader = {}
	TraderOpen = false
	SpacerString = "  "
	SpawnedSurvivors = []
	
	function DisplayName(ind)
	{
		local p = GetPlayerFromCharacter(ind)
		if(p)
		{
			return (p.GetPlayerName())
		}
		else
		{
			return ""
		}
	}
	
	function DisplayCash(ind)
	{
		local p = GetPlayerFromCharacter(ind)
		if((p) && (g_ModeScript.GetSurvivorName(p) in SessionState.PlayerCash))
		{
			return (SessionState.PlayerCash[g_ModeScript.GetSurvivorName(p)])
		}
		else
		{
			return ""
		}
	}
}

function OnGameplayStart()
{
	//teleport players to the start point
	TeleportPlayersToStartPoints( "wave_playerstart" );
}

function GetSurvivorName( survivor )
{
	if ( Director.GetSurvivorSet() == 2 )
	{
		local survivorCharacter = NetProps.GetPropInt( survivor, "m_survivorCharacter" );
		if ( survivorCharacter == 4 )
			return "Bill";
		else if ( survivorCharacter == 5 )
			return "Zoey";
		else if ( survivorCharacter == 6 )
			return "Francis";
		else if ( survivorCharacter == 7 )
			return "Louis";
		else if ( survivorCharacter > 7 && NetProps.GetPropInt( survivor, "m_iTeamNum" ) == 4 )
			return "Survivor";
		else
			return GetCharacterDisplayName( survivor );
	}
	else
		return GetCharacterDisplayName( survivor );
}

function GetLookedAtPlayer( player )
{
	local startPt = player.EyePosition();
	local endPt = startPt + player.EyeAngles().Forward().Scale(999999);
	
	local m_trace = { start = startPt, end = endPt, ignore = player, mask = 33579137 };
	TraceLine(m_trace);
	
	if (!m_trace.hit || m_trace.enthit == null || m_trace.enthit == player)
		return null;
	
	if (m_trace.enthit.GetClassname() == "worldspawn" || !m_trace.enthit.IsValid())
		return null;
	
	return m_trace.enthit;
}

function UserConsoleCommand( player, args )
{
	// Separate the commands and arguments
	local arr = split(args, ",");
	local Command = arr[0];
	
	switch ( Command )
	{
		case "drop_cash":
		{
			local Amount = null;
			local Survivor = GetLookedAtPlayer( player );

			if ( !Survivor )
				return
			
			if ( arr.len() > 1 )
				Amount = arr[1].tointeger();
			
			if ( !Amount )
				Amount = 50;
			
			if ( !Survivor.IsSurvivor() )
				return;
			
			if ( SessionState.PlayerCash[GetSurvivorName( player )] < Amount )
				Amount = SessionState.PlayerCash[GetSurvivorName( player )];
			
			SessionState.PlayerCash[GetSurvivorName( Survivor )] += Amount;
			SessionState.PlayerCash[GetSurvivorName( player )] -= Amount;
			
			break;
		}
	}
}

/*function GetNextStage()
{
	if ( SessionState.SpawnTank )
	{
		Msg("Spawning Tank!\n");
		SessionOptions.ScriptedStageType = STAGE_TANK
		SessionOptions.ScriptedStageValue = 1
		SessionState.SpawnTank = false;
	}
	else
	{
		SessionOptions.ScriptedStageType = STAGE_DELAY
		SessionOptions.ScriptedStageValue = -1
	}
}*/

function GetNextWave()
{
	SessionState.CurrentWave++;
	SessionState.AdvanceMiniWave = true;
	
	switch ( SessionState.CurrentWave )
	{
		case 0:
		{
			HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, 10 );
			g_ModeScript.StatHUD.Fields.infectedalive.flags = g_ModeScript.StatHUD.Fields.infectedalive.flags | g_ModeScript.DirectorScript.HUD_FLAG_NOTVISIBLE
			g_ModeScript.StatHUD.Fields.tradertimer.flags = g_ModeScript.StatHUD.Fields.tradertimer.flags & ~g_ModeScript.DirectorScript.HUD_FLAG_NOTVISIBLE
			EntFire( "trader_door", "Close" );
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GetNextWave()", 10.0 );
			break;
		}
		case 1:
		{
			SetMobLimit(30);
			SessionState.InfectedAlive = 30;
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.CreatePanicEvent()", 15.0 );
			g_ModeScript.StatHUD.Fields.tradertimer.flags = g_ModeScript.StatHUD.Fields.tradertimer.flags | g_ModeScript.DirectorScript.HUD_FLAG_NOTVISIBLE
			g_ModeScript.StatHUD.Fields.infectedalive.flags = g_ModeScript.StatHUD.Fields.infectedalive.flags & ~g_ModeScript.DirectorScript.HUD_FLAG_NOTVISIBLE
			SessionState.WaveActive = true;
			EntFire( "info_director", "ForcePanicEvent" );
			StartAssault();
			break;
		}
		case 2:
		{
			SetMobLimit(45);
			SessionOptions.cm_MaxSpecials = 2;
			SessionOptions.BoomerLimit = 1;
			SessionOptions.HunterLimit = 1;
			SessionState.InfectedAlive = 47;
			EntFire( "info_director", "ForcePanicEvent" );
			StartAssault();
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.CreatePanicEvent()", 30.0 );
			break;
		}
		case 3:
		{
			SetMobLimit(60);
			SessionOptions.cm_MaxSpecials = 4;
			SessionOptions.BoomerLimit = 1;
			SessionOptions.HunterLimit = 1;
			SessionOptions.SmokerLimit = 1;
			SessionOptions.SpitterLimit = 1;
			SessionState.InfectedAlive = 64;
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.CreatePanicEvent()", 30.0 );
			EntFire( "info_director", "ForcePanicEvent" );
			StartAssault();
			break;
		}
		case 4:
		{
			SetMobLimit(60);
			SessionOptions.cm_MaxSpecials = 6;
			SessionOptions.BoomerLimit = 2;
			SessionOptions.HunterLimit = 1;
			SessionOptions.SmokerLimit = 1;
			SessionOptions.SpitterLimit = 1;
			SessionState.InfectedAlive = 81;
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.CreatePanicEvent()", 30.0 );
			EntFire( "info_director", "ForcePanicEvent" );
			StartAssault();
			break;
		}
		case 5:
		{
			SetMobLimit(60);
			SessionOptions.cm_MaxSpecials = 8;
			SessionOptions.BoomerLimit = 2;
			SessionOptions.HunterLimit = 2;
			SessionOptions.SmokerLimit = 1;
			SessionOptions.SpitterLimit = 1;
			SessionOptions.JockeyLimit = 1;
			SessionOptions.ChargerLimit = 1;
			SessionState.InfectedAlive = 98;
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.CreatePanicEvent()", 30.0 );
			EntFire( "info_director", "ForcePanicEvent" );
			StartAssault();
			break;
		}
		case 6:
		{
			SetMobLimit(60);
			SessionOptions.cm_MaxSpecials = 10;
			SessionOptions.BoomerLimit = 2;
			SessionOptions.HunterLimit = 2;
			SessionOptions.SmokerLimit = 2;
			SessionOptions.SpitterLimit = 2;
			SessionOptions.JockeyLimit = 1;
			SessionOptions.ChargerLimit = 1;
			SessionState.InfectedAlive = 115;
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.CreatePanicEvent()", 30.0 );
			EntFire( "info_director", "ForcePanicEvent" );
			StartAssault();
			break;
		}
		case 7:
		{
			SetMobLimit(60);
			SessionOptions.cm_MaxSpecials = 12;
			SessionOptions.BoomerLimit = 2;
			SessionOptions.HunterLimit = 2;
			SessionOptions.SmokerLimit = 2;
			SessionOptions.SpitterLimit = 2;
			SessionOptions.JockeyLimit = 2;
			SessionOptions.ChargerLimit = 2;
			SessionState.InfectedAlive = 132;
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.CreatePanicEvent()", 30.0 );
			EntFire( "info_director", "ForcePanicEvent" );
			StartAssault();
			break;
		}
		case 8:
		{
			SetMobLimit(60);
			SessionOptions.cm_MaxSpecials = 12;
			SessionOptions.BoomerLimit = 2;
			SessionOptions.HunterLimit = 2;
			SessionOptions.SmokerLimit = 2;
			SessionOptions.SpitterLimit = 2;
			SessionOptions.JockeyLimit = 2;
			SessionOptions.ChargerLimit = 2;
			SessionState.InfectedAlive = 147;
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.CreatePanicEvent()", 30.0 );
			EntFire( "info_director", "ForcePanicEvent" );
			StartAssault();
			break;
		}
		case 9:
		{
			SetMobLimit(60);
			SessionOptions.cm_MaxSpecials = 12;
			SessionOptions.BoomerLimit = 2;
			SessionOptions.HunterLimit = 2;
			SessionOptions.SmokerLimit = 2;
			SessionOptions.SpitterLimit = 2;
			SessionOptions.JockeyLimit = 2;
			SessionOptions.ChargerLimit = 2;
			SessionState.InfectedAlive = 162;
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.CreatePanicEvent()", 30.0 );
			EntFire( "info_director", "ForcePanicEvent" );
			StartAssault();
			break;
		}
		case 10:
		{
			SetMobLimit(60);
			SessionOptions.cm_MaxSpecials = 12;
			SessionOptions.BoomerLimit = 2;
			SessionOptions.HunterLimit = 2;
			SessionOptions.SmokerLimit = 2;
			SessionOptions.SpitterLimit = 2;
			SessionOptions.JockeyLimit = 2;
			SessionOptions.ChargerLimit = 2;
			SessionState.InfectedAlive = 177;
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.CreatePanicEvent()", 30.0 );
			EntFire( "info_director", "ForcePanicEvent" );
			StartAssault();
			break;
		}
		case 11:
		{
			SessionOptions.TankLimit = 1;
			SessionOptions.cm_TankLimit = 1;
			SessionOptions.ZombieTankHealth <- 10000;
			SessionState.InfectedAlive = 1;
			//SessionState.SpawnTank = true;
			//Director.ForceNextStage();
			SessionState.BossAlive = true;
			ZSpawn( { type = 8 } );
			g_ModeScript.StatHUD.Fields.infectedalive.datafunc = g_ModeScript.StatHUD.Fields.infectedalive.datafunc = @() SessionState.BossHealth
			break;
		}
		default:
			break;
	}
}

function CreatePanicEvent()
{
	if ( SessionState.InfectedAlive > 0 )
	{
		EntFire( "info_director", "ForcePanicEvent" );
		StartAssault();
	}
}

function ReviveSurvivors()
{
	foreach( survivor in SessionState.SpawnedSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) != 0 )
			survivor.ReviveByDefib();
	}
}

function WarpSurvivors()
{
	local TraderWarpZone = Entities.FindByName( null, "trader_warp_zone" ).GetOrigin();
	foreach( survivor in SessionState.SpawnedSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
		{
			for ( local trigger; trigger = Entities.FindByName( trigger, "trader_trigger" ); )
			{
				if ( trigger.IsTouching( survivor ) )
					survivor.SetOrigin( TraderWarpZone );
			}
		}
	}
}

function SetMobLimit( amount )
{
	SessionOptions.cm_CommonLimit = amount;
	SessionOptions.MegaMobMaxSize = amount;
	SessionOptions.MegaMobMinSize = amount;
	SessionOptions.MegaMobSize = amount;
	SessionOptions.MobSpawnSize = amount;
	SessionOptions.MobMinSize = amount;
	SessionOptions.MobMaxSize = amount;
	SessionOptions.MobMaxPending = amount;
}

function AdvanceMiniWave()
{
	switch ( SessionState.CurrentWave )
	{
		case 4:
		{
			SetMobLimit(15);
			break;
		}
		case 5:
		{
			SetMobLimit(30);
			break;
		}
		case 6:
		{
			SetMobLimit(45);
			break;
		}
		case 7:
		{
			SetMobLimit(60);
			break;
		}
		case 8:
		{
			if ( SessionState.ExtraMiniWave )
			{
				SetMobLimit(15);
				SessionState.ExtraMiniWave = false;
			}
			else
			{
				SetMobLimit(60);
				SessionState.ExtraMiniWave = true;
				SessionState.AdvanceMiniWave = true;
			}
			break;
		}
		case 9:
		{
			if ( SessionState.ExtraMiniWave )
			{
				SetMobLimit(30);
				SessionState.ExtraMiniWave = false;
			}
			else
			{
				SetMobLimit(60);
				SessionState.ExtraMiniWave = true;
				SessionState.AdvanceMiniWave = true;
			}
			break;
		}
		case 10:
		{
			if ( SessionState.ExtraMiniWave )
			{
				SetMobLimit(45);
				SessionState.ExtraMiniWave = false;
			}
			else
			{
				SetMobLimit(60);
				SessionState.ExtraMiniWave = true;
				SessionState.AdvanceMiniWave = true;
			}
			break;
		}
		default:
			break;
	}
	CreatePanicEvent();
}

function PlayWhitakerVoice( soundName )
{
	local whitakerTbl = { classname = "ambient_generic", health = "10", message = soundName, pitch = "100", pitchstart = "100", radius = "1250", spawnflags = "33", origin = Vector( 0, 0, 0 ) };
	local voiceLine = CreateSingleSimpleEntityFromTable( whitakerTbl );
	DoEntFire( "!self", "PlaySound", "", 0, null, voiceLine );
	DoEntFire( "!self", "Kill", "", 0, null, voiceLine );
}

function OpenTrader()
{
	local RandomSound = RandomInt( 0, 1 );
	EntFire( "trader_door", "Open" );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.TraderNags()", 30.0 );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.CloseTrader()", 60.0 );
	HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, 60 );
	g_ModeScript.StatHUD.Fields.infectedalive.flags = g_ModeScript.StatHUD.Fields.infectedalive.flags | g_ModeScript.DirectorScript.HUD_FLAG_NOTVISIBLE
	g_ModeScript.StatHUD.Fields.tradertimer.flags = g_ModeScript.StatHUD.Fields.tradertimer.flags & ~g_ModeScript.DirectorScript.HUD_FLAG_NOTVISIBLE
	if ( RandomSound == 0 )
		PlayWhitakerVoice( "npc/Whitaker/ComeUpstairsLongerB02.wav" );
	else
		PlayWhitakerVoice( "npc/Whitaker/ComeUpstairsLongerA02.wav" );
	ReviveSurvivors();
	SessionState.TraderOpen = true;
}

function CloseTrader()
{
	local RandomSound = RandomInt( 0, 2 );
	EntFire( "trader_door", "Close" );
	WarpSurvivors();
	g_ModeScript.StatHUD.Fields.tradertimer.flags = g_ModeScript.StatHUD.Fields.tradertimer.flags | g_ModeScript.DirectorScript.HUD_FLAG_NOTVISIBLE
	g_ModeScript.StatHUD.Fields.infectedalive.flags = g_ModeScript.StatHUD.Fields.infectedalive.flags & ~g_ModeScript.DirectorScript.HUD_FLAG_NOTVISIBLE
	if ( RandomSound == 0 )
		PlayWhitakerVoice( "npc/Whitaker/DefendChatter15.wav" );
	else
		PlayWhitakerVoice( "npc/Whitaker/DefendChatter14.wav" );
	GetNextWave();
	SessionState.TraderOpen = false;
}

function TraderNags()
{
	local RandomSound = RandomInt( 0, 3 );
	if ( RandomSound == 0 )
		PlayWhitakerVoice( "npc/Whitaker/Nags02.wav" );
	else if ( RandomSound == 1 )
		PlayWhitakerVoice( "npc/Whitaker/Nags04.wav" );
	else if ( RandomSound == 2 )
		PlayWhitakerVoice( "npc/Whitaker/Nags05.wav" );
	else
		PlayWhitakerVoice( "npc/Whitaker/Nags07.wav" );
}

function OnGameEvent_round_start_post_nav( params )
{
	for ( local gascan; gascan = Entities.FindByModel( gascan, "models/props_junk/gascan001a.mdl" ); )
	{
		if ( gascan.GetName().find("_gascan") == null )
			gascan.Kill();
	}
	for ( local propanetank; propanetank = Entities.FindByModel( propanetank, "models/props_junk/propanecanister001a.mdl" ); )
	{
		if ( propanetank.GetName().find("_propanetank") == null )
			propanetank.Kill();
	}
	for ( local oxygentank; oxygentank = Entities.FindByModel( oxygentank, "models/props_equipment/oxygentank01.mdl" ); )
	{
		if ( oxygentank.GetName().find("_oxygentank") == null )
			oxygentank.Kill();
	}
	for ( local fireworkcrate; fireworkcrate = Entities.FindByModel( fireworkcrate, "models/props_junk/explosive_box001.mdl" ); )
	{
		if ( fireworkcrate.GetName().find("_fireworkcrate") == null )
			fireworkcrate.Kill();
	}
	EntFire( "weapon_spawn", "Kill" );
	EntFire( "upgrade_item", "Kill" );
	EntFire( "upgrade_laser_sight", "Kill" );
	
	EntFire( "prop_minigun", "Kill" );
	EntFire( "prop_minigun_l4d1", "Kill" );
	EntFire( "prop_mounted_machine_gun", "Kill" );
	
	if ( SessionState.MapName == "c4m1_milltown_a" || SessionState.MapName == "c4m4_milltown_b" )
	{
		for ( local ladder; ladder = Entities.FindByClassnameWithin( ladder, "func_simpleladder", Vector( -249, 6145, 105.001 ), 10 ); )
			ladder.Kill();
	}
}

function OnGameEvent_round_start( params )
{
	for ( local trigger; trigger = Entities.FindByName( trigger, "trader_trigger" ); )
	{
		if ( trigger.ValidateScriptScope() )
		{
			local triggerScope = trigger.GetScriptScope();
			triggerScope["SurvivorInTrader"] <- function()
			{
				if ( !activator.IsSurvivor() )
					return;
				//printl(activator.GetPlayerName() + " in trader");
				SessionState.PlayerInTrader[g_ModeScript.GetSurvivorName( activator )] <- true;
			}
			trigger.ConnectOutput( "OnStartTouch", "SurvivorInTrader" );

			triggerScope["SurvivorNotInTrader"] <- function()
			{
				if ( !activator.IsSurvivor() )
					return;
				//printl(activator.GetPlayerName() + " not in trader");
				SessionState.PlayerInTrader[g_ModeScript.GetSurvivorName( activator )] <- false;
			}
			trigger.ConnectOutput( "OnEndTouch", "SurvivorNotInTrader" );
		}
	}
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	SessionState.PlayerInTrader[GetSurvivorName( player )] <- false;
	SessionState.PlayerCash[GetSurvivorName( player )] <- 0;

	if ( NetProps.GetPropInt( player, "m_iTeamNum" ) == 4 )
		NetProps.SetPropInt( player, "m_iTeamNum", 2 );
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

function OnGameEvent_tank_spawn( params )
{
	local tank = GetPlayerFromUserID( params["userid"] );
	if ( !tank )
		return;

	if ( SessionState.CurrentWave == 11 )
	{
		DoEntFire( "!self", "Color", "255 0 0", 0, null, tank );
		SessionState.BossTank = tank;
	}
}

function OnGameEvent_player_hurt( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (player.IsSurvivor()) )
		return;

	if ( SessionState.BossAlive && player.GetZombieType() == DirectorScript.ZOMBIE_TANK )
		SessionState.BossHealth = params["health"];
}

function EndGame()
{
	local finaletbl =
	{
		disableshadows = "1",
		model = "models/props/terror/hamradio.mdl",
		skin = "0",
		VersusTravelCompletion = "0.2",
		origin = Vector(0, 0, 0),
		angles = Vector(0, 0, 0)
	};

	local fadetbl =
	{
		duration = "0",
		holdtime = "0",
		renderamt = "255",
		rendercolor = "0 0 0",
		spawnflags = "8",
		origin = Vector(0, 0, 0),
		angles = Vector(0, 0, 0)
	};

	local trigger_finale = SpawnEntityFromTable( "trigger_finale", finaletbl );
	local env_fade = SpawnEntityFromTable( "env_fade", fadetbl );
	local outtro_stats = SpawnEntityFromTable( "env_outtro_stats", { origin = Vector(0, 0, 0), angles = Vector(0, 0, 0) } );

	local eventtbl =
	{
		event_name = "gameinstructor_nodraw",
		range = "0",
		spawnflags = "0",
		targetname = "zsl_tmp_" + UniqueString(),
		origin = Vector(0, 0, 0),
		angles = Vector(0, 0, 0)
	};

	local event_proxy = SpawnEntityFromTable( "info_game_event_proxy", eventtbl );

	DoEntFire( "!self", "GenerateGameEvent", "", 0, null, event_proxy );
	DoEntFire( "!self", "Kill", "", 0, null, event_proxy );
	
	SessionOptions.cm_DominatorLimit <- 0;
	SessionOptions.DominatorLimit <- 0;
	SessionOptions.cm_MaxSpecials <- 0;
	SessionOptions.MaxSpecials <- 0;
	SessionOptions.cm_CommonLimit <- 0;
	SessionOptions.CommonLimit <- 0;
	SessionOptions.SmokerLimit <- 0;
	SessionOptions.BoomerLimit <- 0;
	SessionOptions.HunterLimit <- 0;
	SessionOptions.SpitterLimit <- 0;
	SessionOptions.JockeyLimit <- 0;
	SessionOptions.ChargerLimit <- 0;
	SessionOptions.WitchLimit <- 0;
	SessionOptions.cm_WitchLimit <- 0;
	SessionOptions.TankLimit <- 0;
	SessionOptions.cm_TankLimit <- 0;

	for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
		infected.Kill();
	for ( local witch; witch = Entities.FindByClassname( witch, "witch" ); )
		witch.Kill();
	for ( local player; player = Entities.FindByClassname( player, "player" ); )
	{
		if ( player.IsSurvivor() )
			continue;

		if ( IsPlayerABot( player ) )
			player.Kill();
	}

	DoEntFire( "!self", "Alpha", "255", 0, null, env_fade );
	DoEntFire( "!self", "Fade", "", 0, null, env_fade );
	DoEntFire( "!self", "FinaleEscapeFinished", "", 0, null, trigger_finale );
	DoEntFire( "!self", "FinaleEscapeForceSurvivorPositions", "", 0, null, trigger_finale );
	DoEntFire( "!self", "RollStatsCrawl", "", 0.1, null, outtro_stats );
}

function OnGameEvent_tank_killed( params )
{
	local tank = GetPlayerFromUserID( params["userid"] );
	if ( !tank )
		return;

	if ( tank == SessionState.BossTank )
	{
		Say( null, "Your squad survived!", false );
		SessionState.BossAlive = false;
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.EndGame()", 5.0 );
	}
}

function OnGameEvent_player_death( params )
{
	local victim = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( ( !victim ) || ( (victim.IsPlayer()) && (victim.IsSurvivor()) ) )
		return;
	
	local attacker = GetPlayerFromUserID( params["attacker"] );
	if ( attacker )
	{
		if ( victim.IsPlayer() )
		{
			if ( attacker.IsSurvivor() )
				SessionState.PlayerCash[GetSurvivorName( attacker )] += 25;
			if ( SessionOptions.cm_MaxSpecials > 0 ) //&& SessionState.InfectedAlive > 0 )
			{
				SessionState.InfectedAlive--;
				SessionOptions.cm_MaxSpecials--;
			}
		}
		else if ( victim.GetClassname() == "infected" )
		{
			if ( attacker.IsSurvivor() )
				SessionState.PlayerCash[GetSurvivorName( attacker )] += 5;
			if ( SessionOptions.cm_CommonLimit > 0 )
			{
				SessionState.InfectedAlive--;
				SessionOptions.cm_CommonLimit--;
			}
		}
	}
}

function OnGameEvent_mission_lost( params )
{
	for ( local player; player = Entities.FindByClassname( player, "player" ); )
	{
		if ( !player.IsSurvivor() )
			continue;

		if ( NetProps.GetPropInt( player, "m_survivorCharacter" ) > 3 )
		{
			NetProps.SetPropInt( player, "m_iTeamNum", 4 );
			player.Kill();
		}
	}
}

function SetupModeHUD()
{
	StatHUD <-
	{
		Fields =
		{
			infectedalive =
			{
				slot = HUD_MID_BOX ,
				datafunc = @() SessionState.InfectedAlive,
				name = "infectedalive",
				flags = DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
			}
			wave =
			{
				slot = HUD_SCORE_TITLE ,
				datafunc = @() "Wave " + SessionState.CurrentWave + " / " + "10",
				name = "wave",
				flags = DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
			}
			tradertimer =
			{
				slot = HUD_LEFT_TOP ,
				name = "tradertimer",
				flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_COUNTDOWN_WARN | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
				special = HUD_SPECIAL_TIMER0
			}
			name0 =
			{
				slot = HUD_FAR_LEFT ,
				datafunc = @() SessionState.DisplayName(0) + SessionState.SpacerString + "$" + SessionState.DisplayCash(0),
				name = "name0",
				flags = DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
			name1 =
			{
				slot = HUD_MID_TOP ,
				datafunc = @() SessionState.DisplayName(1) + SessionState.SpacerString + "$" + SessionState.DisplayCash(1),
				name = "name1",
				flags = DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
			name2 =
			{
				slot = HUD_FAR_RIGHT ,
				datafunc = @() "$" + SessionState.DisplayCash(2) + SessionState.SpacerString + SessionState.DisplayName(2),
				name = "name2",
				flags = DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_NOBG,
			}
			name3 =
			{
				slot = HUD_MID_BOT ,
				datafunc = @() "$" + SessionState.DisplayCash(3) + SessionState.SpacerString + SessionState.DisplayName(3),
				name = "name3",
				flags = DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_NOBG,
			}
		}
	}
	HUDPlace( HUD_MID_BOX, 0.0, 0.00, 1.0, 0.045 );
	HUDPlace( HUD_SCORE_TITLE, 0.0, 0.04, 1.0, 0.045 );
	HUDPlace( HUD_LEFT_TOP, 0.0, 0.00, 1.0, 0.045 );
	HUDPlace( HUD_FAR_LEFT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_TOP, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_FAR_RIGHT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOT, 0.0, 0.06, 1.0, 0.045 );
	HUDSetLayout( StatHUD );
	GetNextWave();
}

function Update()
{
	if ( SessionState.AdvanceMiniWave && !SessionState.TraderOpen && SessionState.InfectedAlive > 0 && SessionOptions.cm_CommonLimit <= 0 )
	{
		if ( SessionState.CurrentWave >= 4 && SessionState.InfectedAlive != SessionOptions.cm_MaxSpecials )
		{
			SessionState.AdvanceMiniWave = false;
			AdvanceMiniWave();
		}
	}
	if ( !SessionState.TraderOpen && SessionState.WaveActive && SessionState.InfectedAlive <= 0 )
	{
		OpenTrader();
	}
	if ( (SessionState.CurrentWave == 11) && (SessionState.BossTank != null) && (NetProps.GetPropInt( SessionState.BossTank, "m_lifeState" ) == 0) )
	{
		if ( SessionState.BossTank.GetHealth() < 10000 )
		{
			SessionState.BossTank.SetHealth( SessionState.BossTank.GetHealth() + 100 );
			SessionState.BossHealth += 100;
		}
	}
}
