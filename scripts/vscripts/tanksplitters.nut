//-----------------------------------------------------
Msg("Activating Tank Splitters\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	cm_ShouldHurry = 1
	cm_AllowSurvivorRescue = 0
	cm_InfiniteFuel = 1
	cm_ProhibitBosses = 1
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
	TankLimit = 15
	cm_TankLimit = 15
	
	EscapeSpawnTanks = false

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
		//weapon_pipe_bomb = 0
		//weapon_molotov = 0
		//weapon_vomitjar = 0
		weapon_first_aid_kit = 0
		weapon_pain_pills = 0
		weapon_adrenaline = 0
		weapon_defibrillator = 0
		//weapon_upgradepack_incendiary = 0
		//weapon_upgradepack_explosive = 0
		//upgrade_item = 0
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
	SpawnTank = false
	TankSpawnDelay = 20
	FinaleStartTime = 0
	TriggerRescue = false
	RescueDelay = 240
	TriggerRescueThink = false
	AllowTankSplit = false
	TanksSplit = 0
	TankSplitLevel = 0
	SpecialCloned = {}
	NonClone = {}
	FirstClone = {}
	SecondClone = {}
	LastHPRegenTime = 0
	HPRegenDelay = 3.0
	AllSurvivors = []
	RandomWeps =
	[
		"smg"
		"smg_silenced"
		"pumpshotgun"
		"shotgun_chrome"
		"autoshotgun"
		"shotgun_spas"
		"rifle"
		"rifle_ak47"
		"rifle_desert"
		"hunting_rifle"
		"sniper_military"
		"smg_mp5"
		"rifle_sg552"
		//"sniper_scout"
		//"sniper_awp"
	]
}

function GetNextStage()
{
	if ( SessionState.SpawnTank )
	{
		SessionOptions.ScriptedStageType = STAGE_TANK;
		SessionOptions.ScriptedStageValue = 1;
		SessionState.SpawnTank = false;
	}
	else if ( !SessionState.SpawnTank )
	{
		SessionOptions.ScriptedStageType = STAGE_DELAY;
		SessionOptions.ScriptedStageValue = -1;
	}
	if ( SessionState.TriggerRescue )
	{
		SessionOptions.ScriptedStageType = STAGE_ESCAPE;
		SessionState.TriggerRescue = false;
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

function GiveWeapons( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	local items = {};
	GetInvTable( player, items );
	if ( "slot0" in items )
		items["slot0"].Kill();

	player.GiveItem( SessionState.RandomWeps[ RandomInt( 0, SessionState.RandomWeps.len() - 1 ) ] );
	player.GiveItem( "pistol_magnum" );
	player.GiveUpgrade( DirectorScript.UPGRADE_LASER_SIGHT );
}

function KillInfected( infectedID, attackerID )
{
	local infected = GetPlayerFromUserID( infectedID );
	local attacker = GetPlayerFromUserID( attackerID );
	if ( !infected || !attacker )
		return;

	infected.TakeDamage( infected.GetHealth(), 0, attacker );

	if ( NetProps.GetPropInt( infected, "m_lifeState" ) == 0 )
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillInfected(" + infectedID + "," + attackerID + ")", 0.1 );
}

function TankDeathCheck()
{
	local stats = {};
	GetInfectedStats( stats );
	if ( stats.Tanks == 0 )
	{
		SessionState.AllowTankSplit = false;
		SessionState.TanksSplit = 0;
		SessionState.TankSplitLevel = 0;
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SpawnTank()", SessionState.TankSpawnDelay );
	}
}

function SpawnTank()
{
	SessionState.SpawnTank = true;
	Director.ForceNextStage();
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.TankDeathCheck()", 3.0 );
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

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( damageTable.Attacker.IsPlayer() && damageTable.Victim.IsPlayer() )
	{
		if ( damageTable.Victim.IsSurvivor() && damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_TANK )
			damageTable.DamageDone = 10;
		else if ( damageTable.Victim.GetZombieType() == DirectorScript.ZOMBIE_TANK && damageTable.Attacker.IsSurvivor() )
		{
			if ( (damageTable.Inflictor) && (damageTable.Inflictor.GetClassname() == "pipe_bomb_projectile") )
				damageTable.DamageDone = 6000;
		}
	}

	return true;
}

function OnGameEvent_round_start_post_nav( params )
{
	EntFire( "info_zombie_spawn", "Kill" );
	EntFire( "tankdoorout_button", "Unlock" );
	EntFire( "tank_sound_timer", "Kill" );

	if ( SessionState.MapName == "AirCrash" )
	{
		EntFire( "breakwall1", "Break" );
		EntFire( "breakwall2", "Break" );
		EntFire( "breakwall_stop", "Kill" );
	}

	EntFire( "weapon_spawn", "Kill" );
	foreach( wep, val in MutationOptions.weaponsToRemove )
		EntFire( wep + "_spawn", "Kill" );
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
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveWeapons(" + userid + ")", 0.1 );
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

	SpawnTank();
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	
	if ( ( !victim ) || ( !victim.IsSurvivor() ) )
		return;
	
	EntFire( "survivor_death_model", "BecomeRagdoll" );
}

function OnGameEvent_revive_success( params )
{
	if ( !("subject" in params) )
		return;
	
	local player = GetPlayerFromUserID( params["subject"] );
	
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;
	
	player.SetHealth( 50 );
	player.SetHealthBuffer( 0 );
}

function OnGameEvent_player_now_it( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (player.IsSurvivor()) )
		return;

	if ( player.GetZombieType() == DirectorScript.ZOMBIE_TANK )
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillInfected(" + params["userid"] + "," + params["attacker"] + ")", 5.0 );
}

function OnGameEvent_player_entered_checkpoint( params )
{
	local character = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( !character )
		return;

	if ( NetProps.GetPropInt( character, "m_iTeamNum" ) == 3 )
		character.TakeDamage( character.GetMaxHealth(), 0, Entities.First() );
}

function OnGameEvent_tank_spawn( params )
{
	local tank = GetPlayerFromUserID( params["userid"] );
	if ( !tank )
		return;

	local splitAmount = 0;
	if ( SessionState.AllowTankSplit )
	{
		if ( SessionState.TankSplitLevel == 1 )
		{
			SessionState.FirstClone[tank.GetEntityIndex()] <- true;
			tank.SetHealth(3000);
			DoEntFire( "!self", "Color", "255 85 0", 0, null, tank );
			splitAmount = 2;
		}
		else if ( SessionState.TankSplitLevel == 2 )
		{
			SessionState.SecondClone[tank.GetEntityIndex()] <- true;
			tank.SetHealth(1500);
			DoEntFire( "!self", "Color", "189 74 255", 0, null, tank );
			splitAmount = 4;
		}
		else if ( SessionState.TankSplitLevel == 3 )
		{
			SessionState.SpecialCloned[tank.GetEntityIndex()] <- true;
			tank.SetHealth(500);
			DoEntFire( "!self", "Color", "0 255 255", 0, null, tank );
			splitAmount = 4;
		}
		
		/*if ( SessionState.TanksSplit < splitAmount )
		{
			SessionState.TanksSplit++;
			
			if ( SessionState.TanksSplit == splitAmount )
			{
				SessionState.AllowTankSplit = false;
				SessionState.TanksSplit = 0;
			}
		}*/
	}
	else
	{
		local stats = {};
		GetInfectedStats( stats );
		if ( stats.Tanks > 0 )
		{
			printl("ALERT: Prime Tank has spawned while other Tanks are alive!!!");
			tank.Kill();
		}
		else
		{
			SessionState.NonClone[tank.GetEntityIndex()] <- true;
			DoEntFire( "!self", "Color", "255 69 169", 0, null, tank );
			tank.SetHealth(6000);
		}
	}
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillInfected(" + params["userid"] + "," + params["userid"] + ")", 30.0 );
}

function OnGameEvent_tank_killed( params )
{
	local tank = GetPlayerFromUserID( params["userid"] );
	if ( !tank )
		return;

	local nonClone = false;
	local firstClone = false;
	local secondClone = false;
	if ( (tank.GetEntityIndex() in SessionState.SpecialCloned) && (SessionState.SpecialCloned[tank.GetEntityIndex()]) )
	{
		SessionState.SpecialCloned[tank.GetEntityIndex()] <- false;
		//return;
	}
	if ( (tank.GetEntityIndex() in SessionState.NonClone) && (SessionState.NonClone[tank.GetEntityIndex()]) )
	{
		SessionState.NonClone[tank.GetEntityIndex()] <- false;
		nonClone = true;
	}
	if ( (tank.GetEntityIndex() in SessionState.FirstClone) && (SessionState.FirstClone[tank.GetEntityIndex()]) )
	{
		SessionState.FirstClone[tank.GetEntityIndex()] <- false;
		firstClone = true;
	}
	if ( (tank.GetEntityIndex() in SessionState.SecondClone) && (SessionState.SecondClone[tank.GetEntityIndex()]) )
	{
		SessionState.SecondClone[tank.GetEntityIndex()] <- false;
		secondClone = true;
	}
	local splitAmount = 0;
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
		splitAmount = 4;
	}
	else
	{
		SessionState.AllowTankSplit = false;
		SessionState.TanksSplit = 0;
		SessionState.TankSplitLevel = 0;
	}
	
	if ( splitAmount == 2 )
	{
		ZSpawn( { type = 8, pos = tank.GetOrigin() + Vector( 10, 0, 0 ) } );
		ZSpawn( { type = 8, pos = tank.GetOrigin() + Vector( -10, 0, 0 ) } );
	}
	else if ( splitAmount == 3 )
	{
		ZSpawn( { type = 8, pos = tank.GetOrigin() + Vector( 10, 0, 0 ) } );
		ZSpawn( { type = 8, pos = tank.GetOrigin() + Vector( -10, 0, 0 ) } );
		ZSpawn( { type = 8, pos = tank.GetOrigin() + Vector( 20, 0, 0 ) } );
	}
	else if ( splitAmount == 4 )
	{
		ZSpawn( { type = 8, pos = tank.GetOrigin() + Vector( 10, 0, 0 ) } );
		ZSpawn( { type = 8, pos = tank.GetOrigin() + Vector( -10, 0, 0 ) } );
		ZSpawn( { type = 8, pos = tank.GetOrigin() + Vector( 20, 0, 0 ) } );
		ZSpawn( { type = 8, pos = tank.GetOrigin() + Vector( -20, 0, 0 ) } );
	}
	
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.TankDeathCheck()", 0.5 );
}

function Update()
{
	if ( SessionState.TriggerRescueThink )
		TriggerRescueThink();
	if ( (Time() - SessionState.LastHPRegenTime) >= SessionState.HPRegenDelay )
	{
		foreach( survivor in SessionState.AllSurvivors )
		{
			if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
			{
				if ( survivor.GetHealth() < survivor.GetMaxHealth() )
					survivor.SetHealth( survivor.GetHealth() + 1 );
			}
		}
		SessionState.LastHPRegenTime = Time();
	}
	if ( Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
}
