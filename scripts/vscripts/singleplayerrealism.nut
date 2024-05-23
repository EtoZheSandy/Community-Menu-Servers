//-----------------------------------------------------
Msg("Activating: Single Player Realism\n");
Msg("Made by Karma Jockey\n");

MutationOptions <- 
{
	ActiveChallenge = 1

	cm_MaxSpecials = 0
	cm_CommonLimit = 90
	cm_WitchLimit = 0
	cm_TankLimit = 0
	cm_ProhibitBosses = 1
	cm_NoRescueClosets = 1
	SurvivorMaxIncapacitatedCount = 1
	cm_NoSurvivorBots = 1
	
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	
	weaponsToConvert =
	{
		weapon_pistol_spawn = "weapon_melee_spawn"
	}
	function ConvertWeaponSpawn( classname )
	{
		if ( classname in weaponsToConvert )
		{
			return weaponsToConvert[classname];
		}
		return 0;
	}
	
	weaponsToRemove =
	{
		weapon_grenade_launcher = 0
		weapon_defibrillator = 0
		weapon_incendiary_ammo = 0
		weapon_explosive_ammo = 0
		weapon_adrenaline = 0
		katana = 0
		guitar = 0
		ammo = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return false;
		}
		return true;
	}

	DefaultItems =
	[
		"weapon_pistol",
		"weapon_first_aid_kit",
		"weapon_pain_pills",
	]

	function GetDefaultItem( idx )
	{
		if ( idx < DefaultItems.len() )
		{
			return DefaultItems[idx];
		}
		return 0;
	}
}

function OnGameEvent_round_start_post_nav( params )
{
	EntFire( "tankdoorout_button", "Unlock" );
	EntFire( "tank_sound_timer", "Kill" );
}
