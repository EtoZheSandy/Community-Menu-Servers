//-----------------------------------------------------

if ( !IsModelPrecached( "models/survivors/survivor_namvet.mdl" ) )
	PrecacheModel( "models/survivors/survivor_namvet.mdl" );
if ( !IsModelPrecached( "models/survivors/survivor_ceda.mdl" ) )
	PrecacheModel( "models/survivors/survivor_ceda.mdl" );

if ( Convars.GetFloat( "sb_l4d1_survivor_behavior" ) > 0 )
	Convars.SetValue( "sb_l4d1_survivor_behavior", 0 );

VIPBaseState <-
{
	VIP_OnTakeDamageFunc = null
	SpawnedSurvivor = false
	VIPSpawned = false
	VIP = null
	GaveVIPItems = false
	HasPermaWipe = false
	SaveVIPData = true
	SaveVIPHealth = true
	VIPRules = ""
	VIPDeathTime = 0
	VIPDeathDelay = 30.0
	VIPDeathThink = false
	VIPAllowDamageBackup = null
	VIPOnShutdownBackup = null
	RestoredTables = false
	VIPSpawnLocation = null
	VIP_AllSurvivors = []
	VIPSurvivorCharacter = 4
}

AddDefaultsToTable( "VIPBaseState", g_ModeScript, "MutationState", g_ModeScript );

::VIPData <-
{
	Weapons =
	{
		slot0 = ""
		slot1 = ""
		slot2 = ""
		slot3 = ""
		slot4 = ""
	}
	Misc = {}
	Stats = {}
	UpgradeAmmo = 0
	UpgradeType = 0
	givemedkits = true
}

::VIPMapData <-
{
	maprestarts = 0
}

VIPBase <-
{
	function VIPDeathThink()
	{
		if ( (Time() - SessionState.VIPDeathTime) >= SessionState.VIPDeathDelay )
		{
			VIPDefibTimerEnded();
			Say( null, "Mission Failed: You did not revive the Survivor in time!", false );
			SessionState.VIPDeathThink = false;
		}
	}

	function OnGameEvent_round_start_post_nav( params )
	{
		if ( !SessionState.RestoredTables )
		{
			if ( SessionState.SaveVIPData )
				RestoreTable( "VIPData", VIPData );
			RestoreTable( "VIPMapData", VIPMapData );
			SessionState.RestoredTables = true;
		}
	}

	function RestoreSurvivorCharacter( userid, character )
	{
		local player = GetPlayerFromUserID( userid );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		NetProps.SetPropInt( player, "m_survivorCharacter", character );
	}

	function SpawnExtraSurvivor( userid )
	{
		if ( Director.GetSurvivorSet() == 1 )
		{
			local player = GetPlayerFromUserID( userid );
			if ( (!player) || (!player.IsSurvivor()) )
				return;

			local previousCharacter = NetProps.GetPropInt( player, "m_survivorCharacter" );
			local botName = "bill";
			if ( previousCharacter == 1 )
			{
				botName = "zoey";
				SessionState.VIPSurvivorCharacter = 5;
			}
			else if ( previousCharacter == 2 )
			{
				botName = "louis";
				SessionState.VIPSurvivorCharacter = 7;
			}
			else if ( previousCharacter == 3 )
			{
				botName = "francis";
				SessionState.VIPSurvivorCharacter = 6;
			}
			NetProps.SetPropInt( player, "m_survivorCharacter", 9 );
			SendToServerConsole( "sb_add " + botName );
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.VIPBase.RestoreSurvivorCharacter(" + userid + "," + previousCharacter + ")", 0.1 );
		}
		else
			SendToServerConsole( "sb_add bill" );
	}

	function ConvertVIPDelay( userid )
	{
		local player = GetPlayerFromUserID( userid );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		SessionState.VIP = player;
		SessionState.VIPSpawnLocation = player.GetOrigin();
		NetProps.SetPropInt( player, "m_iTeamNum", 2 );
		NetProps.SetPropInt( player, "m_survivorCharacter", 9 );
		player.SetModel( "models/survivors/survivor_ceda.mdl" );
		NetProps.SetPropString( player, "m_ModelName", "models/survivors/survivor_namvet.mdl" );
		SetFakeClientConVarValue( player, "name", "Survivor" );
		
		local glowColor = 65280;
		if ( player.IsOnThirdStrike() )
			glowColor = 255;
		NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", glowColor );
		NetProps.SetPropInt( player, "m_Glow.m_iGlowType", 3 );
		Say( null, SessionState.VIPRules, false );
		if ( SessionState.HasPermaWipe )
			Convars.SetValue( "sv_permawipe", "0" );
		
		if ( SessionState.SaveVIPData && !SessionState.GaveVIPItems )
		{
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.VIPBase.VIPGiveItems(" + userid + ")", 0.1 );
		}

		if ( "DefaultItems" in g_ModeScript.GetDirectorOptions() )
		{
			player.GetActiveWeapon().Kill();
			
			foreach( item in g_ModeScript.GetDirectorOptions().DefaultItems )
				player.GiveItem( item );
		}
	}

	function VIPGiveItems( userid )
	{
		local player = GetPlayerFromUserID( userid );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		if ( VIPData.givemedkits )
			player.GiveItem( "first_aid_kit" );
		
		foreach( weapon in VIPData.Weapons )
			player.GiveItem( weapon );
		
		if ( SessionState.SaveVIPHealth )
		{
			foreach( netprop, value in VIPData.Misc )
			{
				if ( netprop == "m_healthBuffer" )
					NetProps.SetPropFloat( player, netprop, value );
				else
					NetProps.SetPropInt( player, netprop, value );
			}
		}
		
		// Temporarily removed
		/*foreach( stat, value in VIPData.Stats )
		{
			if ( stat.find("m_checkpoint") != null )
			{
				local Stat = Utils.StringReplace(stat, "m_checkpoint", "");
				player.SetNetProp("m_mission" + Stat, value);
			}
		}*/
		
		local invTable = {};
		GetInvTable( player, invTable );
		
		if ( "slot0" in invTable )
		{
			NetProps.SetPropInt( invTable["slot0"], "m_upgradeBitVec", VIPData.UpgradeType );
			NetProps.SetPropInt( invTable["slot0"], "m_nUpgradedPrimaryAmmoLoaded", VIPData.UpgradeAmmo );
		}
		
		SessionState.GaveVIPItems = true;
	}

	function OnGameEvent_player_spawn( params )
	{
		if ( !SessionState.RestoredTables )
		{
			if ( SessionState.SaveVIPData )
				RestoreTable( "VIPData", VIPData );
			RestoreTable( "VIPMapData", VIPMapData );
			SessionState.RestoredTables = true;
		}

		local player = GetPlayerFromUserID( params["userid"] );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		if ( SessionState.VIP_AllSurvivors.find( player ) == null )
			SessionState.VIP_AllSurvivors.append( player );

		if ( NetProps.GetPropInt( player, "m_iTeamNum" ) == 4 && NetProps.GetPropInt( player, "m_survivorCharacter" ) == SessionState.VIPSurvivorCharacter && VIPMapData.maprestarts == 0 )
		{
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.VIPBase.ConvertVIPDelay(" + params["userid"] + ")", 0 );
		}
		else if ( NetProps.GetPropInt( player, "m_survivorCharacter" ) == 9 && !SessionState.VIPSpawned )
		{
			local glowColor = 65280;
			if ( player.IsOnThirdStrike() )
				glowColor = 255;
			
			SessionState.VIP = player;
			SessionState.VIPSpawnLocation = player.GetOrigin();
			SessionState.VIPSpawned = true;
			NetProps.SetPropString( player, "m_ModelName", "models/survivors/survivor_ceda.mdl" );
			SetFakeClientConVarValue( player, "name", "Survivor" );
			NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", glowColor );
			NetProps.SetPropInt( player, "m_Glow.m_iGlowType", 3 );
			Say( null, SessionState.VIPRules, false );
			if ( SessionState.HasPermaWipe )
				Convars.SetValue( "sv_permawipe", "1" );
		}
		
		if ( SessionState.SaveVIPData && !SessionState.GaveVIPItems && NetProps.GetPropInt( player, "m_survivorCharacter" ) == 9 )
		{
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.VIPBase.VIPGiveItems(" + params["userid"] + ")", 0.1 );
		}
		if ( VIPMapData.maprestarts == 0 && !SessionState.SpawnedSurvivor )
		{
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.VIPBase.SpawnExtraSurvivor(" + params["userid"] + ")", 0.5 );
			SessionState.SpawnedSurvivor = true;
		}
	}

	function OnGameEvent_upgrade_pack_used( params )
	{
		local upgrade = EntIndexToHScript( params["upgradeid"] );
		upgrade.__KeyValueFromInt( "count", 5 );
	}

	function StoreVIPData()
	{
		local SurvivorInv = {};
		GetInvTable( SessionState.VIP, SurvivorInv );
		
		if ( "slot0" in SurvivorInv )
		{
			VIPData.Weapons.slot0 = SurvivorInv["slot0"].GetClassname();
			VIPData.UpgradeType = NetProps.GetPropInt( SurvivorInv["slot0"], "m_upgradeBitVec" );
			VIPData.UpgradeAmmo = NetProps.GetPropInt( SurvivorInv["slot0"], "m_nUpgradedPrimaryAmmoLoaded" );
		}
		if ( "slot1" in SurvivorInv )
			VIPData.Weapons.slot1 = SurvivorInv["slot1"].GetClassname();
		if ( "slot2" in SurvivorInv )
			VIPData.Weapons.slot2 = SurvivorInv["slot2"].GetClassname();
		if ( "slot3" in SurvivorInv )
			VIPData.Weapons.slot3 = SurvivorInv["slot3"].GetClassname();
		if ( "slot4" in SurvivorInv )
			VIPData.Weapons.slot4 = SurvivorInv["slot4"].GetClassname();
		
		// Temporarily removed
		//VIPData.Stats <- SessionState.VIP.GetStats();
		if ( SessionState.SaveVIPHealth )
		{
			VIPData.misc["m_iHealth"] <- NetProps.GetPropInt( survivor, "m_iHealth" );
			VIPData.misc["m_iMaxHealth"] <- NetProps.GetPropInt( survivor, "m_iMaxHealth" );
			VIPData.misc["m_healthBuffer"] <- NetProps.GetPropFloat( survivor, "m_healthBuffer" );
			VIPData.misc["m_currentReviveCount"] <- NetProps.GetPropInt( survivor, "m_currentReviveCount" );
			VIPData.misc["m_bIsOnThirdStrike"] <- NetProps.GetPropInt( survivor, "m_bIsOnThirdStrike" );
			VIPData.misc["m_isGoingToDie"] <- NetProps.GetPropInt( survivor, "m_isGoingToDie" );
		}
	}

	function OnGameEvent_map_transition( params )
	{
		if ( SessionState.SaveVIPData )
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.VIPBase.StoreVIPData()", 0.1 );
		
		NetProps.SetPropInt( SessionState.VIP, "m_iTeamNum", 4 );
	}

	function OnGameEvent_heal_success( params )
	{
		local player = GetPlayerFromUserID( params["subject"] );
		if ( ( !player ) || ( !player.IsSurvivor() ) )
			return;
		
		if ( NetProps.GetPropInt( player, "m_survivorCharacter" ) == 9 )
		{
			local glowColor = 65280;
			if ( player.IsOnThirdStrike() )
				glowColor = 255;
			
			NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", glowColor );
		}
	}

	function OnGameEvent_player_incapacitated( params )
	{
		local player = GetPlayerFromUserID( params["userid"] );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		if ( NetProps.GetPropInt( player, "m_survivorCharacter" ) == 9 && player.IsIncapacitated() )
		{
			NetProps.SetPropInt( player, "m_Glow.m_iGlowType", 0 );
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.VIPBase.VIPToggleGlow()", 1.0 );
		}
	}

	function OnGameEvent_revive_success( params )
	{
		if ( !("subject" in params) )
			return;
		
		local player = GetPlayerFromUserID( params["subject"] );
		
		if ( ( !player ) || ( !player.IsSurvivor() ) )
			return;
		
		if ( NetProps.GetPropInt( player, "m_survivorCharacter" ) == 9 )
		{
			if ( player.IsOnThirdStrike() )
				NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", 255 );
			else
				NetProps.SetPropInt( player, "m_Glow.m_glowColorOverride", 33023 );
			
			if ( !player.IsIT() )
				NetProps.SetPropInt( player, "m_Glow.m_iGlowType", 3 );
		}
	}

	function VIPDefibTimerEnded()
	{
		NetProps.SetPropInt( SessionState.VIP, "m_Glow.m_glowColorOverride", 0 );
		for ( local death_model; death_model = Entities.FindByClassname( death_model, "survivor_death_model" ); )
		{
			if ( NetProps.GetPropInt( death_model, "m_nCharacterType" ) == NetProps.GetPropInt( SessionState.VIP, "m_survivorCharacter" ) )
				DoEntFire( "!self", "BecomeRagdoll", "", 0, null, death_model );
		}
		foreach( survivor in SessionState.VIP_AllSurvivors )
		{
			if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
			{
				survivor.SetReviveCount( 2 );
				survivor.TakeDamage( survivor.GetMaxHealth(), 0, Entities.First() );
			}
		}
	}

	function OnGameEvent_player_death( params )
	{
		if ( !("userid" in params) )
			return;
		
		local victim = GetPlayerFromUserID( params["userid"] );
		
		if ( ( !victim ) || ( !victim.IsSurvivor() ) )
			return;
		
		if ( NetProps.GetPropInt( victim, "m_survivorCharacter" ) == 9 )
		{
			if ( Entities.FindByClassname( null, "weapon_defibrillator" ) || Entities.FindByClassname( null, "weapon_defibrillator_spawn" ) )
			{
				EntFire( "info_changelevel", "Disable" );
				EntFire( "trigger_changelevel", "Disable" );
				NetProps.SetPropString( victim, "m_ModelName", "models/survivors/survivor_namvet.mdl" );
				NetProps.SetPropInt( victim, "m_Glow.m_iGlowType", 0 );
				SessionState.VIPDeathTime = Time();
				SessionState.VIPDeathThink = true;
				Say( null, "You have 30 seconds to revive the Survivor!", false );
				
				for ( local defib; defib = Entities.FindByClassname( defib, "weapon_defibrillato*" ); )
					NetProps.SetPropInt( defib, "m_Glow.m_iGlowType", 3 );
			}
			else
			{
				NetProps.SetPropString( victim, "m_ModelName", "models/survivors/survivor_namvet.mdl" );
				NetProps.SetPropInt( victim, "m_Glow.m_iGlowType", 0 );
				VIPDefibTimerEnded();
				Say( null, "Mission Failed: The Survivor has died!", false );
			}
		}
	}

	function OnGameEvent_defibrillator_used( params )
	{
		if ( !("subject" in params) )
			return;
		
		local player = GetPlayerFromUserID( params["subject"] );
		
		if ( ( !player ) || ( !player.IsSurvivor() ) )
			return;
		
		if ( NetProps.GetPropInt( player, "m_survivorCharacter" ) == 9 )
		{
			EntFire( "info_changelevel", "Enable" );
			EntFire( "trigger_changelevel", "Enable" );
			NetProps.SetPropString( player, "m_ModelName", "models/survivors/survivor_ceda.mdl" );
			NetProps.SetPropInt( player, "m_Glow.m_iGlowType", 3 );
			SessionState.VIPDeathThink = false;
			
			if ( Entities.FindByClassname( null, "weapon_defibrillator" ) || Entities.FindByClassname( null, "weapon_defibrillator_spawn" ) )
			{
				for ( local defib; defib = Entities.FindByClassname( defib, "weapon_defibrillato*" ); )
					NetProps.SetPropInt( defib, "m_Glow.m_iGlowType", 0 );
			}
		}
	}

	function VIPToggleGlow()
	{
		if ( !SessionState.VIP.IsIT() && !SessionState.VIP.IsIncapacitated() )
			return;

		local glowType = NetProps.GetPropInt( SessionState.VIP, "m_Glow.m_iGlowType" );
		if ( glowType == 0 )
			NetProps.SetPropInt( SessionState.VIP, "m_Glow.m_iGlowType", 3 );
		else if ( glowType == 3 )
			NetProps.SetPropInt( SessionState.VIP, "m_Glow.m_iGlowType", 0 );

		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.VIPBase.VIPToggleGlow()", 1.0 );
	}

	function OnGameEvent_player_now_it( params )
	{
		local player = GetPlayerFromUserID( params["userid"] );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		if ( NetProps.GetPropInt( player, "m_survivorCharacter" ) == 9 )
		{
			NetProps.SetPropInt( player, "m_Glow.m_iGlowType", 0 );
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.VIPBase.VIPToggleGlow()", 1.0 );
		}
	}

	function OnGameEvent_player_no_longer_it( params )
	{
		local player = GetPlayerFromUserID( params["userid"] );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		if ( NetProps.GetPropInt( player, "m_survivorCharacter" ) == 9 && !player.IsIncapacitated() )
		{
			if ( NetProps.GetPropInt( player, "m_lifeState" ) == 0 )
				NetProps.SetPropInt( player, "m_Glow.m_iGlowType", 3 );
		}
	}

	function OnGameEvent_finale_vehicle_leaving( params )
	{
		local spawnPos = SessionState.VIPSpawnLocation;
		if (spawnPos)
			SessionState.VIP.SetOrigin( spawnPos );
	}

	function DoNotSpectateExtraSurvivor( userid )
	{
		local player = GetPlayerFromUserID( userid );
		if ( (!player) || (IsPlayerABot( player )) )
			return;

		if ( ( NetProps.GetPropInt( SessionState.VIP, "m_humanSpectatorUserID" ) < 1 ) || ( NetProps.GetPropInt( SessionState.VIP, "m_humanSpectatorUserID" ) != player.GetPlayerUserId() ) )
			return;
		
		NetProps.SetPropInt( SessionState.VIP, "m_humanSpectatorEntIndex", 0 );
		NetProps.SetPropInt( SessionState.VIP, "m_humanSpectatorUserID", 0 );
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
			return;
		
		NetProps.SetPropInt( selectedBot, "m_humanSpectatorEntIndex", player.GetEntityIndex() );
		NetProps.SetPropInt( selectedBot, "m_humanSpectatorUserID", player.GetPlayerUserId() );
	}

	function OnGameEvent_player_team( params )
	{
		local player = GetPlayerFromUserID( params["userid"] );
		if ( (!player) || (IsPlayerABot( player )) )
			return;
		
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.VIPBase.DoNotSpectateExtraSurvivor(" + params["userid"] + ")", 0.1 );
	}
}

__CollectEventCallbacks( g_ModeScript.VIPBase, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener );

if ( "AllowTakeDamage" in this )
	MutationState.VIPAllowDamageBackup = AllowTakeDamage;
function AllowTakeDamage( damageTable )
{
	local returnCode = true;
	if ( SessionState.VIPAllowDamageBackup )
		returnCode = SessionState.VIPAllowDamageBackup( damageTable );

	if ( !damageTable.Attacker || !damageTable.Victim )
		return returnCode;

	if ( (damageTable.Victim.IsPlayer()) && (damageTable.Victim.IsSurvivor()) )
	{
		if ( NetProps.GetPropInt( damageTable.Victim, "m_survivorCharacter" ) == 9 )
		{
			if ( damageTable.DamageType == (damageTable.DamageType | DirectorScript.DMG_BURN) )
				return false;
			else if ( damageTable.DamageType == (damageTable.DamageType | (1 << 18)) && damageTable.DamageType == (damageTable.DamageType | (1 << 10)) )
				damageTable.DamageDone = damageTable.DamageDone / 2;
		}
	}

	if ( SessionState.VIP_OnTakeDamageFunc )
		return SessionState.VIP_OnTakeDamageFunc( damageTable );
	else
		return returnCode;
}

if ( "OnShutdown" in this )
	SessionState.VIPOnShutdownBackup = OnShutdown;
function OnShutdown()
{
	if ( SessionState.VIPOnShutdownBackup )
		SessionState.VIPOnShutdownBackup();

	if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_ROUND_RESTART )
	{
		VIPMapData.maprestarts++;
		SaveTable( "VIPMapData", VIPMapData );
	}

	if ( SessionState.SaveVIPData )
	{
		if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_ROUND_RESTART )
		{
			RestoreTable( "VIPData", VIPData );
			SaveTable( "VIPData", VIPData );
			if ( SessionState.VIP )
				NetProps.SetPropString( SessionState.VIP, "m_ModelName", "models/survivors/survivor_namvet.mdl" );
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
			
			VIPData.givemedkits = false;
			SaveTable( "VIPData", VIPData );
		}
	}
}

function VIP_Update()
{
	if ( SessionState.VIPDeathThink )
		g_ModeScript.VIPBase.VIPDeathThink();
}

ScriptedMode_AddUpdate( VIP_Update );

local vip_rules =
[
	{
		name = "SurvivorSpottedSurvivorMechanic",
		criteria =
		[
			[ @(query) query.concept == "PlayerLook" || query.concept == "PlayerLookHere" ],
			[ "Coughing", 0 ],
			[ "Who", "Mechanic" ],
			[ "SmartLookType", "manual" ],
			[ "Subject", "Unknown" ],
		],
		responses =
		[
			{	scenename = "scenes/Mechanic/NameGamblerC101.vcd",	},
			{	scenename = "scenes/Mechanic/NameGamblerC103.vcd",	}
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	},
	{
		name = "SurvivorCriticalHurtUnknown",
		criteria =
		[
			[ "concept", "Pain" ],
			[ "Who", "Unknown" ],
			[ "PainLevel", "Critical" ],
		],
		responses =
		[
			{	scenename = "scenes/NamVet/HurtCritical02.vcd",	},
			{	scenename = "scenes/NamVet/HurtCritical09.vcd",	}
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	},
	{
		name = "SurvivorIncapacitatedHurtUnknown",
		criteria =
		[
			[ "concept", "Pain" ],
			[ "Who", "Unknown" ],
			[ "PainLevel", "Incapacitated" ],
			[ "Speaking", 0 ],
		],
		responses =
		[
			{	scenename = "scenes/NamVet/IncapacitatedInjury01.vcd",	},
			{	scenename = "scenes/NamVet/IncapacitatedInjury05.vcd",	}
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	},
	{
		name = "SurvivorIncapacitatedHurtUnknown",
		criteria =
		[
			[ "concept", "Pain" ],
			[ "Who", "Unknown" ],
			[ "PainLevel", "Major" ],
		],
		responses =
		[
			{	scenename = "scenes/NamVet/HurtMajor06.vcd",	},
			{	scenename = "scenes/NamVet/HurtMajor07.vcd",	},
			{	scenename = "scenes/NamVet/HurtMajor08.vcd",	}
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	},
	{
		name = "SurvivorMinorHurtUnknown",
		criteria =
		[
			[ "concept", "Pain" ],
			[ "Who", "Unknown" ],
			[ "PainLevel", "Minor" ],
		],
		responses =
		[
			{	scenename = "scenes/NamVet/HurtMinor02.vcd",	},
			{	scenename = "scenes/NamVet/HurtMinor10.vcd",	},
			{	scenename = "scenes/NamVet/HurtMinor11.vcd",	}
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	},
	{
		name = "SurvivorDeathUnknown",
		criteria =
		[
			[ "concept", "PlayerDeath" ],
			[ "Who", "Unknown" ],
			[ "Coughing", 0 ],
		],
		responses =
		[
			{	scenename = "scenes/NamVet/DeathScream06.vcd",	},
			{	scenename = "scenes/NamVet/DeathScream07.vcd",	}
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	},
	{
		name = "PlayerRelaxedSighUnknown",
		criteria =
		[
			[ "concept", "RelaxedSigh" ],
			[ "Who", "Unknown" ],
		],
		responses =
		[
			{	scenename = "scenes/NamVet/PainReliefSigh01.vcd",	}
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	},
	{
		name = "PlayerChokeResponseUnknown",
		criteria =
		[
			[ "concept", "PlayerChoke" ],
			[ "Who", "Unknown" ],
		],
		responses =
		[
			{	scenename = "scenes/NamVet/Choke01.vcd",	},
			{	scenename = "scenes/NamVet/Choke03.vcd",	},
			{	scenename = "scenes/NamVet/Choke11.vcd",	},
			{	scenename = "scenes/NamVet/Choke12.vcd",	}
		],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	}
]
g_rr.rr_ProcessRules( vip_rules );
