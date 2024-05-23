//-----------------------------------------------------
Msg("Activating Split Decision: M60 Edition\n");
Msg("Made by Rayman1103\n");

IncludeScript("split");

SplitOptions <-
{
	weaponsToRemove =
	{
		weapon_pistol = 0
		weapon_pistol_magnum = 0
		weapon_smg = 0
		weapon_pumpshotgun = 0
		weapon_autoshotgun = 0
		weapon_rifle = 0
		weapon_hunting_rifle = 0
		weapon_smg_silenced = 0
		weapon_shotgun_chrome = 0
		weapon_rifle_desert = 0
		weapon_sniper_military = 0
		weapon_shotgun_spas = 0
		weapon_grenade_launcher = 0
		weapon_rifle_ak47 = 0
		weapon_smg_mp5 = 0		
		weapon_rifle_sg552 = 0		
		weapon_sniper_awp = 0	
		weapon_sniper_scout = 0
		weapon_rifle_m60 = 0
		weapon_molotov = 0
		weapon_pipe_bomb = 0
		weapon_vomitjar = 0
		weapon_chainsaw = 0
		weapon_defibrillator = 0
		weapon_adrenaline = 0
		weapon_pain_pills = 0
		weapon_first_aid_kit = 0
		weapon_melee = 0
		weapon_upgradepack_explosive = 0
		weapon_upgradepack_incendiary = 0
		upgrade_item = 0
		ammo = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return false;
		}
		return true;
	}

	function ShouldAvoidItem( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return true;
		}
		return false;
	}

	DefaultItems =
	[
		"weapon_rifle_m60",
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
	
	TempHealthDecayRate = 0.001
	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 0.75 // pain_pills_decay_rate default 0.27
		}
	}
}

SplitState <-
{
	AdvanceWaveTimer = 6.9
	HPRegenTime = 2.0
	LastHPRegenTime = 0
	AllSurvivors = []
}

AddDefaultsToTable( "SplitOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "SplitState", g_ModeScript, "MutationState", g_ModeScript );

function OnGameEvent_revive_success( params )
{
	if ( !("subject" in params) )
		return;
	
	local player = GetPlayerFromUserID( params["subject"] );
	
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;
	
	if ( NetProps.GetPropInt( player, "m_currentReviveCount" ) == 2 )
		player.SetHealth( 69 );
	else
		player.SetHealth( 25 );
	player.SetHealthBuffer( 0 );
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.SetHealthBuffer( 0 );
	player.SetHealth( player.GetMaxHealth() );
	player.SetReviveCount( 0 );
	NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
	StopSoundOn( "Player.Heartbeat", player );
	player.GiveUpgrade( DirectorScript.UPGRADE_LASER_SIGHT );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( !player )
		return;

	if ( player.IsSurvivor() )
	{
		if ( SessionState.AllSurvivors.find( player ) == null )
		{
			SessionState.AllSurvivors.append( player );
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
		}
		return;
	}

	local splitAmount = 0;
	if ( player.GetZombieType() == DirectorScript.ZOMBIE_BOOMER )
	{
		if ( SessionState.AllowBoomerSplit )
		{
			if ( SessionState.BoomerSplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				splitAmount = 2;
			}
			else if ( SessionState.BoomerSplitLevel == 2 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				player.SetHealth( player.GetHealth() / 2 );
				splitAmount = 3;
			}
			
			if ( SessionState.BoomersSplit < splitAmount )
			{
				SessionState.BoomersSplit++;
				
				if ( SessionState.BoomersSplit == splitAmount )
				{
					SessionState.AllowBoomerSplit = false;
					SessionState.BoomersSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
		}
	}
	else if ( player.GetZombieType() == DirectorScript.ZOMBIE_SMOKER )
	{
		if ( SessionState.AllowSmokerSplit )
		{
			if ( SessionState.SmokerSplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				splitAmount = 2;
			}
			else if ( SessionState.SmokerSplitLevel == 2 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				player.SetHealth( player.GetHealth() / 2 );
				splitAmount = 3;
			}
			
			if ( SessionState.SmokersSplit < splitAmount )
			{
				SessionState.SmokersSplit++;
				
				if ( SessionState.SmokersSplit == splitAmount )
				{
					SessionState.AllowSmokerSplit = false;
					SessionState.SmokersSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
		}
	}
	else if ( player.GetZombieType() == DirectorScript.ZOMBIE_HUNTER )
	{
		if ( SessionState.AllowHunterSplit )
		{
			if ( SessionState.HunterSplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				//player.SetHealth( 175 );
				splitAmount = 2;
			}
			else if ( SessionState.HunterSplitLevel == 2 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				//player.SetHealth( 150 );
				splitAmount = 3;
			}
			
			if ( SessionState.HuntersSplit < splitAmount )
			{
				SessionState.HuntersSplit++;
				
				if ( SessionState.HuntersSplit == splitAmount )
				{
					SessionState.AllowHunterSplit = false;
					SessionState.HuntersSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
		}
	}
	else if ( player.GetZombieType() == DirectorScript.ZOMBIE_CHARGER )
	{
		if ( SessionState.AllowChargerSplit )
		{
			if ( SessionState.ChargerSplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				player.SetHealth( 400 );
				splitAmount = 2;
			}
			else if ( SessionState.ChargerSplitLevel == 2 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				player.SetHealth( 250 );
				splitAmount = 3;
			}
			
			if ( SessionState.ChargersSplit < splitAmount )
			{
				SessionState.ChargersSplit++;
				
				if ( SessionState.ChargersSplit == splitAmount )
				{
					SessionState.AllowChargerSplit = false;
					SessionState.ChargersSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
		}
	}
	else if ( player.GetZombieType() == DirectorScript.ZOMBIE_SPITTER )
	{
		if ( SessionState.AllowSpitterSplit )
		{
			if ( SessionState.SpitterSplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				splitAmount = 2;
			}
			else if ( SessionState.SpitterSplitLevel == 2 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				splitAmount = 3;
			}
			
			if ( SessionState.SpittersSplit < splitAmount )
			{
				SessionState.SpittersSplit++;
				
				if ( SessionState.SpittersSplit == splitAmount )
				{
					SessionState.AllowSpitterSplit = false;
					SessionState.SpittersSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
		}
	}
	else if ( player.GetZombieType() == DirectorScript.ZOMBIE_JOCKEY )
	{
		if ( SessionState.AllowJockeySplit )
		{
			if ( SessionState.JockeySplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				player.SetHealth( 200 );
				splitAmount = 2;
			}
			else if ( SessionState.JockeySplitLevel == 2 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				player.SetHealth( 150 );
				splitAmount = 3;
			}
			
			if ( SessionState.JockeysSplit < splitAmount )
			{
				SessionState.JockeysSplit++;
				
				if ( SessionState.JockeysSplit == splitAmount )
				{
					SessionState.AllowJockeySplit = false;
					SessionState.JockeysSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
		}
	}
	else if ( player.GetZombieType() == DirectorScript.ZOMBIE_TANK )
	{
		if ( SessionState.AllowTankSplit )
		{
			if ( SessionState.TankSplitLevel == 1 )
			{
				SessionState.FirstClone[player.GetEntityIndex()] <- true;
				player.SetHealth( 2000 );
				splitAmount = 2;
			}
			else if ( SessionState.TankSplitLevel == 2 )
			{
				SessionState.SecondClone[player.GetEntityIndex()] <- true;
				player.SetHealth( 750 );
				splitAmount = 4;
			}
			else if ( SessionState.TankSplitLevel == 3 )
			{
				SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
				player.SetHealth( 500 );
				splitAmount = 3;
			}
			
			if ( SessionState.TanksSplit < splitAmount )
			{
				SessionState.TanksSplit++;
				
				if ( SessionState.TanksSplit == splitAmount )
				{
					SessionState.AllowTankSplit = false;
					SessionState.TanksSplit = 0;
				}
			}
		}
		else
		{
			SessionState.NonClone[player.GetEntityIndex()] <- true;
			SessionState.TankInPlay = true;
			player.SetHealth( 3000 );
		}
	}
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
	if ( SessionState.TriggerRescueThink )
		TriggerRescueThink();
	if ( Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
	if ( (Time() - SessionState.LastHPRegenTime) >= SessionState.HPRegenTime )
	{
		foreach( survivor in SessionState.AllSurvivors )
		{
			if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
			{
				if ( survivor.GetHealth() < survivor.GetMaxHealth() )
					survivor.SetHealth( survivor.GetHealth() + 1 );
			}
		}
		SessionState.LastHPRegenTime = Time();
	}
}
