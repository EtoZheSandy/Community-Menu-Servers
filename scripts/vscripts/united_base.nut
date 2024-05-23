//-----------------------------------------------------

IncludeScript("united_responserules");

if ( !IsModelPrecached( "models/survivors/survivor_namvet.mdl" ) )
	PrecacheModel( "models/survivors/survivor_namvet.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_biker.mdl" ) )
	PrecacheModel( "models/survivors/survivor_biker.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_manager.mdl" ) )
	PrecacheModel( "models/survivors/survivor_manager.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_teenangst.mdl" ) )
	PrecacheModel( "models/survivors/survivor_teenangst.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_gambler.mdl" ) )
	PrecacheModel( "models/survivors/survivor_gambler.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_producer.mdl" ) )
	PrecacheModel( "models/survivors/survivor_producer.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_mechanic.mdl" ) )
	PrecacheModel( "models/survivors/survivor_mechanic.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_coach.mdl" ) )
	PrecacheModel( "models/survivors/survivor_coach.mdl" );

if ( Convars.GetFloat( "sb_l4d1_survivor_behavior" ) > 0 )
	Convars.SetValue( "sb_l4d1_survivor_behavior", 0 );

MutationState <-
{
	SpawnedL4D1Survivors = false
	RestoredTables = false
	L4D2WeaponsEquiped = {}
	SpawnLocation = {}
	AllSurvivors = []
}

::L4D1Data <-
{
	givemedkits = true
}

UnitedMapData <-
{
	maprestarts = 0
}

SurvivorDefaults <-
{
	weapons = { slot0 = "", slot1 = "", slot2 = "", slot3 = "", slot4 = "", slot5 = "" }
	misc = {}
	stats = {}
	hasdualpistols = false
	isdead = false
	primaryammo = 0
	primaryclip = -1
	secondaryclip = -1
	upgradeammo = 0
	upgradetype = 0
}

if ( Director.GetSurvivorSet() == 1 )
{
	::L4D1Data.Nick <- DuplicateTable(SurvivorDefaults);
	::L4D1Data.Rochelle <- DuplicateTable(SurvivorDefaults);
	::L4D1Data.Ellis <- DuplicateTable(SurvivorDefaults);
	::L4D1Data.Coach <- DuplicateTable(SurvivorDefaults);
}
else
{
	::L4D1Data.Bill <- DuplicateTable(SurvivorDefaults);
	::L4D1Data.Francis <- DuplicateTable(SurvivorDefaults);
	::L4D1Data.Louis <- DuplicateTable(SurvivorDefaults);
	::L4D1Data.Zoey <- DuplicateTable(SurvivorDefaults);
}

function GetSurvivorName( survivor )
{
	if ( Director.GetSurvivorSet() == 1 )
	{
		local model = survivor.GetModelName();
		
		if ( model == "models/survivors/survivor_gambler.mdl" )
			return "Nick";
		else if ( model == "models/survivors/survivor_producer.mdl" )
			return "Rochelle";
		else if ( model == "models/survivors/survivor_mechanic.mdl" )
			return "Ellis";
		else if ( model == "models/survivors/survivor_coach.mdl" )
			return "Coach";
		else
			return GetCharacterDisplayName( survivor );
	}
	else
	{
		local survivorCharacter = NetProps.GetPropInt( survivor, "m_survivorCharacter" );
		if ( survivorCharacter == 4 )
			return "Bill";
		else if ( survivorCharacter == 5 )
			return "Zoey";
		else if ( survivorCharacter == 6 )
			return "Francis";
		else if ( survivorCharacter == 7 )
			return "Louis";
		else if ( survivorCharacter > 7 && NetProps.GetPropInt( survivor, "m_iTeamNum" ) == 4 )
			return "Survivor";
		else
			return GetCharacterDisplayName( survivor );
	}
}

function OnShutdown()
{
	if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_ROUND_RESTART )
	{
		RestoreTable( "L4D1Data", L4D1Data );
		SaveTable( "L4D1Data", L4D1Data );
		UnitedMapData.maprestarts++;
		SaveTable( "UnitedMapData", UnitedMapData );
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

		L4D1Data.givemedkits = false;
		SaveTable( "L4D1Data", L4D1Data );
	}
}

if ( Director.GetMapName() == "c6m3_port" )
{
	EntFire( "relay_coop_setup", "Kill" );
	EntFire( "elevator_nav_blocker", "BlockNav" );
	EntFire( "relay_quiet_script", "Enable" );
	EntFire( "gas_nozzle", "StopGlowing" );
	EntFire( "gascans", "TurnGlowsOff" );
}

function OnGameEvent_round_start( params )
{
	if ( !SessionState.RestoredTables )
	{
		RestoreTable( "L4D1Data", L4D1Data );
		RestoreTable( "UnitedMapData", UnitedMapData );
		SessionState.RestoredTables = true;
	}
}

function OnGameEvent_round_start_post_nav( params )
{
	if ( SessionState.MapName == "c6m1_riverbank" )
	{
		EntFire( "branch_zoey", "Kill" );
		EntFire( "trigger_multiple", "Kill" );

		for ( local survivorPos; survivorPos = Entities.FindByClassname( survivorPos, "info_survivor_position" ); )
		{
			if ( survivorPos.GetName().find( "survivorPos_intro" ) == null )
				survivorPos.Kill();
		}
	}
	else if ( SessionState.MapName == "c6m3_port" )
	{
		EntFire( "francis_outro", "Kill" );
		EntFire( "louis_outro", "Kill" );
		EntFire( "zoey_outro", "Kill" );
	}
	
	EntFire( "info_l4d1_survivor_spawn", "Kill" );
	EntFire( "l4d1_survivors_relay", "Kill" );
	EntFire( "l4d1_teleport_relay", "Kill" );
	EntFire( "l4d1_script_relay", "Kill" );
}

function RestoreSurvivorCharacter( userid, character )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	NetProps.SetPropInt( player, "m_survivorCharacter", character );
}

function SpawnL4D1Survivors( userid )
{
	if ( Director.GetSurvivorSet() == 1 )
	{
		local player = GetPlayerFromUserID( userid );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		local previousCharacter = NetProps.GetPropInt( player, "m_survivorCharacter" );
		local botName = "bill";
		if ( previousCharacter == 1 )
			botName = "zoey";
		else if ( previousCharacter == 2 )
			botName = "louis";
		else if ( previousCharacter == 3 )
			botName = "francis";
		NetProps.SetPropInt( player, "m_survivorCharacter", 9 );
		for ( local i = 0; i < 4; i++ )
			SendToServerConsole( "sb_add " + botName );

		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.RestoreSurvivorCharacter(" + userid + "," + previousCharacter + ")", 0.1 );
	}
	else
	{
		SendToServerConsole( "sb_add bill" );
		SendToServerConsole( "sb_add francis" );
		SendToServerConsole( "sb_add louis" );
		SendToServerConsole( "sb_add zoey" );
	}
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( NetProps.GetPropInt( player, "m_iTeamNum" ) == 4 )
	{
		local survivorCharacter = NetProps.GetPropInt( player, "m_survivorCharacter" );
		if ( Director.GetSurvivorSet() == 1 )
		{
			if ( survivorCharacter == 4 )
			{
				NetProps.SetPropInt( player, "m_survivorCharacter", 19 );
				player.SetContext( "who", "Gambler", -1 );
				player.SetContext( "DistToClosestSurvivor", "-1", -1 );
				SetFakeClientConVarValue( player, "name", "Nick" );
				player.SetModel( "models/survivors/survivor_gambler.mdl" );
				L4D2SurvivorReEquipWeapons( player );
			}
			else if ( survivorCharacter == 5 )
			{
				NetProps.SetPropInt( player, "m_survivorCharacter", 20 );
				player.SetContext( "who", "Mechanic", -1 );
				player.SetContext( "DistToClosestSurvivor", "-1", -1 );
				SetFakeClientConVarValue( player, "name", "Ellis" );
				player.SetModel( "models/survivors/survivor_mechanic.mdl" );
				L4D2SurvivorReEquipWeapons( player );
			}
			else if ( survivorCharacter == 6 )
			{
				NetProps.SetPropInt( player, "m_survivorCharacter", 21 );
				player.SetContext( "who", "Coach", -1 );
				player.SetContext( "DistToClosestSurvivor", "-1", -1 );
				SetFakeClientConVarValue( player, "name", "Coach" );
				player.SetModel( "models/survivors/survivor_coach.mdl" );
				L4D2SurvivorReEquipWeapons( player );
			}
			else if ( survivorCharacter == 7 )
			{
				NetProps.SetPropInt( player, "m_survivorCharacter", 22 );
				player.SetContext( "who", "Producer", -1 );
				player.SetContext( "DistToClosestSurvivor", "-1", -1 );
				SetFakeClientConVarValue( player, "name", "Rochelle" );
				player.SetModel( "models/survivors/survivor_producer.mdl" );
				L4D2SurvivorReEquipWeapons( player );
			}
		}
		else
		{
			if ( Director.GetGameModeBase() != "survival" )
			{
				if ( L4D1Data.givemedkits )
					player.GiveItem( "first_aid_kit" );
				GiveL4D1Items( player );
			}
		}
		
		NetProps.SetPropInt( player, "m_iTeamNum", 2 );
	}
	else if ( NetProps.GetPropInt( player, "m_iTeamNum" ) == 2 )
	{
		if ( NetProps.GetPropInt( player, "m_survivorCharacter" ) > 9 )
		{
			if ( Director.GetSurvivorSet() == 1 )
			{
				switch ( player.GetModelName() )
				{
					case "models/survivors/survivor_gambler.mdl":
					{
						player.SetContext( "who", "Gambler", -1 );
						player.SetContext( "DistToClosestSurvivor", "-1", -1 );
						SetFakeClientConVarValue( player, "name", "Nick" );
						break;
					}
					case "models/survivors/survivor_producer.mdl":
					{
						player.SetContext( "who", "Producer", -1 );
						player.SetContext( "DistToClosestSurvivor", "-1", -1 );
						SetFakeClientConVarValue( player, "name", "Rochelle" );
						break;
					}
					case "models/survivors/survivor_mechanic.mdl":
					{
						player.SetContext( "who", "Mechanic", -1 );
						player.SetContext( "DistToClosestSurvivor", "-1", -1 );
						SetFakeClientConVarValue( player, "name", "Ellis" );
						break;
					}
					case "models/survivors/survivor_coach.mdl":
					{
						player.SetContext( "who", "Coach", -1 );
						player.SetContext( "DistToClosestSurvivor", "-1", -1 );
						SetFakeClientConVarValue( player, "name", "Coach" );
						break;
					}
					default:
						break;
				}
			}
		}
		if ( UnitedMapData.maprestarts > 0 && Director.GetGameModeBase() != "survival" && NetProps.GetPropInt( player, "m_survivorCharacter" ) > 3 )
		{
			local invTable = {};
			GetInvTable( player, invTable );
			if ( "slot0" in invTable )
				invTable["slot0"].Kill();
			if ( L4D1Data.givemedkits )
				player.GiveItem( "first_aid_kit" );
			GiveL4D1Items( player );
		}
	}
}

function OnGameEvent_player_spawn( params )
{
	if ( !SessionState.RestoredTables )
	{
		RestoreTable( "L4D1Data", L4D1Data );
		RestoreTable( "UnitedMapData", UnitedMapData );
		SessionState.RestoredTables = true;
	}

	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( SessionState.AllSurvivors.find( player ) == null )
	{
		SessionState.AllSurvivors.append( player );
		SessionState.SpawnLocation.rawset( player, player.GetOrigin() );
	}
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );

	if ( UnitedMapData.maprestarts == 0 && !SessionState.SpawnedL4D1Survivors )
	{
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SpawnL4D1Survivors(" + params["userid"] + ")", 0.5 );
		SessionState.SpawnedL4D1Survivors = true;
	}
}

function GiveL4D1Items( player )
{
	foreach( weapon in L4D1Data[GetSurvivorName(player)].weapons )
	{
		if ( ( weapon == "weapon_pistol" ) && ( !L4D1Data[GetSurvivorName(player)].hasdualpistols ) )
			continue;
		player.GiveItem( weapon );
	}
	
	if ( L4D1Data[GetSurvivorName(player)].isdead )
		NetProps.SetPropInt( player, "m_iHealth", Convars.GetFloat( "z_survivor_respawn_health" ).tointeger() );
	else
	{
		foreach( netprop, value in L4D1Data[GetSurvivorName(player)].misc )
			NetProps.SetPropInt( player, netprop, value );
	}
	
	// Temporarily removed
	/*foreach( stat, value in L4D1Data[GetSurvivorName(player)].stats )
	{
		if ( stat.find("m_checkpoint") != null )
		{
			local Stat = Utils.StringReplace(stat, "m_checkpoint", "");
			NetProps.SetPropInt( player, "m_mission" + Stat, value );
		}
	}*/
	
	local invTable = {};
	GetInvTable( player, invTable );
	
	if ( ( "slot0" in invTable ) && ( L4D1Data[GetSurvivorName(player)].primaryclip != -1 ) )
	{
		NetProps.SetPropIntArray( player, "m_iAmmo", L4D1Data[GetSurvivorName(player)].primaryammo, NetProps.GetPropInt( invTable["slot0"], "m_iPrimaryAmmoType" ) );
		NetProps.SetPropInt( invTable["slot0"], "m_iClip1", L4D1Data[GetSurvivorName(player)].primaryclip );
		NetProps.SetPropInt( invTable["slot0"], "m_upgradeBitVec", L4D1Data[GetSurvivorName(player)].upgradetype );
		NetProps.SetPropInt( invTable["slot0"], "m_nUpgradedPrimaryAmmoLoaded", L4D1Data[GetSurvivorName(player)].upgradeammo );
	}
	if ( ( "slot1" in invTable ) && ( invTable["slot1"].GetClassname() != "weapon_melee" ) && ( L4D1Data[GetSurvivorName(player)].secondaryclip != -1 ) )
		NetProps.SetPropInt( invTable["slot1"], "m_iClip1", L4D1Data[GetSurvivorName(player)].secondaryclip );
	
	DoEntFire( "!self", "CancelCurrentScene", "", 0, null, player );
}

function L4D2GiveWeapons( userid, hasDualPistols, activeWeapon )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( hasDualPistols )
		player.GiveItem( "weapon_pistol" );
	foreach( weapon in SessionState.L4D2WeaponsEquiped[player] )
		player.GiveItem( weapon );
	player.SwitchToItem( activeWeapon );
	
	if ( Director.GetGameModeBase() != "survival" )
	{
		if ( L4D1Data.givemedkits )
			player.GiveItem( "first_aid_kit" );
		GiveL4D1Items( player );
	}
}

function L4D2SurvivorReEquipWeapons( player )
{
	local activeWeapon = player.GetActiveWeapon().GetClassname();
	local invTable = {};
	GetInvTable( player, invTable );
	local hasDualPistols = 0;
	SessionState.L4D2WeaponsEquiped.rawset( player, [] );
	if ( ("slot1" in invTable) && (invTable["slot1"].GetClassname() == "weapon_pistol") )
		hasDualPistols = NetProps.GetPropInt( invTable["slot1"], "m_hasDualWeapons" );
	foreach( wep in invTable )
	{
		SessionState.L4D2WeaponsEquiped[player].append( wep.GetClassname() );
		wep.Kill();
	}
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.L4D2GiveWeapons(" + player.GetPlayerUserId() + "," + hasDualPistols + ",\"" + activeWeapon + "\")", 0.1 );
}

function OnGameEvent_map_transition( params )
{
	foreach ( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_survivorCharacter" ) > 3 )
		{
			local SurvivorInv = {};
			GetInvTable( survivor, SurvivorInv );
			
			if ( "slot0" in SurvivorInv )
			{
				L4D1Data[GetSurvivorName(survivor)].weapons.slot0 = SurvivorInv["slot0"].GetClassname();
				L4D1Data[GetSurvivorName(survivor)].upgradetype = NetProps.GetPropInt( SurvivorInv["slot0"], "m_upgradeBitVec" );
				L4D1Data[GetSurvivorName(survivor)].upgradeammo = NetProps.GetPropInt( SurvivorInv["slot0"], "m_nUpgradedPrimaryAmmoLoaded" );
				L4D1Data[GetSurvivorName(survivor)].primaryammo = NetProps.GetPropIntArray( survivor, "m_iAmmo", NetProps.GetPropInt( SurvivorInv["slot0"], "m_iPrimaryAmmoType" ) );

				L4D1Data[GetSurvivorName(survivor)].primaryclip = NetProps.GetPropInt( SurvivorInv["slot0"], "m_iClip1" );
			}
			if ( "slot1" in SurvivorInv )
			{
				L4D1Data[GetSurvivorName(survivor)].weapons.slot1 = SurvivorInv["slot1"].GetClassname();
				if ( SurvivorInv["slot1"].GetClassname() != "weapon_melee" )
					L4D1Data[GetSurvivorName(survivor)].secondaryclip = NetProps.GetPropInt( SurvivorInv["slot1"], "m_iClip1" );
				L4D1Data[GetSurvivorName(survivor)].hasdualpistols = NetProps.GetPropInt( SurvivorInv["slot1"], "m_hasDualWeapons" );
			}
			if ( "slot2" in SurvivorInv )
				L4D1Data[GetSurvivorName(survivor)].weapons.slot2 = SurvivorInv["slot2"].GetClassname();
			if ( "slot3" in SurvivorInv )
				L4D1Data[GetSurvivorName(survivor)].weapons.slot3 = SurvivorInv["slot3"].GetClassname();
			if ( "slot4" in SurvivorInv )
				L4D1Data[GetSurvivorName(survivor)].weapons.slot4 = SurvivorInv["slot4"].GetClassname();
			if ( "slot5" in SurvivorInv )
				L4D1Data[GetSurvivorName(survivor)].weapons.slot5 = SurvivorInv["slot5"].GetClassname();
			
			if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
				L4D1Data[GetSurvivorName(survivor)].isdead = false;
			else
				L4D1Data[GetSurvivorName(survivor)].isdead = true;
			
			// Temporarily removed
			//L4D1Data[GetSurvivorName(survivor)].stats <- survivor.GetStats();
			L4D1Data[GetSurvivorName(survivor)].misc["m_iHealth"] <- NetProps.GetPropInt( survivor, "m_iHealth" );
			L4D1Data[GetSurvivorName(survivor)].misc["m_iMaxHealth"] <- NetProps.GetPropInt( survivor, "m_iMaxHealth" );
			L4D1Data[GetSurvivorName(survivor)].misc["m_healthBuffer"] <- NetProps.GetPropFloat( survivor, "m_healthBuffer" );
			L4D1Data[GetSurvivorName(survivor)].misc["m_currentReviveCount"] <- NetProps.GetPropInt( survivor, "m_currentReviveCount" );
			L4D1Data[GetSurvivorName(survivor)].misc["m_bIsOnThirdStrike"] <- NetProps.GetPropInt( survivor, "m_bIsOnThirdStrike" );
			L4D1Data[GetSurvivorName(survivor)].misc["m_isGoingToDie"] <- NetProps.GetPropInt( survivor, "m_isGoingToDie" );
			NetProps.SetPropInt( survivor, "m_iTeamNum", 4 ); // Needed to prevent missing survivors during map transition
		}
	}
}

function OnGameEvent_upgrade_pack_used( params )
{
	local upgrade = EntIndexToHScript( params["upgradeid"] );
	upgrade.__KeyValueFromInt( "count", 8 );
}

function OnGameEvent_player_hurt( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	local attacker = GetPlayerFromUserID( params["attacker"] );
	if ( (!player) || (!player.IsSurvivor()) || (!attacker) || (!attacker.IsSurvivor()) )
		return;
	
	if ( (NetProps.GetPropInt( player, "m_survivorCharacter" ) < 4) || (NetProps.GetPropInt( player, "m_survivorCharacter" ) == NetProps.GetPropInt( attacker, "m_survivorCharacter" )) )
		return;
	
	local dmgType = params["type"]
	local attackerName = ResponseCriteria.GetValue( attacker, "who" );
	local criteria = "subject:" + attackerName;
	
	if ( dmgType == (dmgType | DirectorScript.DMG_BURN) )
		return;
	
	if ( dmgType == (dmgType | DirectorScript.DMG_BULLET) )
		criteria = criteria + ",damagetype:DMG_BULLET";
	
	QueueSpeak( player, "PlayerFriendlyFire", 0.5, criteria );
}

function OnGameEvent_finale_vehicle_leaving( params )
{
	foreach ( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_survivorCharacter" ) > 3 )
		{
			if ( survivor in SessionState.SpawnLocation )
			{
				local spawnPos = SessionState.SpawnLocation[survivor];
				if (spawnPos)
					survivor.SetOrigin( spawnPos );
			}
			NetProps.SetPropInt( survivor, "m_iTeamNum", 4 );
		}
	}
}

function DoNotSpectateL4D1Survivors( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (IsPlayerABot( player )) )
		return;

	foreach ( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_survivorCharacter" ) > 3 )
		{
			if ( ( NetProps.GetPropInt( survivor, "m_humanSpectatorUserID" ) < 1 ) || ( NetProps.GetPropInt( survivor, "m_humanSpectatorUserID" ) != player.GetPlayerUserId() ) )
				continue;
			
			NetProps.SetPropInt( survivor, "m_humanSpectatorEntIndex", 0 );
			NetProps.SetPropInt( survivor, "m_humanSpectatorUserID", 0 );
			local selectedBot = null;
			
			foreach ( bot in SessionState.AllSurvivors )
			{
				if ( !IsPlayerABot( bot ) )
					continue;

				if ( NetProps.GetPropInt( bot, "m_humanSpectatorUserID" ) < 1 && NetProps.GetPropInt( bot, "m_survivorCharacter" ) < 4 )
				{
					selectedBot = bot;
					break;
				}
			}
			
			if ( !selectedBot )
				continue;
			
			NetProps.SetPropInt( selectedBot, "m_humanSpectatorEntIndex", player.GetEntityIndex() );
			NetProps.SetPropInt( selectedBot, "m_humanSpectatorUserID", player.GetPlayerUserId() );
		}
	}
}

function OnGameEvent_player_team( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (IsPlayerABot( player )) )
		return;
	
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.DoNotSpectateL4D1Survivors(" + params["userid"] + ")", 0.1 );
}
