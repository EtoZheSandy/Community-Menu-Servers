//-----------------------------------------------------
Msg("Activating Witchcraft\n");
Msg("Made by Rayman1103\n");

if ( !IsModelPrecached( "models/infected/witch.mdl" ) )
	PrecacheModel( "models/infected/witch.mdl" );
if ( !IsModelPrecached( "models/infected/witch_bride.mdl" ) )
	PrecacheModel( "models/infected/witch_bride.mdl" );

Entities.First().__KeyValueFromInt( "timeofday", 2 );

MutationOptions <-
{
	AllowWitchesInCheckpoints = true
	cm_ProhibitBosses = 1
	cm_CommonLimit = 0
	cm_DominatorLimit = 0
	cm_MaxSpecials = 0
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 30
	cm_WitchLimit = 30

	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_vomitjar =	"weapon_molotov_spawn"
		ammo =	"upgrade_laser_sight"
	}

	function ConvertWeaponSpawn( classname )
	{
		if ( classname in weaponsToConvert )
		{
			return weaponsToConvert[classname];
		}
		return 0;
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
}

MutationState <-
{
	WitchWarping = {}
	FinaleStarted = false
	AllSurvivors = []
}

function SpawnWitchThink()
{
	local witchType = 7;
	if ( RandomInt( 0, 1 ) == 1 )
		witchType = 11;

	ZSpawn( { type = witchType } );

	local delay = 5.0;
	if ( SessionState.FinaleStarted )
		delay = 3.0
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SpawnWitchThink()", delay );
}

function WarpBackWitch( witchIndex, x, y, z )
{
	local witch = EntIndexToHScript( witchIndex );
	if ( !witch )
		return;

	witch.SetOrigin( Vector( x, y, z ) );
	witch.__KeyValueFromInt( "solid", 2 );
	witch.__KeyValueFromInt( "rendermode", 0 );
	witch.__KeyValueFromInt( "renderfx", 0 );
	SessionState.WitchWarping[ witchIndex ] <- false;
}

function StartleWitch( witchIndex, attackerID )
{
	local witch = EntIndexToHScript( witchIndex );
	local attacker = GetPlayerFromUserID( attackerID );
	if ( !witch || !attacker )
		return;

	witch.TakeDamage( 0, 0, attacker );
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( (damageTable.Inflictor) && (damageTable.Inflictor.GetClassname() == "pipe_bomb_projectile") )
	{
		if ( damageTable.Victim.GetClassname() == "witch" )
			damageTable.DamageDone = 1000;
		else if ( (damageTable.Victim.IsPlayer()) && (damageTable.Victim.IsSurvivor()) )
			return false;
	}
	if ( damageTable.Victim.GetClassname() == "witch" )
	{
		if ( (damageTable.Victim.GetEntityIndex() in SessionState.WitchWarping) && (SessionState.WitchWarping[damageTable.Victim.GetEntityIndex()]) )
			return false;
	}
	else if ( (damageTable.Victim.IsPlayer()) && (damageTable.Victim.IsSurvivor()) )
	{
		if ( damageTable.Attacker.GetClassname() == "witch" )
		{
			if ( (damageTable.Attacker.GetEntityIndex() in SessionState.WitchWarping) && (SessionState.WitchWarping[damageTable.Attacker.GetEntityIndex()]) )
				return false;
			
			if ( !damageTable.Victim.IsIncapacitated() )
			{
				if ( GetDifficulty() == 0 )
					damageTable.DamageDone = 15;
				else if ( GetDifficulty() == 1 )
					damageTable.DamageDone = 20;
				else if ( GetDifficulty() == 2 )
					damageTable.DamageDone = 25;
				else if ( GetDifficulty() == 3 )
					damageTable.DamageDone = 50;
			}
		}
	}

	return true;
}

function OnGameEvent_witch_spawn( params )
{
	local witch = EntIndexToHScript( params["witchid"] );
	
	local validTargets = [];
	foreach ( survivor in SessionState.AllSurvivors )
	{
		if ( !survivor.IsIncapacitated() )
			validTargets.append( survivor );
	}
	
	if ( validTargets.len() == 0 )
		return;
	
	local randomTarget = validTargets[ RandomInt( 0, validTargets.len() - 1 ) ];
	
	if ( !IsPlayerABot( randomTarget ) )
	{
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.StartleWitch(" + params["witchid"] + "," + randomTarget.GetPlayerUserId() + ")", 0.2 );
		return;
	}
	
	witch.__KeyValueFromInt( "rendermode", 23 );
	witch.__KeyValueFromInt( "renderfx", 15 );
	witch.__KeyValueFromInt( "solid", 1 );
	local spawnLocation = witch.GetOrigin();
	SessionState.WitchWarping[witch.GetEntityIndex()] <- true;
	witch.SetOrigin( randomTarget.GetOrigin() );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.WarpBackWitch(" + params["witchid"] + "," + spawnLocation.x + "," + spawnLocation.y + "," + spawnLocation.z + ")", 0.4 );
}

function OnGameEvent_round_start_post_nav( params )
{
	EntFire( "info_zombie_spawn", "Kill" );
	EntFire( "tankdoorout_button", "Unlock" );
	EntFire( "tank_sound_timer", "Kill" );

	if ( SessionState.MapName == "AirCrash" )
	{
		EntFire( "breakwall1", "Break" );
		EntFire( "breakwall2", "Break" );
		EntFire( "breakwall_stop", "Kill" );
	}
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) || (SessionState.AllSurvivors.find( player ) != null) )
		return;

	SessionState.AllSurvivors.append( player );
}

function OnGameEvent_player_left_safe_area( params )
{
	SpawnWitchThink();
}

if ( IsMissionFinalMap() )
{
	function OnGameEvent_finale_start( params )
	{
		SessionState.FinaleStarted = true;
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

local witchcraft_rules =
[
	{
		name = "WitchStartAttackOverride",
		criteria = [ [ "concept", "WitchStartAttack" ] ],
		responses = [ { scenename = "" } ],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	},
	{
		name = "WitchGettingAngryOverride",
		criteria = [ [ "concept", "WitchGettingAngry" ] ],
		responses = [ { scenename = "" } ],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	},
	{
		name = "FaultOverride",
		criteria = [ [ "concept", "Fault" ] ],
		responses = [ { scenename = "" } ],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	}
]
g_rr.rr_ProcessRules( witchcraft_rules );
