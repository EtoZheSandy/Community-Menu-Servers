//-----------------------------------------------------
Msg("Activating Wednesday Night Witching Hour!!\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

IncludeScript("witchinghour");
IncludeScript("zsl_base");

ZSLOptions <-
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
	SurvivorMaxIncapacitatedCount = 0
	
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

ZSLState <-
{
	IsRaceEvent = false
	SaferoomAwardsScore = true
	CurrentStage = -1
	TriggerRescue = false
	DidMiscChecks = false
	RandomWeaponSet = -1
}

AddDefaultsToTable( "ZSLOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ZSLState", g_ModeScript, "MutationState", g_ModeScript );

function GiveWeapons( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( !SessionState.DidMiscChecks )
	{
		if ( IsMissionFinalMap() )
		{
			g_ModeScript.StatHUD.Fields.timer0.flags = g_ModeScript.StatHUD.Fields.timer0.flags | DirectorScript.HUD_FLAG_NOTVISIBLE
			HUDPlace( HUD_RIGHT_TOP, 0.0, 0.00, 1.0, 0.045 );
		}
		SessionState.RandomWeaponSet = RandomInt(0, 4);
		SessionState.DidMiscChecks = true;
	}

	local ListOfRandomSMGs = [ "smg", "smg_silenced", "smg_mp5" ];
	local ListOfRandomShotguns = [ "pumpshotgun", "shotgun_chrome" ];
	local ListOfRandomAutoShotguns = [ "autoshotgun", "shotgun_spas" ];
	local ListOfRandomAssaultRifles = [ "rifle", "rifle_ak47", "rifle_desert", "rifle_sg552" ];
	local ListOfRandomSnipers = [ "hunting_rifle", "sniper_military" ];
	local randWepList = null;
	
	switch( SessionState.RandomWeaponSet )
	{
		case 0:
			randWepList = ListOfRandomSMGs;
			break;
		case 1:
			randWepList = ListOfRandomShotguns;
			break;
		case 2:
			randWepList = ListOfRandomAutoShotguns;
			break;
		case 3:
			randWepList = ListOfRandomAssaultRifles;
			break;
		case 4:
			randWepList = ListOfRandomSnipers;
			break;
		default:
			break;
	}
	player.GiveItem( randWepList[ RandomInt( 0, randWepList.len() - 1 ) ] );
	player.GiveItem( "pistol_magnum" );
	player.GiveUpgrade( DirectorScript.UPGRADE_LASER_SIGHT );
	player.GiveItem( "molotov" );
}

function RespawnWitches()
{
	if ( !IsMissionFinalMap() )
	{
		HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, 120 );
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillWitches()", 120.0 );
	}
	Say( null, "The Witching Hour Has Begun...", false );
	SessionOptions.cm_WitchLimit = 10;
	SessionState.SpawnWitchThink = true;
}

function SpawnWitchesDelay()
{
	RespawnWitches();
}

function OnGameEvent_player_left_safe_area( params )
{
	if ( IsMissionFinalMap() && SessionState.HasSurvivalFinale )
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SpawnWitchesDelay()", 20.0 );
	else
		RespawnWitches();
}

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
			timer0 =
			{
				slot = HUD_SCORE_TITLE ,
				staticstring = "Witches recalled to the Netherworld in: ",
				name = "timer0",
				flags = DirectorScript.HUD_FLAG_COUNTDOWN_WARN | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
				special = HUD_SPECIAL_TIMER0
			}
			timer =
			{
				slot = HUD_RIGHT_TOP ,
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
	HUDPlace( HUD_RIGHT_TOP, 0.0, 0.04, 1.0, 0.045 );
	HUDPlace( HUD_LEFT_BOT, 0.0, 0.04, 1.0, 0.045 );
	HUDPlace( HUD_SCORE_TITLE, 0.0, 0.00, 1.0, 0.045 );
	HUDSetLayout( StatHUD );
}
