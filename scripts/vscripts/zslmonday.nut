//-----------------------------------------------------
Msg("Activating Monday Night Survivor Race!!\n");
Msg("Made by ANG3Lskye\n");

IncludeScript("zsl_base");

ZSLOptions <-
{
	cm_AllowSurvivorRescue = 0
	cm_AutoReviveFromSpecialIncap = 1
	cm_CommonLimit = 0
	//cm_FirstManOut = 1
	cm_MaxSpecials = 12
	cm_DominatorLimit = 12
	cm_ProhibitBosses = false
	BoomerLimit = 2
	SmokerLimit = 2
	HunterLimit = 2
	ChargerLimit = 2
	SpitterLimit = 2
	JockeyLimit = 2
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	cm_SpecialRespawnInterval = 5
	cm_AggressiveSpecials = 1
	SpecialInitialSpawnDelayMin = 5
	SpecialInitialSpawnDelayMax = 5
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	TankHitDamageModifierCoop = 0.01

	DefaultItems =
	[
		"weapon_pistol",
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
		if ( (damageTable.Victim.IsPlayer()) && (damageTable.Victim.IsSurvivor()) )
		{
			if ( (damageTable.Attacker.IsPlayer()) && (!damageTable.Attacker.IsSurvivor()) )
			{
				if ( g_ModeScript.HasSurvivorPinned( damageTable.Attacker ) )
				{
					local attackerIndex = damageTable.Attacker.GetEntityIndex();
					if ( !(attackerIndex in SessionState.KillSIQueue) )
					{
						SessionState.KillSIQueue[attackerIndex] <- true;
						EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillPinningSI(" + damageTable.Attacker.GetPlayerUserId() + ")", 3.0 );
					}
				}
				else
				{
					if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_SPITTER && (damageTable.DamageType == 263168 || damageTable.DamageType == 265216) )
						damageTable.Victim.OverrideFriction( 0.5, 2.8 );
				}
			}
			if ( SessionState.AllowRevive )
			{
				if ( damageTable.Attacker.GetClassname() != "worldspawn" )
				{
					if ( damageTable.DamageType == (damageTable.DamageType | (1 << 14)) || damageTable.DamageType == (damageTable.DamageType | (1 << 5)) )
					{
						if ( GetCharacterDisplayName( damageTable.Victim ) in SessionState.SurvivorWarpLocations )
							damageTable.Victim.SetOrigin( SessionState.SurvivorWarpLocations[GetCharacterDisplayName( damageTable.Victim )] );
					}
				}
				return false;
			}
		}

		return true;
	}
	HasSurvivalFinale = false
	EventRules = "[RULES] Reach saferoom ahead of teammates! 1st: 3 points! 2nd: 2 points! 3rd: 1 point! 4th = Dead! Finale = RESCUE RACE! Reach rescue before the others: 2 points! Most points wins! [TIE BREAKER = Player with least damage taken wins!"
	IsRaceEvent = true
	VehicleAward = 2
	TieBreaker = "kills"
	KillSIQueue = {}
	SurvivorWarpLocations = {}
}

AddDefaultsToTable( "ZSLOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ZSLState", g_ModeScript, "MutationState", g_ModeScript );

function HasSurvivorPinned( infected )
{
	local isPinning = false;
	switch( infected.GetZombieType() )
	{
		case 1:
		{
			isPinning = NetProps.GetPropInt( infected, "m_tongueVictim" ) > 0;
			break;
		}
		case 3:
		{
			isPinning = NetProps.GetPropInt( infected, "m_pounceVictim" ) > 0;
			break;
		}
		case 5:
		{
			isPinning = NetProps.GetPropInt( infected, "m_jockeyVictim" ) > 0;
			break;
		}
		case 6:
		{
			isPinning = (NetProps.GetPropInt( infected, "m_pummelVictim" ) > 0 || NetProps.GetPropInt( infected, "m_carryAttacker" ) > 0);
			break;
		}
	}
	return isPinning;
}

function KillPinningSI( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (player.IsSurvivor()) )
		return;

	if ( NetProps.GetPropInt( player, "m_lifeState" ) == 0 )
	{
		SessionState.KillSIQueue.rawdelete(player.GetEntityIndex());
		if ( HasSurvivorPinned( player ) )
			player.TakeDamage( player.GetHealth(), 0, Entities.First() );
	}
}

function StoreSurvivorLocations()
{
	foreach( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
		{
			local flags = NetProps.GetPropInt( survivor, "m_fFlags" );
			if ( flags == ( flags | 1 ) )
				SessionState.SurvivorWarpLocations[GetCharacterDisplayName( survivor )] <- survivor.GetOrigin();
		}
	}
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.StoreSurvivorLocations()", 5.0 );
}

function OnGameEvent_player_left_safe_area( params )
{
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.StoreSurvivorLocations()", 5.0 );
}

function OnGameEvent_player_now_it( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	NetProps.SetPropFloat( player, "m_itTimer.m_timestamp", Time() + 0.1 );
	player.OverrideFriction( 10.0, 2.0 );
}

function OnGameEvent_revive_success( params )
{
	if ( !("subject" in params) )
		return;
	
	local player = GetPlayerFromUserID( params["subject"] );
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;
	
	player.SetHealth( 100 );
	player.SetHealthBuffer( 0 );
	player.SetReviveCount( 0 );
	NetProps.SetPropInt( player, "m_isGoingToDie", 0 );
	NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
	StopSoundOn( "Player.Heartbeat", player );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (player.IsSurvivor()) )
		return;

	local health = player.GetHealth() / 2;
	player.SetMaxHealth( health );
	player.SetHealth( health );
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	if ( ( !victim ) || ( victim.IsSurvivor() ) )
		return;
	
	SessionState.KillSIQueue.rawdelete( victim.GetEntityIndex() );
}
