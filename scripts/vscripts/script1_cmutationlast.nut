Msg("Running Script - Sitting Witch \n");
Skyboxes <- [
	"0"
]

worldspawn <- Entities.FindByClassname (null, "worldspawn");
local i = RandomInt(0,Skyboxes.len()-1);
printl("Skybox is "+Skyboxes[i]);
printl( worldspawn.__KeyValueFromString("timeofday",Skyboxes[i]) );