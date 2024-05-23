//-----------------------------------------------------
Msg("Activating Special Aid\n");

MutationOptions <-
{
	cm_TempHealthOnly = 1
	cm_AllowPillConversion = 0
	cm_ShouldHurry = 1
	cm_AggressiveSpecials = 1
	//cm_AutoReviveFromSpecialIncap = 1
	cm_CommonLimit = 0
	cm_DominatorLimit = 10
	cm_MaxSpecials = 10
	cm_ProhibitBosses = false
	cm_SpecialRespawnInterval = 0
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	SpecialInfectedAssault = 1
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 5
	SurvivorMaxIncapacitatedCount = 1

	SmokerLimit = 2
	BoomerLimit = 2
	HunterLimit = 2
	SpitterLimit = 2
	JockeyLimit = 2
	ChargerLimit = 2
	WitchLimit = 0
	cm_WitchLimit = 0
	
	weaponsToRemove =
	{
		weapon_defibrillator = 0
		weapon_adrenaline = 0
		weapon_pain_pills = 0
		weapon_first_aid_kit = 0
		weapon_vomitjar = 0
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
	
	TempHealthDecayRate = 0.001
	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 1.0 // pain_pills_decay_rate default 0.27
		}
	}
}

MutationState <-
{
	AllSurvivors = []
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( NetProps.GetPropInt( damageTable.Victim, "m_iTeamNum" ) == 2 )
	{
		if ( NetProps.GetPropInt( damageTable.Attacker, "m_iTeamNum" ) == 2 )
			return false;
	}
	else
	{
		if ( damageTable.DamageType == ( DirectorScript.DMG_BLAST | DirectorScript.DMG_BLAST_SURFACE ) && damageTable.Victim.IsPlayer() )
		{
			if ( damageTable.Victim.GetZombieType() == DirectorScript.ZOMBIE_TANK )
				damageTable.DamageDone = 250;
			else
				damageTable.DamageDone = 1000;
		}
	}

	return true;
}

function OnGameplayStart()
{
	Say( null, "Kill baddies to get health. If hp reaches 0 you incap, if black and white you die. Tank kills refresh the group.", false );
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

	if ( SessionState.MapName == "AirCrash" )
	{
		EntFire( "breakwall1", "Break" );
		EntFire( "breakwall2", "Break" );
		EntFire( "breakwall_stop", "Kill" );
	}
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.SetHealthBuffer( player.GetMaxHealth() );
	//player.SetHealth( 0 );
	player.SetReviveCount( 0 );
	NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
	StopSoundOn( "Player.Heartbeat", player );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) || (SessionState.AllSurvivors.find( player ) != null) )
		return;

	SessionState.AllSurvivors.append( player );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	
	if ( !victim )
		return;
	
	if ( victim.IsSurvivor() )
		EntFire( "survivor_death_model", "BecomeRagdoll" );
	else
	{
		local attacker = GetPlayerFromUserID( params["attacker"] );
		if ( !attacker )
			return;
		
		if ( attacker.IsSurvivor() )
		{
			if ( victim.GetZombieType() == DirectorScript.ZOMBIE_TANK )
			{
				foreach( survivor in SessionState.AllSurvivors )
				{
					survivor.ReviveFromIncap();
					survivor.SetHealthBuffer( 100 );
					survivor.SetReviveCount( 0 );
					NetProps.SetPropInt( survivor, "m_bIsOnThirdStrike", 0 );
					StopSoundOn( "Player.Heartbeat", survivor );
					//PrecacheScriptSound( "Gallery.GnomeFTW" );
					EmitSoundOnClient( "Gallery.GnomeFTW", survivor );
				}
			}
			else
			{
				if ( attacker.GetHealthBuffer() <= 75 )
					attacker.SetHealthBuffer( attacker.GetHealthBuffer() + 25 );
				else
					attacker.SetHealthBuffer( 100 );
			}
		}
	}
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
	foreach( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 && !survivor.IsIncapacitated() )
		{
			if ( survivor.GetHealthBuffer() <= 1 && ResponseCriteria.GetValue( survivor, "insafespot" ) == "0" )
				survivor.TakeDamage( survivor.GetHealth(), 0, null );
		}
	}
	if ( Director.GetCommonInfectedCount() >= 1 )
	{
		foreach ( infected in Zombies.CommonInfected() )
			infected.Input( "Kill" );
	}
}
