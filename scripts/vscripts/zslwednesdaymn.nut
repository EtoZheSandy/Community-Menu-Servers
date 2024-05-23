//-----------------------------------------------------
Msg("Activating Wednesday Morning Riot!!\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

IncludeScript("zsl_base");

ZSLOptions <-
{
	cm_CommonLimit = 30
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	cm_ProhibitBosses = 1
	cm_AllowSurvivorRescue = 0
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	SurvivorMaxIncapacitatedCount = 0

	RandomPrimary =
	[
		"autoshotgun",
		"shotgun_spas",
	]
	RandomSecondary =
	[
		"baseball_bat"
	]
	
	function GetDefaultItem(id)
	{
		local PRand = RandomInt(0,RandomPrimary.len()-1);
		local SRand = RandomInt(0,RandomSecondary.len()-1);
		if(id == 0) return RandomPrimary[PRand];
		else if(id == 1) return RandomSecondary[SRand];
		return 0;
	}
}

ZSLState <-
{
	IsRaceEvent = false
	RiotKillTimer = {}
}

AddDefaultsToTable( "ZSLOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ZSLState", g_ModeScript, "MutationState", g_ModeScript );

function OnGameEvent_player_left_safe_area( params )
{
	EntFire( "info_director", "ForcePanicEvent" );
}

function KillRiot( infectedIndex )
{
	local infected = EntIndexToHScript( infectedIndex );
	if ( (!infected) || (!infected.IsValid()) )
		return;

	infected.TakeDamage( infected.GetHealth(), 0, Entities.First() );
}

function OnGameEvent_player_death( params )
{
	local victim = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( (!victim) || (victim.GetClassname() != "infected") )
		return;
	
	if ( NetProps.GetPropInt( victim, "m_Gender" ) == 15 )
	{
		local index = victim.GetEntityIndex();
		if ( index in SessionState.RiotKillTimer )
			SessionState.RiotKillTimer.rawdelete( index );
	}
}

function Update()
{
	for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
	{
		local index = infected.GetEntityIndex();
		if ( !(index in SessionState.RiotKillTimer) && (NetProps.GetPropInt( infected, "m_lifeState" ) == 0) )
		{
			SessionState.RiotKillTimer[index] <- true;
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillRiot(" + index + ")", 60.0 );
		}
	}
}
