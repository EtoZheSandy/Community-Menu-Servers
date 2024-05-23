"Resource/UI/DownloadCampaign.res"
{
	"DownloadCampaign"
	{
		"ControlName"	"Frame"
		"fieldName"		"DownloadCampaign"
		"xpos"			"c-200"
		"ypos"			"c-80"
		"wide"			"400"
		"tall"          "200"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
	}

	"LblDownloadTitle"
	{
		"ControlName"	"Label"
		"fieldName"		"LblDownloadTitle"
		"xpos"			"0"
		"ypos"			"6"
		"zpos"			"2"
		"wide"			"400"
		"tall"			"20"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"labelText"		"#L4D360UI_DownloadCampaign_Title"
		"textAlignment"	"center"
		"fgcolor_override"	"92 92 92 255"
		//"bgcolor_override"	"111 111 0 111"
		"font"			"DefaultVerySmall"
	}

	"LblDownloadCampaign"
	{
		"ControlName"	"Label"
		"fieldName"		"LblDownloadCampaign"
		"xpos"			"20"
		"ypos"			"27"
		"zpos"			"2"
		"wide"			"360"
		"tall"			"20"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"labelText"		"#L4D360UI_DownloadCampaign_Campaign"
		"font"			"MainBold"
		"fgcolor_override"	"255 255 150 255"
		//"bgcolor_override"	"0 0 111 111"
		"textAlignment"	"center"
	}

	"LblDownloadText"
	{
		"ControlName"	"Label"
		"fieldName"		"LblDownloadText"
		"xpos"			"20"
		"ypos"			"40"
		"zpos"			"2"
		"wide"			"360"
		"tall"			"80"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"labelText"		"#L4D360UI_DownloadCampaign_Text"
		"font"			"DefaultVerySmall"
		"textAlignment"	"west"
		"fgcolor_override"	"92 92 92 255"
		"fgcolor_override"	"Label.DisabledFgColor1"
		"wrap"          "1"
		//"bgcolor_override"	"110 0 111 111"
	}

//	"CheckBtnWarning"
//	{
//		"ControlName"	"CvarToggleCheckButton_GameUI"
//		"fieldName"		"CheckBtnWarning"
//		"xpos"			"20"
//		"ypos"			"130"
//		"zpos"			"2"
//		"wide"			"14"
//		"tall"			"14"
//		"autoResize"	"0"
//		"pinCorner"		"0"
//		"visible"		"1"
//		"enabled"		"1"
//		"tabPosition"	"2"
//		"textAlignment"	"west"
//		"dulltext"		"0"
//		"brighttext"	"0"
//		"wrap"			"0"
//		"Default"		"0"
//	}
//
//	"LblWarning"
//	{
//		"ControlName"	"Label"
//		"fieldName"		"LblWarning"
//		"xpos"			"40"
//		"ypos"			"130"
//		"zpos"			"2"
//		"wide"			"360"
//		"tall"			"30"
//		"autoResize"	"0"
//		"pinCorner"		"0"
//		"visible"		"1"
//		"enabled"		"1"
//		"tabPosition"	"0"
//		"labelText"		"#L4D360UI_DownloadCampaign_Warning"
//		"textAlignment"	"west"
//		"wrap"          "1"
//	}

	"LblDownloadSite"
	{
		"ControlName"	"Label"
		"fieldName"		"LblDownloadSite"
		"xpos"			"20"
		"ypos"			"126"
		"zpos"			"2"
		"wide"			"360"
		"tall"			"15"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"labelText"		"#L4D360UI_DownloadCampaign_Site"
		"textAlignment"	"center"
		"font"			"DefaultVerySmall"
		//"bgcolor_override"	"110 0 0 111"
	}

	"BtnURL"
	{
		"ControlName"		"L4D360HybridButton"
		"fieldName"			"BtnURL"
		"xpos"				"10"
		"ypos"				"150"
		"zpos"				"2"
		"wide"				"380"
		"tall"				"18"
		"autoResize"		"0"
		"pinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"labelText"			""
		"textAlignment"		"center"
		"style"		   		"DialogButton"
		"navUp"				"BtnBack"
		"navDown"			"BtnBack"
		"command"			"Continue"
	}	

	"BtnBack"
	{
		"ControlName"		"L4D360HybridButton"
		"fieldName"			"BtnBack"
		"xpos"				"140"
		"ypos"				"180"
		"zpos"				"2"
		"wide"				"120"
		"tall"				"18"
		"autoResize"		"0"
		"pinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"AllCaps"			"1"
		"labelText"			"#L4D360UI_DownloadCampaign_Back"
		"Font"					"DefaultVerySmall"
		"textAlignment"		"center"
		//"paintborder"				"1"
		"style"		   		"DialogButton"
		"navUp"				"BtnURL"
		"navDown"			"BtnURL"
		"command"			"Back"
	}

}