//-----------------------------------------------------
Msg("Activating Friday Night Zombie Run!!\n");
Msg("Made by ANG3Lskye\n");

IncludeScript("zsl_base");

ZSLOptions <-
{
	cm_AllowSurvivorRescue = 0
	//cm_BaseCommonAttackDamage = 100
	cm_CommonLimit = 40
	//cm_HeadshotOnly = 1
	cm_MaxSpecials = 0
	cm_ShouldHurry = 1
	cm_DominatorLimit = 0
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	AlwaysAllowWanderers = true
	NumReservedWanderers = 40
	PreferredMobDirection = SPAWN_ANYWHERE //SPAWN_IN_FRONT_OF_SURVIVORS
	SurvivorMaxIncapacitatedCount = 1

	DefaultItems =
	[
		//"weapon_pistol_magnum",
		//"weapon_pistol",
		//"weapon_pistol",
		"weapon_rifle_m60"
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
}

ZSLState <-
{
	ZSL_OnTakeDamageFunc = function( damageTable )
	{
		if ( NetProps.GetPropInt( damageTable.Attacker, "m_iTeamNum" ) == 3 && NetProps.GetPropInt( damageTable.Victim, "m_iTeamNum" ) == 2 )
			damageTable.DamageDone = 100;

		return true;
	}
	IsRaceEvent = false
	TieBreaker = "kills"
	InfectedKillTimer = {}
}

AddDefaultsToTable( "ZSLOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ZSLState", g_ModeScript, "MutationState", g_ModeScript );

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.GiveItem( "molotov" );
	player.GiveUpgrade( DirectorScript.UPGRADE_LASER_SIGHT );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}

function OnGameEvent_revive_success( params )
{
	if ( !("subject" in params) )
		return;
	
	local player = GetPlayerFromUserID( params["subject"] );
	
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;
	
	NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
	player.SetHealthBuffer( 100 );
	player.SetHealth( 1 );
	NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", 255 );
}

function KillCommonInfected( infectedIndex )
{
	local infected = EntIndexToHScript( infectedIndex );
	if ( (!infected) || (!infected.IsValid()) )
		return;
	
	if ( infected in SessionState.InfectedKillTimer )
		infected.TakeDamage( infected.GetHealth(), 0, Entities.First() );
}

function OnGameEvent_player_incapacitated( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	local invTable = {};
	GetInvTable( player, invTable );
	if ( "slot1" in invTable )
		invTable["slot1"].Kill();
}

function OnGameEvent_player_death( params )
{
	local victim = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( ( !victim ) || ( victim.GetClassname() != "infected" ) )
		return;
	
	if ( victim in SessionState.InfectedKillTimer )
		SessionState.InfectedKillTimer.rawdelete(victim);
}

function Update()
{
	if ( Director.HasAnySurvivorLeftSafeArea() )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
		{
			local index = infected.GetEntityIndex();
			if ( !(index in SessionState.InfectedKillTimer) && (NetProps.GetPropInt( infected, "m_lifeState" ) == 0) )
			{
				SessionState.InfectedKillTimer[infected] <- true;
				EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillCommonInfected(" + index + ")", 30.0 );
			}
			
			if ( NetProps.GetPropInt( infected, "m_mobRush" ) == 0 )
				NetProps.SetPropInt( infected, "m_mobRush", 1 );
		}
	}
}
