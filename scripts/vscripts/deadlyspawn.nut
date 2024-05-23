//-----------------------------------------------------
Msg("Activating Deadly Spawn\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	cm_AggressiveSpecials = 1
	cm_CommonLimit = 0
	cm_DominatorLimit = 10
	cm_MaxSpecials = 10
	cm_SpecialRespawnInterval = 0
	cm_SpecialSlotCountdownTime = 0
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	//cm_ProhibitBosses = true
	SpecialInfectedAssault = 1
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 5
	//ShouldAllowSpecialsWithTank = true
	//ZombieTankHealth = 5000
	FarAcquireRange = 999999
	NearAcquireRange = 999999
	FarAcquireTime = 0.0
	NearAcquireTime = 0.0
	
	BoomerLimit = 2
	SmokerLimit = 2
	HunterLimit = 2
	ChargerLimit = 2
	SpitterLimit = 2
	JockeyLimit = 2
	
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

MutationState <-
{
	AllSurvivors = []
}

function OnGameplayStart()
{
	Say( null, "If your temporary health drains to zero you will be incapped, if black and white you will die.", false );
}

function OnGameEvent_player_death( params )
{
	local victim = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( !victim )
		return;

	if ( victim.GetClassname() == "infected" )
		return;

	if ( (victim.IsPlayer()) && (victim.IsSurvivor()) )
		EntFire( "survivor_death_model", "BecomeRagdoll" );
	else
	{
		local amount = 10;
		local vectorOverride = 10;
		if ( victim.GetClassname() == "witch" )
			amount = 40;
		else if ( victim.IsPlayer() )
		{
			if ( victim.GetZombieType() == DirectorScript.ZOMBIE_BOOMER )
			{
				for ( local player; player = Entities.FindByClassname( player, "player" ); )
				{
					if ( player.IsSurvivor() )
						continue;

					if ( player.GetZombieType() != DirectorScript.ZOMBIE_TANK )
						player.TakeDamage( player.GetHealth(), 0, null );
				}
				amount = 20;
			}
			else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_TANK )
				amount = 60;
		}
			
		for ( local i = 0; i < amount; i++ )
		{
			ZSpawn( { type = 0, pos = victim.GetOrigin() + Vector( vectorOverride, 0, 0 ) } );
			vectorOverride += 10;
		}
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			NetProps.SetPropInt( infected, "m_mobRush", 1 );
	}
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
	if ( (!player) || (!player.IsSurvivor()) || (SessionState.AllSurvivors.find( player ) != null) )
		return;

	SessionState.AllSurvivors.append( player );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
	foreach( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 && !survivor.IsIncapacitated() )
		{
			if ( survivor.GetHealthBuffer() == 0 && NetProps.GetPropInt( survivor, "m_currentReviveCount" ) > 0 )
			{
				survivor.TakeDamage( survivor.GetHealth(), 0, null );
			}
		}
	}
}
