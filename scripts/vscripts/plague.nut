//-----------------------------------------------------
Msg("Activating Plague of the Dead\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	cm_AllowSurvivorRescue = false
	cm_BaseCommonAttackDamage = 12
	cm_CommonLimit = 35
	cm_HeadshotOnly = 1
	cm_ShouldHurry = 1
	cm_MaxSpecials = 0
	cm_DominatorLimit = 0
	AlwaysAllowWanderers = true
	NumReservedWanderers = 40
	PreferredMobDirection = SPAWN_ANYWHERE
	SurvivorMaxIncapacitatedCount = 1
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
	
	// convert items that aren't useful
	weaponsToConvert =
	{
		ammo =	"weapon_pistol_spawn"
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
		weapon_vomitjar = 0
		weapon_first_aid_kit = 0
		weapon_pain_pills = 0
		weapon_adrenaline = 0
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
	
	TempHealthDecayRate = 0.001
	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 0.834 // pain_pills_decay_rate default 0.27 //0.556
		}
	}
}

MutationState <-
{
	HUDTimer = {}
	DeathTimer = 120.0
	AllSurvivors = []
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
}

function GetInfectionTimer( ind )
{
	local player = GetPlayerFromCharacter(ind);
	
	if ( !player )
		return;
	
	if ( NetProps.GetPropInt( player, "m_currentReviveCount" ) == 0 )
		return "--:--";
	
	local survivorCharacter = NetProps.GetPropInt( player, "m_survivorCharacter" );
	local time = SessionState.HUDTimer[ player ];
	if ( NetProps.GetPropInt( player, "m_lifeState" ) == 0 && time > 0 && time < 11 )
	{
		foreach( hud in g_ModeScript.PlagueHUD.Fields )
		{
			if ( hud.name == "name" + survivorCharacter )
				hud.flags = hud.flags | DirectorScript.HUD_FLAG_BLINK;
		}
	}
	else
	{
		foreach( hud in g_ModeScript.PlagueHUD.Fields )
		{
			if ( hud.name == "name" + survivorCharacter )
				hud.flags = hud.flags & ~DirectorScript.HUD_FLAG_BLINK;
		}
	}
	
	return "0" + g_MapScript.TimeToDisplayString( time );
}

function StopAllTimers()
{
	foreach( survivor in SessionState.AllSurvivors )
		SessionState.HUDTimer[ survivor ] = 0;
}

function OnGameEvent_finale_vehicle_leaving( params )
{
	StopAllTimers();
}

function OnGameEvent_map_transition( params )
{
	StopAllTimers();
}

function OnGameEvent_mission_lost( params )
{
	StopAllTimers();
}

function OnGameEvent_round_start_post_nav( params )
{
	EntFire( "tankdoorout_button", "Unlock" );
	EntFire( "tank_sound_timer", "Kill" );
	EntFire( "button_locker-*", "Kill" );
	EntFire( "locker-*", "Kill" );
	EntFire( "WorldFootLocker-*", "Kill" );
	for ( local wep_spawner; wep_spawner = Entities.FindByClassname( wep_spawner, "weapon_*" ); )
		NetProps.SetPropInt( wep_spawner, "m_itemCount", 1 );
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
	if ( !SessionState.HUDTimer.rawin( player ) )
		SessionState.HUDTimer.rawset( player, -1 );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( SessionState.AllSurvivors.find( player ) == null )
	{
		SessionState.AllSurvivors.append( player );
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
	}
}

function OnGameEvent_player_left_safe_area( params )
{
	EntFire( "info_director", "FireConceptToAny", "PlayerWarnCareful" );
}

function OnGameEvent_player_incapacitated( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.ReviveFromIncap();
	SessionState.HUDTimer[ player ] = SessionState.DeathTimer;
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	
	if ( ( !victim ) || ( !victim.IsSurvivor() ) )
		return;
	
	EntFire( "survivor_death_model", "BecomeRagdoll" );
	local survivorCharacter = NetProps.GetPropInt( victim, "m_survivorCharacter" );
	SessionState.HUDTimer[ victim ] = 0;
}

function SetupModeHUD()
{
	PlagueHUD <-
	{
		Fields =
		{
			name0 = 
			{
				slot = HUD_FAR_LEFT ,
				datafunc = @() SessionState.DisplayName(0) + "   " + g_ModeScript.GetInfectionTimer(0),
				name = "name0",
				flags = DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_NOBG,
			}
			name1 = 
			{
				slot = HUD_MID_TOP ,
				datafunc = @() SessionState.DisplayName(1) + "   " + g_ModeScript.GetInfectionTimer(1),
				name = "name1",
				flags = DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_NOBG,
			}
			name2 = 
			{
				slot = HUD_FAR_RIGHT ,
				datafunc = @() g_ModeScript.GetInfectionTimer(2) + "   " + SessionState.DisplayName(2),
				name = "name2",
				flags = DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_NOBG,
			}
			name3 = 
			{
				slot = HUD_MID_BOT ,
				datafunc = @() g_ModeScript.GetInfectionTimer(3) + "   " + SessionState.DisplayName(3),
				name = "name3",
				flags = DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_NOBG,
			}
			/*timer0 = 
			{
				slot = HUD_LEFT_TOP ,
				staticstring = " ",
				name = "timer0",
				flags = DirectorScript.HUD_FLAG_COUNTDOWN_WARN | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
				special = HUD_SPECIAL_TIMER0
			}
			timer1 = 
			{
				slot = HUD_LEFT_BOT ,
				staticstring = " ",
				name = "timer1",
				flags = DirectorScript.HUD_FLAG_COUNTDOWN_WARN | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
				special = HUD_SPECIAL_TIMER1
			}
			timer2 = 
			{
				slot = HUD_RIGHT_TOP ,
				staticstring = " ",
				name = "timer2",
				flags = DirectorScript.HUD_FLAG_COUNTDOWN_WARN | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
				special = HUD_SPECIAL_TIMER2
			}
			timer3 = 
			{
				slot = HUD_RIGHT_BOT ,
				staticstring = " ",
				name = "timer3",
				flags = DirectorScript.HUD_FLAG_COUNTDOWN_WARN | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
				special = HUD_SPECIAL_TIMER3
			}*/
		}
	}
	HUDPlace( HUD_FAR_LEFT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_TOP, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_FAR_RIGHT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOT, 0.0, 0.06, 1.0, 0.045 );
	HUDSetLayout( PlagueHUD );
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
	foreach( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 && NetProps.GetPropInt( survivor, "m_currentReviveCount" ) > 0 )
		{
			if ( SessionState.HUDTimer[ survivor ] == 0 )
			{
				survivor.SetReviveCount( 2 );
				survivor.TakeDamage( survivor.GetMaxHealth(), 0, Entities.First() );
			}
			else
				SessionState.HUDTimer[ survivor ]--;
		}
	}
}
