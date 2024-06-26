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
		"tall"				"65" [$X360]
		"tall"				"65" [$WIN32]
		"visible"			"1"
		"enabled"			"1"
		"paintbackground"	"1"
		"paintborder"		"1"
	}

	"BtnCommentary"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnCommentary"
		"xpos"					"0"
		"ypos"					"0"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"BtnBlogPost"
		"navDown"				"BtnCredits"
		"tooltiptext"			"#L4D360UI_Extras_Commentary_Tip"
		"labelText"				"#L4D360UI_Extras_Commentary"
		"style"					"FlyoutMenuButton"
		"command"				"DeveloperCommentary"
	}

	"BtnCredits"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnCredits"
		"xpos"					"0"
		"ypos"					"20"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"BtnCommentary"
		"navDown"				"BtnBlogPost"
		"tooltiptext"			"#L4D360UI_Extras_Credits_Tip"
		"labelText"				"#L4D360UI_Extras_Credits"
		"style"					"FlyoutMenuButton"
		"command"				"Credits"
	}
	"BtnBlogPost"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnBlogPost"
		"xpos"					"0"
		"ypos"					"40"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"BtnCredits"
		"navDown"				"BtnCommentary"
		"labelText"				"#L4D360UI_MainMenu_BlogPost"
		"tooltiptext"			""
		"style"					"FlyoutMenuButton"
		"command"				"ShowBlogPost"
		"ActivationType"		"1"
		"EnableCondition"					"Never" [$DEMO]
	}	
	
}