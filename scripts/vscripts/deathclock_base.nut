//-----------------------------------------------------

MutationOptions <-
{
	cm_AggressiveSpecials = 1
	cm_AllowSurvivorRescue = false
	cm_CommonLimit = 0
	cm_ShouldHurry = 1
	cm_MaxSpecials = 14
	cm_DominatorLimit = 14
	cm_AutoReviveFromSpecialIncap = 1
	cm_SpecialRespawnInterval = 0
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 0
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	SurvivorMaxIncapacitatedCount = 1
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	
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
		upgrade_item = 0
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
}

MutationState <-
{
	DC_OnTakeDamageFunc = null
	DC_RoundStartFunc = null
	DC_LeftSafeAreaFunc = null
	//SurvivorIsSafe = {}
	AllowDamage = false
	DeathClockTimer = 360
	AllSurvivors = []
	ActiveTimer = false
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

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( !SessionState.AllowDamage )
	{
		if ( damageTable.Attacker.IsPlayer() && damageTable.Victim.IsPlayer() )
		{
			if ( damageTable.Attacker.IsSurvivor() && damageTable.Victim.IsSurvivor() )
			{
				if ( damageTable.DamageType != DirectorScript.DMG_BURN )
					return false;
			}
		}
	}

	if ( SessionState.DC_OnTakeDamageFunc )
		return SessionState.DC_OnTakeDamageFunc( damageTable );
	else
		return true;
}

function OnGameplayStart()
{
	if ( IsMissionFinalMap() )
		SessionState.DeathClockTimer = 300;

	HUDManageTimers( 0, DirectorScript.TIMER_STOP, 0 );
	HUDManageTimers( 0, DirectorScript.TIMER_SET, SessionState.DeathClockTimer );
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
	player.SetReviveCount( 0 );
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
	if ( (!player) || (!player.IsSurvivor()) || (SessionState.AllSurvivors.find( player ) != null) )
		return;

	SessionState.AllSurvivors.append( player );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
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

function OnGameEvent_finale_vehicle_leaving( params )
{
	HUDManageTimers( 0, DirectorScript.TIMER_STOP, 0 );
}

function OnGameEvent_map_transition( params )
{
	HUDManageTimers( 0, DirectorScript.TIMER_STOP, 0 );
}

function OnGameEvent_mission_lost( params )
{
	HUDManageTimers( 0, DirectorScript.TIMER_STOP, 0 );
}

function OnGameEvent_round_start_post_nav( params )
{
	if ( SessionOptions.cm_CommonLimit == 0 )
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
	}

	EntFire( "weapon_spawn", "Kill" );
	foreach( wep, val in MutationOptions.weaponsToRemove )
		EntFire( wep + "_spawn", "Kill" );
	
	if ( SessionState.DC_RoundStartFunc )
		SessionState.DC_RoundStartFunc();
}

function OnGameEvent_player_left_safe_area( params )
{
	HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, SessionState.DeathClockTimer );
	SessionState.ActiveTimer = true;

	if ( SessionState.DC_LeftSafeAreaFunc )
		SessionState.DC_LeftSafeAreaFunc();
}

function OnGameEvent_finale_start( params )
{
	EntFire( "trigger_finale", "FinaleEscapeStarted" );
	EntFire( "relay_car_ready", "Trigger" );
	NavMesh.UnblockRescueVehicleNav();
}

/*function OnGameEvent_player_entered_checkpoint( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	SessionState.SurvivorIsSafe[GetCharacterDisplayName( player )] <- true;
}

function OnGameEvent_player_left_checkpoint( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	SessionState.SurvivorIsSafe[GetCharacterDisplayName( player )] <- false;
}*/

function SetupModeHUD()
{
	DeathClockHUD <-
	{
		Fields =
		{
			timer = 
			{
				slot = HUD_MID_TOP ,
				staticstring = " To Reach The Saferoom Or You're DEAD!",
				name = "timer",
				flags = DirectorScript.HUD_FLAG_COUNTDOWN_WARN | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_POSTSTR | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
				special = HUD_SPECIAL_TIMER0
			}
		}
	}
	HUDPlace( HUD_MID_TOP, 0.0, 0.00, 1.0, 0.045 );
	HUDSetLayout( DeathClockHUD );
}

function Update()
{
	if ( SessionOptions.cm_CommonLimit == 0 && Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
	if ( SessionState.ActiveTimer )
	{
		if ( HUDReadTimer( 0 ) <= 0 )
		{
			SessionState.AllowDamage = true;

			foreach( survivor in SessionState.AllSurvivors )
			{
				if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 && ResponseCriteria.GetValue( survivor, "incheckpoint" ) == "0" )
				{
					survivor.SetReviveCount( 2 );
					survivor.TakeDamage( survivor.GetMaxHealth(), 0, Entities.First() );
				}
				//if ( !SessionState.SurvivorIsSafe[GetCharacterDisplayName( survivor )] )
			}

			EntFire( "prop_door_rotating_checkpoint", "Close" );
			SessionState.ActiveTimer = false;
		}
	}
}
