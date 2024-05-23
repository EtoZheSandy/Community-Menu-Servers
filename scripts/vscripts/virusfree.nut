//-----------------------------------------------------
Msg("Activating Virus Free\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	cm_AllowSurvivorRescue = 0
	SurvivorMaxIncapacitatedCount = 1
	
	TempHealthDecayRate = 0.001
	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 0.50 // pain_pills_decay_rate default 0.27
		}
	}
}

MutationState <-
{
	PlayerInfected = {}
	InfectedState = {}
	SetBlackWhite = {}
	AllSurvivors = []
}

function OnGameplayStart()
{
	Say( null, "If your temporary health drains to zero while infected you will die. Health kits don't remove the infection, they just delay it. The safe room holds the cure.", false );
}

function GetInfectedInfo( idx )
{
	local player = GetPlayerFromCharacter(idx);
	
	if ( (!player) || !(GetCharacterDisplayName( player ) in SessionState.InfectedState) )
		return;
	
	if ( NetProps.GetPropInt( player, "m_currentReviveCount" ) > 0 && NetProps.GetPropInt( player, "m_lifeState" ) == 0 )
		return player.GetPlayerName() + " is " + (100 - player.GetHealthBuffer()).tointeger() + "% INFECTED!";
	else
		return player.GetPlayerName() + " is " + SessionState.InfectedState[GetCharacterDisplayName( player )];
}

function OnGameEvent_player_incapacitated( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	SessionState.PlayerInfected[GetCharacterDisplayName( player )] <- true;
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	
	if ( ( !victim ) || ( !victim.IsSurvivor() ) )
		return;
	
	SessionState.InfectedState[GetCharacterDisplayName( victim )] <- "DEAD :(";
}

function OnGameEvent_heal_success( params )
{
	local player = GetPlayerFromUserID( params["subject"] );
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;
	
	if ( (GetCharacterDisplayName( player ) in SessionState.PlayerInfected) && (SessionState.PlayerInfected[GetCharacterDisplayName( player )]) )
	{
		player.SetHealthBuffer( 100 );
		player.SetHealth( 1 );
		player.SetReviveCount( 1 );
		NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
		StopSoundOn( "Player.Heartbeat", player );
	}
}

function OnGameEvent_defibrillator_used( params )
{
	if ( !("subject" in params) )
		return;
	
	local player = GetPlayerFromUserID( params["subject"] );
	
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;
	
	player.SetHealthBuffer( 70 );
	player.SetHealth( 1 );
	player.SetReviveCount( 1 );
	NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
	StopSoundOn( "Player.Heartbeat", player );
}

function OnGameEvent_bot_player_replace( params )
{
	local player = GetPlayerFromUserID( params["player"] );
	if ( !player )
		return;

	if ( player.GetHealthBuffer() > 40 )
		StopSoundOn( "Player.Heartbeat", player );
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.SetHealth( player.GetHealth() + player.GetHealthBuffer() );
	player.SetHealthBuffer( 0 );
	player.SetReviveCount( 0 );
	SessionState.PlayerInfected[GetCharacterDisplayName( player )] <- false;
	SessionState.SetBlackWhite[GetCharacterDisplayName( player )] <- false;
	SessionState.InfectedState[GetCharacterDisplayName( player )] <- "Virus Free";
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) || (SessionState.AllSurvivors.find( player ) != null) )
		return;

	SessionState.AllSurvivors.append( player );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}

function SetupModeHUD()
{
	InfectedHUD <-
	{
		Fields =
		{
			name0 = 
			{
				slot = HUD_FAR_LEFT ,
				datafunc = @() g_ModeScript.GetInfectedInfo(0),
				name = "name0",
				flags = DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
			name1 = 
			{
				slot = HUD_MID_TOP ,
				datafunc = @() g_ModeScript.GetInfectedInfo(1),
				name = "name1",
				flags = DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
			}
			name2 = 
			{
				slot = HUD_FAR_RIGHT ,
				datafunc = @() g_ModeScript.GetInfectedInfo(2),
				name = "name2",
				flags = DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_NOBG,
			}
			name3 = 
			{
				slot = HUD_MID_BOT ,
				datafunc = @() g_ModeScript.GetInfectedInfo(3),
				name = "name3",
				flags = DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_NOBG,
			}
		}
	}
	HUDPlace( HUD_FAR_LEFT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_TOP, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_FAR_RIGHT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOT, 0.0, 0.06, 1.0, 0.045 );
	HUDSetLayout( InfectedHUD );
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
	foreach( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 && NetProps.GetPropInt( survivor, "m_currentReviveCount" ) > 0 )
		{
			if ( !survivor.IsIncapacitated() && survivor.GetHealthBuffer() == 0 && ResponseCriteria.GetValue( survivor, "incheckpoint" ) == "0" )
				survivor.TakeDamage( survivor.GetHealth(), 0, Entities.First() );
			
			if ( !SessionState.SetBlackWhite[GetCharacterDisplayName( survivor )] && survivor.GetHealthBuffer() < 40 )
			{
				NetProps.SetPropInt( survivor, "m_bIsOnThirdStrike", 1 );
				StopSoundOn( "Player.Heartbeat", survivor );
				EmitSoundOnClient( "Player.Heartbeat", survivor );
				SessionState.SetBlackWhite[GetCharacterDisplayName( survivor )] = true;
			}
			else if ( SessionState.SetBlackWhite[GetCharacterDisplayName( survivor )] && survivor.GetHealthBuffer() > 40 )
			{
				NetProps.SetPropInt( survivor, "m_bIsOnThirdStrike", 0 );
				StopSoundOn( "Player.Heartbeat", survivor );
				SessionState.SetBlackWhite[GetCharacterDisplayName( survivor )] = false;
			}
		}
	}
}
