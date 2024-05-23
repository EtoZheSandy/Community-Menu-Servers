//-----------------------------------------------------
Msg("Activating Madness\n");
Msg("Made by DarkDragon\n");


MutationOptions <-
{
	ActiveChallenge = 1
	cm_ShouldHurry = 1
	ProhibitBosses = 1
	CommonLimit = 90
	cm_CommonLimit = 90
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
}

function OnGameEvent_round_start_post_nav( params )
{
	EntFire( "tankdoorout_button", "Unlock" );
	EntFire( "tank_sound_timer", "Kill" );
}

function OnGameEvent_player_left_safe_area( params )
{
	EntFire( "info_director", "ForcePanicEvent" );
}
