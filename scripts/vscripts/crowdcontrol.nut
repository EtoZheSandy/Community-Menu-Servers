//-----------------------------------------------------
Msg("Activating: Crowd Control\n");
Msg("Made by Karma Jockey\n");

MutationOptions <- 
{
	ActiveChallenge = 1

	cm_MaxSpecials = 0
	cm_CommonLimit = 120
	cm_WitchLimit = 0
	cm_TankLimit = 0
	cm_ProhibitBosses = 1
	cm_NoRescueClosets = 0
	SurvivorMaxIncapacitatedCount = 0
	cm_NoSurvivorBots = 0
	cm_BaseCommonAttackDamage = 20
	cm_WanderingZombieDensityModifier = 0.09
	
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	
	weaponsToRemove =
	{
		weapon_pistol = 0
		weapon_pistol_magnum = 0
		weapon_smg = 0
		weapon_rifle = 0
		weapon_hunting_rifle = 0
		weapon_smg_silenced = 0
		weapon_rifle_desert = 0
		weapon_sniper_military = 0
		weapon_grenade_launcher = 0
		weapon_rifle_ak47 = 0
		weapon_smg_mp5 = 0
		weapon_rifle_sg552 = 0	
		weapon_sniper_awp = 0	
		weapon_sniper_scout = 0
		weapon_melee = 0
		weapon_chainsaw = 0
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
		"weapon_autoshotgun"
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
