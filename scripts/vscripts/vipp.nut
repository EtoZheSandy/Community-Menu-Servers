//-----------------------------------------------------
Msg("Activating VIP Escort: Plague of the Dead\n");
Msg("Made by Rayman1103\n");

IncludeScript("plague");
IncludeScript("vip_base");

VIPState <-
{
	HasPermaWipe = false
	SaveVIPData = true
	SaveVIPHealth = false
	VIPRules = "The Survivor's heartbeat is linked to yours, if he dies, everyone dies. There are no incaps, if you go down, you're dead."
}

AddDefaultsToTable( "VIPState", g_ModeScript, "MutationState", g_ModeScript );

::VIPData.givemedkits <- false;

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
			name9 =
			{
				slot = HUD_RIGHT_TOP ,
				datafunc = @() SessionState.DisplayName(9) + "   " + g_ModeScript.GetInfectionTimer(9),
				name = "name9",
				flags = DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
			}
		}
	}
	HUDPlace( HUD_FAR_LEFT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_TOP, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_FAR_RIGHT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOT, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_RIGHT_TOP, 0.0, 0.04, 1.0, 0.045 );
	HUDSetLayout( PlagueHUD );
}
