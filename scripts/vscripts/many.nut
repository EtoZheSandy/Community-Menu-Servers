//-----------------------------------------------------
Msg("Activating One Against Many\n");
Msg("Made by Rayman1103 and RainingMetal\n");


MutationOptions <-
{
	ActiveChallenge = 1
	cm_NoSurvivorBots = 1
	cm_ProhibitBosses = 1
	cm_MaxSpecials = 0
	CommonLimit = 45
	MegaMobMaxSize = 55
	MegaMobMinSize = 55
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	
	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_defibrillator =	"weapon_first_aid_kit_spawn"		
	}

	function ConvertWeaponSpawn( classname )
	{
		if ( classname in weaponsToConvert )
		{
			return weaponsToConvert[classname];
		}
		return 0;
	}
}

function OnGameEvent_round_start_post_nav( params )
{
	EntFire( "tankdoorout_button", "Unlock" );
	EntFire( "tank_sound_timer", "Kill" );
}
