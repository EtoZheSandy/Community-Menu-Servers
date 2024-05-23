"Resource/guardian_servers.res"
{
	"PnlBackground"
	{
		"ControlName"		"Panel"
		"fieldName"			"PnlBackground"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"-1"
		"wide"				"156"
		"tall"				"130"
		"visible"			"1"
		"enabled"			"1"
		"paintbackground"	"1"
		"paintborder"		"1"
	}

	"tum_l4d2_sky_1"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"tum_l4d2_sky_1"
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
		"navUp"					"tum_l4d2_sky_6"
		"navDown"				"tum_l4d2_sky_2"
		"labelText"				"GUARDIAN SKY"
		"tooltiptext"			""
		"style"					"FlyoutMenuButton"
		"command"				"#con_enable 1;connect 178.22.51.56:22803"
		"ActivationType"		"1"
	}
	"tum_l4d2_sky_2"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"tum_l4d2_sky_2"
		"xpos"					"0"
		"ypos"					"20"
		"wide"					"20"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"0" [$X360]
		"visible"				"1" [$WIN32]
		"enabled"				"1"
		"tabPosition"			"0"
		"labelText"				"GUARDIAN CUP"
		"navUp"					"tum_l4d2_sky_1"
		"navDown"				"tum_l4d2_sky_3"
		"tooltiptext"			""
		"style"					"FlyoutMenuButton"
		"command"				"#con_enable 1;connect 178.22.51.56:22811"
		"ActivationType"		"1"
	}
	"tum_l4d2_sky_3"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"tum_l4d2_sky_3"
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
		"labelText"				"GUARDIAN REWORK"
		"navUp"					"tum_l4d2_sky_2"
		"navDown"				"tum_l4d2_sky_4"
		"tooltiptext"			""
		"style"					"FlyoutMenuButton"
		"command"				"#con_enable 1;connect 178.22.51.56:22813"
		"ActivationType"		"1"
	}
		"tum_l4d2_sky_4"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"tum_l4d2_sky_4"
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
		"labelText"				"GUARDIAN REALISM"
		"navUp"					"tum_l4d2_sky_2"
		"navDown"				"tum_l4d2_sky_4"
		"tooltiptext"			""
		"style"					"FlyoutMenuButton"
		"command"				"#con_enable 1;connect 178.22.51.56:22802"
		"ActivationType"		"1"
	}
	"tum_l4d2_sky_5"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"tum_l4d2_sky_5"
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
		"labelText"				"GUARDIAN ELITE"
		"navUp"					"tum_l4d2_sky_4"
		"navDown"				"tum_l4d2_sky_6"
		"tooltiptext"			""
		"style"					"FlyoutMenuButton"
		"command"				"#con_enable 1;connect 178.22.51.56:22801"
		"ActivationType"		"1"
	}
	"tum_l4d2_sky_6"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"tum_l4d2_sky_6"
		"xpos"					"0"
		"ypos"					"100"
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"0" [$X360]
		"visible"				"1" [$WIN32]
		"enabled"				"1"
		"tabPosition"			"0"
		"labelText"				"GUARDIAN T1 HARD"
		"navUp"					"tum_l4d2_sky_6"
		"navDown"				"tum_l4d2_sky_1"
		"tooltiptext"			""
		"style"					"FlyoutMenuButton"
		"command"				"#con_enable 1;connect 178.22.51.56:22806"
		"ActivationType"		"1"
	}

}
