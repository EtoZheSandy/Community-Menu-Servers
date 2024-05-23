Msg("Activating Mutation: Jockeys!") 
Msg("Made by Karma Jockey\n");

MutationOptions <-
{
	ActiveChallenge = 1
	RelaxMinInterval = 0
	RelaxMaxInterval = 0
	SpecialRespawnInterval = 0
	cm_CommonLimit = 0
	cm_DominatorLimit = 20
	cm_MaxSpecials = 20
	JockeyLimit = 20
	ChargerLimit = 0
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	SpitterLimit = 0
	ProhibitBosses = 1

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

		if ( population == "jockey"	|| population == "new_special" || population == "tank" || population == "witch" || population == "witch_bride" || population == "river_docks_trap" )
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
