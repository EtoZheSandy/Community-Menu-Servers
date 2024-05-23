Msg("Activating Mutation Boomer Shooter (beta version)\n");

MutationOptions <-
{
	ActiveChallenge = 1
	RelaxMinInterval = 15
	RelaxMaxInterval = 15
	SpecialRespawnInterval = 8
	cm_CommonLimit = 50
	cm_DominatorLimit = 20
	cm_MaxSpecials = 20
	BoomerLimit = 20
	ChargerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	ProhibitBosses = 1 //tanks still spawn at finales though

	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_vomitjar = 	"weapon_molotov_spawn"
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

