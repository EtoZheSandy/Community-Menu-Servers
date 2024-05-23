//-----------------------------------------------------
Msg("Activating 3 of a Kind\n");

if ( !IsModelPrecached( "models/infected/smoker.mdl" ) )
	PrecacheModel( "models/infected/smoker.mdl" );
if ( !IsModelPrecached( "models/infected/smoker_l4d1.mdl" ) )
	PrecacheModel( "models/infected/smoker_l4d1.mdl" );
if ( !IsModelPrecached( "models/infected/boomer.mdl" ) )
	PrecacheModel( "models/infected/boomer.mdl" );
if ( !IsModelPrecached( "models/infected/boomer_l4d1.mdl" ) )
	PrecacheModel( "models/infected/boomer_l4d1.mdl" );
if ( !IsModelPrecached( "models/infected/boomette.mdl" ) )
	PrecacheModel( "models/infected/boomette.mdl" );
if ( !IsModelPrecached( "models/infected/hunter.mdl" ) )
	PrecacheModel( "models/infected/hunter.mdl" );
if ( !IsModelPrecached( "models/infected/hunter_l4d1.mdl" ) )
	PrecacheModel( "models/infected/hunter_l4d1.mdl" );
if ( !IsModelPrecached( "models/infected/limbs/exploded_boomette.mdl" ) )
{
	PrecacheModel( "models/infected/limbs/exploded_boomette.mdl" );
	::three_of_kind_no_female_boomers <- true;
}
if ( !IsModelPrecached( "models/infected/spitter.mdl" ) )
	PrecacheModel( "models/infected/spitter.mdl" );
if ( !IsModelPrecached( "models/infected/jockey.mdl" ) )
	PrecacheModel( "models/infected/jockey.mdl" );
if ( !IsModelPrecached( "models/infected/charger.mdl" ) )
	PrecacheModel( "models/infected/charger.mdl" );

MutationOptions <-
{
	cm_AggressiveSpecials = 1
	cm_CommonLimit = 0
	cm_ShouldHurry = 1
	cm_SpecialRespawnInterval = 13
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 0
	SpecialInfectedAssault = true
	LockTempo = true
	cm_MaxSpecials = 6
	cm_DominatorLimit = 6
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	//WitchLimit = 0
	//cm_WitchLimit = 0
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	//TankHitDamageModifierCoop = 0.3
	ShouldAllowSpecialsWithTank = true
	ZombieTankHealth = 750
	
	TempHealthDecayRate = 0.001
	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 0.334 // pain_pills_decay_rate default 0.27
		}
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
	EnableTanks = false
	SpecialSlotTimer = 13.0
	SIModelsBase = [ [ "models/infected/smoker.mdl", "models/infected/smoker_l4d1.mdl" ],
					[ "models/infected/boomer.mdl", "models/infected/boomer_l4d1.mdl", "models/infected/boomette.mdl" ],
						[ "models/infected/hunter.mdl", "models/infected/hunter_l4d1.mdl" ],
							[ "models/infected/spitter.mdl" ],
								[ "models/infected/jockey.mdl" ],
									[ "models/infected/charger.mdl" ] ]
	SIModels = [ [ "models/infected/smoker.mdl", "models/infected/smoker_l4d1.mdl" ],
				[ "models/infected/boomer.mdl", "models/infected/boomer_l4d1.mdl", "models/infected/boomette.mdl" ],
					[ "models/infected/hunter.mdl", "models/infected/hunter_l4d1.mdl" ],
						[ "models/infected/spitter.mdl" ],
							[ "models/infected/jockey.mdl" ],
								[ "models/infected/charger.mdl" ] ]
	ModelCheck = [ false, false, false, false, false, false ]
	LastBoomerModel = ""
	BoomersChecked = 0
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( NetProps.GetPropInt( damageTable.Victim, "m_iTeamNum" ) == 3 )
	{
		if ( (damageTable.Inflictor) && (damageTable.Inflictor.GetClassname() == "pipe_bomb_projectile") )
			damageTable.DamageDone = 1000;
	}

	return true;
}

function GetRandomInfected()
{
	local InfectedChoices =
	[
		ZOMBIE_SMOKER
		ZOMBIE_BOOMER
		ZOMBIE_HUNTER
		ZOMBIE_SPITTER
		ZOMBIE_JOCKEY
		ZOMBIE_CHARGER
		ZOMBIE_TANK
	]
	
	if ( IsMissionFinalMap() )
	{
		local foundTank = InfectedChoices.find( DirectorScript.ZOMBIE_TANK );
		if ( foundTank != null )
			InfectedChoices.remove( foundTank );
	}
	
	for ( local i = 0; i < 3; i++ )
	{
		local random_choice = InfectedChoices[ RandomInt( 0, InfectedChoices.len() - 1 ) ];
		
		switch ( random_choice )
		{
			case DirectorScript.ZOMBIE_SMOKER:
			{
				SessionOptions.SmokerLimit += 2;
				break;
			}
			case DirectorScript.ZOMBIE_BOOMER:
			{
				SessionOptions.BoomerLimit += 2;
				local foundBoomer = InfectedChoices.find( DirectorScript.ZOMBIE_BOOMER );
				if ( foundBoomer != null )
					InfectedChoices.remove( foundBoomer );
				break;
			}
			case DirectorScript.ZOMBIE_HUNTER:
			{
				SessionOptions.HunterLimit += 2;
				break;
			}
			case DirectorScript.ZOMBIE_SPITTER:
			{
				SessionOptions.SpitterLimit += 2;
				break;
			}
			case DirectorScript.ZOMBIE_JOCKEY:
			{
				SessionOptions.JockeyLimit += 2;
				break;
			}
			case DirectorScript.ZOMBIE_CHARGER:
			{
				SessionOptions.ChargerLimit += 2;
				break;
			}
			case DirectorScript.ZOMBIE_TANK:
			{
				SessionOptions.TankLimit += 2;
				SessionOptions.cm_TankLimit += 2;
				SessionState.EnableTanks = true;
				break;
			}
			default:
				break;
		}
	}
}

function ThreeKind_SpawnTank()
{
	ZSpawn( { type = DirectorScript.ZOMBIE_TANK } );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ThreeKind_SpawnTank()", SessionState.SpecialSlotTimer );
}

function OnGameEvent_round_start_post_nav( params )
{
	for ( local spawner; spawner = Entities.FindByClassname( spawner, "info_zombie_spawn" ); )
	{
		local population = NetProps.GetPropString( spawner, "m_szPopulation" );

		if ( population == "boomer" || population == "hunter" || population == "smoker" || population == "jockey"
			|| population == "charger" || population == "spitter" || population == "new_special" || population == "church"
				|| population == "tank" || population == "witch" || population == "witch_bride" || population == "river_docks_trap" )
			continue;
		else
			spawner.Kill();
	}

	GetRandomInfected();
}

function ResetSpecialTimers()
{
	Director.ResetSpecialTimers();
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ResetSpecialTimers()", SessionState.SpecialSlotTimer );
}

function OnGameEvent_player_left_safe_area( params )
{
	EntFire( "tankdoorout_button", "Unlock" );
	EntFire( "tank_sound_timer", "Kill" );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ResetSpecialTimers()", SessionState.SpecialSlotTimer );
	if ( SessionState.EnableTanks )
		ThreeKind_SpawnTank();
}

function KillInfected( infectedID, attackerID )
{
	local infected = GetPlayerFromUserID( infectedID );
	local attacker = GetPlayerFromUserID( attackerID );
	if ( !infected || !attacker )
		return;

	infected.TakeDamage( infected.GetHealth(), 0, attacker );

	if ( NetProps.GetPropInt( infected, "m_lifeState" ) == 0 )
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillInfected(" + infectedID + "," + attackerID + ")", 0.1 );
}

function OnGameEvent_player_now_it( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (player.IsSurvivor()) )
		return;

	local KillTimer = 2.0;
	if ( player.GetZombieType() == DirectorScript.ZOMBIE_TANK )
		KillTimer = 5.0;

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillInfected(" + params["userid"] + "," + params["attacker"] + ")", KillTimer );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );

	if ( ( !player ) || ( player.IsSurvivor() ) )
		return;

	local zombieType = player.GetZombieType();
	if ( zombieType > 6 )
		return;

	local modelName = player.GetModelName();

	if ( !SessionState.ModelCheck[ zombieType - 1 ] )
	{
		if ( (zombieType == 2) && !("three_of_kind_no_female_boomers" in getroottable()) )
		{
			if ( SessionState.LastBoomerModel != modelName )
			{
				SessionState.LastBoomerModel = modelName;
				SessionState.BoomersChecked++;
			}
			if ( SessionState.BoomersChecked > 1 )
				SessionState.ModelCheck[ zombieType - 1 ] = true;
		}
		else
			SessionState.ModelCheck[ zombieType - 1 ] = true;

		if ( SessionState.SIModelsBase[zombieType - 1].find( modelName ) == null )
		{
			SessionState.SIModelsBase[zombieType - 1].append( modelName );
			SessionState.SIModels[zombieType - 1].append( modelName );
		}
	}

	if ( SessionState.SIModelsBase[zombieType - 1].len() == 1 )
		return;

	local zombieModels = SessionState.SIModels[zombieType - 1];
	if ( zombieModels.len() == 0 )
		SessionState.SIModels[zombieType - 1].extend( SessionState.SIModelsBase[zombieType - 1] );
	local foundModel = zombieModels.find( modelName );
	if ( foundModel != null )
	{
		zombieModels.remove( foundModel );
		return;
	}

	local randomElement = RandomInt( 0, zombieModels.len() - 1 );
	local randomModel = zombieModels[ randomElement ];
	zombieModels.remove( randomElement );

	player.SetModel( randomModel );
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
	if ( Director.GetCommonInfectedCount() > 0 )
	{
		for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
			infected.Kill();
	}
}
