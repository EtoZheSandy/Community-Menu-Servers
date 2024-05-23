//-------------------------------------
// entities to sanitize on map spawn
//
// 'Sanitizing' is deleting entities from a map that are not wanted or 
// needed by this scripted mode. This frees up memory and CPU.
// And is sometimes needed to remove events from a map that you dont want in your mode
//-------------------------------------
SanitizeTable <-
[
	// fire these outputs on map load
	{ targetname	= "relay_intro_start", input = "kill" },
	{ targetname	= "relay_intro_finished", input = "trigger" },
	{ targetname	= "survivorPos_*", input = "kill" },
	{ classname		= "logic_choreographed_scene", input = "kill" },
	{ classname		= "info_remarkable", input = "kill" },
]
