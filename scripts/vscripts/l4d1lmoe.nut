//-----------------------------------------------------
Msg("Activating L4D1 Last Man on Earth\n");

IncludeScript("l4d1");

LMOEOptions <-
{
	cm_NoSurvivorBots = true
	cm_CommonLimit = 0
	cm_DominatorLimit = 1
	cm_MaxSpecials = 2
	cm_SpecialRespawnInterval = 60
	cm_AutoReviveFromSpecialIncap = true
	cm_AllowPillConversion = false

	BoomerLimit = 0
	MobMaxPending = 0
	SurvivorMaxIncapacitatedCount = 1
	SpecialInitialSpawnDelayMin = 5
	SpecialInitialSpawnDelayMax = 30
	TankHitDamageModifierCoop = 0.5

	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_pipe_bomb =	"weapon_molotov_spawn"
		weapon_vomitjar =	"weapon_molotov_spawn"
		weapon_defibrillator =	"weapon_first_aid_kit_spawn"
		weapon_adrenaline =	"weapon_pain_pills_spawn"
		weapon_ammo_pack =	"weapon_first_aid_kit_spawn"

		weapon_pistol_magnum =	"weapon_pistol_spawn"
		weapon_smg =		"weapon_rifle_spawn"
		weapon_pumpshotgun =	"weapon_autoshotgun_spawn"
		weapon_smg_silenced =	"weapon_rifle_spawn"
		weapon_shotgun_chrome =	"weapon_autoshotgun_spawn"
		weapon_smg_mp5 =	"weapon_rifle_spawn"

		weapon_shotgun_spas =	"weapon_autoshotgun_spawn"
		weapon_sniper_military =	"weapon_hunting_rifle_spawn"
		weapon_rifle_ak47 =	"weapon_rifle_spawn"
		weapon_rifle_desert =	"weapon_rifle_spawn"
		weapon_sniper_awp =	"weapon_hunting_rifle_spawn"
		weapon_sniper_scout =	"weapon_hunting_rifle_spawn"
		weapon_rifle_sg552 =	"weapon_rifle_spawn"
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

AddDefaultsToTable( "LMOEOptions", g_ModeScript, "DirectorOptions", g_ModeScript );

LMOEEvents <-
{
	function OnGameEvent_round_start_post_nav( params )
	{
		for ( local spawner; spawner = Entities.FindByClassname( spawner, "info_zombie_spawn" ); )
		{
			local population = NetProps.GetPropString( spawner, "m_szPopulation" );

			if ( population == "boomer" || population == "hunter" || population == "smoker" || population == "church"
					|| population == "tank" || population == "witch" || population == "witch_bride" || population == "river_docks_trap" )
				continue;
			else
				spawner.Kill();
		}

		if ( Director.GetMapName() == "c5m5_bridge" || Director.GetMapName() == "c6m3_port" )
			DirectorOptions.cm_MaxSpecials = 0;
	}

	function OnGameEvent_finale_start( params )
	{
		if ( Director.GetMapName() == "c6m3_port" )
			DirectorOptions.cm_MaxSpecials = 2;
	}

	function OnGameEvent_gauntlet_finale_start( params )
	{
		if ( Director.GetMapName() == "c5m5_bridge" )
			DirectorOptions.cm_MaxSpecials = 2;
	}
}

__CollectEventCallbacks( g_ModeScript.LMOEEvents, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener );

function Update()
{
	if ( Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
}
