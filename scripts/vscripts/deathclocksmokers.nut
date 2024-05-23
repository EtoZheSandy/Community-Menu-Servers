//-----------------------------------------------------
Msg("Activating Death Clock: Smokers\n");

IncludeScript("deathclock_base");

DeathClockOptions <-
{
	SmokerLimit = 14
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
}

DeathClockState <-
{
	DC_LeftSafeAreaFunc = function()
	{
		EntFire( "tankdoorout_button", "Unlock" );
		EntFire( "tank_sound_timer", "Kill" );
		EntFire( "spawn_church_zombie", "AddOutput", "population smoker" );
		EntFire( "info_director", "FireConceptToAny", "PlayerHurryUp" );

		if ( Entities.FindByName( null, "l4d1_teleport_relay" ) )
		{
			SessionOptions.cm_MaxSpecials <- 10;
			SessionOptions.cm_DominatorLimit <- 10;
			SessionOptions.SmokerLimit <- 10;
		}
	}
}

AddDefaultsToTable( "DeathClockOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "DeathClockState", g_ModeScript, "MutationState", g_ModeScript );
