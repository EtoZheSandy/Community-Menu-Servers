//-----------------------------------------------------

IncludeScript("zsl_responserules");

if ( !IsModelPrecached( "models/infected/smoker.mdl" ) )
	PrecacheModel( "models/infected/smoker.mdl" );
if ( !IsModelPrecached( "models/infected/smoker_l4d1.mdl" ) )
	PrecacheModel( "models/infected/smoker_l4d1.mdl" );
if ( !IsModelPrecached( "models/infected/boomer.mdl" ) )
	PrecacheModel( "models/infected/boomer.mdl" );
if ( !IsModelPrecached( "models/infected/boomer_l4d1.mdl" ) )
	PrecacheModel( "models/infected/boomer_l4d1.mdl" );
if ( !IsModelPrecached( "models/infected/boomette.mdl" ) )
	PrecacheModel( "models/infected/boomette.mdl" );
if ( !IsModelPrecached( "models/infected/hunter.mdl" ) )
	PrecacheModel( "models/infected/hunter.mdl" );
if ( !IsModelPrecached( "models/infected/hunter_l4d1.mdl" ) )
	PrecacheModel( "models/infected/hunter_l4d1.mdl" );
if ( !IsModelPrecached( "models/infected/limbs/exploded_boomette.mdl" ) )
{
	PrecacheModel( "models/infected/limbs/exploded_boomette.mdl" );
	::zsl_no_female_boomers <- true;
}
if ( !IsModelPrecached( "models/infected/spitter.mdl" ) )
	PrecacheModel( "models/infected/spitter.mdl" );
if ( !IsModelPrecached( "models/infected/jockey.mdl" ) )
	PrecacheModel( "models/infected/jockey.mdl" );
if ( !IsModelPrecached( "models/infected/charger.mdl" ) )
	PrecacheModel( "models/infected/charger.mdl" );

ZSLBaseOptions <-
{
	cm_AllowSurvivorRescue = 0
	cm_AutoReviveFromSpecialIncap = 1
	cm_AggressiveSpecials = 1
	cm_CommonLimit = 0
	cm_MaxSpecials = 12
	cm_DominatorLimit = 12
	BoomerLimit = 6
	SmokerLimit = 3
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 3
	SurvivorMaxIncapacitatedCount = 2

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
		weapon_chainsaw = 0
		weapon_defibrillator = 0
		weapon_pain_pills = 0
		weapon_adrenaline = 0
		weapon_first_aid_kit = 0
		weapon_molotov = 0
		weapon_pipe_bomb = 0
		weapon_vomitjar = 0
		weapon_upgradepack_incendiary = 0
		weapon_upgradepack_explosive = 0
		weapon_melee = 0
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

	TempHealthDecayRate = 0.001
	
	function EndScriptedMode()
	{
		if ( ZSLMapData.maprestarts == 2 && SessionState.HasSurvivalFinale )
		{
			SessionState.EndRound = true;
			
			HUDPlace( HUD_MID_BOX, 0.30, 0.32, 0.44, 0.06 );
			SessionState.FinalScores = "Final Attempt Failed: 0 Points Awarded.\n             Moving To Next Round";
			g_ModeScript.StatHUD.Fields.scores.flags = g_ModeScript.StatHUD.Fields.scores.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
			
			foreach( survivor in SessionState.AllSurvivors )
			{
				if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
					continue;

				local deathModel = SpawnEntityFromTable( "survivor_death_model", { origin = survivor.GetOrigin() } );
				NetProps.SetPropInt( deathModel, "m_nCharacterType", NetProps.GetPropInt( survivor, "m_survivorCharacter" ) );
				survivor.ReviveByDefib();
			}
			Director.WarpAllSurvivorsToCheckpoint();
			return 2;
		}
		else
			return 1; // SCENARIO_SURVIVORS_DEAD
	}
}

ZSLBaseState <-
{
	Score1 = ""
	Score2 = ""
	Score3 = ""
	Score4 = ""
	Attempts = ""
	GameEnded = false
	EndRound = false
	HasSurvivalFinale = true
	TimerString = "Race Begins in: "
	EventRules = "[RULES] Make it to the saferoom for 1 point. Finale (escape) map is now a survival round, last one standing gets the bonus point. Most points at the end wins!!"
	IsRaceEvent = false
	AutoStartFinale = true
	AutoTriggerEvents = true
	VehicleAward = 1
	SaferoomAward = 1
	SaferoomAwardsScore = true
	SaferoomWeaponNeeded = ""
	SaferoomKillLastSurvivor = true
	SurvivorsSafe = false
	KillTimerDecreasesScore = false
	TieBreaker = "damage"
	AllowRevive = true
	NeededSurvivors = 4
	ScoredSurvivors = 0
	SaferoomCheck = false
	FirstInSaferoom = ""
	SecondInSaferoom = ""
	ThirdInSaferoom = ""
	FourthInSaferoom = ""
	Scored = {}
	SurvivorIsSafe = {}
	SurvivorInStart = {}
	FirstSurvivor = null
	SecondSurvivor = null
	ThirdSurvivor = null
	FourthSurvivor = null
	SpacerString = "  "
	EmptyString = ""
	FinalScores = "FINAL SCORES"
	FirstPlace = "1st Place: "
	SecondPlace = "2nd Place: "
	ThirdPlace = "3rd Place: "
	FourthPlace = "4th Place: "
	FirstName = null
	SecondName = null
	ThirdName = null
	FourthName = null
	FirstScore = 0
	SecondScore = 0
	ThirdScore = 0
	FourthScore = 0
	CoachPosition = ""
	EllisPosition = ""
	NickPosition = ""
	RochellePosition = ""
	RescueReady = false
	AwardedRescueScore = false
	SpittersSpawned = false
	SIModelsBase = [ [ "models/infected/smoker.mdl", "models/infected/smoker_l4d1.mdl" ],
					[ "models/infected/boomer.mdl", "models/infected/boomer_l4d1.mdl", "models/infected/boomette.mdl" ],
						[ "models/infected/hunter.mdl", "models/infected/hunter_l4d1.mdl" ],
							[ "models/infected/spitter.mdl" ],
								[ "models/infected/jockey.mdl" ],
									[ "models/infected/charger.mdl" ] ]
	SIModels = [ [ "models/infected/smoker.mdl", "models/infected/smoker_l4d1.mdl" ],
				[ "models/infected/boomer.mdl", "models/infected/boomer_l4d1.mdl", "models/infected/boomette.mdl" ],
					[ "models/infected/hunter.mdl", "models/infected/hunter_l4d1.mdl" ],
						[ "models/infected/spitter.mdl" ],
							[ "models/infected/jockey.mdl" ],
								[ "models/infected/charger.mdl" ] ]
	ModelCheck = [ false, false, false, false, false, false ]
	LastBoomerModel = ""
	BoomersChecked = 0
	LastHPDecayTime = 0
	HPDecayDelay = 2.0
	HPDecayActive = false
	AllSurvivors = []
	ZSLAllowDamageBackup = null
	ZSL_OnTakeDamageFunc = null
	DidMiscChecks = false
	
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
	
	function DisplayScore(ind)
	{
		local p = GetPlayerFromCharacter(ind)
		if(p && GetCharacterDisplayName( p ) in g_ModeScript.SurvivorStats.score)
		{
			return (g_ModeScript.SurvivorStats.score[GetCharacterDisplayName( p )])
		}
		else
		{
			return ""
		}
	}
}

AddDefaultsToTable( "ZSLBaseOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ZSLBaseState", g_ModeScript, "MutationState", g_ModeScript );

::SurvivorStats <-
{
	score = {}
	tiedscore = false
	tiedsurvivors = {}
}
::SurvivorStatsBackup <- DuplicateTable(SurvivorStats);

::ZSLMapData <-
{
	maprestarts = 0
}

if ( "AllowTakeDamage" in this )
	MutationState.ZSLAllowDamageBackup = AllowTakeDamage;
function AllowTakeDamage( damageTable )
{
	local returnCode = true;
	if ( SessionState.ZSLAllowDamageBackup )
		returnCode = SessionState.ZSLAllowDamageBackup( damageTable );

	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( (damageTable.Victim.IsPlayer()) && (damageTable.Victim.IsSurvivor()) )
	{
		if ( ((damageTable.Attacker.IsPlayer()) && (damageTable.Attacker.IsSurvivor())) || ResponseCriteria.GetValue( damageTable.Victim, "incheckpoint" ) == "1" )
			return false;
		if ( SessionState.HasSurvivalFinale && damageTable.DamageType == (damageTable.DamageType | DirectorScript.DMG_BURN) )
		{
			if ( !Director.HasAnySurvivorLeftSafeArea() )
				return true;
			if ( !SessionState.SurvivorInStart[GetCharacterDisplayName( damageTable.Victim )] )
				return false;
		}
	}

	if ( SessionState.ZSL_OnTakeDamageFunc )
		return SessionState.ZSL_OnTakeDamageFunc( damageTable );
	else
		return returnCode;
}

function OnShutdown()
{
	if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_ROUND_RESTART )
	{
		if ( SessionState.HasSurvivalFinale && Utils.IsFinale() )
		{
			SaveTable( "Stats", SurvivorStats );
			SaveTable( "StatsBackup", SurvivorStats );
		}
		else
		{
			RestoreTable( "StatsBackup", SurvivorStatsBackup );
			SaveTable( "StatsBackup", SurvivorStatsBackup );
			SaveTable( "Stats", SurvivorStatsBackup );
		}
		ZSLMapData.maprestarts++;
		SaveTable( "ZSLMapData", ZSLMapData );
	}
	else if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_LEVEL_TRANSITION )
	{
		local nextMap = "";
		local changelevel = null;
		if ( changelevel = Entities.FindByClassname( changelevel, "info_changelevel" ) )
			nextMap = NetProps.GetPropString( changelevel, "m_mapName" );
		else if ( changelevel = Entities.FindByClassname( changelevel, "trigger_changelevel" ) )
			nextMap = NetProps.GetPropString( changelevel, "m_mapName" );

		if ( SessionState.NextMap != nextMap )
			return;
		
		SaveTable( "Stats", SurvivorStats );
		SaveTable( "StatsBackup", SurvivorStats );
	}
}

ZSLBase <-
{
	function ZSLShowHint( player, text, duration = 5, icon = "icon_tip", binding = "", color = "255 255 255", pulsating = 0, alphapulse = 0, shaking = 0 )
	{
		local hinttbl =
		{
			hint_allow_nodraw_target = "1",
			hint_alphaoption = alphapulse,
			hint_auto_start = "0",
			hint_binding = binding,
			hint_caption = text,
			hint_color = color,
			hint_forcecaption = "0",
			hint_icon_offscreen = icon,
			hint_icon_offset = "0",
			hint_icon_onscreen = icon,
			hint_instance_type = "2",
			hint_nooffscreen = "0",
			hint_pulseoption = pulsating,
			hint_range = "0",
			hint_shakeoption = shaking,
			hint_static = "1",
			hint_target = "",
			hint_timeout = duration,
			targetname = "zsl_tmp_" + UniqueString(),
			origin = Vector(0, 0, 0),
			angles = Vector(0, 0, 0)
		};
		
		local hint = SpawnEntityFromTable( "env_instructor_hint", hinttbl );
		DoEntFire( "!self", "ShowHint", "", 0, player, hint );
		
		if ( duration > 0 )
			DoEntFire( "!self", "Kill", "", duration, null, hint );
	}

	function SaferoomInferno()
	{
		foreach( survivor in SessionState.AllSurvivors )
		{
			if ( ResponseCriteria.GetValue( survivor, "instartarea" ) == "1" || !Director.HasAnySurvivorLeftSafeArea() )
			{
				local origin = survivor.GetOrigin();
				origin.z += 16;
				DropFire( origin );
				ZSLShowHint( survivor, "LEAVE IMMEDIATELY OR DIE!", 5, "icon_alert_red", "", "255 0 0" );
			}
		}
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.SaferoomInferno()", 5.0 );
	}

	function FinaleTankSpawn()
	{
		if ( ("cm_TankLimit" in SessionOptions) && (SessionOptions.cm_TankLimit == 0) )
			SessionOptions.cm_TankLimit <- 4;
		ZSpawn( { type = 8 } );
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.FinaleTankSpawn()", 60.0 );
	}

	function FinaleDelay()
	{
		if ( Director.GetMapName() == "c2m5_concert" )
			EntFire( "stadium_entrance_door_relay", "Kill" );
		EntFire( "info_game_event_proxy", "Kill" );
		EntFire( "trigger_finale", "ForceFinaleStart" );
		
		if ( SessionState.ModeName != "zsltuesday" && SessionState.ModeName != "zslsaturday" )
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.FinaleTankSpawn()", 60.0 );
	}

	function OpenDoor()
	{
		if ( SessionState.HasSurvivalFinale )
		{
			Say( null, "You have 10 seconds to leave the saferoom or it will become your tomb!", false );
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.SaferoomInferno()", 10.0 );
		}
		
		g_ModeScript.StatHUD.Fields.timer.flags = g_ModeScript.StatHUD.Fields.timer.flags | DirectorScript.HUD_FLAG_NOTVISIBLE
		
		local dist = null;
		local ent = null;
		
		for ( local door; door = Entities.FindByClassname( door, "prop_door_rotating_checkpoint" ); )
		{
			if ( NetProps.GetPropInt( door, "m_hasUnlockSequence" ) == 0 )
				continue;
			
			local distTo = (door.GetOrigin() - SessionState.AllSurvivors[0].GetOrigin()).Length();
			
			if ( !dist || distTo < dist )
			{
				dist = distTo;
				ent = door;
			}
		}
		
		if ( ent )
		{
			DoEntFire( "!self", "DisableShadow", "", 0, null, ent );
			DoEntFire( "!self", "DisableCollision", "", 0, null, ent );
			NetProps.SetPropInt( ent, "m_nRenderMode", 1 );
			DoEntFire( "!self", "Alpha", "70", 0, null, ent );
		}
	}

	function KillSurvivors()
	{
		SessionState.AllowRevive = false;
		
		foreach ( survivor in SessionState.AllSurvivors )
		{
			if ( !SessionState.SurvivorIsSafe[GetCharacterDisplayName( survivor )] )
			{
				if ( SessionState.KillTimerDecreasesScore )
				{
					if ( g_ModeScript.SurvivorStats.score[GetCharacterDisplayName( survivor )] >= 2 )
						g_ModeScript.SurvivorStats.score[GetCharacterDisplayName( survivor )] -= 2;
					else if ( g_ModeScript.SurvivorStats.score[GetCharacterDisplayName( survivor )] == 1 )
						g_ModeScript.SurvivorStats.score[GetCharacterDisplayName( survivor )]--;
				}
				survivor.SetReviveCount( 2 );
				survivor.TakeDamage( survivor.GetHealth(), 0, Entities.First() );
			}
		}
		
		for ( local door; door = Entities.FindByClassname( door, "prop_door_rotating_checkpoint" ); )
		{
			if ( NetProps.GetPropInt( door, "m_hasUnlockSequence" ) == 1 || door.GetName() == "checkpoint_exit" )
				continue;
			
			local flags = NetProps.GetPropInt( door, "m_spawnflags" );

			if ( flags == ( flags | 32768 ) )
				NetProps.SetPropInt( door, "m_spawnflags", ( flags & ~32768 ) );
			
			DoEntFire( "!self", "Alpha", "255", 0, null, door );
			DoEntFire( "!self", "EnableShadow", "", 0, null, door );
			DoEntFire( "!self", "EnableCollision", "", 0, null, door );
			DoEntFire( "!self", "Close", "", 0, null, door );
			EmitSoundOn( "bridge.gate_slam", door );
		}
	}

	function CheckNeededSurvivors()
	{
		if ( SessionState.ScoredSurvivors >= SessionState.NeededSurvivors )
		{
			if ( SessionState.IsRaceEvent )
			{
				SessionState.AllowRevive = false;
				EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.KillSurvivors()", 0.1 );
			}
			else
			{
				for ( local door; door = Entities.FindByClassname( door, "prop_door_rotating_checkpoint" ); )
				{
					if ( NetProps.GetPropInt( door, "m_hasUnlockSequence" ) == 1 || door.GetName() == "checkpoint_exit" )
						continue;
					
					local flags = NetProps.GetPropInt( door, "m_spawnflags" );

					if ( flags == ( flags | 32768 ) )
						NetProps.SetPropInt( door, "m_spawnflags", ( flags & ~32768 ) );
					
					DoEntFire( "!self", "Alpha", "255", 0, null, door );
					DoEntFire( "!self", "EnableShadow", "", 0, null, door );
					DoEntFire( "!self", "EnableCollision", "", 0, null, door );
					DoEntFire( "!self", "Close", "", 0, null, door );
					EmitSoundOn( "bridge.gate_slam", door );
				}
			}
			SessionState.SurvivorsSafe = true;
		}
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
		DoEntFire( "!self", "CancelCurrentScene", "", 0.3, null, player );
		
		if ( player.IsOnThirdStrike() )
		{
			NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", 255 );
			return;
		}
		
		local reviveCount = NetProps.GetPropInt( player, "m_currentReviveCount" );
		if ( reviveCount == 0 )
		{
			local color = 255 //alpha
			color = (color << 8) | 122 //blue
			color = (color << 8) | 61 //green
			color = (color << 8) | 255 //red
			NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", color );
		}
		else if ( reviveCount == 1 )
			NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", 33023 );
		else if ( reviveCount == 2 )
			NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", 255 );
	}

	function OnGameEvent_player_incapacitated( params )
	{
		local player = GetPlayerFromUserID( params["userid"] );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		if ( SessionState.AllowRevive )
			player.ReviveFromIncap();
	}

	function ZSL_RollStatsCrawl()
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

	function EndGame()
	{
		SessionState.GameEnded = true;
		ZSL_RollStatsCrawl();
		Say( null, SessionState.Score1, false );
		Say( null, SessionState.Score2, false );
		Say( null, SessionState.Score3, false );
		Say( null, SessionState.Score4, false );
	}

	function DoMiscChecks()
	{
		if ( SessionState.IsRaceEvent && !Director.IsFirstMapInScenario() )
		{
			g_ModeScript.StatHUD.Fields.timer.flags = g_ModeScript.StatHUD.Fields.timer.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
			HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, 30 );
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.OpenDoor()", 30.0 );
			for ( local door; door = Entities.FindByClassname( door, "prop_door_rotating_checkpoint" ); )
			{
				local flags = NetProps.GetPropInt( door, "m_spawnflags" );
				if ( !(flags == ( flags | 32768 )) )
					NetProps.SetPropInt( door, "m_spawnflags", ( flags | 32768 ) );
				
				if ( NetProps.GetPropInt( door, "m_hasUnlockSequence" ) == 0 )
				{
					DoEntFire( "!self", "Close", "", 0, null, door );
					DoEntFire( "!self", "DisableShadow", "", 0, null, door );
					DoEntFire( "!self", "DisableCollision", "", 0, null, door );
					NetProps.SetPropInt( door, "m_nRenderMode", 1 );
					DoEntFire( "!self", "Alpha", "70", 0, null, door );
				}
			}
		}
		else
		{
			if ( IsMissionFinalMap() && SessionState.AutoStartFinale )
			{
				g_ModeScript.StatHUD.Fields.timer.flags = g_ModeScript.StatHUD.Fields.timer.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
				HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, 30 );
				EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.OpenDoor()", 30.0 );
				for ( local door; door = Entities.FindByClassname( door, "prop_door_rotating_checkpoint" ); )
				{
					local flags = NetProps.GetPropInt( door, "m_spawnflags" );
					if ( !(flags == ( flags | 32768 )) )
						NetProps.SetPropInt( door, "m_spawnflags", ( flags | 32768 ) );
				}
			}
			else
			{
				for ( local door; door = Entities.FindByClassname( door, "prop_door_rotating_checkpoint" ); )
				{
					if ( NetProps.GetPropInt( door, "m_hasUnlockSequence" ) == 1 || door.GetName() == "checkpoint_exit" )
						continue;
					
					local flags = NetProps.GetPropInt( door, "m_spawnflags" );
					if ( !(flags == ( flags | 32768 )) )
						NetProps.SetPropInt( door, "m_spawnflags", ( flags | 32768 ) );

					DoEntFire( "!self", "Close", "", 0, null, door );
					DoEntFire( "!self", "DisableShadow", "", 0, null, door );
					DoEntFire( "!self", "DisableCollision", "", 0, null, door );
					NetProps.SetPropInt( door, "m_nRenderMode", 1 );
					DoEntFire( "!self", "Alpha", "70", 0, null, door );
				}
			}
		}
		
		if ( SessionState.HasSurvivalFinale )
		{
			if ( !IsMissionFinalMap() )
			{
				if ( ZSLMapData.maprestarts == 3 )
				{
					for ( local door; door = Entities.FindByClassname( door, "prop_door_rotating_checkpoint" ); )
					{
						if ( NetProps.GetPropInt( door, "m_hasUnlockSequence" ) == 1 || door.GetName() == "checkpoint_exit" )
							continue;
						
						local flags = NetProps.GetPropInt( door, "m_spawnflags" );
						if ( flags == ( flags | 32768 ) )
							NetProps.SetPropInt( door, "m_spawnflags", ( flags & ~32768 ) );

						DoEntFire( "!self", "Close", "", 0, null, door );
					}
				}
				g_ModeScript.StatHUD.Fields.attempts.flags = g_ModeScript.StatHUD.Fields.attempts.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
			}
			else
			{
				if ( ZSLMapData.maprestarts == 1 )
					g_ModeScript.StatHUD.Fields.attempts.flags = g_ModeScript.StatHUD.Fields.attempts.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
				g_ModeScript.StatHUD.Fields.timer.staticstring = "Survival Round Begins in: ";
				SessionOptions.SurvivorMaxIncapacitatedCount = 1;
			}
		}
	}

	function SurvivorPostSpawn( userid )
	{
		local player = GetPlayerFromUserID( userid );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		if ( !(GetCharacterDisplayName( player ) in SessionState.Scored) )
			SessionState.Scored[GetCharacterDisplayName( player )] <- false;
		if ( !(GetCharacterDisplayName( player ) in SessionState.SurvivorIsSafe) )
			SessionState.SurvivorIsSafe[GetCharacterDisplayName( player )] <- false;
		if ( !(GetCharacterDisplayName( player ) in SessionState.SurvivorInStart) )
			SessionState.SurvivorInStart[GetCharacterDisplayName( player )] <- false;
		
		if ( !(GetCharacterDisplayName( player ) in SurvivorStats.score) )
			SurvivorStats.score[GetCharacterDisplayName( player )] <- 0;
		
		if ( SurvivorStats.tiedscore )
		{
			if ( !(GetCharacterDisplayName( player ) in SurvivorStats.tiedsurvivors) )
			{
				player.SetReviveCount( 2 );
				player.TakeDamage( player.GetMaxHealth(), 0, Entities.First() );
			}
		}
		
		player.SetHealthBuffer( 0 );
		player.SetHealth( player.GetMaxHealth() );
		player.SetReviveCount( 0 );
		NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
		StopSoundOn( "Player.Heartbeat", player );

		local color = 255 //alpha
		color = (color << 8) | 122 //blue
		color = (color << 8) | 61 //green
		color = (color << 8) | 255 //red
		NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", color );
		NetProps.SetPropInt( player, "m_Glow.m_iGlowType", 3 );
		DoEntFire( "!self", "DisableLedgeHang", "", 0, null, player );
	}

	function OnGameEvent_player_spawn( params )
	{
		local player = GetPlayerFromUserID( params["userid"] );
		if ( !player )
			return;

		if ( player.IsSurvivor() )
		{
			if ( SessionState.AllSurvivors.find( player ) == null )
				SessionState.AllSurvivors.append( player );
			if ( !SessionState.DidMiscChecks )
			{
				EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.DoMiscChecks()", 0.2 );
				SessionState.DidMiscChecks = true;
			}
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
		}
		else
		{
			DoEntFire( "!self", "Color", RandomInt( 0, 255 ) + " " + RandomInt( 0, 255 ) + " " + RandomInt( 0, 255 ), 0, null, player );

			if ( SessionOptions.BoomerLimit == 0 && player.GetZombieType() == DirectorScript.ZOMBIE_BOOMER )
				player.TakeDamage( player.GetHealth(), 0, Entities.First() );
			else if ( SessionOptions.SmokerLimit == 0 && player.GetZombieType() == DirectorScript.ZOMBIE_SMOKER )
				player.TakeDamage( player.GetHealth(), 0, Entities.First() );
			else if ( SessionOptions.HunterLimit == 0 && player.GetZombieType() == DirectorScript.ZOMBIE_HUNTER )
				player.TakeDamage( player.GetHealth(), 0, Entities.First() );
			else if ( SessionOptions.ChargerLimit == 0 && player.GetZombieType() == DirectorScript.ZOMBIE_CHARGER )
				player.TakeDamage( player.GetHealth(), 0, Entities.First() );
			else if ( SessionOptions.SpitterLimit == 0 && player.GetZombieType() == DirectorScript.ZOMBIE_SPITTER )
				player.TakeDamage( player.GetHealth(), 0, Entities.First() );
			else if ( SessionOptions.JockeyLimit == 0 && player.GetZombieType() == DirectorScript.ZOMBIE_JOCKEY )
				player.TakeDamage( player.GetHealth(), 0, Entities.First() );
			else
			{
				local zombieType = player.GetZombieType();
				if ( zombieType < 7 )
				{
					local modelName = player.GetModelName();

					if ( !SessionState.ModelCheck[ zombieType - 1 ] )
					{
						if ( (zombieType == 2) && !("zsl_no_female_boomers" in getroottable()) )
						{
							if ( SessionState.LastBoomerModel != modelName )
							{
								SessionState.LastBoomerModel = modelName;
								SessionState.BoomersChecked++;
							}
							if ( SessionState.BoomersChecked > 1 )
								SessionState.ModelCheck[ zombieType - 1 ] = true;
						}
						else
							SessionState.ModelCheck[ zombieType - 1 ] = true;

						if ( SessionState.SIModelsBase[zombieType - 1].find( modelName ) == null )
						{
							SessionState.SIModelsBase[zombieType - 1].append( modelName );
							SessionState.SIModels[zombieType - 1].append( modelName );
						}
					}

					if ( SessionState.SIModelsBase[zombieType - 1].len() == 1 )
						return;

					local zombieModels = SessionState.SIModels[zombieType - 1];
					if ( zombieModels.len() == 0 )
						SessionState.SIModels[zombieType - 1].extend( SessionState.SIModelsBase[zombieType - 1] );
					local foundModel = zombieModels.find( modelName );
					if ( foundModel != null )
					{
						zombieModels.remove( foundModel );
						return;
					}

					local randomElement = RandomInt( 0, zombieModels.len() - 1 );
					local randomModel = zombieModels[ randomElement ];
					zombieModels.remove( randomElement );

					player.SetModel( randomModel );
				}
			}
		}
	}

	function OnGameEvent_player_death( params )
	{
		if ( !("userid" in params) )
			return;
		
		local victim = GetPlayerFromUserID( params["userid"] );
		
		if ( ( !victim ) || ( !victim.IsSurvivor() ) )
			return;
		
		NetProps.SetPropInt( victim, "m_Glow.m_glowColorOverride", 0 );
		NetProps.SetPropInt( victim, "m_Glow.m_iGlowType", 0 );
		EntFire( "survivor_death_model", "BecomeRagdoll" );
		SessionState.NeededSurvivors--;
		
		if ( IsMissionFinalMap() && SessionState.HasSurvivalFinale )
		{
			if ( SessionState.NeededSurvivors == 1 )
			{
				local winner = null;
				foreach( survivor in SessionState.AllSurvivors )
				{
					if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
					{
						winner = survivor;
						break;
					}
				}
				if ( winner )
				{
					NetProps.SetPropInt( winner, "m_takedamage", 0 );
					g_ModeScript.SurvivorStats.score[GetCharacterDisplayName( winner )] += SessionState.VehicleAward;
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
					g_ModeScript.RemoveHUD();
					g_ModeScript.DisplayScores();
				}
			}
		}
	}

	function EnterSaferoom( userid )
	{
		if ( SessionState.EndRound )
			return;
		
		local player = GetPlayerFromUserID( userid );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		if ( (!player.IsValid()) || (ResponseCriteria.GetValue( player, "incheckpoint" ) == "0" && ResponseCriteria.GetValue( player, "instartarea" ) == "0") )
			return;
		
		if ( ResponseCriteria.GetValue( player, "incheckpoint" ) == "1" )
		{
			SessionState.SurvivorIsSafe[GetCharacterDisplayName( player )] <- true;
			
			if ( SessionState.SaferoomAwardsScore && SessionState.SaferoomCheck && !SessionState.Scored[GetCharacterDisplayName( player )] )
			{
				if ( SessionState.IsRaceEvent )
				{
					if ( SessionState.FirstInSaferoom == "" )
					{
						SessionState.FirstInSaferoom = GetCharacterDisplayName( player );
						SurvivorStats.score[GetCharacterDisplayName( player )] += 3;
					}
					else
					{
						if ( SessionState.SecondInSaferoom == "" )
						{
							SessionState.SecondInSaferoom = GetCharacterDisplayName( player );
							SurvivorStats.score[GetCharacterDisplayName( player )] += 2;
						}
						else
						{
							if ( SessionState.ThirdInSaferoom == "" )
							{
								SessionState.ThirdInSaferoom = GetCharacterDisplayName( player );
								SurvivorStats.score[GetCharacterDisplayName( player )] += 1;
							}
						}
					}
					SessionState.Scored[GetCharacterDisplayName( player )] <- true;
				}
				else
				{
					if ( SessionState.SaferoomWeaponNeeded != "" )
					{
						if ( player.GetActiveWeapon().GetClassname() == SessionState.SaferoomWeaponNeeded )
						{
							SurvivorStats.score[GetCharacterDisplayName( player )]++;
							SessionState.Scored[GetCharacterDisplayName( player )] <- true;
						}
					}
					else
					{
						SurvivorStats.score[GetCharacterDisplayName( player )] += SessionState.SaferoomAward;
						SessionState.Scored[GetCharacterDisplayName( player )] <- true;
					}
				}
				SessionState.ScoredSurvivors++;
				
				if ( !SessionState.SurvivorsSafe && !IsMissionFinalMap() )
				{
					CheckNeededSurvivors();
				}
			}
		}
		else if ( ResponseCriteria.GetValue( player, "instartarea" ) == "1" )
		{
			SessionState.SurvivorInStart[GetCharacterDisplayName( player )] <- true;
		}
	}

	function OnGameEvent_player_entered_checkpoint( params )
	{
		local character = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
		if ( !character )
			return;

		local teamNum = NetProps.GetPropInt( character, "m_iTeamNum" );
		if ( teamNum == 3 )
			character.TakeDamage( character.GetMaxHealth(), 0, Entities.First() );
		else if ( teamNum == 2 )
		{
			if ( SessionState.EndRound )
				return;

			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.EnterSaferoom(" + params["userid"] + ")", 0.1 );
		}
	}

	function LeaveSaferoom( userid )
	{
		if ( SessionState.EndRound )
			return;
		
		local player = GetPlayerFromUserID( userid );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		if ( (!player.IsValid()) || (ResponseCriteria.GetValue( player, "incheckpoint" ) == "1" && ResponseCriteria.GetValue( player, "instartarea" ) == "1") )
			return;
		
		SessionState.SurvivorIsSafe[GetCharacterDisplayName( player )] <- false;
		SessionState.SurvivorInStart[GetCharacterDisplayName( player )] <- false;
	}

	function OnGameEvent_player_left_checkpoint( params )
	{
		if ( SessionState.EndRound )
			return;

		if ( !("userid" in params) )
			return;
		
		local player = GetPlayerFromUserID( params["userid"] );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.LeaveSaferoom(" + params["userid"] + ")", 0.1 );
	}

	function ConnectRescueVehicleTriggerOutputs()
	{
		local function ZSL_EnterRescue()
		{
			if ( (!activator.IsPlayer()) || (!activator.IsSurvivor()) )
				return;
			
			if ( !SessionState.AwardedRescueScore )
			{
				g_ModeScript.SurvivorStats.score[GetCharacterDisplayName( activator )] += SessionState.VehicleAward;
				SessionState.AwardedRescueScore = true;
			}
			SessionState.AllowRevive = false;
			foreach( survivor in SessionState.AllSurvivors )
			{
				if ( survivor != activator )
				{
					survivor.SetReviveCount( 2 );
					survivor.TakeDamage( survivor.GetHealth(), 0, Entities.First() );
				}
			}
		}

		local function AddOutput( trigger )
		{
			if ( !trigger )
				return;

			if ( trigger.ValidateScriptScope() )
			{
				local triggerScope = trigger.GetScriptScope();
				triggerScope["ZSL_EnterRescue"] <- ZSL_EnterRescue;
				trigger.ConnectOutput( "OnStartTouch", "ZSL_EnterRescue" );
			}
		}

		if ( Director.GetMapName() == "c2m5_concert" )
		{
			AddOutput( Entities.FindByName( null, "stadium_exit_right_escape_trigger" ) );
			AddOutput( Entities.FindByName( null, "stadium_exit_leftt_escape_trigger" ) );
		}
		else
			AddOutput( FindRescueAreaTrigger() );
	}

	function OnGameEvent_finale_vehicle_ready( params )
	{
		if ( !SessionState.HasSurvivalFinale )
			ConnectRescueVehicleTriggerOutputs();
	}

	function OnGameEvent_finale_vehicle_leaving( params )
	{
		if ( SessionState.GameEnded )
			return;
		
		RemoveHUD();
		DisplayScores();
	}

	function OnGameEvent_round_start_post_nav( params )
	{
		RestoreTable( "Stats", SurvivorStats );
		RestoreTable( "StatsBackup", SurvivorStatsBackup );
		RestoreTable( "ZSLMapData", ZSLMapData );

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
		if ( SessionOptions.cm_MaxSpecials == 0 )
		{
			for ( local spawner; spawner = Entities.FindByClassname( spawner, "info_zombie_spawn" ); )
			{
				local population = NetProps.GetPropString( spawner, "m_szPopulation" );

				if ( population == "boomer" || population == "hunter" || population == "smoker" || population == "jockey"
					|| population == "charger" || population == "spitter" || population == "new_special" || population == "church"
						|| population == "tank" || population == "witch" || population == "witch_bride" || population == "river_docks_trap" )
					spawner.Kill();
			}
		}

		EntFire( "weapon_spawn", "Kill" );
		foreach( wep, val in SessionOptions.weaponsToRemove )
			EntFire( wep + "_spawn", "Kill" );
		
		EntFire( "prop_minigun", "Kill" );
		EntFire( "prop_minigun_l4d1", "Kill" );
		EntFire( "prop_mounted_machine_gun", "Kill" );

		if ( SessionState.HasSurvivalFinale )
		{
			if ( IsMissionFinalMap() )
			{
				if ( ZSLMapData.maprestarts == 1 )
					SessionState.Attempts = "OVERTIME!!";
				SessionOptions.SpecialInitialSpawnDelayMin <- 20;
				SessionOptions.SpecialInitialSpawnDelayMax <- 20;
				SessionOptions.A_CustomFinale1 <- STAGE_PANIC;
				SessionOptions.A_CustomFinaleValue1 <- 999999;
			}
			else
			{
				if ( ZSLMapData.maprestarts == 0 )
					SessionState.Attempts = "First Attempt";
				else if ( ZSLMapData.maprestarts == 1 )
					SessionState.Attempts = "Second Attempt";
				else if ( ZSLMapData.maprestarts == 2 )
					SessionState.Attempts = "Final Attempt";
			}
		}
		
		if ( SessionState.IsRaceEvent )
			SessionState.NeededSurvivors = 3;
	}

	function OnGameEvent_player_hurt( params )
	{
		local player = GetPlayerFromUserID( params["userid"] );
		if ( (!player) || (!player.IsSurvivor()) )
			return;
		
		local maxIncap = ("SurvivorMaxIncapacitatedCount" in DirectorScript.GetDirectorOptions()) ? DirectorScript.GetDirectorOptions().SurvivorMaxIncapacitatedCount : Convars.GetFloat( "survivor_max_incapacitated_count" );
		if ( maxIncap == 0 )
		{
			if ( player.GetHealth() > 25 && player.GetHealth() <= 50 )
				NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", 33023 );
			else if ( player.GetHealth() <= 25 )
				NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", 255 );
		}
	}

	function OnGameEvent_player_left_safe_area( params )
	{
		if ( IsMissionFinalMap() )
		{
			if ( SessionState.HasSurvivalFinale )
				EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.FinaleDelay()", 20.0 );
			else
			{
				if ( SessionState.AutoStartFinale )
				{
					EntFire( "trigger_finale", "ForceFinaleStart" );
					EntFire( "trigger_finale", "FinaleEscapeStarted" );
					EntFire( "relay_car_ready", "Trigger" );
					NavMesh.UnblockRescueVehicleNav();
				}
			}
		}

		if ( SessionState.AutoTriggerEvents )
		{
			EntFire( "spawn_church_zombie", "Kill" );
			
			EntFire( "gunshop_door_button", "Kill" );
			EntFire( "gunshop_door_01", "Unlock" );
			EntFire( "gunshop_door_01", "Open" );
			EntFire( "gunshop_door_01", "SetBreakable" );
			EntFire( "tanker_destroy_relay", "Trigger" );
			EntFire( "whitaker_relay", "Trigger" );
			EntFire( "carousel_start_relay", "Trigger" );
			EntFire( "carousel_gate_relay", "Trigger" );
			EntFire( "carousel_game_event", "Kill" );
			EntFire( "carousel_gate_button_model", "SetAnimation", "on" );
			EntFire( "carousel_gate_button_model", "StopGlowing" );
			EntFire( "carousel_gate_button_sound", "PlaySound" );
			EntFire( "carousel_instruct_timer", "Kill" );
			EntFire( "carousel_gate_button", "Kill" );
			EntFire( "carousel_button2_relay", "Trigger" );
			EntFire( "relay_start_onslaught", "Trigger" );
			EntFire( "minifinale_gates_slide_door", "Open" );
			EntFire( "ticketbooth_hint", "Kill" );
			EntFire( "minifinale_gates_sound", "PlaySound" );
			EntFire( "ferry_button_stick_relay", "Trigger" );
			EntFire( "bridge_button", "Press" );
			EntFire( "button_callelevator", "Press" );
			EntFire( "relay_car_ready", "Trigger" );
			EntFire( "finale_cleanse_entrance_door", "Lock" );
			EntFire( "finale_cleanse_exit_door", "Unlock" );
			EntFire( "ceda_trailer_canopen_frontdoor_listener", "Kill" );
			EntFire( "finale_cleanse_backdoors_blocker", "Kill" );
			EntFire( "finale_end_doors_left", "Open" );
			EntFire( "finale_end_doors_right", "Open" );
			EntFire( "tractor_start_relay", "Trigger" );
			EntFire( "filter_generator", "TestActivator" );
			EntFire( "elevator","MoveToFloor", "bottom" );
			EntFire( "elevator_pulley", "Start" );
			EntFire( "elevator_pulley2", "Start" );
			EntFire( "elevbuttonoutsidefront", "skin", "1" );
			EntFire( "sound_elevator_startup", "PlaySound" );
			EntFire( "elevator_start_shake", "StartShake" );
			EntFire( "elevator_number_relay", "Trigger" );
			EntFire( "elevator_breakwalls*", "Kill" );
			EntFire( "elevator_game_event", "Kill" );
			EntFire( "button_minifinale", "Press" );
			EntFire( "relay_enable_chuch_zombie_loop", "Trigger" );
			EntFire( "train_engine_button", "Press" );
			EntFire( "tankdoorin", "Unlock" );
			EntFire( "tankdoorin", "Open" );
			EntFire( "tankdoorin_button", "Kill" );
			EntFire( "tankdoorout", "Unlock" );
			EntFire( "tankdoorout", "Open" );
			EntFire( "tankdoorout_button", "Kill" );
			EntFire( "tank_sound_timer", "Kill" );
			EntFire( "radio_fake_button", "Press" );
			EntFire( "drawbridge", "MoveToFloor", "bottom" );
			EntFire( "drawbridge_start_sound", "PlaySound" );
			EntFire( "startbldg_door_button", "Press" );
			EntFire( "startbldg_door", "Open" );
			EntFire( "stage_lights_button", "Press" );
			EntFire( "fire_howitzer", "Press" );
			if ( SessionState.MapName == "c9m2_lots" )
			{
				EntFire( "finaleswitch_initial", "Kill" );
				EntFire( "finale_lever", "Enable", "", 5 );
				EntFire( "radio_game_event_pre", "Kill" );
				EntFire( "radio_game_event", "GenerateGameEvent" );
				EntFire( "sound_generator_start", "StopSound" );
				EntFire( "generator_start_particles", "Start" );
				EntFire( "generator_light_switchable", "TurnOn" );
				EntFire( "generator_lights", "LightOn" );
				EntFire( "sound_generator_run", "PlaySound", "", 0.8 );
				EntFire( "lift_switch_spark", "SparkOnce", "", 1 );
				EntFire( "lift_lever", "SetDefaultAnimation", "IDLE_DOWN", 0.1 );
				EntFire( "lift_lever", "SetAnimation", "DOWN" );
				EntFire( "lift_spark02", "SparkOnce" );
				EntFire( "lift_spark01", "SparkOnce" );
				EntFire( "radio_game_event", "Kill" );
				EntFire( "survivalmode_exempt", "Trigger" );
				EntFire( "generator_break_timer", "Enable" );
				EntFire( "generator_hint", "EndHint" );
				EntFire( "survival_start_relay", "Trigger" );
			}
			EntFire( "button", "Press" );
			EntFire( "crane button", "Press" );
			EntFire( "barricade_gas_can", "Ignite" );
			
			NavMesh.UnblockRescueVehicleNav();
		}
		
		if ( SessionState.HasSurvivalFinale )
			EntFire( "trigger_heli", "Kill" );
		
		if ( !SessionState.EndRound && !IsMissionFinalMap() )
		{
			local dist = null;
			local ent = null;
			
			for ( local door; door = Entities.FindByClassname( door, "prop_door_rotating_checkpoint" ); )
			{
				if ( NetProps.GetPropInt( door, "m_hasUnlockSequence" ) == 1 || door.GetName() == "checkpoint_exit" )
					continue;
				
				if ( NetProps.GetPropInt( door, "m_eDoorState" ) != 2 )
				{
					local distTo = (door.GetOrigin() - SessionState.AllSurvivors[0].GetOrigin()).Length();
					
					if ( !dist || distTo < dist )
					{
						dist = distTo;
						ent = door;
					}
				}
			}
			
			if ( ent && dist > 999.9 )
			{
				DoEntFire( "!self", "Close", "", 0, null, ent );
				DoEntFire( "!self", "DisableShadow", "", 0, null, ent );
				DoEntFire( "!self", "DisableCollision", "", 0, null, ent );
				NetProps.SetPropInt( ent, "m_nRenderMode", 1 );
				DoEntFire( "!self", "Alpha", "70", 0, null, ent );
			}
		}
		
		SessionState.SaferoomCheck = true;
		if ( SessionState.EventRules != "" )
			ClientPrint( null, 5, "ZSL: " + SessionState.EventRules );
	}

	function OnGameEvent_player_bot_replace( params )
	{
		local player = GetPlayerFromUserID( params["player"] );
		local bot = GetPlayerFromUserID( params["bot"] );
		if ( ( !player ) || ( !player.IsSurvivor() ) || ( !bot ) || ( !bot.IsSurvivor() ) )
			return;

		NetProps.SetPropInt( player, "m_Glow.m_iGlowType", 0 );
		
		local maxIncap = ("SurvivorMaxIncapacitatedCount" in DirectorScript.GetDirectorOptions()) ? DirectorScript.GetDirectorOptions().SurvivorMaxIncapacitatedCount : Convars.GetFloat( "survivor_max_incapacitated_count" );
		if ( maxIncap == 0 )
		{
			if ( bot.GetHealth() > 50 )
			{
				local color = 255 //alpha
				color = (color << 8) | 122 //blue
				color = (color << 8) | 61 //green
				color = (color << 8) | 255 //red
				NetProps.SetPropInt( bot, "m_Glow.m_glowColorOverride", color );
			}
			else if ( bot.GetHealth() > 25 && bot.GetHealth() <= 50 )
				NetProps.SetPropInt( bot, "m_Glow.m_glowColorOverride", 33023 );
			else if ( bot.GetHealth() <= 25 )
				NetProps.SetPropInt( bot, "m_Glow.m_glowColorOverride", 255 );
		}
		else
		{
			local reviveCount = NetProps.GetPropInt( bot, "m_currentReviveCount" );
			if ( reviveCount == 0 )
			{
				local color = 255 //alpha
				color = (color << 8) | 122 //blue
				color = (color << 8) | 61 //green
				color = (color << 8) | 255 //red
				NetProps.SetPropInt( bot, "m_Glow.m_glowColorOverride", color );
			}
			else if ( reviveCount == 1 )
				NetProps.SetPropInt( bot, "m_Glow.m_glowColorOverride", 33023 );
			else if ( reviveCount == 2 )
				NetProps.SetPropInt( bot, "m_Glow.m_glowColorOverride", 255 );
		}
		
		if ( NetProps.GetPropInt( bot, "m_lifeState" ) == 0 )
			NetProps.SetPropInt( bot, "m_Glow.m_iGlowType", 3 );
	}

	function OnGameEvent_bot_player_replace( params )
	{
		local player = GetPlayerFromUserID( params["player"] );
		local bot = GetPlayerFromUserID( params["bot"] );
		if ( ( !player ) || ( !player.IsSurvivor() ) || ( !bot ) || ( !bot.IsSurvivor() ) )
			return;

		NetProps.SetPropInt( bot, "m_Glow.m_iGlowType", 0 );
		
		local reviveCount = NetProps.GetPropInt( bot, "m_currentReviveCount" );
		local maxIncap = ("SurvivorMaxIncapacitatedCount" in DirectorScript.GetDirectorOptions()) ? DirectorScript.GetDirectorOptions().SurvivorMaxIncapacitatedCount : Convars.GetFloat( "survivor_max_incapacitated_count" );
		if ( maxIncap == 0 )
		{
			if ( bot.GetHealth() > 50 )
			{
				local color = 255 //alpha
				color = (color << 8) | 122 //blue
				color = (color << 8) | 61 //green
				color = (color << 8) | 255 //red
				NetProps.SetPropInt( bot, "m_Glow.m_glowColorOverride", color );
			}
			else if ( bot.GetHealth() > 25 && bot.GetHealth() <= 50 )
				NetProps.SetPropInt( bot, "m_Glow.m_glowColorOverride", 33023 );
			else if ( bot.GetHealth() <= 25 )
				NetProps.SetPropInt( bot, "m_Glow.m_glowColorOverride", 255 );
		}
		else
		{
			if ( reviveCount == 0 )
			{
				local color = 255 //alpha
				color = (color << 8) | 122 //blue
				color = (color << 8) | 61 //green
				color = (color << 8) | 255 //red
				NetProps.SetPropInt( bot, "m_Glow.m_glowColorOverride", color );
			}
			else if ( reviveCount == 1 )
				NetProps.SetPropInt( bot, "m_Glow.m_glowColorOverride", 33023 );
			else if ( reviveCount == 2 )
				NetProps.SetPropInt( bot, "m_Glow.m_glowColorOverride", 255 );
		}
		
		if ( NetProps.GetPropInt( bot, "m_lifeState" ) == 0 )
			NetProps.SetPropInt( bot, "m_Glow.m_iGlowType", 3 );
		if ( reviveCount < 2 )
			StopSoundOn( "Player.Heartbeat", player );
	}

	function RemoveHUD()
	{
		//Remove unneeded HUD elements for score display
		StatHUD.Fields.timer.flags = StatHUD.Fields.timer.flags | DirectorScript.HUD_FLAG_NOTVISIBLE
		StatHUD.Fields.name0.flags = StatHUD.Fields.name0.flags | DirectorScript.HUD_FLAG_NOTVISIBLE
		StatHUD.Fields.name1.flags = StatHUD.Fields.name1.flags | DirectorScript.HUD_FLAG_NOTVISIBLE
		StatHUD.Fields.name2.flags = StatHUD.Fields.name2.flags | DirectorScript.HUD_FLAG_NOTVISIBLE
		StatHUD.Fields.name3.flags = StatHUD.Fields.name3.flags | DirectorScript.HUD_FLAG_NOTVISIBLE
	}

	function DisplayScores()
	{
		local Scores = {};
		foreach ( survivor in SessionState.AllSurvivors )
			Scores.rawset( survivor, SurvivorStats.score[GetCharacterDisplayName( survivor )] );
		
		local HiScores = [];
		local slot = 0;
		
		while ( Scores.len() > 0 )
		{
			local highestScore = 0;
			local player = null;
			
			foreach( survivor, score in Scores )
			{
				if ( score >= highestScore )
				{
					highestScore = score;
					player = survivor;
				}
			}
			
			HiScores.insert(slot, player);
			Scores.rawdelete(player);
			slot++;
		}
		
		SessionState.FirstScore = SurvivorStats.score[GetCharacterDisplayName( HiScores[0] )];
		SessionState.FirstName = HiScores[0].GetPlayerName();
		SessionState.FirstSurvivor = HiScores[0];
		SessionState.SecondScore = SurvivorStats.score[GetCharacterDisplayName( HiScores[1] )];
		SessionState.SecondName = HiScores[1].GetPlayerName();
		SessionState.SecondSurvivor = HiScores[1];
		SessionState.ThirdScore = SurvivorStats.score[GetCharacterDisplayName( HiScores[2] )];
		SessionState.ThirdName = HiScores[2].GetPlayerName();
		SessionState.ThirdSurvivor = HiScores[2];
		SessionState.FourthScore = SurvivorStats.score[GetCharacterDisplayName( HiScores[3] )];
		SessionState.FourthName = HiScores[3].GetPlayerName();
		SessionState.FourthSurvivor = HiScores[3];
		
		SessionState.Score1 = SessionState.FirstPlace + SessionState.FirstName + " (" + SessionState.FirstScore + ")";
		SessionState.Score2 = SessionState.SecondPlace + SessionState.SecondName + " (" + SessionState.SecondScore + ")";
		SessionState.Score3 = SessionState.ThirdPlace + SessionState.ThirdName + " (" + SessionState.ThirdScore + ")";
		SessionState.Score4 = SessionState.FourthPlace + SessionState.FourthName + " (" + SessionState.FourthScore + ")";
		
		if ( SessionState.HasSurvivalFinale && SessionState.FirstScore == SessionState.SecondScore )
		{
			SurvivorStats.tiedsurvivors.rawset( GetCharacterDisplayName( SessionState.FirstSurvivor ), true );
			SurvivorStats.tiedsurvivors.rawset( GetCharacterDisplayName( SessionState.SecondSurvivor ), true );
			
			if ( SessionState.SecondScore == SessionState.ThirdScore )
				SurvivorStats.tiedsurvivors.rawset( GetCharacterDisplayName( SessionState.ThirdSurvivor ), true );
			if ( SessionState.SecondScore == SessionState.FourthScore )
				SurvivorStats.tiedsurvivors.rawset( GetCharacterDisplayName( SessionState.FourthSurvivor ), true );
			
			SurvivorStats.tiedscore = true;
			
			foreach( survivor in SessionState.AllSurvivors )
			{
				if ( NetProps.GetPropInt( survivor, "m_lifeState" ) != 0 )
					continue;

				NetProps.SetPropInt( survivor, "m_takedamage", 2 );
				survivor.SetReviveCount( 2 );
				survivor.TakeDamage( survivor.GetMaxHealth(), 0, Entities.First() );
			}
			
			HUDPlace( HUD_MID_BOX, 0.30, 0.32, 0.44, 0.06 );
			SessionState.FinalScores = "Survivors are tied, going to Sudden Death!!";
			g_ModeScript.StatHUD.Fields.scores.flags = g_ModeScript.StatHUD.Fields.scores.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
		}
		else
		{
			HUDPlace( HUD_MID_BOX, 0.30, 0.32, 0.44, 0.06 );
			HUDPlace( HUD_RIGHT_BOT, 0.30, 0.32, 0.44, 0.40 );
			HUDPlace( HUD_SCORE_1, 0.38, 0.40, 0.44, 0.06 ); //HUDPlace( HUD_SCORE_1, 0.28, 0.50, 0.44, 0.06 )
			HUDPlace( HUD_SCORE_2, 0.38, 0.48, 0.44, 0.06 ); //HUDPlace( HUD_SCORE_2, 0.28, 0.58, 0.44, 0.06 )
			HUDPlace( HUD_SCORE_3, 0.38, 0.56, 0.44, 0.06 ); //HUDPlace( HUD_SCORE_3, 0.28, 0.66, 0.44, 0.06 )
			HUDPlace( HUD_SCORE_4, 0.38, 0.64, 0.44, 0.06 ); //HUDPlace( HUD_SCORE_4, 0.28, 0.74, 0.44, 0.06 )
			StatHUD.Fields.scores.flags = StatHUD.Fields.scores.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
			StatHUD.Fields.scorebackground.flags = StatHUD.Fields.scorebackground.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
			StatHUD.Fields.score0.flags = StatHUD.Fields.score0.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
			StatHUD.Fields.score1.flags = StatHUD.Fields.score1.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
			StatHUD.Fields.score2.flags = StatHUD.Fields.score2.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
			StatHUD.Fields.score3.flags = StatHUD.Fields.score3.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.EndGame()", 10.0 );
		}
	}
}

__CollectEventCallbacks( g_ModeScript.ZSLBase, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener );

function SetupModeHUD()
{
	StatHUD <-
	{
		Fields =
		{
			scores =
			{
				slot = HUD_MID_BOX ,
				datafunc = @() SessionState.FinalScores,
				name = "scores",
				flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
			}
			timer =
			{
				slot = HUD_SCORE_TITLE ,
				staticstring = SessionState.TimerString,
				name = "timer",
				flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_COUNTDOWN_WARN | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
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
			attempts =
			{
				slot = HUD_LEFT_BOT ,
				datafunc = @() SessionState.Attempts,
				name = "attempts",
				flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
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
	HUDPlace( HUD_FAR_LEFT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_TOP, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_FAR_RIGHT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOT, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOX, 0.0, 0.04, 1.0, 0.045 );
	HUDPlace( HUD_LEFT_BOT, 0.0, 0.04, 1.0, 0.045 );
	HUDPlace( HUD_SCORE_TITLE, 0.0, 0.00, 1.0, 0.045 );
	HUDSetLayout( StatHUD );
}

function ZSL_Update()
{
	if ( SessionState.HPDecayActive && (Time() - SessionState.LastHPDecayTime) >= SessionState.HPDecayDelay )
	{
		foreach( survivor in SessionState.AllSurvivors )
		{
			if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
			{
				if ( survivor.GetHealth() > 1 )
				{
					survivor.SetHealth( survivor.GetHealth() - 1 );

					local maxIncap = ("SurvivorMaxIncapacitatedCount" in DirectorScript.GetDirectorOptions()) ? DirectorScript.GetDirectorOptions().SurvivorMaxIncapacitatedCount : Convars.GetFloat( "survivor_max_incapacitated_count" );
					if ( maxIncap == 0 )
					{
						if ( survivor.GetHealth() > 25 && survivor.GetHealth() <= 50 )
							NetProps.SetPropInt( survivor, "m_Glow.m_glowColorOverride", 33023 );
						else if ( survivor.GetHealth() <= 25 )
							NetProps.SetPropInt( survivor, "m_Glow.m_glowColorOverride", 255 );
					}
				}
			}
		}
		SessionState.LastHPDecayTime = Time();
	}
	if ( SessionOptions.cm_CommonLimit == 0 && Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
	if ( !SessionState.SurvivorsSafe && !IsMissionFinalMap() && SessionState.SaferoomAwardsScore && SessionState.SaferoomCheck )
	{
		g_ModeScript.ZSLBase.CheckNeededSurvivors();
	}
}

ScriptedMode_AddUpdate( ZSL_Update );
