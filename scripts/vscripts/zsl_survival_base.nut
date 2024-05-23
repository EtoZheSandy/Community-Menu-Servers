//-----------------------------------------------------

if ( !IsModelPrecached( "models/infected/hulk.mdl" ) )
	PrecacheModel( "models/infected/hulk.mdl" );
if ( !IsModelPrecached( "models/infected/hulk_dlc3.mdl" ) )
	PrecacheModel( "models/infected/hulk_dlc3.mdl" );
if ( !IsModelPrecached( "models/infected/hulk_l4d1.mdl" ) )
	PrecacheModel( "models/infected/hulk_l4d1.mdl" );

IncludeScript("zsl_responserules");

MutationOptions <-
{
	cm_AggressiveSpecials = 1
	cm_AutoReviveFromSpecialIncap = 1
	CommonLimit = 0
	cm_CommonLimit = 0
	cm_MaxSpecials = 12
	cm_DominatorLimit = 12
	cm_SpecialRespawnInterval = 5
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 0
	ShouldAllowSpecialsWithTank = true
	SurvivorMaxIncapacitatedCount = 2
	SurvivalSetupTime = 60

	weaponsToRemove =
	{
		weapon_defibrillator = 0
		weapon_pain_pills = 0
		weapon_adrenaline = 0
		weapon_first_aid_kit = 0
		weapon_molotov = 0
		weapon_pipe_bomb = 0
		weapon_vomitjar = 0
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
	
	function ShouldAvoidItem( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return true;
		}
		return false;
	}
}

MutationState <-
{
	ZSLTanksSpawned = 0
	AutoStarted = false
	SurvivorsDied = 0
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
	FirstName = ""
	SecondName = ""
	ThirdName = ""
	FourthName = ""
	FirstScore = 0
	SecondScore = 0
	ThirdScore = 0
	FourthScore = 0
	LastHPDecayTime = 0
	HPDecayDelay = 2.0
	HPDecayActive = false
	ZSLTimescaleEntity = null
	AllSurvivors = []
	ZSL_OnTakeDamageFunc = null
	
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
		if( (p) && (GetCharacterDisplayName(p) in g_ModeScript.SurvivorStats.score) )
		{
			return (g_ModeScript.SurvivorStats.score[GetCharacterDisplayName(p)])
		}
		else
		{
			return ""
		}
	}
}

::SurvivorStats <-
{
	score = {}
	currentround = 0
	tiedscore = false
	tiedsurvivors = {}
	gameover = false
	score1 = ""
	score2 = ""
	score3 = ""
	score4 = ""
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( damageTable.Attacker.IsPlayer() && damageTable.Victim.IsPlayer() )
	{
		if ( damageTable.Attacker.IsSurvivor() && damageTable.Victim.IsSurvivor() )
			return false;
	}

	if ( SessionState.ZSL_OnTakeDamageFunc )
		return SessionState.ZSL_OnTakeDamageFunc( damageTable );
	else
		return true;
}

function OnShutdown()
{
	if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_ROUND_RESTART )
	{
		SaveTable( "Stats", SurvivorStats );
	}
}

function OnGameplayStart()
{
	if ( !SurvivorStats.gameover )
		ClientPrint( null, 5, "ZSL: [RULES] Survive longer than the others. *1st to die: 0 pts. *2nd to die: 1 pt. *3rd to die: 2 pts. *Last man standing: 3 pts. Survivor with most points after 4 rounds wins!!" );
}

ZSLBase <-
{
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

	function OnGameEvent_round_start_post_nav( params )
	{
		RestoreTable( "Stats", SurvivorStats );
		g_ModeScript.SurvivorStats.currentround++;
		
		if ( g_ModeScript.SurvivorStats.currentround == 4 )
			g_ModeScript.StatHUD.Fields.round.datafunc = @() "Final Round";
		else if ( g_ModeScript.SurvivorStats.currentround >= 5 )
			g_ModeScript.StatHUD.Fields.round.datafunc = @() "Overtime";
		
		if ( SurvivorStats.gameover )
		{
			ZSL_RollStatsCrawl();
			Say( null, SurvivorStats.score1, false );
			Say( null, SurvivorStats.score2, false );
			Say( null, SurvivorStats.score3, false );
			Say( null, SurvivorStats.score4, false );
		}

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
		}
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.ZSLAutoStart()", 60.0 );
	}

	function ZSLSpawnTank()
	{
		local spawnDelay = 5.0;
		switch ( SessionState.ZSLTanksSpawned )
		{
			case 0:
			{
				spawnDelay = 20.0;
				break;
			}
			case 1:
			{
				spawnDelay = 30.0;
				break;
			}
			case 2:
			{
				spawnDelay = 15.0;
				break;
			}
			case 3:
			{
				spawnDelay = 10.0;
				break;
			}
			default:
				break;
		}
		
		ZSpawn( { type = 8 } );
		SessionState.ZSLTanksSpawned++;
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.ZSLSpawnTank()", spawnDelay );
	}

	function ZSLAutoStart()
	{
		if ( SessionState.AutoStarted )
			return;

		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.ZSLSpawnTank()", 40.0 );
		SessionState.HPDecayActive = true;
		SessionState.AutoStarted = true;
	}

	function OnGameEvent_survival_round_start( params )
	{
		if ( !SessionState.AutoStarted )
			ZSLAutoStart();
	}

	function SurvivorPostSpawn( userid )
	{
		local player = GetPlayerFromUserID( userid );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		if ( !(GetCharacterDisplayName( player ) in SurvivorStats.score) )
			SurvivorStats.score[GetCharacterDisplayName( player )] <- 0;
		
		if ( SurvivorStats.tiedscore && !SurvivorStats.gameover )
		{
			if ( !(GetCharacterDisplayName( player ) in SurvivorStats.tiedsurvivors) )
			{
				player.SetReviveCount( 2 );
				player.TakeDamage( player.GetMaxHealth(), 0, Entities.First() );
			}
		}
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
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
		}
		else
			DoEntFire( "!self", "Color", RandomInt( 0, 255 ) + " " + RandomInt( 0, 255 ) + " " + RandomInt( 0, 255 ), 0, null, player );
	}

	function OnGameEvent_tank_spawn( params )
	{
		local tank = GetPlayerFromUserID( params["userid"] );
		if ( !tank )
			return;

		if ( RandomInt( 0, 1 ) == 1 )
		{
			local TankModels =
			[
				"models/infected/hulk.mdl"
				"models/infected/hulk_dlc3.mdl"
				"models/infected/hulk_l4d1.mdl"
			]
			
			local foundModel = TankModels.find( tank.GetModelName() );
			if ( foundModel != null )
				TankModels.remove( foundModel );
			
			tank.SetModel( TankModels[ RandomInt( 0, TankModels.len() - 1 ) ] );
		}
	}

	function OnGameEvent_adrenaline_used( params )
	{
		local player = GetPlayerFromUserID( params["userid"] );
		if ( !player )
			return;

		player.SetHealth( 100 );
		player.SetHealthBuffer( 0 );
		
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

	function OnGameEvent_player_incapacitated( params )
	{
		local player = GetPlayerFromUserID( params["userid"] );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		player.ReviveFromIncap();
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

	function EndRound( userid )
	{
		local player = GetPlayerFromUserID( userid );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		if ( SessionState.ZSLTimescaleEntity )
			DoEntFire( "!self", "Stop", "", 0, null, SessionState.ZSLTimescaleEntity );
		player.SetReviveCount( 2 );
		player.TakeDamage( player.GetMaxHealth(), 0, Entities.First() );
	}

	function CheckScores()
	{
		if ( g_ModeScript.SurvivorStats.currentround >= 4 )
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
			
			if ( SessionState.FirstScore == SessionState.SecondScore )
			{
				SurvivorStats.tiedsurvivors.rawset( GetCharacterDisplayName( SessionState.FirstSurvivor ), true );
				SurvivorStats.tiedsurvivors.rawset( GetCharacterDisplayName( SessionState.SecondSurvivor ), true );
				
				if ( SessionState.SecondScore == SessionState.ThirdScore )
					SurvivorStats.tiedsurvivors.rawset( GetCharacterDisplayName( SessionState.ThirdSurvivor ), true );
				if ( SessionState.SecondScore == SessionState.FourthScore )
					SurvivorStats.tiedsurvivors.rawset( GetCharacterDisplayName( SessionState.FourthSurvivor ), true );
				
				SurvivorStats.tiedscore = true;
			}
			else
			{
				SurvivorStats.gameover = true;
				SurvivorStats.score1 = SessionState.FirstPlace + SessionState.FirstName + " (" + SessionState.FirstScore + ")";
				SurvivorStats.score2 = SessionState.SecondPlace + SessionState.SecondName + " (" + SessionState.SecondScore + ")";
				SurvivorStats.score3 = SessionState.ThirdPlace + SessionState.ThirdName + " (" + SessionState.ThirdScore + ")";
				SurvivorStats.score4 = SessionState.FourthPlace + SessionState.FourthName + " (" + SessionState.FourthScore + ")";
				HUDPlace( HUD_MID_BOX, 0.30, 0.32, 0.44, 0.06 );
				HUDPlace( HUD_RIGHT_BOT, 0.30, 0.32, 0.44, 0.40 );
				HUDPlace( HUD_SCORE_1, 0.38, 0.40, 0.44, 0.06 );
				HUDPlace( HUD_SCORE_2, 0.38, 0.48, 0.44, 0.06 );
				HUDPlace( HUD_SCORE_3, 0.38, 0.56, 0.44, 0.06 );
				HUDPlace( HUD_SCORE_4, 0.38, 0.64, 0.44, 0.06 );
				g_ModeScript.StatHUD.Fields.scores.flags = g_ModeScript.StatHUD.Fields.scores.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
				g_ModeScript.StatHUD.Fields.scorebackground.flags = g_ModeScript.StatHUD.Fields.scorebackground.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
				g_ModeScript.StatHUD.Fields.score0.flags = g_ModeScript.StatHUD.Fields.score0.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
				g_ModeScript.StatHUD.Fields.score1.flags = g_ModeScript.StatHUD.Fields.score1.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
				g_ModeScript.StatHUD.Fields.score2.flags = g_ModeScript.StatHUD.Fields.score2.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
				g_ModeScript.StatHUD.Fields.score3.flags = g_ModeScript.StatHUD.Fields.score3.flags & ~DirectorScript.HUD_FLAG_NOTVISIBLE
			}
		}
	}

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

	function ZSLSlowTime( desiredTimeScale = 0.2, re_Acceleration = 2.0, minBlendRate = 1.0, blendDeltaMultiplier = 2.0 )
	{
		if ( !SessionState.ZSLTimescaleEntity )
			SessionState.ZSLTimescaleEntity = SpawnEntityFromTable( "func_timescale", { targetname = "zsl_timescale", origin = Vector(0, 0, 0) } );
		
		SessionState.ZSLTimescaleEntity.__KeyValueFromInt( "desiredTimescale", desiredTimeScale );
		SessionState.ZSLTimescaleEntity.__KeyValueFromInt( "acceleration", re_Acceleration );
		SessionState.ZSLTimescaleEntity.__KeyValueFromInt( "minBlendRate", minBlendRate );
		SessionState.ZSLTimescaleEntity.__KeyValueFromInt( "blendDeltaMultiplier", blendDeltaMultiplier );
		DoEntFire( "!self", "Start", "", 0, null, SessionState.ZSLTimescaleEntity );
	}

	function OnGameEvent_player_death( params )
	{
		if ( !("userid" in params) )
			return;
		
		local victim = GetPlayerFromUserID( params["userid"] );
		
		if ( ( !victim ) || ( !victim.IsSurvivor() ) )
			return;
		
		SessionState.SurvivorsDied++;
		NetProps.SetPropInt( victim, "m_Glow.m_glowColorOverride", 0 );
		NetProps.SetPropInt( victim, "m_Glow.m_iGlowType", 0 );
		EntFire( "survivor_death_model", "BecomeRagdoll" );
		
		for ( local adrenaline; adrenaline = Entities.FindByClassname( adrenaline, "weapon_adrenaline" ); )
		{
			if ( !NetProps.GetPropEntity( adrenaline, "m_hOwner" ) )
				adrenaline.Kill();
		}
		
		if ( SurvivorStats.tiedscore )
		{
			if ( !(GetCharacterDisplayName( victim ) in SurvivorStats.tiedsurvivors) )
				return;
		}
		
		if ( g_ModeScript.SurvivorStats.currentround == 5 && SessionState.SurvivorsDied < 3 )
			return;
		
		if ( SessionState.SurvivorsDied == 2 )
			SurvivorStats.score[GetCharacterDisplayName( victim )] += 1;
		else if ( SessionState.SurvivorsDied == 3 )
		{
			if ( g_ModeScript.SurvivorStats.currentround < 5 )
				SurvivorStats.score[GetCharacterDisplayName( victim )] += 2;
			ZSLSlowTime(0.5, 2.0, 1.0, 2.0);
			local winMessage = "You've won this round!";
			if ( g_ModeScript.SurvivorStats.currentround >= 4 )
				winMessage = "You've won the match!";
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
				if ( g_ModeScript.SurvivorStats.currentround < 5 )
					SurvivorStats.score[GetCharacterDisplayName( winner )] += 3;
				else
					SurvivorStats.score[GetCharacterDisplayName( winner )]++;
				ZSLShowHint( winner, winMessage, 5, "icon_alert", "", "255 61 122" );
				EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.EndRound(" + winner.GetPlayerUserId() + ")", 5.0 );
			}
		}
		else if ( SessionState.SurvivorsDied == 4 )
		{
			if ( SessionState.ZSLTimescaleEntity )
				DoEntFire( "!self", "Stop", "", 0, null, SessionState.ZSLTimescaleEntity );
			CheckScores();
		}
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
		if ( NetProps.GetPropInt( player, "m_lifeState" ) == 0 )
			NetProps.SetPropInt( player, "m_Glow.m_iGlowType", 3 );
		if ( player.GetReviveCount() < 2 )
			StopSoundOn( "Player.Heartbeat", player );
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
			round =
			{
				slot = HUD_SCORE_TITLE ,
				datafunc = @() "Round " + g_ModeScript.SurvivorStats.currentround,
				name = "round",
				flags = DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
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
	HUDPlace( HUD_FAR_LEFT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_TOP, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_FAR_RIGHT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOT, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOX, 0.0, 0.04, 1.0, 0.045 );
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
}

ScriptedMode_AddUpdate( ZSL_Update );
