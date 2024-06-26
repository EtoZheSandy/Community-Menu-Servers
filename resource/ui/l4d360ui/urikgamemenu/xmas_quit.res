"Resource/UI/Xmas_quit.res"
{
	"PnlBackground"
	{
		"ControlName"				"Panel"
		"fieldName"				"PnlBackground"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"-1"
		"wide"					"400"
		"tall"					"400"
		"visible"				"1"
		"enabled"				"1"
		"paintbackground"		"1"
		"paintborder"			"0"
	}
	
	"PnlBackground1"
	{
		"ControlName"			"Panel"
		"fieldName"				"PnlBackground1"
		"xpos"					"0"
		"ypos"					"0"
		"wide"					"400"
		"tall"					"400"
		"visible"				"1"
		"enabled"				"1"
		"bgcolor_override"	"20 20 20 255"
		"PaintBackground"	"1"
		// "PaintBackground"	"1"
		// "paintborder"			"0"
		"zpos"					"50"
	}
	
	"bell"
	{
		"ControlName"	"ImagePanel"
		"fieldname"		"bell"
		"xpos"			"320"
		"ypos"			"6"
		"wide"			"65"
		"tall"			"65"
		"zpos"			"53"
		"visible"					"0" [$x360lodef]//newyear
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			"urikgamemenu_xmas/xmas_bell"
		//"drawcolor"	"255 255 255 255"
	}	
	
	"bell_button"
	{
		"ControlName"				"Button"
		"fieldName"					"bell_button"
		"xpos"						"320"
		"ypos"						"6"
		"wide"						"66"
		"tall"						"66"
		"zpos"						"54"
		"visible"					"0" [$x360lodef]//newyear
		"visible"					"1"
		"enabled"					"1"
		"tabPosition"				"0"
		"navUp"						""
		"navDown"					""
		"labelText"					""
		"tooltiptext"				""
		"textalignment"				"west"
		"font"						"MainBold"
		"allcaps"					"0"
		"style"						"Button"
		"ActivationType"			"1"
		"paintborder"				"0"
		"defaultBgColor_override"	"20 20 20 255"
		"armedBgColor_override"		"0 0 0 0"
		"depressedBgColor_override"	"0 0 0 0"
		"sound_armed"				""
		"sound_depressed"			"level\bell_normal.wav"
		//"sound_depressed"			"player\footsteps\clown/concrete1.wav"
		"sound_released"			""
		"command"					""
	}	
	
	"fireworks" [$x360lodef]//newyear
	{
		"ControlName"	"ImagePanel"
		"fieldname"		"fireworks"
		"xpos"			"2"
		"ypos"			"36"
		"wide"			"156"
		"tall"			"180"
		"zpos"			"53"
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			"urikgamemenu_xmas/fireworks"//1:1.156
		//"drawcolor"	"255 255 255 255"
	}
	
	"fireworks_button" [$x360lodef]//newyear
	{
		"ControlName"				"Button"
		"fieldName"					"fireworks_button"
		"xpos"						"2"
		"ypos"						"46"
		"wide"						"156"
		"tall"						"180"
		"zpos"						"54"
		"visible"					"1"
		"enabled"					"1"
		"tabPosition"				"0"
		"navUp"						""
		"navDown"					""
		"labelText"					""
		"tooltiptext"				""
		"textalignment"				"west"
		"font"						"MainBold"
		"allcaps"					"0"
		"style"						"Button"
		"ActivationType"			"1"
		"paintborder"				"0"
		"defaultBgColor_override"	"20 20 20 255"
		"armedBgColor_override"		"0 0 0 0"
		"depressedBgColor_override"	"0 0 0 0"
		"sound_armed"				""
		//"sound_depressed"			"level\bell_normal.wav"
		"sound_depressed"			"ambient\atmosphere\firewerks_launch_03.wav"
		"sound_released"			""
		"command"					""
	}
	
	"fireworks2" [$x360lodef]//newyear
	{
		"ControlName"	"ImagePanel"
		"fieldname"		"fireworks2"
		"xpos"			"222"
		"ypos"			"2"
		"wide"			"156"
		"tall"			"180"
		"zpos"			"53"
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			"urikgamemenu_xmas/fireworks"//1:1.156
		//"drawcolor"	"255 255 255 255"
	}	
	
	"fireworks2_button" [$x360lodef]//newyear
	{
		"ControlName"				"Button"
		"fieldName"					"fireworks2_button"
		"xpos"						"222"
		"ypos"						"2"
		"wide"						"156"
		"tall"						"180"
		"zpos"						"54"
		"visible"					"1"
		"enabled"					"1"
		"tabPosition"				"0"
		"navUp"						""
		"navDown"					""
		"labelText"					""
		"tooltiptext"				""
		"textalignment"				"west"
		"font"						"MainBold"
		"allcaps"					"0"
		"style"						"Button"
		"ActivationType"			"1"
		"paintborder"				"0"
		"defaultBgColor_override"	"20 20 20 255"
		"armedBgColor_override"		"0 0 0 0"
		"depressedBgColor_override"	"0 0 0 0"
		"sound_armed"				""
		//"sound_depressed"			"level\bell_normal.wav"
		"sound_depressed"			"ambient\atmosphere\firewerks_launch_04.wav"
		"sound_released"			""
		"command"					""
	}	
	
	"snowman"
	{
		"ControlName"	"ImagePanel"
		"fieldname"		"snowman"
		"xpos"						"10"
		"ypos"						"6"
		"wide"						"100"
		"tall"						"118"
		"zpos"			"53"
		"visible"		"0" [$x360lodef]//newyear
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			"urikgamemenu_xmas/snowman"
		//"drawcolor"	"255 255 255 255"
	}
	
	"snowman_button"
	{
		"ControlName"				"Button"
		"fieldName"					"snowman_button"
		"xpos"						"2" [$x360lodef]//newyear
		"xpos"						"10"
		"ypos"						"6"
		"wide"						"100"
		"tall"						"120"
		"zpos"						"54"
		"visible"					"0" [$x360lodef]//newyear
		"visible"					"1"
		"enabled"					"1"
		"tabPosition"				"0"
		"navUp"						""
		"navDown"					""
		"labelText"					""
		"tooltiptext"				""
		"textalignment"				"west"
		"font"						"MainBold"
		"allcaps"					"0"
		"style"						"Button"
		"ActivationType"			"1"
		"paintborder"				"0"
		"defaultBgColor_override"	"20 20 20 255"
		"armedBgColor_override"		"0 0 0 0"
		"depressedBgColor_override"	"0 0 0 0"
		"sound_armed"				""
		//"sound_depressed"			"level\bell_normal.wav"
		"sound_depressed"			"player\footsteps\clown/concrete1.wav"
		"sound_released"			""
		"command"					""
	}
	
	"santa"
	{
		"ControlName"	"ImagePanel"
		"fieldname"		"santa"
		"xpos"			"166"
		"ypos"			"110"
		"wide"			"88"
		"tall"			"88"
		"zpos"			"53"
		"visible"		"0" [$x360lodef]//newyear
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			"urikgamemenu_xmas/santagabe"
		//"drawcolor"	"255 255 255 255"
	}	
	"santa_button"
	{
		"ControlName"				"Button"
		"fieldName"					"santa_button"
		"xpos"						"164"
		"ypos"						"180"
		"wide"						"78"
		"tall"						"87"
		"zpos"						"54"
		"visible"					"0" [$x360lodef]//newyear
		"visible"					"1"
		"enabled"					"1"
		"tabPosition"				"0"
		"navUp"						""
		"navDown"					""
		"labelText"					""
		"tooltiptext"				""
		"textalignment"				"west"
		"font"						"MainBold"
		"allcaps"					"0"
		"style"						"Button"
		"ActivationType"			"1"
		"paintborder"				"0"
		"defaultBgColor_override"	"20 20 20 255"
		"armedBgColor_override"		"0 0 0 0"
		"depressedBgColor_override"	"0 0 0 0"
		"sound_armed"				""
		//"sound_depressed"			"level\bell_normal.wav"
		"sound_depressed"			"player\survivor\voice\coach/laughter01.wav"
		"sound_released"			""
		"command"					""
	}	

	"XmasImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"XmasImage"
		"xpos"				"60"
		"ypos"				"10"
		"wide"				"270"
		"tall"				"200"		
		"autoResize"		"0"
		"pinCorner"			"0"
		"visible"			"0" [$x360lodef]//newyear
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"scaleimage"		"1"
		"image"			"urikgamemenu_xmas/merry_xmas"
		"zpos"				"55"
	}
	
	"NewYearImage" [$x360lodef]//newyear
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"NewYearImage"
		"xpos"				"90"
		"ypos"				"4"
		"wide"				"220"
		"tall"				"220"		
		"autoResize"		"0"
		"pinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"scaleimage"		"1"
		"image"			"urikgamemenu_xmas/happynewyear3"
		"zpos"				"55"
	}	

	"quit?"
	{
		"ControlName"		"Label"
		"fieldName"		"quit?"
		"xpos"			"4"
		"ypos"			"230"
		"wide"			"392"
		"tall"			"12"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"centerwrap"		"1"
		"textAlignment"			"center"
		"Font"					"DefaultVerySmall"
		"tabPosition"	"0"
		"labelText"				"Выйти из игры???" [$RUSSIAN]
		"labelText"				"Quit the game???" [!$RUSSIAN]
		"fgcolor_override"		"100 100 100 255"
		//"bgcolor_override"		"0 0 255 200"
		"zpos"					"52"
	}
	
	"BtnOK"	
	{
		"ControlName"				"Button"
		"fieldName"					"BtnOK"
		"xpos"						"28"
		"ypos"						"360"
		"wide"						"120"
		"tall"						"20"
		"labelText"					"#L4D2360_IntroMovie_39"
		"tooltiptext"				""
		"Font"						"BlogPostText"
		"centerwrap"				"1"
		"textalignment"				"center"
		"defaultBgColor_override"	"0 0 0 100"
		"armedBgColor_override"		"0 0 0 0"
 		"depressedBgColor_override"	"0 0 0 50"
		"paintborder"				"1"
		"sound_armed"				"ui/menu_focus.wav"
		"sound_depressed"			""//"player/survivor/voice/mechanic/EllisStoriesInterrupt05.wav"
		"sound_released"			""
		"command"					"#quit"
		"zpos"						"55"
	}	
	
	"BtnCancel"	
	{
		"ControlName"				"Button"
		"fieldName"					"BtnCancel"
		"xpos"						"260"
		"ypos"						"360"
		"wide"						"120"
		"tall"						"20"
		"labelText"					"#L4D2360_IntroMovie_35"
		"tooltiptext"				""
		"Font"						"BlogPostText"
		"centerwrap"				"1"
		"textalignment"				"center"
		"defaultBgColor_override"	"0 0 0 100"
		"armedBgColor_override"		"0 0 0 0"
 		"depressedBgColor_override"	"0 0 0 50"
		"paintborder"				"1"
		"sound_armed"				"ui/menu_focus.wav"
		"sound_depressed"			""	
		"sound_released"			"player\survivor\voice\coach/taunt04.wav" [$x360lodef]//newyear
		"sound_released"			"player/survivor/voice/mechanic/WorldC2M3B15.wav"
		"command"					"Back"
		"zpos"						"55"
	}
}