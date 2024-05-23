Msg("Custom Mutation by dani1341 \n");
Msg("Activating Mutation Lights Out \n");
Msg("Big Thanks to: \n");
Msg("Winded for helping with script \n");
Msg("Karma Jockey (KJ) for helping with custom fog \n");
Msg("Rayman1103 for adding the mutation to his mutations mod \n");
Msg("Mutation Compiled by dani1341 \n");

Skyboxes <- 
[
	"cmutationLAST_hdr",
]

worldspawn <- Entities.FindByClassname (null, "worldspawn");
local i = RandomInt(0,Skyboxes.len()-1);
printl("Skybox is "+Skyboxes[i]);
printl( worldspawn.__KeyValueFromString("skyname",Skyboxes[i]) );


MutationOptions <-
{
	ActiveChallenge = 1
}

timer_done <- false;
function Update()
{
	if(!timer_done && Time() >= 10)
	{
		EntFire("env_sun","Kill");
		EntFire("env_sprite","Kill");
		EntFire("beam_spotlight","Kill");
		EntFire("light_environment","Kill");
		EntFire("light_directional","Kill");
		EntFire("info_director","RunScriptFile","aftermob_cmutationlast");
		EntFire("logic_director_query","AddOutout","On20SecondsToMob,info_director,RunScriptFile,tomob_cmutationlast");
		EntFire("info_director","AddOutout","OnPanicEventFinished,info_director,RunScriptFile,aftermob_cmutationlast");
		EntFire( "info_director","BeginScript","script1_cmutationlast" );
		EntFire( "env_fog_controller","TurnOn","" );
		timer_done = true;
	}
}