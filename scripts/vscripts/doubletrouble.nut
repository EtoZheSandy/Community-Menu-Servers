//-----------------------------------------------------
Msg("Activating Double Trouble\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	cm_CommonLimit = 0
	cm_DominatorLimit = 12
	cm_MaxSpecials = 12
	cm_SpecialRespawnInterval = 0
	//cm_ProhibitBosses = true
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 5
	//ZombieTankHealth = 5000
	
	BoomerLimit = 1
	SmokerLimit = 1
	HunterLimit = 1
	ChargerLimit = 1
	SpitterLimit = 1
	JockeyLimit = 1
	//TankLimit = 10
}

MutationState <-
{
	AllowBoomerSplit = false
	AllowSmokerSplit = false
	AllowHunterSplit = false
	AllowChargerSplit = false
	AllowSpitterSplit = false
	AllowJockeySplit = false
	AllowTankSplit = false
	AllowWitchSplit = false
	BoomersSplit = 0
	SmokersSplit = 0
	HuntersSplit = 0
	ChargersSplit = 0
	SpittersSplit = 0
	JockeysSplit = 0
	TanksSplit = 0
	WitchesSplit = 0
	SpecialCloned = {}
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( damageTable.DamageType == ( DirectorScript.DMG_BLAST | DirectorScript.DMG_BLAST_SURFACE ) && NetProps.GetPropInt( damageTable.Victim, "m_iTeamNum" ) == 3 )
	{
		damageTable.DamageDone = 1000;
	}

	return true;
}

function OnGameEvent_witch_spawn( params )
{
	local witch = EntIndexToHScript( params["witchid"] );
	if ( SessionState.AllowWitchSplit )
	{
		if ( SessionState.WitchesSplit < 2 )
		{
			witch.SetHealth( witch.GetHealth() / 2 );
			SessionState.SpecialCloned[params["witchid"]] <- true;
			SessionState.WitchesSplit++;
			
			if ( SessionState.WitchesSplit == 2 )
			{
				SessionState.AllowWitchSplit = false;
				SessionState.WitchesSplit = 0;
			}
		}
	}
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (player.IsSurvivor()) )
		return;

	switch( player.GetZombieType() )
	{
		case DirectorScript.ZOMBIE_BOOMER:
		{
			if ( SessionState.AllowBoomerSplit )
			{
				if ( SessionState.BoomersSplit < 2 )
				{
					SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
					SessionState.BoomersSplit++;
					
					if ( SessionState.BoomersSplit == 2 )
					{
						SessionState.AllowBoomerSplit = false;
						SessionState.BoomersSplit = 0;
					}
				}
			}
			break;
		}
		case DirectorScript.ZOMBIE_SMOKER:
		{
			if ( SessionState.AllowSmokerSplit )
			{
				if ( SessionState.SmokersSplit < 2 )
				{
					SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
					SessionState.SmokersSplit++;
					
					if ( SessionState.SmokersSplit == 2 )
					{
						SessionState.AllowSmokerSplit = false;
						SessionState.SmokersSplit = 0;
					}
				}
			}
			break;
		}
		case DirectorScript.ZOMBIE_HUNTER:
		{
			if ( SessionState.AllowHunterSplit )
			{
				if ( SessionState.HuntersSplit < 2 )
				{
					SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
					SessionState.HuntersSplit++;
					
					if ( SessionState.HuntersSplit == 2 )
					{
						SessionState.AllowHunterSplit = false;
						SessionState.HuntersSplit = 0;
					}
				}
			}
			break;
		}
		case DirectorScript.ZOMBIE_CHARGER:
		{
			if ( SessionState.AllowChargerSplit )
			{
				if ( SessionState.ChargersSplit < 2 )
				{
					player.SetHealth( player.GetHealth() / 2 );
					SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
					SessionState.ChargersSplit++;
					
					if ( SessionState.ChargersSplit == 2 )
					{
						SessionState.AllowChargerSplit = false;
						SessionState.ChargersSplit = 0;
					}
				}
			}
			break;
		}
		case DirectorScript.ZOMBIE_SPITTER:
		{
			if ( SessionState.AllowSpitterSplit )
			{
				if ( SessionState.SpittersSplit < 2 )
				{
					SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
					SessionState.SpittersSplit++;
					
					if ( SessionState.SpittersSplit == 2 )
					{
						SessionState.AllowSpitterSplit = false;
						SessionState.SpittersSplit = 0;
					}
				}
			}
			break;
		}
		case DirectorScript.ZOMBIE_JOCKEY:
		{
			if ( SessionState.AllowJockeySplit )
			{
				if ( SessionState.JockeysSplit < 2 )
				{
					player.SetHealth( player.GetHealth() / 2 );
					SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
					SessionState.JockeysSplit++;
					
					if ( SessionState.JockeysSplit == 2 )
					{
						SessionState.AllowJockeySplit = false;
						SessionState.JockeysSplit = 0;
					}
				}
			}
			break;
		}
		case DirectorScript.ZOMBIE_TANK:
		{
			if ( SessionState.AllowTankSplit )
			{
				if ( SessionState.TanksSplit < 2 )
				{
					player.SetHealth( player.GetHealth() / 2 );
					SessionState.SpecialCloned[player.GetEntityIndex()] <- true;
					SessionState.TanksSplit++;
					
					if ( SessionState.TanksSplit == 2 )
					{
						SessionState.AllowTankSplit = false;
						SessionState.TanksSplit = 0;
					}
				}
			}
			break;
		}
	}
}

function OnGameEvent_player_death( params )
{
	local victim = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( !victim )
		return;

	if ( (victim.IsPlayer()) && (victim.IsSurvivor()) )
		return;

	if ( (victim.GetEntityIndex() in SessionState.SpecialCloned) && (SessionState.SpecialCloned[victim.GetEntityIndex()]) )
	{
		SessionState.SpecialCloned[victim.GetEntityIndex()] <- false;
		return;
	}

	if ( victim.GetClassname() == "witch" )
	{
		SessionState.AllowWitchSplit = true;
		ZSpawn( { type = 7, pos = victim.GetOrigin() } );
		ZSpawn( { type = 7, pos = victim.GetOrigin() } );
	}
	else
	{
		switch( victim.GetZombieType() )
		{
			case DirectorScript.ZOMBIE_BOOMER:
			{
				SessionOptions.BoomerLimit = 2;
				SessionState.AllowBoomerSplit = true;
				break;
			}
			case DirectorScript.ZOMBIE_SMOKER:
			{
				SessionOptions.SmokerLimit = 2;
				SessionState.AllowSmokerSplit = true;
				break;
			}
			case DirectorScript.ZOMBIE_HUNTER:
			{
				SessionOptions.HunterLimit = 2;
				SessionState.AllowHunterSplit = true;
				break;
			}
			case DirectorScript.ZOMBIE_CHARGER:
			{
				SessionOptions.ChargerLimit = 2;
				SessionState.AllowChargerSplit = true;
				break;
			}
			case DirectorScript.ZOMBIE_SPITTER:
			{
				SessionOptions.SpitterLimit = 2;
				SessionState.AllowSpitterSplit = true;
				break;
			}
			case DirectorScript.ZOMBIE_JOCKEY:
			{
				SessionOptions.JockeyLimit = 2;
				SessionState.AllowJockeySplit = true;
				break;
			}
			case DirectorScript.ZOMBIE_TANK:
			{
				SessionState.AllowTankSplit = true;
				break;
			}
		}

		ZSpawn( { type = victim.GetZombieType(), pos = victim.GetOrigin() } );
		ZSpawn( { type = victim.GetZombieType(), pos = victim.GetOrigin() } );
		
		if ( victim.GetZombieType() == DirectorScript.ZOMBIE_BOOMER )
			SessionOptions.BoomerLimit = 1;
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_SMOKER )
			SessionOptions.SmokerLimit = 1;
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_HUNTER )
			SessionOptions.HunterLimit = 1;
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_CHARGER )
			SessionOptions.ChargerLimit = 1;
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_SPITTER )
			SessionOptions.SpitterLimit = 1;
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_JOCKEY )
			SessionOptions.JockeyLimit = 1;
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
