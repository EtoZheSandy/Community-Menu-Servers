"Resource/tumtara_l4d2.res"
{
	"PnlBackground"
	{
		"ControlName"		"Panel"
		"fieldName"			"PnlBackground"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"-1"
		"wide"				"156"
		"tall"				"110"
		"visible"			"1"
		"enabled"			"1"
		"paintbackground"	"1"
		"paintborder"		"1"
	}

	"tum_l4d1_1"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"tum_l4d1_1"
		"xpos"					"0"
		"ypos"					"0"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"0" [$X360]
		"visible"				"1" [$WIN32]
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"tum_l4d1_5"
		"navDown"				"tum_l4d1_2"
		"labelText"				"★CarnivaL★ #1"
		"tooltiptext"			""
		"style"					"FlyoutMenuButton"
		"command"				"#con_enable 1;connect 46.174.48.189:27015"
		"ActivationType"		"1"
	}
	
	"tum_l4d1_2"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"tum_l4d1_2"
		"xpos"					"0"
		"ypos"					"20"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"0" [$X360]
		"visible"				"1" [$WIN32]
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"tum_l4d1_1"
		"navDown"				"tum_l4d1_3"
		"labelText"				"★CarnivaL★ #2"
		"tooltiptext"			""
		"style"					"FlyoutMenuButton"
		"command"				"#con_enable 1;connect 46.174.48.189:27016"
		"ActivationType"		"1"
	}
	"tum_l4d1_3"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"tum_l4d1_3"
		"xpos"					"0"
		"ypos"					"40"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"0" [$X360]
		"visible"				"1" [$WIN32]
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"tum_l4d1_2"
		"navDown"				"tum_l4d1_4"
		"labelText"				"★CarnivaL★ #3"
		"tooltiptext"			""
		"style"					"FlyoutMenuButton"
		"command"				"#con_enable 1;connect 46.174.48.189:27017"
		"ActivationType"		"1"
	}	

	"tum_l4d1_4"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"tum_l4d1_4"
		"xpos"					"0"
		"ypos"					"60"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"0" [$X360]
		"visible"				"1" [$WIN32]
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"tum_l4d1_3"
		"navDown"				"tum_l4d1_5"
		"labelText"				"★CarnivaL★ #4"
		"tooltiptext"			""
		"style"					"FlyoutMenuButton"
		"command"				"#con_enable 1;connect 46.174.48.189:27018"
		"ActivationType"		"1"
	}
	"tum_l4d1_5"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"tum_l4d1_5"
		"xpos"					"0"
		"ypos"					"80"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"0" [$X360]
		"visible"				"1" [$WIN32]
		"enabled"				"1"
		"tabPosition"			"0"
		"navUp"					"tum_l4d1_4"
		"navDown"				"tum_l4d1_1"
		"labelText"				"★CarnivaL★ #AM"
		"tooltiptext"			""
		"style"					"FlyoutMenuButton"
		"command"				"#con_enable 1;connect 46.174.48.189:27020"
		"ActivationType"		"1"
	}

}
