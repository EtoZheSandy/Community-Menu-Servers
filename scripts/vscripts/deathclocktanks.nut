//-----------------------------------------------------
Msg("Activating Death Clock: Tanks\n");

IncludeScript("deathclock_base");

DeathClockOptions <-
{
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	//TankHitDamageModifierCoop = 0.08
	SurvivorMaxIncapacitatedCount = 0
	TankLimit = 10
	cm_TankLimit = 10
	WitchLimit = 0
	cm_WitchLimit = 0
	
	// convert items that aren't useful
	weaponsToConvert =
	{
		ammo =	"weapon_molotov_spawn"
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
		weapon_pistol = 0
		weapon_pistol_magnum = 0
		weapon_smg = 0
		weapon_pumpshotgun = 0
		weapon_autoshotgun = 0
		weapon_rifle = 0
		weapon_hunting_rifle = 0
		weapon_smg_silenced = 0
		weapon_shotgun_chrome = 0
		weapon_rifle_desert = 0
		weapon_sniper_military = 0
		weapon_shotgun_spas = 0
		weapon_grenade_launcher = 0
		weapon_rifle_ak47 = 0
		weapon_smg_mp5 = 0		
		weapon_rifle_sg552 = 0		
		weapon_sniper_awp = 0	
		weapon_sniper_scout = 0
		weapon_rifle_m60 = 0
		weapon_melee = 0
		weapon_chainsaw = 0
		weapon_pipe_bomb = 0
		//weapon_molotov = 0
		weapon_vomitjar = 0
		weapon_first_aid_kit = 0
		weapon_pain_pills = 0
		weapon_adrenaline = 0
		weapon_defibrillator = 0
		weapon_upgradepack_incendiary = 0
		weapon_upgradepack_explosive = 0
		upgrade_item = 0
		//ammo = 0
	}
}

DeathClockState <-
{
	SpawnTank = false
	TriggerRescue = false
	DC_OnTakeDamageFunc = function( damageTable )
	{
		if ( damageTable.Attacker.IsPlayer() && damageTable.Victim.IsPlayer() )
		{
			if ( damageTable.Attacker.GetZombieType() == 8 && damageTable.Victim.IsSurvivor() && damageTable.DamageType == ( 1 << 7 ) )
				damageTable.DamageDone = 2;
		}
		return true;
	}
	DC_LeftSafeAreaFunc = function()
	{
		EntFire( "finale_cleanse_entrance_door", "Lock" );
		EntFire( "finale_cleanse_exit_door", "Unlock" );
		EntFire( "ceda_trailer_canopen_frontdoor_listener", "Kill" );
		EntFire( "finale_cleanse_backdoors_blocker", "Kill" );
		EntFire( "radio_fake_button", "Press" );
		EntFire( "drawbridge", "movetofloor", "Bottom" );
		EntFire( "drawbridge_start_sound", "PlaySound" );
		EntFire( "startbldg_door_button", "Press" );
		EntFire( "startbldg_door", "Open" );
		EntFire( "elevator", "movetofloor", "Bottom" );
		EntFire( "elevator_pulley", "Start" );
		EntFire( "elevator_pulley2", "Start" );
		EntFire( "elevbuttonoutsidefront", "Skin", "1" );
		EntFire( "sound_elevator_startup", "PlaySound" );
		EntFire( "elevator_start_shake", "StartShake" );
		EntFire( "elevator_number_relay", "Trigger" );
		EntFire( "elevator_breakwalls", "Kill" );
		EntFire( "elevator_game_event", "Kill" );
		EntFire( "spawn_church_zombie", "AddOutput", "population tank" );
		EntFire( "info_director", "FireConceptToAny", "PlayerHurryUp" );
		g_ModeScript.DC_SpawnTank();
	}
}

AddDefaultsToTable( "DeathClockOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "DeathClockState", g_ModeScript, "MutationState", g_ModeScript );

function DC_SpawnTank()
{
	ZSpawn( { type = DirectorScript.ZOMBIE_TANK } );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.DC_SpawnTank()", 10.0 );
}
