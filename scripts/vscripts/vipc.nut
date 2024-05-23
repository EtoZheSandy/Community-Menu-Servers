//-----------------------------------------------------
Msg("Activating VIP Escort: Contagious\n");
Msg("Made by Rayman1103\n");

IncludeScript("contagious");
IncludeScript("vip_base");

VIPState <-
{
	HasPermaWipe = false
	SaveVIPData = true
	VIPRules = "You must protect the Survivor at all cost! If his heart stops beating, so will yours!"
}

AddDefaultsToTable( "VIPState", g_ModeScript, "MutationState", g_ModeScript );

function SetupModeHUD()
{
	InfectedHUD <-
	{
		Fields =
		{
			timer =
			{
				slot = HUD_MID_BOX ,
				staticstring = " Until Next Infection",
				name = "target",
				flags = DirectorScript.HUD_FLAG_COUNTDOWN_WARN | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_POSTSTR | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
				special = HUD_SPECIAL_TIMER0
			}
			name0 =
			{
				slot = HUD_FAR_LEFT ,
				datafunc = @() g_ModeScript.GetInfectedInfo(0),
				name = "name0",
				flags = DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
			name1 =
			{
				slot = HUD_MID_TOP ,
				datafunc = @() g_ModeScript.GetInfectedInfo(1),
				name = "name1",
				flags = DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
			name2 =
			{
				slot = HUD_FAR_RIGHT ,
				datafunc = @() g_ModeScript.GetInfectedInfo(2),
				name = "name2",
				flags = DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_NOBG,
			}
			name3 =
			{
				slot = HUD_MID_BOT ,
				datafunc = @() g_ModeScript.GetInfectedInfo(3),
				name = "name3",
				flags = DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_NOBG,
			}
			name9 =
			{
				slot = HUD_RIGHT_TOP ,
				datafunc = @() g_ModeScript.GetInfectedInfo(9),
				name = "name9",
				flags = DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
			}
		}
	}
	HUDPlace( HUD_MID_BOX, 0.0, 0.00, 1.0, 0.045 );
	HUDPlace( HUD_FAR_LEFT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_TOP, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_FAR_RIGHT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOT, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_RIGHT_TOP, 0.0, 0.04, 1.0, 0.045 );
	HUDSetLayout( InfectedHUD );
}
