//-----------------------------------------------------
Msg("Activating Versus Training - Jockeys\n");
Msg("Made by Rayman1103\n");


MutationOptions <-
{
	// Challenge vars
	ActiveChallenge = 1
	
	TankLimit = 0
	cm_TankLimit = 0
	
	// Always convert to the Jockey
	function ConvertZombieClass( iClass )
	{
		return 5;
	}
}

function OnGameEvent_round_start_post_nav( params )
{
	EntFire( "tankdoorout_button", "Unlock" );
	EntFire( "tank_sound_timer", "Kill" );
}