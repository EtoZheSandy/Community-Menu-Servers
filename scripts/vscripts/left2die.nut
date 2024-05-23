//-----------------------------------------------------
Msg("Activating Left 2 Die\n");
Msg("Made by Rayman1103\n");


MutationOptions <-
{
	ActiveChallenge = 1

	cm_CommonLimit = 0
	cm_DominatorLimit = 4
	cm_MaxSpecials = 4
	cm_SpecialRespawnInterval = 30
	cm_AutoReviveFromSpecialIncap = 1
	cm_AllowPillConversion = 0

	BoomerLimit = 0
	MobMaxPending = 0
	SurvivorMaxIncapacitatedCount = 1
	SpecialInitialSpawnDelayMin = 5
	SpecialInitialSpawnDelayMax = 30
	TankHitDamageModifierCoop = 0.5
	
	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_pipe_bomb = 	"weapon_molotov_spawn"
		weapon_vomitjar = 	"weapon_molotov_spawn"
		weapon_first_aid_kit =	"weapon_defibrillator_spawn"

		weapon_smg = 		"weapon_rifle_spawn"
		weapon_pumpshotgun = 	"weapon_autoshotgun_spawn"
		weapon_smg_silenced =	"weapon_rifle_desert_spawn"
		weapon_shotgun_chrome = "weapon_shotgun_spas_spawn"
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
