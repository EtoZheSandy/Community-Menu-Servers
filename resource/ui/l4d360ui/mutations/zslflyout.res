"Resource/UI/ZSLFlyout.res"
{
	"PnlBackground"
	{
		"ControlName"			"Panel"
		"fieldName"				"PnlBackground"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"-1"
		"wide"					"190" [$ENGLISH]
		"wide"					"270" [!$ENGLISH]
		"tall"					"45"
		"visible"				"1"
		"enabled"				"1"
		"paintbackground"		"1"
		"paintborder"			"1"
	}

	"BtnMutationList1"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnMutationList1"
		"xpos"					"0"
		"ypos"					"0"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"wrap"					"1"		
		"navUp"					"BtnMutationList2"
		"navDown"				"BtnMutationList2"
		"labelText"				"Competitive Campaign"
		"tooltiptext"			""
		"disabled_tooltiptext"	""
		"style"					"FlyoutMenuButton"
		"command"				"FlmZSLWeeklyFlyout"
	}

	"BtnMutationList2"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnMutationList2"
		"xpos"					"0"
		"ypos"					"20"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"wrap"					"1"
		"navUp"					"BtnMutationList1"
		"navDown"				"BtnMutationList1"
		"labelText"				"Competitive Survival"
		"tooltiptext"			""
		"disabled_tooltiptext"	""
		"style"					"FlyoutMenuButton"
		"command"				"FlmZSLSurvivalFlyout"
	}
}