//-----------------------------------------------------
Msg("Activating Triple Threat\n");

IncludeScript("ass_base");

ASSOptions <-
{
	cm_MaxSpecials = 14
	cm_DominatorLimit = 14
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	//SurvivorMaxIncapacitatedCount = 1
	TankHitDamageModifierCoop = 0.3 //0.2
	ShouldAllowSpecialsWithTank = true
	ZombieTankHealth = 1000
	
	TempHealthDecayRate = 0.001
	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 0.334 // pain_pills_decay_rate default 0.27
		}
	}
}

ASSState <-
{
	ASS_RoundStartFunc = function()
	{
		g_ModeScript.GetRandomInfected();
		EntFire( "tankdoorout_button", "Unlock" );
		EntFire( "tank_sound_timer", "Kill" );
	}
	EnableTanks = false
	TanksAlive = 0
	LastTankSpawnTime = 0
	TankSpawnInterval = 5
	SpawnTankThink = false
}

AddDefaultsToTable( "ASSOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ASSState", g_ModeScript, "MutationState", g_ModeScript );

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
				SessionOptions.SmokerLimit += 4;
				break;
			}
			case DirectorScript.ZOMBIE_BOOMER:
			{
				SessionOptions.BoomerLimit += 4;
				break;
			}
			case DirectorScript.ZOMBIE_HUNTER:
			{
				SessionOptions.HunterLimit += 4;
				break;
			}
			case DirectorScript.ZOMBIE_SPITTER:
			{
				SessionOptions.SpitterLimit += 4;
				break;
			}
			case DirectorScript.ZOMBIE_JOCKEY:
			{
				SessionOptions.JockeyLimit += 4;
				break;
			}
			case DirectorScript.ZOMBIE_CHARGER:
			{
				SessionOptions.ChargerLimit += 4;
				break;
			}
			case DirectorScript.ZOMBIE_TANK:
			{
				SessionOptions.TankLimit += 4;
				SessionOptions.cm_TankLimit += 4;
				SessionState.EnableTanks = true;
				break;
			}
			default:
				break;
		}
	}
}

function SpawnTankThink()
{
	if ( SessionOptions.cm_TankLimit == 0 )
		return;

	if ( (SessionState.TanksAlive < SessionOptions.cm_TankLimit) && ((Time() - SessionState.LastTankSpawnTime) >= SessionState.TankSpawnInterval || SessionState.LastTankSpawnTime == 0) )
	{
		if ( ZSpawn( { type = 8 } ) )
			SessionState.LastTankSpawnTime = Time();
	}
}

function OnGameEvent_player_left_safe_area( params )
{
	if ( SessionState.EnableTanks )
	{
		SessionState.SpawnTankThink = true;
	}
}

function OnGameEvent_tank_spawn( params )
{
	local tank = GetPlayerFromUserID( params["userid"] );
	if ( !tank )
		return;

	SessionState.TanksAlive++;
}

function OnGameEvent_tank_killed( params )
{
	SessionState.TanksAlive--;
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
	if ( SessionState.SpawnTankThink )
		SpawnTankThink();
}
