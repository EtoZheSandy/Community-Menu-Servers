//-----------------------------------------------------
Msg("Activating Monday Morning Target Acquired!!\n");

IncludeScript("zsl_base");

ZSLOptions <-
{
	cm_AggressiveSpecials = 1
	cm_AutoReviveFromSpecialIncap = 1
	cm_CommonLimit = 0
	cm_DominatorLimit = 12
	cm_MaxSpecials = 12
	cm_ProhibitBosses = false
	cm_SpecialRespawnInterval = 0
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	SpecialInfectedAssault = true
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 5
	SurvivorMaxIncapacitatedCount = 2
	ShouldAllowSpecialsWithTank = true
	ShouldIgnoreClearStateForSpawn = true
	LockTempo = true

	SmokerLimit = 2
	BoomerLimit = 2
	HunterLimit = 2
	SpitterLimit = 2
	JockeyLimit = 2
	ChargerLimit = 2
	WitchLimit = 0
	cm_WitchLimit = 0
	
	DefaultItems =
	[
		//"weapon_rifle_m60",
		"weapon_smg_silenced",
	]

	function GetDefaultItem( idx )
	{
		if ( idx < DefaultItems.len() )
			return DefaultItems[idx];

		return 0;
	}
}

ZSLState <-
{
	ZSL_OnTakeDamageFunc = function( damageTable )
	{
		if ( (damageTable.Victim.IsPlayer()) && (damageTable.Victim.IsSurvivor()) )
		{
			if ( SessionState.AllowRevive )
			{
				if ( damageTable.Attacker.GetClassname() != "worldspawn" )
				{
					if ( damageTable.DamageType == (damageTable.DamageType | (1 << 14)) || damageTable.DamageType == (damageTable.DamageType | (1 << 5)) )
					{
						if ( GetCharacterDisplayName( damageTable.Victim ) in SessionState.SurvivorWarpLocations )
							damageTable.Victim.SetOrigin( SessionState.SurvivorWarpLocations[GetCharacterDisplayName( damageTable.Victim )] );
					}
					return false;
				}
				if ( (damageTable.Attacker.IsPlayer()) && (damageTable.Attacker.IsSurvivor()) )
					return false;
			}
		}

		return true;
	}
	BonusTankDamage = {}
	EventRules = ""
	HasSurvivalFinale = false
	AutoStartFinale = false
	AutoTriggerEvents = false
	VehicleAward = 2
	SaferoomAward = 0
	SaferoomAwardsScore = false
	KillTimerDecreasesScore = true
	TieBreaker = "kills"
	SpittersSpawned = false
	RescueReady = false
	TargetInfo = "Current Target: "
	TargetActive = true
	TargetName = ""
	TargetGlowColor = 0
	CurrentTarget = null
	SetKillTimer = false
	TimerString = "Reach Safety or DIE (-2 points) in: "
	SurvivorWarpLocations = {}
}

AddDefaultsToTable( "ZSLOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ZSLState", g_ModeScript, "MutationState", g_ModeScript );

function AllowBash( basher, bashee )
{
	if ( basher.IsSurvivor() && NetProps.GetPropInt( bashee, "m_iTeamNum" ) == 3 )
		return ALLOW_BASH_PUSHONLY;
}

function SpawnSpitters()
{
	for ( local player; player = Entities.FindByClassname( player, "player" ); )
	{
		if ( player.IsSurvivor() )
			continue;

		player.Kill();
	}

	if ( SessionState.RescueReady == true )
		Say( null, "RESCUE HAS ARRIVED! You are no longer invincible. Get to the rescue vehicle or face your extermination.", false );
	else
		Say( null, "TIME IS UP! You are no longer invincible. Get to the rescue vehicle or face your extermination.", false );

	if ( Entities.FindByClassname( null, "game_scavenge_progress_display" ) || Entities.FindByClassname( null, "weapon_scavenge_item_spawn" ) )
		EntFire( "relay_car_ready", "Trigger" )

	SessionState.SpittersSpawned = true;
	SessionState.TargetActive = false;
	SessionState.AllowRevive = false;
	SessionState.TargetName = "N/A";
	SessionOptions.SurvivorMaxIncapacitatedCount = 0;
	SessionOptions.SmokerLimit = 0;
	SessionOptions.BoomerLimit = 0;
	SessionOptions.HunterLimit = 0;
	SessionOptions.SpitterLimit = 5;
	SessionOptions.JockeyLimit = 0;
	SessionOptions.ChargerLimit = 0;

	foreach ( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
		{
			survivor.SetHealthBuffer( 100 );
			survivor.SetHealth( 0 );
		}
	}
}

function RandomTarget()
{
	local function GetTargetName( target )
	{
		local InfectedNames =
		{
			Smoker = DirectorScript.ZOMBIE_SMOKER,
			Boomer = DirectorScript.ZOMBIE_BOOMER,
			Hunter = DirectorScript.ZOMBIE_HUNTER,
			Spitter = DirectorScript.ZOMBIE_SPITTER,
			Jockey = DirectorScript.ZOMBIE_JOCKEY,
			Charger = DirectorScript.ZOMBIE_CHARGER,
		}
		
		foreach( name, infectedtype in InfectedNames )
		{
			if ( target == infectedtype )
				return name;
		}
	}
	
	local InfectedTargets =
	[
		ZOMBIE_SMOKER
		ZOMBIE_BOOMER
		ZOMBIE_HUNTER
		ZOMBIE_SPITTER
		ZOMBIE_JOCKEY
		ZOMBIE_CHARGER
	]
	
	if ( SessionState.CurrentTarget != null )
	{
		local foundTarget = InfectedTargets.find( SessionState.CurrentTarget );
		if ( foundTarget != null )
			InfectedTargets.remove( foundTarget );

		for ( local player; player = Entities.FindByClassname( player, "player" ); )
		{
			EmitSoundOnClient( "Gallery.GnomeFTW", player ); //Christmas.GiftPickup
		}
	}
	
	local random_target = InfectedTargets[ RandomInt( 0, InfectedTargets.len() - 1 ) ];
	SessionState.CurrentTarget = random_target;
	SessionState.TargetName = GetTargetName(random_target);
	local color = 255 //alpha
	color = (color << 8) | RandomInt( 0, 255 ) //blue
	color = (color << 8) | RandomInt( 0, 255 ) //green
	color = (color << 8) | RandomInt( 0, 255 ) //red
	SessionState.TargetGlowColor = color;
	
	for ( local player; player = Entities.FindByClassname( player, "player" ); )
	{
		if ( player.IsSurvivor() )
			continue;

		if ( player.GetZombieType() != DirectorScript.ZOMBIE_TANK && NetProps.GetPropInt( player, "m_Glow.m_iGlowType" ) > 0 )
			NetProps.SetPropInt( player, "m_Glow.m_iGlowType", 0 );
		
		if ( NetProps.GetPropInt( player, "m_lifeState" ) == 0 && player.GetZombieType() == SessionState.CurrentTarget )
		{
			NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", SessionState.TargetGlowColor );
			NetProps.SetPropInt( player, "m_Glow.m_iGlowType", 2 );
		}
	}
}

function ReviveFromLedge( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( player.IsHangingFromLedge() )
		player.ReviveFromIncap();
}

function OnGameEvent_player_ledge_grab( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ReviveFromLedgeHang(" + params["userid"] + ")", 0.1 );
}

function OnGameEvent_revive_success( params )
{
	if ( !("subject" in params) )
		return;
	
	local player = GetPlayerFromUserID( params["subject"] );
	
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;
	
	player.SetHealth( 100 );
	player.SetHealthBuffer( 0 );
	player.SetReviveCount( 0 );
	NetProps.SetPropInt( player, "m_isGoingToDie", 0 );
	NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
	StopSoundOn( "Player.Heartbeat", player );
	DoEntFire( "!self", "CancelCurrentScene", "", 0.3, null, player );
}

function ToggleTankGlow( userid )
{
	local tank = GetPlayerFromUserID( userid );
	if ( (!tank) || (NetProps.GetPropInt( tank, "m_lifeState" ) != 0) )
		return;

	local glowColor = NetProps.GetPropInt( tank, "m_Glow.m_glowColorOverride" );
	if ( glowColor == 33023 )
		NetProps.SetPropInt( tank, "m_Glow.m_glowColorOverride", 255 );
	else if ( glowColor == 255 )
		NetProps.SetPropInt( tank, "m_Glow.m_glowColorOverride", 33023 );

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ToggleTankGlow(" + userid + ")", 1.0 );
}

function OnGameEvent_tank_spawn( params )
{
	local tank = GetPlayerFromUserID( params["userid"] );
	if ( !tank )
		return;

	NetProps.SetPropInt( tank, "m_Glow.m_glowColorOverride", 255 );
	NetProps.SetPropInt( tank, "m_Glow.m_iGlowType", 3 );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ToggleTankGlow(" + params["userid"] + ")", 1.0 );
	Say( null, "BONUS ROUND!!!! Inflict the most damage to the TANK for 2 bonus points!", false );
}

function OnGameEvent_player_hurt( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	local attacker = GetPlayerFromUserID( params["attacker"] );
	if ( (!player) || (player.GetZombieType() != DirectorScript.ZOMBIE_TANK) || (!attacker) || (!attacker.IsSurvivor()) )
		return;
	
	local name = GetCharacterDisplayName( attacker );
	local index = player.GetEntityIndex();
	
	if ( !(index in SessionState.BonusTankDamage) )
		SessionState.BonusTankDamage[index] <- {};
	if ( !(name in SessionState.BonusTankDamage[index]) )
		SessionState.BonusTankDamage[index][name] <- 0;
	
	SessionState.BonusTankDamage[index][name] += params["dmg_health"];
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	local attacker = GetPlayerFromUserID( params["attacker"] );
	if ( (!victim) || (victim.IsSurvivor()) || (!attacker) || (!attacker.IsSurvivor()) )
		return;
	
	if ( NetProps.GetPropInt( victim, "m_Glow.m_iGlowType" ) > 0 )
		NetProps.SetPropInt( victim, "m_Glow.m_iGlowType", 0 );
	
	if ( victim.GetZombieType() == DirectorScript.ZOMBIE_TANK )
	{
		for ( local player; player = Entities.FindByClassname( player, "player" ); )
		{
			EmitSoundOnClient( "WAM.HighScore", player );
		}
		local index = victim.GetEntityIndex();

		if ( index in SessionState.BonusTankDamage )
		{
			local Damage = {};
			foreach ( survivor in SessionState.AllSurvivors )
			{
				local name = GetCharacterDisplayName( survivor );
				if ( name in SessionState.BonusTankDamage[index] )
					Damage.rawset( survivor, SessionState.BonusTankDamage[index][name] );
			}
			
			local MostDamage = [];
			local slot = 0;
			
			while ( Damage.len() > 0 )
			{
				local highestDamage = 0;
				local player = null;
				
				foreach( survivor, score in Damage )
				{
					if ( score >= highestDamage )
					{
						highestDamage = score;
						player = survivor;
					}
				}
				
				MostDamage.insert(slot, player);
				Damage.rawdelete(player);
				slot++;
			}
			
			if ( (MostDamage.len() > 1) && (SessionState.BonusTankDamage[index][GetCharacterDisplayName( MostDamage[0] )] == SessionState.BonusTankDamage[index][GetCharacterDisplayName( MostDamage[1] )]) )
			{
				SurvivorStats.score[GetCharacterDisplayName( MostDamage[0] )] += 5;
				SurvivorStats.score[GetCharacterDisplayName( MostDamage[1] )] += 5;
			}
			else
				SurvivorStats.score[GetCharacterDisplayName( MostDamage[0] )] += 10;
			
			SessionState.BonusTankDamage.rawdelete( index );
		}
	}
	if ( SessionState.TargetActive )
	{
		if ( victim.GetZombieType() == SessionState.CurrentTarget )
		{
			SurvivorStats.score[GetCharacterDisplayName( attacker )] += 5;
			RandomTarget();
		}
		else
		{
			SurvivorStats.score[GetCharacterDisplayName( attacker )]++;
		}
	}
}

function OnGameEvent_finale_vehicle_ready( params )
{
	if ( SessionState.SpittersSpawned == false )
	{
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SpawnSpitters()", 0.1 );
		HUDManageTimers( 0, DirectorScript.TIMER_SET, 0 );
		SessionState.RescueReady = true;
	}
}

function OnGameEvent_finale_vehicle_leaving( params )
{
	g_ModeScript.StatHUD.Fields.target.flags = g_ModeScript.StatHUD.Fields.target.flags | DirectorScript.HUD_FLAG_NOTVISIBLE
	HUDPlace( HUD_LEFT_BOT, 0.30, 0.32, 0.44, 0.06 );
}

function OnGameEvent_round_start_post_nav( params )
{
	RandomTarget();
	local time = 360;
	
	if ( Entities.FindByClassname( null, "game_scavenge_progress_display" ) || Entities.FindByClassname( null, "weapon_scavenge_item_spawn" ) )
		time = 420;
	
	HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, time );
	HUDManageTimers( 0, DirectorScript.TIMER_STOP, time );
	
	if ( Director.GetSurvivorSet() == 2 )
	{
		EntFire( "!bill", "Kill" );
		EntFire( "!francis", "Kill" );
		EntFire( "!louis", "Kill" );
		EntFire( "!zoey", "Kill" );
		EntFire( "info_l4d1_survivor_spawn", "Kill" );
	}
}

function StoreSurvivorLocations()
{
	foreach( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
		{
			local flags = NetProps.GetPropInt( survivor, "m_fFlags" );
			if ( flags == ( flags | 1 ) )
				SessionState.SurvivorWarpLocations[GetCharacterDisplayName( survivor )] <- survivor.GetOrigin();
		}
	}
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.StoreSurvivorLocations()", 5.0 );
}

function ResetSpecialTimers()
{
	Director.ResetSpecialTimers();
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ResetSpecialTimers()", 1.0 );
}

function OnGameEvent_player_left_safe_area( params )
{
	if ( IsMissionFinalMap() )
	{
		local time = 360;
		
		if ( Entities.FindByClassname( null, "game_scavenge_progress_display" ) || Entities.FindByClassname( null, "weapon_scavenge_item_spawn" ) )
			time = 420;
		
		HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, time );
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SpawnSpitters()", time );
	}
	else
	{
		HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, 360 );
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillSurvivors()", 360.0 );
	}
	
	if ( Entities.FindByClassname( null, "game_scavenge_progress_display" ) || Entities.FindByClassname( null, "weapon_scavenge_item_spawn" ) )
	{
		for ( local gascan; gascan = Entities.FindByModel( gascan, "models/props_junk/gascan001a.mdl" ); )
			gascan.Kill();
		
		EntFire( "weapon_scavenge_item_spawn", "Kill" );
		EntFire( "gas_nozzle", "Kill" );
		EntFire( "game_scavenge_progress_display", "Kill" );
	}
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.StoreSurvivorLocations()", 5.0 );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ResetSpecialTimers()", 1.0 );
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.GiveUpgrade( DirectorScript.UPGRADE_LASER_SIGHT );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( !player )
		return;

	if ( !player.IsSurvivor() )
	{
		if ( player.GetZombieType() == SessionState.CurrentTarget )
		{
			NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", SessionState.TargetGlowColor );
			NetProps.SetPropInt( player, "m_Glow.m_iGlowType", 2 );
		}
		if ( SessionState.SpittersSpawned && player.GetZombieType() == DirectorScript.ZOMBIE_SPITTER )
			NetProps.SetPropInt( player, "m_takedamage", 0 );
	}
	else
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}

function SetKillTimer( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( ResponseCriteria.GetValue( player, "incheckpoint" ) == "0" )
		return;
	
	if ( !SessionState.SetKillTimer && HUDReadTimer(0) > 60 )
	{
		HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, 60 );
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillSurvivors()", 60.0 );
		SessionState.SetKillTimer = true;
	}
}

function OnGameEvent_player_entered_checkpoint( params )
{
	if ( !("userid" in params) )
		return;

	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SetKillTimer(" + params["userid"] + ")", 0.2 );
}

function SetupModeHUD()
{
	StatHUD <-
	{
		Fields =
		{
			scores =
			{
				slot = HUD_LEFT_BOT ,
				datafunc = @() SessionState.FinalScores,
				name = "scores",
				flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
			}
			target =
			{
				slot = HUD_MID_BOX ,
				datafunc = @() SessionState.TargetInfo + SessionState.TargetName,
				name = "target",
				flags = DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
			}
			timer =
			{
				slot = HUD_SCORE_TITLE ,
				staticstring = SessionState.TimerString,
				name = "timer",
				flags = DirectorScript.HUD_FLAG_COUNTDOWN_WARN | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
				special = HUD_SPECIAL_TIMER0
			}
			name0 =
			{
				slot = HUD_FAR_LEFT ,
				datafunc = @() SessionState.DisplayName(0) + SessionState.SpacerString + "(" + SessionState.DisplayScore(0) + ")",
				name = "name0",
				flags = DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
			name1 =
			{
				slot = HUD_MID_TOP ,
				datafunc = @() SessionState.DisplayName(1) + SessionState.SpacerString + "(" + SessionState.DisplayScore(1) + ")",
				name = "name1",
				flags = DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
			name2 =
			{
				slot = HUD_FAR_RIGHT ,
				datafunc = @() "(" + SessionState.DisplayScore(2) + ")" + SessionState.SpacerString + SessionState.DisplayName(2),
				name = "name2",
				flags = DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_NOBG,
			}
			name3 =
			{
				slot = HUD_MID_BOT ,
				datafunc = @() "(" + SessionState.DisplayScore(3) + ")" + SessionState.SpacerString + SessionState.DisplayName(3),
				name = "name3",
				flags = DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_NOBG,
			}
			scorebackground =
			{
				slot = HUD_RIGHT_BOT ,
				datafunc = @() SessionState.EmptyString,
				name = "scorebackground",
				flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_CENTER,
			}
			score0 =
			{
				slot = HUD_SCORE_1 ,
				datafunc = @() SessionState.FirstPlace + SessionState.FirstName + SessionState.SpacerString + "(" + SessionState.FirstScore + ")",
				name = "score0",
				flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
			score1 =
			{
				slot = HUD_SCORE_2 ,
				datafunc = @() SessionState.SecondPlace + SessionState.SecondName + SessionState.SpacerString + "(" + SessionState.SecondScore + ")",
				name = "score1",
				flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
			score2 =
			{
				slot = HUD_SCORE_3 ,
				datafunc = @() SessionState.ThirdPlace + SessionState.ThirdName + SessionState.SpacerString + "(" + SessionState.ThirdScore + ")",
				name = "score2",
				flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
			score3 =
			{
				slot = HUD_SCORE_4 ,
				datafunc = @() SessionState.FourthPlace + SessionState.FourthName + SessionState.SpacerString + "(" + SessionState.FourthScore + ")",
				name = "score3",
				flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
		}
	}
	
	if ( IsMissionFinalMap() )
	{
		if ( Entities.FindByClassname( null, "game_scavenge_progress_display" ) || Entities.FindByClassname( null, "weapon_scavenge_item_spawn" ) )
			StatHUD.Fields.timer.staticstring = "Reach Escape Vehicle or ELSE in: ";
		else
			StatHUD.Fields.timer.staticstring = "Rescue Arrives in: ";
	}
	
	HUDPlace( HUD_FAR_LEFT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_TOP, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_FAR_RIGHT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOT, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOX, 0.0, 0.04, 1.0, 0.045 );
	HUDPlace( HUD_SCORE_TITLE, 0.0, 0.00, 1.0, 0.045 );
	HUDPlace( HUD_LEFT_BOT, 0.0, 0.04, 1.0, 0.045 );
	HUDSetLayout( StatHUD );
}
