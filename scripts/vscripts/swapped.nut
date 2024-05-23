//-----------------------------------------------------
Msg("Activating Survivor Swap\n");
Msg("Made by Rayman1103\n");


if ( Entities.FindByName( null, "c1m1_c1m2_changelevel" ) )
{
	local sceneTable =
	{
		busyactor = 1,
		onplayerdeath = "0",
		SceneFile = "scenes/c1m1_intro_survivors_01.vcd",
		targetname = "update_lcs_intro",
		connections =
		{
			OnTrigger1 =
			{
				cmd1 = "directorFireConceptToAnyIntroC1M10-1"
			}
		}
		origin = Vector(669.351, 5729.67, 2933.31),
		angles = Vector(0, 0, 0) 
	}
	local relayTable =
	{
		spawnflags = 0,
		StartDisabled = "0",
		targetname = "relay_intro_start",
		connections =
		{
			OnTrigger =
			{
				cmd1 = "update_lcs_introStart2-1"
			}
		}
		origin = Vector(669.28, 5729.87, 2903.31),
		angles = Vector(0, 0, 0) 
	}

	SpawnEntityFromTable( "logic_choreographed_scene", sceneTable );
	SpawnEntityFromTable( "logic_relay", relayTable );
}

if ( Entities.FindByName( null, "l4d1_survivors_relay" ) )
{
	local relayTable =
	{
		spawnflags = 0,
		StartDisabled = "0",
		targetname = "relay_swappedcoop_setup",
		connections =
		{
			OnTrigger =
			{
				cmd1 = "elevator_nav_blockerBlockNav0-1"
				cmd2 = "l4d1_script_relayEnable0-1"
				cmd3 = "relay_quiet_scriptEnable0-1"
				cmd4 = "l4d1_survivors_relayEnable0-1"
				cmd5 = "gas_nozzleStopGlowing0-1"
				cmd6 = "gascansTurnGlowsOff0-1"
			}
		}
		origin = Vector( -368, -288, 296 ),
		angles = Vector( 0, 0, 0 ) 
	}

	SpawnEntityFromTable( "logic_relay", relayTable );
}

if ( Entities.FindByName( null, "branch_zoey" ) )
{
	EntFire( "info_l4d1_survivor_spawn", "Kill", "", 0 );
	EntFire( "trigger_multiple", "Kill", "", 0 );
	EntFire( "francis_start", "Kill", "", 0 );
	EntFire( "zoey_start", "Kill", "", 0 );
	EntFire( "branch_zoey", "Kill", "", 0 );
	EntFire( "scavenge_shortcut", "Kill", "", 0 );
}

function SpawnBillCrates()
{
	local cratetbl1 =
	{
		classname = "prop_dynamic",
		fademindist = "-1",
		fadescale = "1",
		glowbackfacemult = "1.0",
		glowcolor = "0 0 0",
		MaxAnimTime = "10",
		MinAnimTime = "5",
		model = "models/props_crates/static_crate_40.mdl",
		renderamt = "255",
		rendercolor = "255 255 255",
		skin = "0",
		solid = "6",
		origin = Vector( -369, -991, 0 ),
		angles = Vector( 0, 90, 0 )
	}
	local cratetbl2 =
	{
		classname = "prop_dynamic_override",
		fademindist = "-1",
		fadescale = "1",
		glowbackfacemult = "1.0",
		glowcolor = "0 0 0",
		MaxAnimTime = "10",
		MinAnimTime = "5",
		model = "models/props_crates/supply_crate01.mdl",
		renderamt = "255",
		rendercolor = "255 255 255",
		skin = "0",
		solid = "6",
		origin = Vector( -364, -1016, 15 ),
		angles = Vector( 0, 180, 90 )
	}
	local cratetbl3 =
	{
		classname = "prop_dynamic_override",
		fademindist = "-1",
		fadescale = "1",
		glowbackfacemult = "1.0",
		glowcolor = "0 0 0",
		MaxAnimTime = "10",
		MinAnimTime = "5",
		model = "models/props_crates/supply_crate01.mdl",
		renderamt = "255",
		rendercolor = "255 255 255",
		skin = "0",
		solid = "6",
		origin = Vector( -385, -1016, 15 ),
		angles = Vector( 0, 180, 90 )
	}
	local cratetbl4 =
	{
		classname = "prop_dynamic_override",
		fademindist = "-1",
		fadescale = "1",
		glowbackfacemult = "1.0",
		glowcolor = "0 0 0",
		MaxAnimTime = "10",
		MinAnimTime = "5",
		model = "models/props_crates/supply_crate01.mdl",
		renderamt = "255",
		rendercolor = "255 255 255",
		skin = "0",
		solid = "6",
		origin = Vector( -369, -1033, 17 ),
		angles = Vector( 0, 270, 0 )
	}

	CreateSingleSimpleEntityFromTable( cratetbl1 );
	CreateSingleSimpleEntityFromTable( cratetbl2 );
	CreateSingleSimpleEntityFromTable( cratetbl3 );
	CreateSingleSimpleEntityFromTable( cratetbl4 );
}

function OnGameEvent_round_start_post_nav( params )
{
	for ( local survivorPos; survivorPos = Entities.FindByClassname( survivorPos, "info_survivor_position" ); )
	{
		local survivorName = NetProps.GetPropString( survivorPos, "m_iszSurvivorName" ).tolower();
		if ( Director.GetSurvivorSet() == 1 )
		{
			if ( survivorName == "nick" )
				NetProps.SetPropString( survivorPos, "m_iszSurvivorName", "bill" );
			else if ( survivorName == "rochelle" )
				NetProps.SetPropString( survivorPos, "m_iszSurvivorName", "zoey" );
			else if ( survivorName == "coach" )
				NetProps.SetPropString( survivorPos, "m_iszSurvivorName", "louis" );
			else if ( survivorName == "ellis" )
				NetProps.SetPropString( survivorPos, "m_iszSurvivorName", "francis" );
		}
		else
		{
			if ( survivorName == "bill" )
				NetProps.SetPropString( survivorPos, "m_iszSurvivorName", "nick" );
			else if ( survivorName == "zoey" )
				NetProps.SetPropString( survivorPos, "m_iszSurvivorName", "rochelle" );
			else if ( survivorName == "francis" )
				NetProps.SetPropString( survivorPos, "m_iszSurvivorName", "ellis" );
			else if ( survivorName == "louis" )
				NetProps.SetPropString( survivorPos, "m_iszSurvivorName", "coach" );
		}
	}

	for ( local gameMode; gameMode = Entities.FindByClassname( gameMode, "info_gamemode" ); )
	{
		if ( EntityOutputs.HasAction( gameMode, "OnCoop" ) )
		{
			local numElements = EntityOutputs.GetNumElements( gameMode, "OnCoop" );
			for ( local i = 0; i < numElements; i++ )
			{
				local tbl = {};
				EntityOutputs.GetOutputTable( gameMode, "OnCoop", tbl, i );
				EntFire( tbl.target, tbl.input, tbl.parameter, tbl.delay );
			}
		}
		if ( EntityOutputs.HasAction( gameMode, "OnCoopPostIO" ) )
		{
			local numElements = EntityOutputs.GetNumElements( gameMode, "OnCoopPostIO" );
			for ( local i = 0; i < numElements; i++ )
			{
				local tbl = {};
				EntityOutputs.GetOutputTable( gameMode, "OnCoopPostIO", tbl, i );
				EntFire( tbl.target, tbl.input, tbl.parameter, tbl.delay );
			}
		}
	}

	if ( SessionState.MapName == "c6m3_port" )
	{
		EntFire( "info_l4d1_survivor_spawn", "Kill", "", 0 );
		EntFire( "l4d1_survivors_relay", "Kill", "", 0 );
		EntFire( "l4d1_teleport_relay", "Kill", "", 0 );
		EntFire( "l4d1_script_relay", "Kill", "", 0 );
		EntFire( "francis_outro", "Kill", "", 0 );
		EntFire( "louis_outro", "Kill", "", 0 );
		EntFire( "zoey_outro", "Kill", "", 0 );
		EntFire( "relay_swappedcoop_setup", "Trigger", "", 0 );
		for ( local billRifle; billRifle = Entities.FindByClassnameWithin( billRifle, "weapon_rifle_spawn", Vector( -364, -1007, 11.3106 ), 10 ); )
			DoEntFire( "!self", "Kill", "", 0, null, billRifle );
		SpawnBillCrates();
	}
}
