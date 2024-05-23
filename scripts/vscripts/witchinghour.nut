//-----------------------------------------------------
Msg("Activating The Witching Hour\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

MutationOptions <-
{
	cm_AllowSurvivorRescue = 0
	CommonLimit = 0
	MaxSpecials = 0
	SmokerLimit = 0
	BoomerLimit = 0
	HunterLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	ChargerLimit = 0
	TankLimit = 0
	WitchLimit = 10
	cm_WitchLimit = 10
	
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
		//weapon_molotov = 0
		weapon_vomitjar = 0
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
	
	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_upgradepack_explosive =	"weapon_upgradepack_incendiary"
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
		"weapon_pistol_magnum"
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
	CurrentStage = -1
	FinaleStarted = false
	FinaleStartTime = 0
	TriggerRescue = false
	RescueDelay = 260
	TriggerRescueThink = false
	WitchesAlive = 0
	LastWitchSpawnTime = 0
	WitchSpawnInterval = 1
	SpawnWitchThink = false
	WipedWeapons = false
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

if ( IsMissionFinalMap() )
{
	function GetNextStage()
	{
		if ( SessionState.TriggerRescue )
		{
			SessionOptions.ScriptedStageType = STAGE_ESCAPE
			SessionOptions.ScriptedStageValue = 0
			SessionState.TriggerRescue = false;
		}
	}
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( damageTable.Attacker.GetClassname() == "witch" && damageTable.Victim.IsPlayer() )
	{
		if ( damageTable.Victim.IsSurvivor() )
		{
			if ( GetDifficulty() == 0 )
				damageTable.DamageDone = 3;
			else if ( GetDifficulty() == 1 )
				damageTable.DamageDone = 4;
			else if ( GetDifficulty() == 2 )
				damageTable.DamageDone = 5;
			else if ( GetDifficulty() == 3 )
				damageTable.DamageDone = 10;
		}
	}

	return true;
}

function SetupModeHUD()
{
	if ( !Entities.FindByClassname( null, "game_scavenge_progress_display" ) && !Entities.FindByClassname( null, "weapon_scavenge_item_spawn" ) )
	{
		WitchingHourHUD <-
		{
			Fields =
			{
				timer = 
				{
					slot = HUD_MID_TOP ,
					staticstring = "Witches recalled to the Netherworld in: ",
					name = "timer",
					flags = DirectorScript.HUD_FLAG_COUNTDOWN_WARN | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
					special = HUD_SPECIAL_TIMER0
				}
			}
		}
		HUDPlace( HUD_MID_TOP, 0.0, 0.00, 1.0, 0.045 );
		HUDSetLayout( WitchingHourHUD );
	}
}

function RespawnWitches()
{
	if ( !Entities.FindByClassname( null, "game_scavenge_progress_display" ) && !Entities.FindByClassname( null, "weapon_scavenge_item_spawn" ) )
		HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, 120 );
	Say( null, "The Witching Hour Has Begun...", false );
	SessionOptions.cm_WitchLimit = 10;
	
	// This will kill the witches in 120 seconds
	if ( !Entities.FindByClassname( null, "game_scavenge_progress_display" ) && !Entities.FindByClassname( null, "weapon_scavenge_item_spawn" ) )
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillWitches()", 120.0 );
	
	SessionState.SpawnWitchThink = true;
}

function KillWitches()
{
	EntFire( "witch", "Kill" );
	SessionOptions.cm_WitchLimit = 0;
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.RespawnWitches()", 30.0 );
	SessionState.SpawnWitchThink = false;
}

function SpawnWitchThink()
{
	if ( SessionOptions.cm_WitchLimit == 0 )
		return;

	if ( (SessionState.WitchesAlive < SessionOptions.cm_WitchLimit) && ((Time() - SessionState.LastWitchSpawnTime) >= SessionState.WitchSpawnInterval || SessionState.LastWitchSpawnTime == 0) )
	{
		local witchType = 7;
		if ( SessionState.MapName == "c6m1_riverbank" )
			witchType = 11;

		local survivor = null;
		local flow = -1;
		for ( local player; player = Entities.FindByClassname( player, "player" ); )
		{
			if ( !player.IsSurvivor() )
				continue;

			local dist = GetCurrentFlowDistanceForPlayer( player );
			if ( dist > flow )
			{
				survivor = player;
				flow = dist;
			}
		}

		if ( !survivor )
			return;

		if ( ZSpawn( { type = witchType, pos = survivor.TryGetPathableLocationWithin( RandomInt( 800, 1200 ) ) } ) )
			SessionState.LastWitchSpawnTime = Time();
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

function ClearWeapons()
{
	foreach( wep, val in MutationOptions.weaponsToRemove )
	{
		for ( local weapon; weapon = Entities.FindByClassname( weapon, wep ); )
		{
			if ( !weapon.GetOwnerEntity() )
				weapon.Kill();
		}
	}
}

function GiveWeapons( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.GiveItem( SessionState.RandomWeps[ RandomInt( 0, SessionState.RandomWeps.len() - 1 ) ] );
	player.GiveItem( "pistol_magnum" );
	player.GiveUpgrade( DirectorScript.UPGRADE_LASER_SIGHT );
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.SetHealthBuffer( 0 );
	player.SetHealth( player.GetMaxHealth() );
	//player.SetReviveCount( 0 );
	NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
	StopSoundOn( "Player.Heartbeat", player );

	if ( !SessionState.WipedWeapons )
	{
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ClearWeapons()", 0.2 );
		SessionState.WipedWeapons = true;
	}

	local invTable = {};
	GetInvTable( player, invTable );
	foreach( weapon in invTable )
		weapon.Kill();
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveWeapons(" + userid + ")", 0.1 );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}

function OnGameEvent_round_start_post_nav( params )
{
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

	if ( SessionState.MapName == "AirCrash" )
	{
		EntFire( "breakwall1", "Break" );
		EntFire( "breakwall2", "Break" );
		EntFire( "breakwall_stop", "Kill" );
	}

	EntFire( "weapon_spawn", "Kill" );
	foreach( wep, val in MutationOptions.weaponsToRemove )
		EntFire( wep + "_spawn", "Kill" );
	
	EntFire( "tankdoorout_button", "Unlock" );
	EntFire( "tank_sound_timer", "Kill" );
	//Utils.CreateEntity( "game_ragdoll_manager", Vector( 0, 0, 0 ), QAngle( 0, 0, 0 ), { MaxRagdollCountDX8 = 0, MaxRagdollCount = 0 } );

	if ( !Entities.FindByClassname( null, "game_scavenge_progress_display" ) && !Entities.FindByClassname( null, "weapon_scavenge_item_spawn" ) )
	{
		HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, 120 );
		HUDManageTimers( 0, DirectorScript.TIMER_STOP, 120 );
	}
}

function OnGameEvent_player_left_safe_area( params )
{
	RespawnWitches();
}

function KillWitch( witchIndex )
{
	local witch = EntIndexToHScript( witchIndex );
	if ( !witch )
		return;

	witch.Kill();
}

function OnGameEvent_witch_spawn( params )
{
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillWitch(" + params["witchid"] + ")", 30.0 );
}

function OnGameEvent_finale_vehicle_leaving( params )
{
	HUDManageTimers( 0, DirectorScript.TIMER_STOP, 0 );
	SessionState.SpawnWitchThink = false;
}

function OnGameEvent_map_transition( params )
{
	HUDManageTimers( 0, DirectorScript.TIMER_STOP, 0 );
	SessionState.SpawnWitchThink = false;
}

function OnGameEvent_finale_start( params )
{
	if ( Entities.FindByClassname( null, "game_scavenge_progress_display" ) || Entities.FindByClassname( null, "weapon_scavenge_item_spawn" ) )
	{
		EntFire( "trigger_finale", "ForceFinaleStart" );
		EntFire( "trigger_finale", "FinaleEscapeStarted" );
		EntFire( "relay_car_ready", "Trigger" );
		NavMesh.UnblockRescueVehicleNav();
	}
	else
	{
		SessionState.FinaleStarted = true;
		SessionState.FinaleStartTime = Time();
		SessionState.TriggerRescueThink = true;
	}
}

function Update()
{
	if ( SessionState.SpawnWitchThink )
		SpawnWitchThink();
	if ( SessionState.TriggerRescueThink )
		TriggerRescueThink();
	if ( Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
	for ( local witch; witch = Entities.FindByClassname( witch, "witch" ); )
	{
		local sequence = NetProps.GetPropInt( witch, "m_nSequence" );
		if ( sequence == 5 || sequence == 8 )
			witch.TakeDamage( witch.GetMaxHealth(), 0, Entities.First() );
	}
}

local witchinghour_rules =
[
	{
		name = "WitchStartAttackOverride",
		criteria = [ [ "concept", "WitchStartAttack" ] ],
		responses = [ { scenename = "" } ],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	},
	{
		name = "WitchGettingAngryOverride",
		criteria = [ [ "concept", "WitchGettingAngry" ] ],
		responses = [ { scenename = "" } ],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	},
	{
		name = "FaultOverride",
		criteria = [ [ "concept", "Fault" ] ],
		responses = [ { scenename = "" } ],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	}
]
g_rr.rr_ProcessRules( witchinghour_rules );
