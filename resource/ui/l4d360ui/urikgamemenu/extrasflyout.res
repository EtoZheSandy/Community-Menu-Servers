"Resource/UI/ExtrasFlyout.res"
{
	"PnlBackground"
	{
		"ControlName"		"Panel"
		"fieldName"			"PnlBackground"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"-1"
		"wide"				"156" [$ENGLISH]
		"wide"				"236" [!$ENGLISH]
		"tall"				"150"
		"visible"			"1"
		"enabled"			"1"
		"paintbackground"	"1"
		"paintborder"		"1"
	}		
	//"DemoUI"
	//{
	//	"ControlName"			"L4D360HybridButton"
	//	"fieldName"				"DemoUI"
	//	"xpos"					"20"
	//	"ypos"					"0"
	//	"wide"					"150"
	//	"tall"					"20"
	//	"autoResize"			"1"
	//	"pinCorner"				"0"
	//	"visible"				"1"
	//	"enabled"				"1"
	//	"tabPosition"			"0"
	//	"wrap"					"1"		
	//	"navUp"					"BtnCommentary"
	//	"navDown"				"DemoUI2"
	//	"labelText"				"Demo Player"
	//	"tooltiptext"			""
	//	"disabled_tooltiptext"	""
	//	"style"					"SmallButton"
	//	"command"				"#demoui"
	//}
	
	"IconReloadscheme"
	{
		"ControlName"	"ImagePanel"
		"fieldname"		"IconReloadscheme"
		"xpos"			"7"
		"ypos"			"6"
		"wide"			"8"
		"tall"			"8"
		"zpos"			"0"
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			"icon_reloadfont"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
	}

	"Reloadscheme"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"Reloadscheme"
		"xpos"					"20"
		"ypos"					"5"
		"wide"					"120"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"wrap"					"1"		
		"navUp"					"UpdateAudioCache"
		"navDown"				"Reloadscheme_FAQ"
		"labelText"				"Reloadfont.cfg"
		"tooltiptext"			""
		"disabled_tooltiptext"	""
		"style"					"SmallButton"
		"command"				"#exec reloadfont.cfg"
	}
	"IconRebuildCache"
	{
		"ControlName"	"ImagePanel"
		"fieldname"		"IconRebuildCache"
		"xpos"			"7"
		"ypos"			"34"
		"wide"			"8"
		"tall"			"8"
		"zpos"			"0"
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			"icon_rebuildcache"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
	}
	"RebuildAudioCache"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"RebuildAudioCache"
		"xpos"					"20"
		"ypos"					"44"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"wrap"					"1"		
		"navUp"					"DemoUI2"
		"navDown"				"UpdateAudioCache"
		"labelText"				"Rebuild Audio Cache"
		"tooltiptext"			""
		"disabled_tooltiptext"	""
		"style"					"SmallButton"
		"command"				"#snd_rebuildaudiocache"
	}
	"IconUpdateCache"
	{
		"ControlName"	"ImagePanel"
		"fieldname"		"IconUpdateCache"
		"xpos"			"7"
		"ypos"			"48"
		"wide"			"8"
		"tall"			"8"
		"zpos"			"0"
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			"icon_updatecache"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
	}	
	"UpdateAudioCache"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"UpdateAudioCache"
		"xpos"					"20"
		"ypos"					"64"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"wrap"					"1"		
		"navUp"					"RebuildAudioCache"
		"navDown"				"Reloadscheme"
		"labelText"				"Update Audio Cache"
		"tooltiptext"			""
		"disabled_tooltiptext"	""
		"style"					"SmallButton"
		"command"				"#snd_updateaudiocache"
	}
	"BtnCredits"
	{
		"visible"				"0"
		"enabled"				"0"
	}
	//"Reloadscheme_FAQ"
	//{
	//	"ControlName"			"L4D360HybridButton"
	//	"fieldName"				"Reloadscheme_FAQ"
	//	"xpos"					"20"
	//	"ypos"					"120"
	//	"wide"					"120"
	//	"tall"					"20"
	//	"autoResize"			"1"
	//	"pinCorner"				"0"
	//	"visible"				"1"
	//	"enabled"				"1"
	//	"tabPosition"			"0"
	//	"wrap"					"1"		
	//	"navUp"					"Reloadscheme"
	//	"navDown"				"CreditsUrik"
	//	"labelText"				"Reloadfont FAQ"
	//	"tooltiptext"			""
	//	"disabled_tooltiptext"	""
	//	"style"					"SmallButton"
	//	"command"				"FlmReloadfont_FAQ"
	//}	
	"FlmReloadfont_FAQ"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmReloadfont_FAQ"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			""
		"ResourceFile"			"resource/UI/L4D360UI/urikgamemenu/reloadfont_faq.res"
	}	
	"IconCredits"
	{
		"ControlName"	"ImagePanel"
		"fieldname"		"IconCredits"
		"xpos"			"7"
		"ypos"			"76"
		"wide"			"8"
		"tall"			"8"
		"zpos"			"0"
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			"icon_credits"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
	}
	"CreditsUrik"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"CreditsUrik"
		"xpos"					"20"
		"ypos"					"104"
		"wide"					"120"
		"tall"					"20"
		"autoResize"				"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"				"0"
		"wrap"					"1"		
		"navUp"					"Reloadscheme_FAQ"
		"navDown"				"BtnCommentary"
		"labelText"				"ABOUT Urik Game Menu"	[$ENGLISH]
		"labelText"				"#L4D360UI_Extras_Credits"	[!$ENGLISH]
		"tooltiptext"				"#L4D360UI_Extras_Credits_Tip"
		"allcaps"				"0"	[$ENGLISH]
		"allcaps"				"1"	[$ENGLISH]
		"style"					"SmallButton"
		"command"				"FlmCreditsUrik"
	}	
	"Flmcreditsurik"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"Flmcreditsurik"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			""
		"ResourceFile"			"resource/UI/L4D360UI/urikgamemenu/CreditsUrik.res"
	}
	"IconCommentary"
	{
		"ControlName"	"ImagePanel"
		"fieldname"		"IconCommentary"
		"xpos"			"7"
		"ypos"			"90"
		"wide"			"8"
		"tall"			"8"
		"zpos"			"0"
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			"icon_commentary"
		"drawcolor" "140 20 0 255" [$x360lodef]//xmas
		"drawcolor" "139 139 139 255"//icon_drawcolor
	}
	"BtnCommentary"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnCommentary"
		"xpos"					"20"
		"ypos"					"124"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"CreditsUrik"
		"navDown"				"DemoUI"
		"tooltiptext"				"#L4D360UI_Extras_Commentary_Tip"
		"labelText"				"#L4D360UI_Extras_Commentary"
		"style"					"SmallButton"
		"command"				"DeveloperCommentary"
	}
}