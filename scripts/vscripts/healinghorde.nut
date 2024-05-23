//-----------------------------------------------------
Msg("Activating Healing Horde\n");

MutationOptions <-
{
	cm_TempHealthOnly = 1
	cm_AllowPillConversion = 0
	cm_ShouldHurry = 1
	//cm_AggressiveSpecials = 1
	//cm_AutoReviveFromSpecialIncap = 1
	cm_CommonLimit = 20
	//cm_DominatorLimit = 10
	cm_MaxSpecials = 0
	cm_ProhibitBosses = true
	//cm_SpecialRespawnInterval = 0
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	//PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	//SpecialInfectedAssault = 1
	//SpecialInitialSpawnDelayMin = 0
	//SpecialInitialSpawnDelayMax = 5
	SurvivorMaxIncapacitatedCount = 1

	WitchLimit = 0
	cm_WitchLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	
	weaponsToRemove =
	{
		weapon_defibrillator = 0
		weapon_adrenaline = 0
		weapon_pain_pills = 0
		weapon_first_aid_kit = 0
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

	if ( damageTable.Attacker.GetClassname() == "infected" && NetProps.GetPropInt( damageTable.Victim, "m_iTeamNum" ) == 2 )
	{
		damageTable.DamageDone = 20;
	}

	return true;
}

function OnGameplayStart()
{
	Say( null, "Kill baddies to get health. If hp reaches 0 you incap, if black and white you die.", false );
}

function ForcePanicThink()
{
	EntFire( "info_director", "ForcePanicEvent" );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ForcePanicThink()", 15.0 );
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

function OnGameEvent_player_left_safe_area( params )
{
	if ( !Entities.FindByClassname( null, "trigger_finale" ) )
		ForcePanicThink();
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	
	if ( ( !victim ) || ( !victim.IsSurvivor() ) )
		return;
	
	EntFire( "survivor_death_model", "BecomeRagdoll" );
}

function OnGameEvent_infected_death( params )
{
	if ( !("attacker" in params) )
		return;
	
	local attacker = GetPlayerFromUserID( params["attacker"] );
	if ( !attacker )
		return;
	
	if ( attacker.IsSurvivor() )
	{
		if ( attacker.GetHealthBuffer() <= 97.5 )
			attacker.SetHealthBuffer( attacker.GetHealthBuffer() + 2.5 );
		else
			attacker.SetHealthBuffer( 100 );
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
}
