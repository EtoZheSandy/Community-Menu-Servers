//-----------------------------------------------------
Msg("Activating Borrowed Time\n");

MutationOptions <-
{
	cm_TempHealthOnly = 1
	cm_AllowPillConversion = 0
	cm_ShouldHurry = 1
	SurvivorMaxIncapacitatedCount = 1
	
	weaponsToRemove =
	{
		weapon_defibrillator = 0
		weapon_adrenaline = 0
		weapon_pain_pills = 0
		weapon_first_aid_kit = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return false;
		}
		return true;
	}

	function ShouldAvoidItem( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return true;
		}
		return false;
	}
	
	TempHealthDecayRate = 0.001
	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 0.75 // pain_pills_decay_rate default 0.27
		}
	}
}

MutationState <-
{
	AllSurvivors = []
}

function OnGameplayStart()
{
	Say( null, "Kill baddies to get health. If hp reaches 0 you incap, if black and white you die.", false );
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.SetHealthBuffer( player.GetMaxHealth() );
	//player.SetHealth( 0 );
	player.SetReviveCount( 0 );
	NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
	StopSoundOn( "Player.Heartbeat", player );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) || (SessionState.AllSurvivors.find( player ) != null) )
		return;

	SessionState.AllSurvivors.append( player );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}

function OnGameEvent_player_death( params )
{
	local victim = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( !victim )
		return;
	
	if ( (victim.IsPlayer()) && (victim.IsSurvivor()) )
		EntFire( "survivor_death_model", "BecomeRagdoll" );
	else
	{
		local attacker = GetPlayerFromUserID( params["attacker"] );
		if ( (attacker) && (attacker.IsSurvivor()) )
		{
			if ( victim.GetClassname() == "infected" )
			{
				if ( attacker.GetHealthBuffer() <= 98 )
					attacker.SetHealthBuffer( attacker.GetHealthBuffer() + 2 );
				else
					attacker.SetHealthBuffer( 100 );
			}
			else if ( victim.GetClassname() == "witch" )
			{
				foreach( survivor in SessionState.AllSurvivors )
				{
					if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
					{
						if ( survivor.GetHealthBuffer() <= 70 )
							survivor.SetHealthBuffer( survivor.GetHealthBuffer() + 30 );
						else
							survivor.SetHealthBuffer( 100 );
					}
				}
			}
			else if ( victim.IsPlayer() )
			{
				if ( victim.GetZombieType() == DirectorScript.ZOMBIE_TANK )
				{
					foreach( survivor in SessionState.AllSurvivors )
					{
						if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
						{
							if ( survivor.GetHealthBuffer() <= 50 )
								survivor.SetHealthBuffer( survivor.GetHealthBuffer() + 50 );
							else
								survivor.SetHealthBuffer( 100 );
						}
					}
				}
				else
				{
					if ( attacker.GetHealthBuffer() <= 80 )
						attacker.SetHealthBuffer( attacker.GetHealthBuffer() + 20 );
					else
						attacker.SetHealthBuffer( 100 );
				}
			}
		}
	}
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
	foreach( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 && !survivor.IsIncapacitated() )
		{
			if ( survivor.GetHealthBuffer() <= 1 && ResponseCriteria.GetValue( survivor, "insafespot" ) == "0" )
				survivor.TakeDamage( survivor.GetHealth(), 0, null );
		}
	}
}
