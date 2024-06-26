//  Rayman update
//1 add new Rayman's buttons & flyouts if necessary
//2 auto-replace flyouts xpos from "280" to "251" (see //flyouts xpos)
//2 auto-replace flyouts ypos from "203" to "160" (see //flyouts ypos)
//3 uncomment mutation modes, if necessary
//4 copy other assets, like maps, scripts, modes, materials
"Resource/UI/MainMenu.res"
{
	"NyanCat" [$x360lodef]//classic
	{
		"ControlName"	"ImagePanel"
		"fieldname"		"NyanCat"
		"xpos"			"c-180" [$WIN32WIDE]
		"xpos"			"224" [!$WIN32WIDE]
		"ypos"			"41"
		"wide"			"54"
		"tall"			"54"
		"zpos"			"-19"
		"visible"		"1"//draw_nyancat
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			"urikgamemenu/nyancat_4x4"
	}
	"MainMenu"
	{
		"ControlName"			"Frame"
		"fieldName"				"MainMenu"
		"xpos"					"0"
		"ypos"					"0"
		"wide"					"f0"
		"tall"					"f0"
		"autoResize"			"0"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"PaintBackgroundType"	"0"
	}
	"Tinsel1" [$x360lodef]//xmas
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"Tinsel1"
		"xpos"					"0"
		"ypos"					"-12"
		"wide"					"f0"
		"tall"					"53"
		"autoResize"			"0"
		"pinCorner"				"0"
		"visible"				"1"
		"visible"				"0"
		"enabled"				"0"
		"tabPosition"			"0"
		"PaintBackgroundType"	"0"
		"image"				"urikgamemenu_xmas/xmas_tinsel_red"
		"scaleimage"			"1"
		"zpos"				"-9"//tinsel1_zpos
	}	
	"Snowflakes" [$x360lodef]//xmas
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"Snowflakes"
		"xpos"					"0"
		"ypos"					"0"
		"wide"					"f0"
		"tall"					"f0"
		"autoResize"			"0"
		"pinCorner"				"0"
		"visible"				"1"
		"visible"				"0"
		"enabled"				"0"
		"tabPosition"			"0"
		"PaintBackgroundType"	"0"
		"image"				"urikgamemenu_xmas/snowflakes_main"
		"scaleimage"			"1"
		"zpos"				"-20"//snow_zpos
	}
	"BtnGameModes"
	{
		"ControlName"			"GameModes"
		"fieldName"				"BtnGameModes"
	
		"tabPosition"			"1"
		"navUp"					"PnlQuickJoinGroups"		
		"navDown"				"BtnToggleConsole"
		"xpos"					"c-456"	[$WIN32WIDE]
		"xpos"					"-50"	[!$WIN32WIDE]
		"ypos"					"28"	//was 10
		
		// needed to push the game modes carousel behind the other main menu buttons
		// that overlap into the carousel rect (which needs be oversized due to flyouts)
		// and would not get mouse hittests
		"zpos"					-10				
		"borderimage"			"vgui/urikgamemenu_xmas/menu_mode_border_xmas" [$x360lodef]//xmas
		"leftarrow"				"vgui/urikgamemenu_xmas/arrow_left_xmas" [$x360lodef]//xmas
		"rightarrow"			"vgui/urikgamemenu_xmas/arrow_right_xmas" [$x360lodef]//xmas
		"borderimage"			"vgui/urikgamemenu/avatarframe"//new 202
	
		"leftarrow"				"vgui/arrow_left"	
		"rightarrow"			"vgui/arrow_right"	
		"arrowwidth"			21
		"arrowheight"			21
		"arrowoffsety"			-3		//was -3
		"rightarrowoffsetx"		5		//was 7	
		// main pic, vertically centered
		"picoffsetx"			100	//was 100
		//"picoffsety"			10	//was 100
		"picwidth"				128	//was 153
		"picheight"				128 //was 153
		// menu text, underneath pic
		"menutitlex"			100
		"menutitley"			5	//was 5 // was 16
		// the pc clips text, these need to be wider for the hint, but then use wideatopen to foreshorten the flyout
		"menutitlewide"			500
		"wideatopen"			180
	//	"wideatopen"			180
	//	"wideatopen"			240	[$POLISH]
		"menutitletall"			80
		// small pics, vertically centered, to the right of the main pic
		"subpics"				8		[$X360WIDE || $WIN32WIDE]		//was 5
		"subpics"				7		[!($X360WIDE || $WIN32WIDE)]	//was 3
		"subpicgap"				4		//was "6" // between pics
		"subpicoffsetx"			46		//was "50" urik- value chosen that way so that in non-wide aspect ratio 5 sub-pics fit on screen
		"subpicoffsety"			-15 	//was -10
		"subpicwidth"			72		//was 86
		"subpicheight"			72		//was 86
		"subpicnamefont"		"DefaultVerySmall"
		"hidelabels"			"0"		// urik- as can be seen from saved commented duplicate of this line, it was disabling gamemode thumbnail labels for any language except english.
	//	"hidelabels"			"1"		[!$ENGLISH]	
	
		"mode" [!$X360GUEST]
		{
			"id"				"BtnCoOp"
			"name"				"#L4D360UI_ModeCaps_COOP"
			"image"				"vgui/menu_mode_campaign"
			"command"			"FlmCampaignFlyout"
			"menutitle"			"#L4D360UI_MainMenu_CoOp"
			"menuhint"			"#L4D360UI_MainMenu_CoOp_Tip"
		}
		
		"mode" [!$X360GUEST]
		{
			"id"				"BtnPlayChallenge"
			"name"				"#L4D360UI_ModeCaps_CHALLENGE"
			"image"				"vgui/menu_mode_mutation"
			"command"			"PlayChallenge"
			"menutitle"			"#L4D360UI_MainMenu_PlayChallenge"
			"menuhint"			" "
			"menuhintdisabled"	"#L4D360UI_MainMenu_DemoVersion"	[$DEMO]
			"custommode"		"1" // mutation
			"enabled"			"0"									[$DEMO]
		}
		
		//RMMmodes_start
		"mode" [!$X360GUEST]
		{
			"id"				"BtnCusMutations"
			"name"				"COM Servers"
			"image"				"vgui/menu_mode_biohazard"
			"command"			"FlmCusMutationsFlyout"
			"menutitle"			"Communuty Servers"
			"menuhint"			"Select a Communuty Servers from the list."
		}
		
		//"mode" [!$X360GUEST]
		//{
		//	"id"				"BtnZSL"
		//	"name"				"          ZSL"
		//	"image"				"vgui/menu_mode_ZSL"
		//	"command"			"FlmZSLFlyout"
		//	"menutitle"			"HEAD2HEAD - COMPETITIVE EVENTS"
		//	"menuhint"			"Enter the Zombie Sports League and defeat your friends!"
		//}
		//RMMmodes_end
		
		"mode" [!$X360GUEST]
		{
			"id"				"BtnPlayRealism"
			"name"				"#L4D360UI_ModeCaps_REALISM"
			"image"				"vgui/menu_mode_realism"
			"command"			"FlmRealismFlyout"
			"menutitle"			"#L4D360UI_MainMenu_Realism"
			"menuhint"			"#L4D360UI_MainMenu_Realism_Tip"
			"menuhintdisabled"	"#L4D360UI_MainMenu_DemoVersion"	[$DEMO]
			"enabled"			"0"									[$DEMO]
		}
		
		"mode" [!$X360GUEST]
		{
			"id"				"BtnVersus"
			"name"				"#L4D360UI_ModeCaps_VERSUS"
			"image"				"vgui/menu_mode_versus"
			"command"			"VersusSoftLock"
			"menutitle"			"#L4D360UI_MainMenu_Versus"
			"menuhint"			"#L4D360UI_MainMenu_Versus_Tip"
			"menuhintdisabled"	"#L4D360UI_MainMenu_DemoVersion"	[$DEMO]
			"enabled"			"0"									[$DEMO]
		}
		
		"mode" [!$X360GUEST]
		{
			"id"				"BtnRealismVersus"
			"name"				"#L4D360UI_ModeCaps_mutation12_short"
			"image"				"vgui/menu_mode_realismversus"
			"command"			"FlmRealismVersusFlyout"						
			"menutitle"			"#L4D360UI_ModeCaps_mutation12"
			"menuhint"			"#L4D360UI_MainMenu_PlayChallenge_Tip_mutation12"			
			"menuhintdisabled"	"#L4D360UI_MainMenu_DemoVersion"	[$DEMO]
			"enabled"			"0"									[$DEMO]
		}
		
		"mode" [!$X360GUEST]
		{
			"id"				"BtnSurvival"
			"name"				"#L4D360UI_ModeCaps_SURVIVAL"
			"image"				"vgui/menu_mode_survival"
			"command"			"SurvivalCheck"
			"menutitle"			"#L4D360UI_MainMenu_Survival"
			"menuhint"			"#L4D360UI_MainMenu_Survival_Tip"
			"menuhintdisabled"	"#L4D360UI_MainMenu_DemoVersion"	[$DEMO]
			"enabled"			"0"									[$DEMO]
		}
		
		"mode" [!$X360GUEST]
		{
			"id"				"BtnVersusSurvival"
			"name"				"#L4D360UI_ModeCaps_mutation15_short"
			"image"				"vgui/menu_mode_versussurvival"
			"command"			"FlmVersusSurvivalFlyout"						
			"menutitle"			"#L4D360UI_ModeCaps_mutation15"
			"menuhint"			"#L4D360UI_MainMenu_PlayChallenge_Tip_mutation15"			
			"menuhintdisabled"	"#L4D360UI_MainMenu_DemoVersion"	[$DEMO]
			"enabled"			"0"									[$DEMO]
		}
		
		"mode" [!$X360GUEST]
		{
			"id"				"BtnScavenge"
			"name"				"#L4D360UI_ModeCaps_SCAVENGE"
			"image"				"vgui/menu_mode_scavenge"
			"command"			"ScavengeCheck"
			"menutitle"			"#L4D360UI_MainMenu_Scavenge"
			"menuhint"			"#L4D360UI_MainMenu_Scavenge_Tip"
			"menuhintdisabled"	"#L4D360UI_MainMenu_DemoVersion"	[$DEMO]
			"enabled"			"0"									[$DEMO]
		}
		
		//"mode" [!$X360SPLITSCREEN]
		//{
		//	"id"				"BtnPlaySolo"
		//	"name"				"#L4D360UI_ModeCaps_offline_SP"
		//	"image"				"vgui/menu_mode_singleplayer"
		//	"command"			"SoloPlay"
		//	"menutitle"			"#L4D360UI_MainMenu_PlaySolo"
		//	"menuhint"			"#L4D360UI_MainMenu_PlaySolo_Tip"
		//}
		"mode" [$X360SPLITSCREEN]
		{
			"id"				"BtnPlaySolo"
			"name"				"#L4D360UI_ModeCaps_offline_SS"
			"image"				"vgui/menu_mode_offline_coop"
			"command"			"SoloPlay"
			"menutitle"			"#L4D360UI_MainMenu_PlaySplitscreen"
			"menuhint"			"#L4D360UI_MainMenu_OfflineCoOp_Tip"
		}
	}
	
	// Custom Flyouts Buttons Start
	// Rayman start
	"BtnCustomMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnCustomMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmCustomMutationsFlyout"
	}              
	"BtnSVSMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnSVSMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmSVSMutationsFlyout"
	}
	"BtnCustomMutations0"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnCustomMutations0"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmCustomMutations0Flyout"
	}
	"BtnCustomMutations1"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnCustomMutations1"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmCustomMutations1Flyout"
	}
	"BtnCampaignMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnCampaignMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmCampaignMutationsFlyout"
	}
	"BtnCampaignMutations1"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnCampaignMutations1"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmCampaignMutations1Flyout"
	}
	"BtnCampaignMutations2"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnCampaignMutations2"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmCampaignMutations2Flyout"
	}
	"BtnCampaignMutations3"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnCampaignMutations3"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmCampaignMutations3Flyout"
	}
	"BtnParasiteMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnParasiteMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmParasiteMutationsFlyout"
	}
	"Btn1L2LMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "Btn1L2LMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "Flm1L2LMutationsFlyout"
	}
	// обязательно добавляем этот хук для новой группы серверов проекта!
	"Btn1L2LMutationsTest"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "Btn1L2LMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "Flm1L2LMutationsFlyoutTest"
	}
	// Guardians Servers
	"BtnGuardiansServers"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "Btn1L2LMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlyoutProjectGuardians"
	}
	// Freiheit Servers
	"BtnFreiheitServers"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "Btn1L2LMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlyoutProjectFreiheit"
	}
	// Carnival Servers
	"BtnCarnivalServers"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "Btn1L2LMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlyoutProjectCarnival"
	}
	// ClassicCut Servers
	"BtnClassicCutServers"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "Btn1L2LMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlyoutProjectClassicCut"
	}
	"BtnVIPMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnVIPMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmVIPMutationsFlyout"
	}
	"BtnViralMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnViralMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmViralMutationsFlyout"
	}
	"BtnM60Mutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnM60Mutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmM60MutationsFlyout"
	}
	"BtnDeathThrowsMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnDeathThrowsMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmDeathThrowsMutationsFlyout"
	}
	"BtnUncommonMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnUncommonMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmUncommonMutationsFlyout"
	}
	"BtnAntiSpecialSquadMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnAntiSpecialSquadMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmAntiSpecialSquadMutationsFlyout"
	}
	"BtnDeathClockMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnDeathClockMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmDeathClockMutationsFlyout"
	}
	"BtnGunGame2Mutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnGunGame2Mutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmGunGame2MutationsFlyout"
	}
	"BtnGunGameMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnGunGameMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmGunGameMutationsFlyout"
	}
	"BtnVersusTrainingMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnVersusTrainingMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmVersusTrainingMutationsFlyout"
	}
	"BtnVersusMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnVersusMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmVersusMutationsFlyout"
	}
	"BtnVersusMutations1"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnVersusMutations1"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmVersusMutations1Flyout"
	}
	"BtnSurvivalMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnSurvivalMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmSurvivalMutationsFlyout"
	}
	"BtnScavengeMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnScavengeMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmScavengeMutationsFlyout"
	}
	"BtnClassicMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnClassicMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmClassicMutationsFlyout"
	}
	"BtnRealismMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnRealismMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmRealismMutationsFlyout"
	}
	"BtnSoloMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnSoloMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmSoloMutationsFlyout"
	}
	"Btn2PMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "Btn2PMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "Flm2PMutationsFlyout"
	}
	"BtnZSLWeekly"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnZSLWeekly"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmZSLWeeklyFlyout"
	}
	"BtnZSLSurvival"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnZSLSurvival"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmZSLSurvivalFlyout"
	}
	"BtnGuestMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnGuestMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmGuestMutationsFlyout"
	}
	"BtnGuestCampaignMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnGuestCampaignMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmGuestCampaignMutationsFlyout"
	}
	"BtnGuestClassicMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnGuestClassicMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmGuestClassicMutationsFlyout"
	}
	"BtnGuestRealismMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnGuestRealismMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmGuestRealismMutationsFlyout"
	}
	"BtnGuestScavengeMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnGuestScavengeMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmGuestScavengeMutationsFlyout"
	}
	"BtnGuestSoloMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnGuestSoloMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmGuestSoloMutationsFlyout"
	}
	"BtnGuest2PMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnGuest2PMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmGuest2PMutationsFlyout"
	}
	"BtnGuestSurvivalMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnGuestSurvivalMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmGuestSurvivalMutationsFlyout"
	}
	"BtnGuestVersusMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnGuestVersusMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmGuestVersusMutationsFlyout"
	}
	"BtnGuestUncommonMutations"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "BtnGuestUncommonMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlmGuestUncommonMutationsFlyout"
	}
	//Rayman End
	//Urik start
	"BtnCreditsUrik"
	{
		"ControlName"				"L4D360HybridButton"
		"FieldName"				"BtnCreditsUrik"
		"xpos"					"c-200"
		"ypos"					"120"
		"wide"					"0"
		"tall"					"20"
		"visible"				"0"
		"enabled"				"1"
		"labeltext"				""
		"tooltiptext"				""
		"style"					"MainMenuButton"
		"command"				"FlmCreditsUrik"
	}
	"BtnReloadfont_FAQ"
	{
		"ControlName"				"L4D360HybridButton"
		"FieldName"				"BtnReloadfont_FAQ"
		"xpos"					"219"//flyoutsurik xpos.
		"ypos"					"160"//flyoutsurik ypos
		"wide"					"0"//flyouts width
		"tall"					"20"
		"visible"				"0"
		"enabled"				"1"
		"labeltext"				""
		"tooltiptext"				""
		"style"					"MainMenuButton"
		"command"				"FlmReloadfont_FAQ"
	}
	"BtnXMAS_Quit"
	{
		"ControlName"			"L4D360HybridButton"
		"FieldName"				"BtnXMAS_Quit"
		"xpos"					"c-200"
		"ypos"					"120"
		"wide"					"0"
		"tall"					"20"
		"visible"				"0"
		"enabled"				"1"
		"labeltext"				""
		"tooltiptext"			""
		"style"					"MainMenuButton"
		"command"				"FlmXMAS_Quit"
	}
	// Custom Buttons End
	
	"BtnChangeGamers"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnChangeGamers"
		"xpos"					"c-356"	[$WIN32WIDE]
		"xpos"					"50"	[!$WIN32WIDE]
		"ypos"					"255"
		"wide"					"180"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"0"
		"enabled"				"0"
		"tabPosition"			"0"
		"navUp"					"BtnGameModes"
		"navDown"				"BtnToggleConsole"
		"labelText"				"#L4D360UI_MainMenu_SignIn"
		"tooltiptext"			"#L4D360UI_MainMenu_ChangeGamers_Tip"
		"style"					"MainMenuButton"
		"command"				"ChangeGamers"
		"ActivationType"		"1"
	}
	
	"IconConsole"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"IconConsole"
		"xpos"					"c-379"	[$WIN32WIDE]
		"xpos"					"27"	[!$WIN32WIDE]
		"ypos"					"208"
		"wide"					"14"
		"tall"					"14"
		"scaleImage"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"image"					"icon_console"
		"frame"					"0"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
		"scaleImage"			"1"
	}
	
	"BtnToggleConsole"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnToggleConsole"
		"xpos"					"c-356"	[$WIN32WIDE]
		"xpos"					"50"	[!$WIN32WIDE]
		"ypos"					"205"	
		"wide"					"140" [$RUSSIAN]
		"wide"					"160" [$ENGLISH || $GERMAN]
		"wide"					"210" [!$ENGLISH && !$GERMAN && !$RUSSIAN && !$FRENCH && !$JAPANESE && !$KOREAN && !$SCHINESE && !$TCHINESE && !$PORTUGUESE]
		"wide"					"190" [$FRENCH || $PORTUGUESE || $JAPANESE || $KOREAN || $SCHINESE || $TCHINESE]
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"BtnChangeGamers"
		"navDown"				"BtnSearchGames"
		"labeltext"				"CONSOLE"	
		"tooltiptext"			""
		"style"					"MainMenuButton"
		"command"				"#toggleconsole"
		"ActivationType"		"1"
		"allcaps"				"1" // urik- to ensure caps'd letters
	}
	
	"IconSearchGames"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"IconSearchGames"
		"xpos"					"c-379"	[$WIN32WIDE]
		"xpos"					"27"	[!$WIN32WIDE]
		"ypos"					"228"
		"wide"					"14"
		"tall"					"14"
		"scaleImage"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"image"					"icon_dice"
		"frame"					"0"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
		"scaleImage"			"1"
	}
	
	"BtnSearchGames"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnSearchGames"
		"xpos"					"c-356"	[$WIN32WIDE]
		"xpos"					"50"	[!$WIN32WIDE]
		"ypos"					"225"	
		"wide"					"140" [$RUSSIAN]
		"wide"					"160" [$ENGLISH || $GERMAN]
		"wide"					"210" [!$ENGLISH && !$GERMAN && !$RUSSIAN && !$FRENCH && !$JAPANESE && !$KOREAN && !$SCHINESE && !$TCHINESE && !$PORTUGUESE]
		"wide"					"190" [$FRENCH || $PORTUGUESE || $JAPANESE || $KOREAN || $SCHINESE || $TCHINESE]
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"BtnToggleConsole"
		"navDown"				"BtnAddons"
		"labeltext"				"#L4D360UI_LiveMatchChooser"	
		"tooltiptext"			""
		"style"					"MainMenuButton"
		"command"				"FlmSearchGamesFlyout"
		"ActivationType"		"1"
		"allcaps"				"1" // urik- to ensure caps'd letters
	}
	
	"IconAddonsUrik"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"IconAddonsUrik"
		"xpos"					"c-379"	[$WIN32WIDE]
		"xpos"					"27"	[!$WIN32WIDE]
		"ypos"					"248"
		"wide"					"14"
		"tall"					"14"
		"scaleImage"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"image"					"icon_addons"
		"frame"					"0"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
	}
	"IconAddonsUrikGlow" [$x360lodef]//classic
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"IconAddonsUrikGlow"
		"xpos"					"c-379"	[$WIN32WIDE]
		"xpos"					"27"	[!$WIN32WIDE]
		"ypos"					"248"
		"wide"					"14"
		"tall"					"14"
		"scaleImage"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"image"					"icon_addons_glow"
		"frame"					"0"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
	}
	
	"IconAddons"
	{
		"visible"				"0"
		"enabled"				"0"
	}
	
	"BtnAddons"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnAddons"
		"xpos"					"c-356"	[$WIN32WIDE]
		"xpos"					"50"	[!$WIN32WIDE]
		"ypos"					"245"
		"wide"					"140" [$ENGLISH || $RUSSIAN || $JAPANESE || $KOREAN || $SCHINESE || $TCHINESE || $ITALIAN]
		"wide"					"230" [!$RUSSIAN && !$ENGLISH && !$JAPANESE && !$KOREAN && !$SCHINESE && !$TCHINESE && !$GERMAN && !$ITALIAN]
		"wide"					"170" [$GERMAN]
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"BtnSearchGames"
		"navDown"				"BtnStatsAndAchievements"
		"tooltiptext"			"#L4D360UI_Extras_Addons_Tip"
		"labelText"				"Дополнения"  [$RUSSIAN]
		"labelText"				"#L4D360UI_Extras_Addons"  [!$RUSSIAN]
		"style"					"MainMenuButton"
		"command"				"Addons"
		"ActivationType"		"1"
		"allcaps"			"1" // urik- to ensure caps'd letters
	}	
	
	"IconAchievements"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"IconAchievements"
		"xpos"					"c-379"	[$WIN32WIDE]
		"xpos"					"27"	[!$WIN32WIDE]
		"ypos"					"268"
		"wide"					"14"
		"tall"					"14"
		"scaleImage"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"image"					"icon_achievements"
		"frame"					"0"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
		"scaleImage"			"1"
	}
	"IconAchievementsGlow" [$x360lodef]//classic
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"IconAchievementsGlow"
		"xpos"					"c-378"	[$WIN32WIDE]
		"xpos"					"28"	[!$WIN32WIDE]
		"ypos"					"266"
		"wide"					"14"
		"tall"					"7"
		"scaleImage"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"image"					"icon_achievements_glow"
		"frame"					"0"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
		"scaleImage"			"1"
	}
	
	"BtnStatsAndAchievements"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnStatsAndAchievements"
		"xpos"					"c-356"	[$WIN32WIDE]
		"xpos"					"50"	[!$WIN32WIDE]
		"ypos"					"265"
		"wide"					"176" [$ENGLISH || $RUSSIAN || $JAPANESE || $KOREAN || $SCHINESE || $TCHINESE || $ITALIAN]
		"wide"					"230" [!$RUSSIAN && !$ENGLISH && !$JAPANESE && !$KOREAN && !$SCHINESE && !$TCHINESE && !$GERMAN && !$ITALIAN]
		"wide"					"170" [$GERMAN]
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"BtnAddons"
		"navDown"				"BtnOptions"
		"labelText"				"#L4D360UI_MainMenu_StatsAndAchievements"
		"tooltiptext"			"#L4D360UI_MainMenu_PCStatsAndAchievements_Tip"
		"style"					"MainMenuButton"
		"command"				"StatsAndAchievements"
		"ActivationType"		"1"
	}
	
	"IconOptions"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"IconOptions"
		"xpos"					"c-379"	[$WIN32WIDE]
		"xpos"					"27"	[!$WIN32WIDE]
		"ypos"					"288"
		"wide"					"14"
		"tall"					"14"
		"scaleImage"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"image"					"icon_options"
		"frame"					"0"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
		"scaleImage"			"1"
	}
	"BtnOptions"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnOptions"
		"xpos"					"c-356"	[$WIN32WIDE]
		"xpos"					"50"	[!$WIN32WIDE]
		"ypos"					"285"
		"wide"					"140" [$ENGLISH || $JAPANESE || $KOREAN || $SCHINESE || $TCHINESE || $ITALIAN]
		"wide"					"144" [$RUSSIAN]
		"wide"					"170" [!$RUSSIAN && !$ENGLISH && !$JAPANESE && !$KOREAN && !$SCHINESE && !$TCHINESE && !$GERMAN && !$ITALIAN && !$FRENCH]
		"wide"					"190" [$FRENCH]
		"wide"					"170" [$GERMAN]
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"BtnStatsAndAchievements"
		"navDown"				"BtnExtras"
		"labelText"				"#L4D360UI_MainMenu_Options"
		"tooltiptext"			"#L4D360UI_MainMenu_Options_Tip"
		"style"					"MainMenuButton"
		"command"				"FlmOptionsFlyout"
		"ActivationType"		"1"
	}
	"IconExtras"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"IconExtras"
		"xpos"					"c-379"	[$WIN32WIDE]
		"xpos"					"27"	[!$WIN32WIDE]
		"ypos"					"308"
		"wide"					"14"
		"tall"					"14"
		"scaleImage"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"image"					"icon_extras"
		"frame"					"0"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
		"scaleImage"			"1"
	}
	
	"BtnExtras"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnExtras"
		"xpos"					"c-356"	[$WIN32WIDE]
		"xpos"					"50"	[!$WIN32WIDE]
		"ypos"					"305"
		"wide"					"140" [$ENGLISH || $JAPANESE || $KOREAN || $SCHINESE || $TCHINESE || $ITALIAN]
		"wide"					"144" [$RUSSIAN]
		"wide"					"170" [!$RUSSIAN && !$ENGLISH && !$JAPANESE && !$KOREAN && !$SCHINESE && !$TCHINESE && !$GERMAN && !$ITALIAN && !$FRENCH]
		"wide"					"190" [$FRENCH]
		"wide"					"170" [$GERMAN]
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"BtnOptions"
		"navDown"				"BtnQuit"
		"labelText"				"#L4D360UI_MainMenu_Extras"
		"tooltiptext"				"#L4D360UI_MainMenu_Extras_Tip"
		"style"					"MainMenuButton"
		"command"				"FlmExtrasFlyoutCheck"
		"ActivationType"		"1"
	}
	"IconBlogPost"
	{
		"visible"				"0"
		"enabled"				"0"
	}
	"BtnBlogPost"
	{
		"visible"				"0"
		"enabled"				"0"
	}
	"IconQuit"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"IconQuit"
		"xpos"					"c-379"	[$WIN32WIDE]
		"xpos"					"27"	[!$WIN32WIDE]
		"ypos"					"328"
		"wide"					"14"
		"tall"					"14"
		"scaleImage"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"image"					"icon_exit"
		"frame"					"0"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
		"scaleImage"			"1"
	}
	"IconQuitGlow" [$x360lodef]//classic
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"IconQuitGlow"
		"xpos"					"c-379"	[$WIN32WIDE]
		"xpos"					"27"	[!$WIN32WIDE]
		"ypos"					"328"
		"wide"					"14"
		"tall"					"14"
		"scaleImage"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"image"					"icon_exit_glow"
		"frame"					"0"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
		"scaleImage"			"1"
	}
	"BtnQuit"
	{
		"ControlName"			"Button" [$x360lodef]//xmas
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnQuit"
		"xpos"					"c-359"	[$x360lodef]//xmas
		"xpos"					"c-356"	[$WIN32WIDE]
		"xpos"					"47"	[$x360lodef]//xmas
		"xpos"					"50"
		"ypos"					"325"
		"wide"					"140" [$ENGLISH || $RUSSIAN || $JAPANESE || $KOREAN || $SCHINESE || $TCHINESE || $ITALIAN]
		"wide"					"230" [!$RUSSIAN && !$ENGLISH && !$JAPANESE && !$KOREAN && !$SCHINESE && !$TCHINESE && !$GERMAN && !$ITALIAN]
		"wide"					"170" [$GERMAN]
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"BtnExtras"
		"navDown"				"PnlQuickJoin"
		"labelText"				"#L4D360UI_MainMenu_Quit"
		"tooltiptext"			"#L4D360UI_MainMenu_Quit_Tip"
		"font"					"MainBold" [$x360lodef]//xmas
		"style"					"Button" [$x360lodef]//xmas
		"style"					"MainMenuButton"
		"paintborder"			"0" [$x360lodef]//xmas
		"defaultBgColor_override"	"0 0 0 0" [$x360lodef]//xmas
		"armedBgColor_override"		"0 0 0 0" [$x360lodef]//xmas
 		"depressedBgColor_override"	"0 0 0 0" [$x360lodef]//xmas
		"command"				"FlmXMAS_Quit" [$x360lodef]//xmas
		"command"				"QuitGame"
		"ActivationType"		"1"
	}
	
	"FlmQuickMatchFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmQuickMatchFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnOfficialOnly"
		"ResourceFile"			"resource/UI/L4D360UI/QuickMatchFlyout.res"
	}
	
	"FlmCampaignFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmCampaignFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnQuickMatch"
		"ResourceFile"			"resource/UI/L4D360UI/CampaignFlyout.res"
	}
	
	"FlmRealismFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmRealismFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnQuickMatch"
		"ResourceFile"			"resource/UI/L4D360UI/RealismFlyout.res"
	}
	
	"FlmSurvivalFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmSurvivalFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnQuickMatch"
		"ResourceFile"			"resource/UI/L4D360UI/SurvivalFlyout.res"
	}
	
	"FlmScavengeFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmScavengeFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnQuickMatch"
		"ResourceFile"			"resource/UI/L4D360UI/ScavengeFlyout.res"
	}
	
	"FlmVersusFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmVersusFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnQuickMatch"
		"ResourceFile"			"resource/UI/L4D360UI/VersusFlyout.res"
	}
	
	"FlmRealismVersusFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmRealismVersusFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnQuickMatch"
		"ResourceFile"			"resource/UI/L4D360UI/RealismVersusFlyout.res"
	}
	
	"FlmVersusSurvivalFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmVersusSurvivalFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnQuickMatch"
		"ResourceFile"			"resource/UI/L4D360UI/VersusSurvivalFlyout.res"
	}
	
	"FlmMutationCategories"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmMutationCategories"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnQuickMatch"
		"ResourceFile"			"resource/UI/L4D360UI/MutationCategoriesFlyout.res"
	}
	
	"FlmMutationSolo"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmMutationSolo"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnQuickMatch"
		"ResourceFile"			"resource/UI/L4D360UI/MutationSoloFlyout.res"
	}
	
	"FlmMutationCoop"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmMutationCoop"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnQuickMatch"
		"ResourceFile"			"resource/UI/L4D360UI/MutationCoopFlyout.res"
	}
	
	"FlmMutationVersus"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmMutationVersus"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnQuickMatch"
		"ResourceFile"			"resource/UI/L4D360UI/MutationVersusFlyout.res"
	}
	
	"FlmChallengeFlyout1"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmChallengeFlyout1"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnStartGame"
		"ResourceFile"			"resource/UI/L4D360UI/mainmenu_flyout_challenge1.res"
	}
	
	"FlmChallengeFlyout4"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmChallengeFlyout4"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnQuickMatch"
		"ResourceFile"			"resource/UI/L4D360UI/mainmenu_flyout_challenge4.res"
	}
	
	"FlmChallengeFlyout8"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmChallengeFlyout8"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnQuickMatch"
		"ResourceFile"			"resource/UI/L4D360UI/mainmenu_flyout_challenge8.res"
	}
	
	// Rayman start
	"FlmCusMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmCusMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnMutationList1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/CustomMutationsFlyout.res"
	}
	
	"FlmCustomMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmCustomMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/CustomMutationsFlyout.res"
	}
	
	"FlmSVSMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmSVSMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/SVSMutationsFlyout.res"
	}
	
	"FlmCustomMutations0Flyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmCustomMutations0Flyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnMutationList1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/CustomMutations0Flyout.res"
	}
	
	"FlmCustomMutations1Flyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmCustomMutations1Flyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/CustomMutations1Flyout.res"
	}
	
	"FlmCampaignMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmCampaignMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnMutationList1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/CampaignMutationsFlyout.res"
	}
	
	"FlmCampaignMutations1Flyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmCampaignMutations1Flyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/CampaignMutations1Flyout.res"
	}

	//"FlmCampaignMutations1FlyoutGuardian"
	//{
	//	"ControlName"			"FlyoutMenu"
	//	"fieldName"				"FlmCampaignMutations1FlyoutGuardian"
	//	"visible"				"0"
	//	"wide"					"0"
	//	"tall"					"0"
	//	"zpos"					"3"
	//	"InitialFocus"			"BtnPlayMutation1"
	//	"ResourceFile"			"resource/UI/L4D360UI/guardian_servers.res"
	//}
	
	"FlmCampaignMutations2Flyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmCampaignMutations2Flyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/CampaignMutations2Flyout.res"
	}
	
	"FlmCampaignMutations3Flyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmCampaignMutations3Flyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/CampaignMutations3Flyout.res"
	}
	
	"FlmParasiteMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmParasiteMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/ParasiteMutationsFlyout.res"
	}
	
	"Flm1L2LMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"Flm1L2LMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/1L2LMutationsFlyout.res"
	}

	// Внимание! перед добавлением своих серверов и своей разметке не зубдь инициализировать название своего хука! fieldName
	"Flm1L2LMutationsFlyoutTest"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"Flm1L2LMutationsFlyoutTest"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Project/guardians.res"
	}

	// Guardians Servers 
	"FlyoutProjectGuardians"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlyoutProjectGuardians"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Project/guardians.res"
	}
	
	// Freiheit Servers
	"FlyoutProjectFreiheit"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlyoutProjectFreiheit"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Project/freiheit.res"
	}

	// Carnival Servers
	"FlyoutProjectCarnival"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlyoutProjectCarnival"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Project/carnival.res"
	}

	// ClassicCut Servers
	"FlyoutProjectClassicCut"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlyoutProjectClassicCut"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Project/classiccut.res"
	}
	
	"FlmVIPMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmVIPMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/VIPMutationsFlyout.res"
	}
	
	"FlmViralMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmViralMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/ViralMutationsFlyout.res"
	}
	
	"FlmM60MutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmM60MutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/M60MutationsFlyout.res"
	}
	
	"FlmDeathThrowsMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmDeathThrowsMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/DeathThrowsMutationsFlyout.res"
	}
	
	"FlmUncommonMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmUncommonMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/UncommonMutationsFlyout.res"
	}
	
	"FlmAntiSpecialSquadMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmAntiSpecialSquadMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/AntiSpecialSquadMutationsFlyout.res"
	}
	
	"FlmDeathClockMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmDeathClockMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/DeathClockMutationsFlyout.res"
	}
	
	"FlmGunGame2MutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmGunGame2MutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/GunGame2MutationsFlyout.res"
	}
	
	"FlmGunGameMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmGunGameMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/GunGameMutationsFlyout.res"
	}
	
	"FlmSurvivalMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmSurvivalMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/SurvivalMutationsFlyout.res"
	}
	
	"FlmScavengeMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmScavengeMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/ScavengeMutationsFlyout.res"
	}
	
	"FlmVersusTrainingMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmVersusTrainingMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/VersusTrainingMutationsFlyout.res"
	}
	
	//"FlmVersusMutationsFlyout"
	//{
	//	"ControlName"			"FlyoutMenu"
	//	"fieldName"				"FlmVersusMutationsFlyout"
	//	"visible"				"0"
	//	"wide"					"0"
	//	"tall"					"0"
	//	"zpos"					"3"
	//	"InitialFocus"			"BtnMutationList1"
	//	"ResourceFile"			"resource/UI/L4D360UI/Mutations/VersusMutationsFlyout.res"
	//}
	
	// подкинул разметку для списка проектов
	"FlmVersusMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmVersusMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnMutationList1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/Versusmutationsflyout.res"
	}
	// если вдруг сервер будет больше и они не вместятся на 1 страницу то создадим вторую разметку и повесим на кнопку переключения их
	"FlmVersusMutations1Flyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmVersusMutations1Flyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/VersusMutations1Flyout.res"
	}
	
	"FlmClassicMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmClassicMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/ClassicMutationsFlyout.res"
	}
	
	"FlmRealismMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmRealismMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/RealismMutationsFlyout.res"
	}
	
	"FlmSoloMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmSoloMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlaySoloMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/SoloMutationsFlyout.res"
	}
	
	"Flm2PMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"Flm2PMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/2PMutationsFlyout.res"
	}
	
	"FlmZSLFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmZSLFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnMutationList1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/ZSLFlyout.res"
	}
	
	"FlmZSLWeeklyFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmZSLWeeklyFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/ZSLWeeklyFlyout.res"
	}
	
	"FlmZSLSurvivalFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmZSLSurvivalFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/ZSLSurvivalFlyout.res"
	}
	
	"FlmGuestMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmGuestMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnMutationList1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/GuestMutationsFlyout.res"
	}
	
	"FlmGuestCampaignMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmGuestCampaignMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/GuestCampaignMutationsFlyout.res"
	}
	
	"FlmGuestClassicMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmGuestClassicMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/GuestClassicMutationsFlyout.res"
	}
	
	"FlmGuestRealismMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmGuestRealismMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/GuestRealismMutationsFlyout.res"
	}
	
	"FlmGuestScavengeMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmGuestScavengeMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/GuestScavengeMutationsFlyout.res"
	}
	
	"FlmGuestSoloMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmGuestSoloMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/GuestSoloMutationsFlyout.res"
	}
	
	"FlmGuest2PMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmGuest2PMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/Guest2PMutationsFlyout.res"
	}
	
	"FlmGuestSurvivalMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmGuestSurvivalMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/GuestSurvivalMutationsFlyout.res"
	}
	
	"FlmGuestVersusMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmGuestVersusMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/GuestVersusMutationsFlyout.res"
	}
	
	"FlmGuestUncommonMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmGuestUncommonMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/GuestUncommonMutationsFlyout.res"
	}
	// Rayman end
	// Urik start
	
	"FlmCreditsUrik"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmCreditsUrik"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			""
		"ResourceFile"			"resource/UI/L4D360UI/urikgamemenu/CreditsUrik.res"
	}
	
	"FlmReloadFont_FAQ"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmReloadFont_FAQ"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			""
		"ResourceFile"			"resource/UI/L4D360UI/urikgamemenu/reloadfont_faq.res"
	}
	
	"FlmSearchGamesFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmSearchGamesFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnGameBrowser"
		"ResourceFile"			"resource/UI/L4D360UI/urikgamemenu/SearchGamesFlyout.res"
	}
	
	"FlmXMAS_Quit"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmXMAS_Quit"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			""
		"ResourceFile"			"resource/UI/L4D360UI/urikgamemenu/XMAS_Quit.res"
	}
	// Custom flyouts end
	
	"FlmOptionsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmOptionsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnVideo"
		"ResourceFile"			"resource/UI/L4D360UI/OptionsFlyout.res"
	}
	
	"FlmOptionsGuestFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmOptionsGuestFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnAudioVideo"
		"ResourceFile"			"resource/UI/L4D360UI/OptionsGuestFlyout.res"
	}
	
	"FlmExtrasFlyout_Simple"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmExtrasFlyout_Simple"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"DemoUI"
		"ResourceFile"			"resource/UI/L4D360UI/urikgamemenu/ExtrasFlyout.res"
	}
	
	"FlmExtrasFlyout_Live"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmExtrasFlyout_Live"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnCommunity"
		"ResourceFile"			"resource/UI/L4D360UI/ExtrasFlyoutLive.res"
	}
	
	"PnlQuickJoin"
	{
		"ControlName"			"QuickJoinPanel"
		"fieldName"				"PnlQuickJoin"
		"ResourceFile"			"resource/UI/L4D360UI/QuickJoin.res"
		"visible"				"0"
		"wide"					"240"
		"tall"					"300"
		"xpos"					"c-380"	[$WIN32WIDE]
		"xpos"					"30"	[!$WIN32WIDE]
		"ypos"					"r75"
		"navUp"					"BtnQuit"
		"navDown"				"PnlQuickJoinGroups"
	}
	"PnlQuickJoinGroups"
	{
		"ControlName"			"QuickJoinGroupsPanel"
		"fieldName"				"PnlQuickJoinGroups"
		"ResourceFile"			"resource/UI/L4D360UI/QuickJoinGroups.res"
		"visible"				"0"
		"wide"					"500"
		"tall"					"300"
		"xpos"					"c90"	[$WIN32WIDE]
		"xpos"					"c0"	[!$WIN32WIDE]
		"ypos"					"r75"
		"navUp"					"PnlQuickJoin"
		"navDown"				"BtnGameModes"
	}
}
