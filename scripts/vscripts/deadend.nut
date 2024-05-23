//-----------------------------------------------------
Msg("Activating Dead End\n");

MutationOptions <-
{
	weaponsToRemove =
	{
		weapon_defibrillator = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return false;
		}
		return true;
	}
}

MutationState <-
{
	AllSurvivors = []
}

::DeadSurvivor <-
{
	Coach = false
	Ellis = false
	Nick = false
	Rochelle = false
	Bill = false
	Francis = false
	Louis = false
	Zoey = false
}

::AliveSurvivor <-
{
	Amount = 4
}

function OnGameplayStart()
{
	Say( null, "If you die there is no coming back, so be careful that this doesn't become your Dead End.", false );
}

function OnShutdown()
{
	if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_ROUND_RESTART )
	{
		RestoreTable( "DeadSurvivors", DeadSurvivor );
		SaveTable( "DeadSurvivors", DeadSurvivor );
	}
	else if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_LEVEL_TRANSITION )
	{
		local nextMap = "";
		local changelevel = null;
		if ( changelevel = Entities.FindByClassname( changelevel, "info_changelevel" ) )
			nextMap = NetProps.GetPropString( changelevel, "m_mapName" );
		else if ( changelevel = Entities.FindByClassname( changelevel, "trigger_changelevel" ) )
			nextMap = NetProps.GetPropString( changelevel, "m_mapName" );

		if ( SessionState.NextMap != nextMap )
			return;

		SaveTable( "DeadSurvivors", DeadSurvivor );
	}
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	
	if ( ( !victim ) || ( !victim.IsSurvivor() ) )
		return;
	
	if ( Director.HasAnySurvivorLeftSafeArea() )
		EntFire( "survivor_death_model", "BecomeRagdoll" );
	else
		EntFire( "survivor_death_model", "Kill" );

	g_ModeScript.DeadSurvivor[GetCharacterDisplayName( victim )] = true;
	g_ModeScript.AliveSurvivor.Amount--;

	if ( ResponseCriteria.GetValue( victim, "campaign" ) == "l4d2_7" && g_ModeScript.AliveSurvivor.Amount == 1 )
	{
		Say( null, "Survivors Failed: You need at least 2 living Survivors in order to complete this Campaign.", false );
		foreach( survivor in SessionState.AllSurvivors )
		{
			survivor.SetReviveCount( 2 );
			survivor.TakeDamage( survivor.GetMaxHealth(), 0, null );
		}
	}
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( (GetCharacterDisplayName( player ) in DeadSurvivor) && (DeadSurvivor[GetCharacterDisplayName( player )]) )
	{
		local invTable = {};
		GetInvTable( player, invTable );
		foreach( weapon in invTable )
			weapon.Kill();
		player.SetReviveCount( 2 );
		player.TakeDamage( player.GetMaxHealth(), 0, null );
		if ( !Director.HasAnySurvivorLeftSafeArea() )
			DoEntFire( "!self", "CancelCurrentScene", "", 0, null, player );
	}
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) || (SessionState.AllSurvivors.find( player ) != null) )
		return;

	SessionState.AllSurvivors.append( player );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}

function OnGameEvent_round_start_post_nav( params )
{
	RestoreTable( "DeadSurvivors", DeadSurvivor );
}
