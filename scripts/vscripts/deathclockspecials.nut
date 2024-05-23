//-----------------------------------------------------
Msg("Activating Death Clock: Specials\n");

IncludeScript("deathclock_base");

DeathClockOptions <-
{
	ShouldAllowSpecialsWithTank = true
	ZombieTankHealth = 2000
	
	BoomerLimit = 3
	SmokerLimit = 3
	HunterLimit = 2
	ChargerLimit = 2
	SpitterLimit = 2
	JockeyLimit = 2
	//TankLimit = 0
	//cm_TankLimit = 0
	//WitchLimit = 0
	//cm_WitchLimit = 0
}

DeathClockState <-
{
	DC_LeftSafeAreaFunc = function()
	{
		EntFire( "tankdoorout_button", "Unlock" );
		EntFire( "tank_sound_timer", "Kill" );
		EntFire( "info_director", "FireConceptToAny", "PlayerHurryUp" );

		if ( Entities.FindByName( null, "l4d1_teleport_relay" ) )
		{
			SessionOptions.cm_MaxSpecials <- 10;
			SessionOptions.cm_DominatorLimit <- 10;
			SessionOptions.BoomerLimit <- 2;
			SessionOptions.SmokerLimit <- 2;
			SessionOptions.HunterLimit <- 1;
			SessionOptions.ChargerLimit <- 2;
			SessionOptions.SpitterLimit <- 2;
			SessionOptions.JockeyLimit <- 1;
		}
	}
}

AddDefaultsToTable( "DeathClockOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "DeathClockState", g_ModeScript, "MutationState", g_ModeScript );
