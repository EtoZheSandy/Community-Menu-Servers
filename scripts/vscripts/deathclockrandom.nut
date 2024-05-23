//-----------------------------------------------------
Msg("Activating Death Clock: Random\n");

IncludeScript("deathclock_base");

DeathClockOptions <-
{
	TankHitDamageModifierCoop = 0.2
	ZombieTankHealth = 1000
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
}

DeathClockState <-
{
	EnableTanks = false
	DC_RoundStartFunc = function()
	{
		g_ModeScript.GetRandomInfected();
	}
	DC_LeftSafeAreaFunc = function()
	{
		EntFire( "tankdoorout_button", "Unlock" );
		EntFire( "tank_sound_timer", "Kill" );
		EntFire( "info_director", "FireConceptToAny", "PlayerHurryUp" );

		if ( SessionState.EnableTanks )
		{
			g_ModeScript.DC_SpawnTank();
		}
	}
}

AddDefaultsToTable( "DeathClockOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "DeathClockState", g_ModeScript, "MutationState", g_ModeScript );

function DC_SpawnTank()
{
	ZSpawn( { type = DirectorScript.ZOMBIE_TANK } );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.DC_SpawnTank()", 10.0 );
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
