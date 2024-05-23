//-----------------------------------------------------
Msg("Activating: Pitch Black\n");
Msg("Made by Karma Jockey\n");

MutationOptions <-
{
	ActiveChallenge = 1

	cm_NoSurvivorBots = 1
	cm_CommonLimit = 0
	cm_DominatorLimit = 6
	cm_MaxSpecials = 6
	cm_SpecialRespawnInterval = 30
	cm_AutoReviveFromSpecialIncap = 1
	cm_AllowPillConversion = 0
	JockeyLimit = 0
	ChargerLimit = 0
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 6
	SpitterLimit = 0
	ProhibitBosses = 1
	SurvivorMaxIncapacitatedCount = 6
	SpecialInitialSpawnDelayMin = 15
	SpecialInitialSpawnDelayMax = 15
	TankHitDamageModifierCoop = 0.5

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

function OnGameEvent_round_start_post_nav( params )
{
	for ( local spawner; spawner = Entities.FindByClassname( spawner, "info_zombie_spawn" ); )
	{
		local population = NetProps.GetPropString( spawner, "m_szPopulation" );

		if ( population == "hunter" || population == "church" || population == "tank" || population == "witch" || population == "witch_bride" || population == "river_docks_trap" )
			continue;
		else
			spawner.Kill();
	}
}

function Update()
{
	if ( Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
}
