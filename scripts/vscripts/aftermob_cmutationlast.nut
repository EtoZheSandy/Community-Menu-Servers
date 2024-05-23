Msg("Running Script - after mob fog changer \n");
timer_aftermob_done <- false;
function Update()
{
	if(!timer_aftermob_done && Time() >= 1)
	{
		EntFire( "env_fog_controller", "SetColor", "0 0 0" );
		EntFire( "env_fog_controller", "SetColorSecondary", "0 0 0" );
		EntFire( "env_fog_controller", "SetStartDist", "-10000" );
		EntFire( "env_fog_controller", "SetEndDist", "1707" );
		EntFire( "env_fog_controller", "StartFogTransition", "" );
		timer_aftermob_done = true;
	}
}