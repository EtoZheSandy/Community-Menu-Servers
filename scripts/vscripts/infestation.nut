//-----------------------------------------------------
Msg("Activating Infestation\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	RelaxMinInterval = 0
	RelaxMaxInterval = 0
	SpecialRespawnInterval = 7
	cm_DominatorLimit = 14
	cm_MaxSpecials = 14
	CommonLimit = 0
	cm_CommomLimit = 0
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 14
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	ProhibitBosses = 1
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE

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

	DefaultItems =
	[
		"weapon_pistol_magnum",
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
	for ( local spawner; spawner = Entities.FindByClassname( spawner, "info_zombie_spawn" ); )
	{
		local population = NetProps.GetPropString( spawner, "m_szPopulation" );

		if ( population == "boomer" || population == "hunter" || population == "smoker" || population == "jockey"
			|| population == "charger" || population == "spitter" || population == "new_special" || population == "church"
				|| population == "tank" || population == "witch" || population == "witch_bride" || population == "river_docks_trap" )
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
