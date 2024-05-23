//-----------------------------------------------------
Msg("Activating Fallen Hope\n");
Msg("Made by Rayman1103\n");


MutationOptions <-
{
	ActiveChallenge = 1

	cm_CommonLimit = 100
	cm_TempHealthOnly = 1
	cm_MaxSpecials = 1
	cm_DominatorLimit = 1
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 1
	JockeyLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	PreferredMobDirection = SPAWN_ANYWHERE
	SpecialInitialSpawnDelayMin = 300
	SpecialInitialSpawnDelayMax = 300
	PreferredSpecialDirection = SPAWN_BEHIND_SURVIVORS
	ShouldAllowMobsWithTank = true
	cm_BaseCommonAttackDamage = 2

	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_first_aid_kit = "weapon_adrenaline_spawn"
		weapon_defibrillator = "weapon_adrenaline_spawn"
		weapon_upgradepack_incendiary = "weapon_adrenaline_spawn"
		weapon_upgradepack_explosive = "weapon_adrenaline_spawn"
		ammo = "weapon_pipe_bomb_spawn"
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
		weapon_chainsaw = 0
		weapon_melee = 0
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
		"weapon_pistol",
	]

	function GetDefaultItem( idx )
	{
		if ( idx < DefaultItems.len() )
		{
			return DefaultItems[idx];
		}
		return 0;
	}


	
	TempHealthDecayRate = 0.001
	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 1.0 // pain_pills_decay_rate default
		}
	}
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
}
