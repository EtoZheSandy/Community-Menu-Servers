Msg("Activating Death's Bleeding Tank\n");
Msg("Made by Krandel\n");

MutationOptions <-
{
	ActiveChallenge = 1

	cm_frustrationTimer = 0
	cm_TankRun = 1
	cm_ShouldHurry = 1
	cm_TempHealthOnly = 1
	cm_AllowSurvivorRescue = 0
	TempHealthDecayRate = 0.001

	PreferredSpecialDirection = SPAWN_BEHIND_SURVIVORS
	BehindSurvivorsSpawnDistance = 2000
	TankRunSpawnDelay = 15

	MobMaxPending = 0

	// Always convert to the TANK!!!
	function ConvertZombieClass( iClass )
	{
		return 8;
	}
	weaponsToConvert =
	{
		weapon_first_aid_kit = "weapon_pain_pills_spawn"
		weapon_defibrillator = "weapon_pain_pills_spawn"
	}

	function ConvertWeaponSpawn( classname )
	{
		if ( classname in weaponsToConvert )
		{
			return weaponsToConvert[classname];
		}
		return 0;
	}

	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 0.27 // pain_pills_decay_rate default
		}
	}
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
}
