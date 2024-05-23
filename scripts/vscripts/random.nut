//-----------------------------------------------------
Msg("Activating Random\n");
Msg("Made by Rayman1103\n");

Skyboxes <- [ "0", "2" ];
Entities.First().__KeyValueFromString( "timeofday", Skyboxes[ RandomInt( 0, Skyboxes.len()-1 ) ] );

MutationOptions <-
{
	cm_AggressiveSpecials = 1
	cm_CommonLimit = 0
	cm_ProhibitBosses = false
	cm_SpecialRespawnInterval = 5
	//cm_TempHealthOnly = RandomInt( 0, 1 )
	ShouldAllowMobsWithTank = true
	ShouldAllowSpecialsWithTank = true
	EscapeSpawnTanks = true

	cm_DominatorLimit = 0
	cm_MaxSpecials = 0
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 5
	SmokerLimit = 0
	BoomerLimit = 0
	HunterLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	ChargerLimit = 0

	TankLimit = 4
	cm_TankLimit = 4
	WitchLimit = 4
	cm_WitchLimit = 4
	
	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_first_aid_kit = "weapon_pain_pills_spawn"
		weapon_pain_pills = "weapon_adrenaline_spawn"
		weapon_adrenaline = "weapon_first_aid_kit_spawn"
		weapon_smg = "weapon_pumpshotgun_spawn"
		weapon_smg_silenced = "weapon_shotgun_chrome_spawn"
		weapon_pumpshotgun = "weapon_smg_spawn"
		weapon_shotgun_chrome = "weapon_smg_silenced_spawn"
		weapon_pistol = "weapon_pistol_magnum_spawn"
		weapon_rifle = "weapon_rifle_ak47_spawn"
		weapon_rifle_ak47 = "weapon_desert_spawn"
		weapon_desert = "weapon_rifle_spawn"
		weapon_autoshotgun = "weapon_shotgun_spas_spawn"
		weapon_hunting_rifle = "weapon_sniper_military_spawn"
		weapon_pipe_bomb = "weapon_molotov_spawn"
		weapon_molotov = "weapon_vomitjar_spawn"
		weapon_vomitjar = "weapon_pipe_bomb_spawn"
		//weapon_melee = "weapon_upgradepack_explosive_spawn" //remove possible
	}
	
	weaponsToConvert2 =
	{
		weapon_first_aid_kit = "weapon_adrenaline_spawn"
		weapon_pain_pills = "weapon_first_aid_kit_spawn"
		weapon_adrenaline = "weapon_pain_pills_spawn"
		weapon_smg = "weapon_shotgun_chrome_spawn"
		weapon_smg_silenced = "weapon_pumpshotgun_spawn"
		weapon_pumpshotgun = "weapon_smg_silenced_spawn"
		weapon_shotgun_chrome = "weapon_smg_spawn"
		weapon_pistol_magnum = "weapon_pistol_spawn"
		weapon_rifle = "weapon_rifle_desert_spawn"
		weapon_rifle_ak47 = "weapon_rifle_spawn"
		weapon_desert = "weapon_rifle_ak47_spawn"
		weapon_shotgun_spas = "weapon_autoshotgun_spawn"
		weapon_sniper_military = "weapon_hunting_rifle_spawn"
		weapon_pipe_bomb = "weapon_vomitjar_spawn"
		weapon_molotov = "weapon_pipe_bomb_spawn"
		weapon_vomitjar = "weapon_molotov_spawn"
		//weapon_melee = "weapon_upgradepack_incendiary_spawn" //remove possible
	}
	
	allow_convert = 1

	function ConvertWeaponSpawn( classname )
	{
		local random_convert = RandomInt( 0, 2 )
		if ( classname in weaponsToConvert && random_convert == 0 && allow_convert == 1 )
		{
			Msg("Converting Table 1\n");
			return weaponsToConvert[classname];
			allow_convert = 0;
		}
		else if ( classname in weaponsToConvert2 && random_convert == 1 && allow_convert == 1 )
		{
			Msg("Converting Table 2\n");
			return weaponsToConvert2[classname];
			allow_convert = 0;
		}
		return 0;
	}
	
	RandomPistol =
	[
		"pistol",
		"pistol_magnum",
	]
	
	function GetDefaultItem(id)
	{
		local PRand = RandomInt(0,RandomPistol.len()-1);
		if(id == 0) return RandomPistol[PRand];
		return 0;
	}
}

MutationState <-
{
	enable_tanks = false
	LastTankSpawnTime = 0
	TankSpawnInterval = 60
	SpawnTankThink = false
}

function SpawnTankThink()
{
	if ( ((Time() - SessionState.LastTankSpawnTime) >= SessionState.TankSpawnInterval || SessionState.LastTankSpawnTime == 0) )
	{
		if ( ZSpawn( { type = 8 } ) )
			SessionState.LastTankSpawnTime = Time();
	}
}

function OnGameEvent_player_left_safe_area( params )
{
	if ( SessionState.enable_tanks )
		SessionState.SpawnTankThink = true;
}

function OnGameEvent_tank_spawn( params )
{
	if ( !SessionState.enable_tanks )
		return;

	local tank = GetPlayerFromUserID( params["userid"] );
	if ( !tank )
		return;

	if ( GetDifficulty() == 0 )
		tank.SetHealth( 1500 );
	else if ( GetDifficulty() == 1 || GetDifficulty() == 2 )
		tank.SetHealth( 2000 );
	else if ( GetDifficulty() == 3 )
		tank.SetHealth( 4000 );
}

function ChooseRandomSettings()
{
	local random_chance = RandomInt( 0, 16 );
	printl("Activating Random Game " + (random_chance + 1));
	if ( random_chance == 0 )
	{
		SessionOptions.cm_DominatorLimit = 6;
		SessionOptions.cm_MaxSpecials = 6;
		SessionOptions.SmokerLimit = 3;
		SessionOptions.ChargerLimit = 3;
	}
	else if ( random_chance == 1 )
	{
		SessionOptions.cm_DominatorLimit = 6;
		SessionOptions.cm_MaxSpecials = 6;
		SessionOptions.HunterLimit = 3;
		SessionOptions.SpitterLimit = 3;
	}
	else if ( random_chance == 2 )
	{
		SessionOptions.cm_CommonLimit = 10;
		SessionOptions.cm_DominatorLimit = 6;
		SessionOptions.cm_MaxSpecials = 6;
		SessionOptions.WanderingZombieDensityModifier <- 0.0;
		SessionOptions.BoomerLimit = 3;
		SessionOptions.JockeyLimit = 3;
	}
	else if ( random_chance == 3 )
	{
		SessionOptions.cm_CommonLimit = 30;
		SessionOptions.cm_HeadshotOnly <- 1;
	}
	else if ( random_chance == 4 )
	{
		SessionOptions.cm_DominatorLimit = 8;
		SessionOptions.cm_MaxSpecials = 8;
		SessionOptions.SmokerLimit = 2;
		SessionOptions.HunterLimit = 2;
		SessionOptions.SpitterLimit = 2;
		SessionOptions.JockeyLimit = 1;
		SessionOptions.ChargerLimit = 1;
	}
	else if ( random_chance == 5 )
	{
		SessionOptions.cm_DominatorLimit = 6;
		SessionOptions.cm_MaxSpecials = 6;
		SessionOptions.SmokerLimit = 3;
		SessionOptions.SpitterLimit = 3;
		SessionOptions.ChargerLimit = 0;
	}
	else if ( random_chance == 6 )
	{
		SessionOptions.cm_DominatorLimit = 6;
		SessionOptions.cm_MaxSpecials = 6;
		SessionOptions.HunterLimit = 3;
		SessionOptions.JockeyLimit = 3;
	}
	else if ( random_chance == 7 )
	{
		SessionOptions.cm_CommonLimit = 10;
		SessionOptions.cm_DominatorLimit = 6;
		SessionOptions.cm_MaxSpecials = 6;
		SessionOptions.BoomerLimit = 3;
		SessionOptions.ChargerLimit = 3;
	}
	else if ( random_chance == 8 )
	{
		SessionOptions.cm_DominatorLimit = 6;
		SessionOptions.cm_MaxSpecials = 6;
		SessionOptions.SmokerLimit = 3;
		SessionOptions.HunterLimit = 3;
	}
	else if ( random_chance == 9 )
	{
		SessionOptions.cm_CommonLimit = 10;
		SessionOptions.cm_DominatorLimit = 6;
		SessionOptions.cm_MaxSpecials = 6;
		SessionOptions.BoomerLimit = 3;
		SessionOptions.HunterLimit = 3;
	}
	else if ( random_chance == 10 )
	{
		SessionOptions.cm_CommonLimit = 10;
		SessionOptions.cm_DominatorLimit = 6;
		SessionOptions.cm_MaxSpecials = 6;
		SessionOptions.SmokerLimit = 3;
		SessionOptions.BoomerLimit = 3;
	}
	else if ( random_chance == 11 )
	{
		SessionOptions.cm_DominatorLimit = 6;
		SessionOptions.cm_MaxSpecials = 6;
		SessionOptions.SpitterLimit = 3;
		SessionOptions.ChargerLimit = 3;
	}
	else if ( random_chance == 12 )
	{
		SessionOptions.cm_DominatorLimit = 6;
		SessionOptions.cm_MaxSpecials = 6;
		SessionOptions.JockeyLimit = 3;
		SessionOptions.ChargerLimit = 3;
	}
	else if ( random_chance == 13 )
	{
		SessionOptions.cm_DominatorLimit = 6;
		SessionOptions.cm_MaxSpecials = 6;
		SessionOptions.SpitterLimit = 3;
		SessionOptions.JockeyLimit = 3;
	}
	else if ( random_chance == 14 )
	{
		SessionOptions.cm_DominatorLimit = 8;
		SessionOptions.cm_MaxSpecials = 8;
		SessionOptions.SmokerLimit = 3;
		SessionOptions.BoomerLimit = 2;
		SessionOptions.HunterLimit = 3;
	}
	else if ( random_chance == 15 )
	{
		SessionOptions.cm_DominatorLimit = 8;
		SessionOptions.cm_MaxSpecials = 8;
		SessionOptions.SpitterLimit = 3;
		SessionOptions.JockeyLimit = 2;
		SessionOptions.ChargerLimit = 3;
	}
	else if ( random_chance == 16 )
	{
		if ( Entities.FindByClassname( null, "trigger_finale" ) || Entities.FindByClassname( null, "trigger_finale_dlc3" ) )
			ChooseRandomSettings();
		else
		{
			SessionOptions.cm_CommonLimit = 15;
			SessionOptions.cm_DominatorLimit = 4;
			SessionOptions.cm_MaxSpecials = 4;
			SessionOptions.cm_SpecialRespawnInterval = 30;
			SessionOptions.SpecialInitialSpawnDelayMin = 5;
			SessionOptions.SpecialInitialSpawnDelayMax = 10;
			SessionOptions.SmokerLimit = 1;
			SessionOptions.BoomerLimit = 1;
			SessionOptions.HunterLimit = 1;
			SessionOptions.SpitterLimit = 1;
			SessionOptions.JockeyLimit = 1;
			SessionOptions.ChargerLimit = 1;
			SessionOptions.WitchLimit = 0;
			SessionOptions.cm_WitchLimit = 0;
			SessionState.enable_tanks = true;
		}
	}
}

function OnGameEvent_round_start_post_nav( params )
{
	ChooseRandomSettings();
}

function Update()
{
	if ( SessionState.SpawnTankThink )
		SpawnTankThink();
}
