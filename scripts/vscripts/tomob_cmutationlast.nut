Msg("Running Script - 20 seconds to mob fog changer \n");
timer_beforemob_done <- false;
function Update()
{
	if(!timer_beforemob_done && Time() >= 1)
	{
		EntFire( "env_fog_controller", "SetColor", "30 30 30" );
		EntFire( "env_fog_controller", "SetColorSecondary", "30 30 30" );
		EntFire( "env_fog_controller", "SetStartDist", "500.0" );
		EntFire( "env_fog_controller", "SetEndDist", "2000.0" );
		EntFire( "env_fog_controller", "StartFogTransition", "" );
		timer_beforemob_done = true;
	}
}