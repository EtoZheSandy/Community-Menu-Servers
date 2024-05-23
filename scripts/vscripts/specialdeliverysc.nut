//-----------------------------------------------------
Msg("Activating Special Delivery Scavenge\n");
Msg("Made by Rayman1103\n");


MutationOptions <-
{
	ActiveChallenge = 1
	cm_CommonLimit = 0
	cm_DominatorLimit = 6
	cm_MaxSpecials = 6
	cm_SpecialRespawnInterval = 10
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 0
	ShouldAllowSpecialsWithTank = true

	SmokerLimit = 1
	BoomerLimit = 1
	HunterLimit = 1
	SpitterLimit = 1
	JockeyLimit = 1
	ChargerLimit = 1

	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_pipe_bomb = 	"weapon_molotov_spawn"
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
