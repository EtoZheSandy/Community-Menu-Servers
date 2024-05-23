//-----------------------------------------------------
Msg("Activating Last Man Standing\n");

IncludeScript("pvp_base");

PVPOptions <-
{
	weaponsToRemove =
	{
		weapon_pistol = 0
		weapon_pistol_magnum = 0
		weapon_smg = 0
		weapon_pumpshotgun = 0
		weapon_autoshotgun = 0
		weapon_rifle = 0
		weapon_hunting_rifle = 0
		weapon_smg_silenced = 0
		weapon_shotgun_chrome = 0
		weapon_rifle_desert = 0
		weapon_sniper_military = 0
		weapon_shotgun_spas = 0
		weapon_grenade_launcher = 0
		weapon_rifle_ak47 = 0
		weapon_smg_mp5 = 0
		weapon_rifle_sg552 = 0
		weapon_sniper_awp = 0   
		weapon_sniper_scout = 0
		weapon_rifle_m60 = 0
		weapon_melee = 0
		weapon_chainsaw = 0
		weapon_first_aid_kit = 0
		weapon_pain_pills = 0
		weapon_adrenaline = 0
		weapon_defibrillator = 0
		weapon_upgradepack_incendiary = 0
		weapon_upgradepack_explosive = 0
		upgrade_item = 0
		ammo = 0
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

PVPState <-
{
	PVP_OnGameplayStartFunc = function()
	{
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveWeapons()", 10.0 );
	}
	PVP_OnTakeDamageFunc = function( damageTable )
	{
		local DMG_PIPEBOMB = 134217792;

		if ( damageTable.DamageType == DMG_PIPEBOMB )
			ScriptedDamageInfo.DamageDone = 40;
		
		return true;
	}
	SpawnedSurvivors = []
}

AddDefaultsToTable( "PVPOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "PVPState", g_ModeScript, "MutationState", g_ModeScript );

::StatHUD <-
{
	Fields =
	{
		round =
		{
			slot = HUD_SCORE_TITLE ,
			datafunc = @() SessionState.RoundInfo + RoundState.currentround,
			name = "round",
			flags = DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
		}
		timer =
		{
			slot = HUD_MID_BOX ,
			staticstring = "Everyone Will Be Visible In: ",
			name = "timer",
			flags = DirectorScript.HUD_FLAG_COUNTDOWN_WARN | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
			special = HUD_SPECIAL_TIMER0
		}
		name0 =
		{
			slot = HUD_FAR_LEFT ,
			datafunc = @() SessionState.DisplayName(0) + SessionState.SpacerString + "(" + SessionState.DisplayScore(0) + ")",
			name = "name0",
			flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
		}
		name1 =
		{
			slot = HUD_MID_TOP ,
			datafunc = @() SessionState.DisplayName(1) + SessionState.SpacerString + "(" + SessionState.DisplayScore(1) + ")",
			name = "name1",
			flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
		}
		name2 =
		{
			slot = HUD_FAR_RIGHT ,
			datafunc = @() "(" + SessionState.DisplayScore(2) + ")" + SessionState.SpacerString + SessionState.DisplayName(2),
			name = "name2",
			flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_NOBG,
		}
		name3 =
		{
			slot = HUD_MID_BOT ,
			datafunc = @() "(" + SessionState.DisplayScore(3) + ")" + SessionState.SpacerString + SessionState.DisplayName(3),
			name = "name3",
			flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_RIGHT | DirectorScript.HUD_FLAG_NOBG,
		}
		scorebackground =
		{
			slot = HUD_RIGHT_BOT ,
			datafunc = @() SessionState.EmptyString,
			name = "scorebackground",
			flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_CENTER,
		}
		score0 =
		{
			slot = HUD_SCORE_1 ,
			datafunc = @() SessionState.FirstPlace + SessionState.FirstName + SessionState.SpacerString + "(" + SessionState.FirstScore + ")",
			name = "score0",
			flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
		}
		score1 =
		{
			slot = HUD_SCORE_2 ,
			datafunc = @() SessionState.SecondPlace + SessionState.SecondName + SessionState.SpacerString + "(" + SessionState.SecondScore + ")",
			name = "score1",
			flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
		}
		score2 =
		{
			slot = HUD_SCORE_3 ,
			datafunc = @() SessionState.ThirdPlace + SessionState.ThirdName + SessionState.SpacerString + "(" + SessionState.ThirdScore + ")",
			name = "score2",
			flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
		}
		score3 =
		{
			slot = HUD_SCORE_4 ,
			datafunc = @() SessionState.FourthPlace + SessionState.FourthName + SessionState.SpacerString + "(" + SessionState.FourthScore + ")",
			name = "score3",
			flags = DirectorScript.HUD_FLAG_NOTVISIBLE | DirectorScript.HUD_FLAG_ALIGN_LEFT | DirectorScript.HUD_FLAG_NOBG,
		}
	}
}

ListOfRandomWeps <-
[
	"smg"
	"smg_silenced"
	"pumpshotgun"
	"shotgun_chrome"
	"autoshotgun"
	"shotgun_spas"
	"rifle"
	"rifle_ak47"
	"rifle_desert"
	"hunting_rifle"
	"sniper_military"
]

PVPBase.BeginMatch <- function()
{
	SessionState.RoundActive = true;
	SessionState.StartedMatch = true;
	HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, 180 );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.PVPBase.EnableGlows()", 180.0 );
	Say( null, "(Rules) Kill any and all of the other players, 1 point for each player killed. The final map will award an additional 2 bonus points to the Last Man Standing!", false );
}

function OnGameEvent_round_start_post_nav( params )
{
	if ( RoundState.currentround == 5 )
		StatHUD.Fields.round.datafunc = StatHUD.Fields.round.datafunc = @() SessionState.FinalRound
}

function GiveRandomWeapon( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.GiveItem( ListOfRandomWeps[ RandomInt( 0, ListOfRandomWeps.len() - 1 ) ] );
	player.GiveUpgrade( DirectorScript.UPGRADE_LASER_SIGHT );
}

function GiveWeapons()
{
	foreach( survivor in SessionState.AllSurvivors )
	{
		local invTable = {};
		GetInvTable( survivor, invTable );
		foreach( slot, weapon in invTable )
		{
			if ( slot == "slot0" || slot == "slot1" || slot == "slot2" )
				weapon.Kill();
		}
		
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveRandomWeapon(" + survivor.GetPlayerUserId() + ")", 0.1 );
	}
	
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveWeapons()", 10.0 );
}

function GiveWeapon( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	local invTable = {};
	GetInvTable( player, invTable );
	foreach( slot, weapon in invTable )
	{
		if ( slot == "slot0" || slot == "slot1" || slot == "slot2" )
			weapon.Kill();
	}
	
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveRandomWeapon(" + player.GetPlayerUserId() + ")", 0.1 );
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveWeapon(" + userid + ")", 0.1 );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( SessionState.SpawnedSurvivors.find( player ) == null )
	{
		SessionState.SpawnedSurvivors.append( player );
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
	}
}

PVPBase.OnGameEvent_player_death <- function ( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	local attacker = GetPlayerFromUserID( params["attacker"] );
	if ( ( !victim ) || ( !victim.IsSurvivor() ) || ( !attacker ) || ( !attacker.IsSurvivor() ) )
		return;
	
	EntFire( "survivor_death_model", "BecomeRagdoll" );
	if ( SessionState.SurvivorDied == false )
		SessionState.SurvivorDied = true;
	
	SessionState.AliveSurvivors--;
	
	if ( SessionState.AllowDeath )
		SurvivorStats.deaths[GetCharacterDisplayName( victim )]++;
	
	if ( SessionState.RoundActive )
	{
		if ( attacker != victim )
			SurvivorStats.kills[GetCharacterDisplayName( attacker )]++;
	}
	
	local survivorsAlive = 0;
	foreach( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
			survivorsAlive++;
	}

	if ( survivorsAlive == 1 )
	{
		if ( IsMissionFinalMap() )
		{
			local winner = null;
			foreach( survivor in SessionState.AllSurvivors )
			{
				if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
				{
					winner = survivor;
					break;
				}
			}
			if ( winner )
			{
				SurvivorStats.kills[GetCharacterDisplayName( winner )] += 2;
				RemoveHUD();
				DisplayScores();
				EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.PVPBase.EndGame(" + params["userid"] + ")", 15.0 );
			}
		}
		else
		{
			/*foreach( survivor in SessionState.AllSurvivors )
			{
				if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
					survivor.SetOrigin( Utils.GetSaferoomLocation() );
			}*/
			Director.WarpAllSurvivorsToCheckpoint();
			EntFire( "prop_door_rotating_checkpoint", "SetSpeed", "200" );
			EntFire( "prop_door_rotating_checkpoint", "Open" );
			EntFire( "prop_door_rotating_checkpoint", "Close" );
			SessionState.SaveTables = false;
		}
	}
}

function SetupModeHUD()
{
	HUDPlace( HUD_SCORE_TITLE, 0.0, 0.00, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOX, 0.0, 0.04, 1.0, 0.045 );
	HUDPlace( HUD_FAR_LEFT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_TOP, 0.0, 0.06, 1.0, 0.045 );
	HUDPlace( HUD_FAR_RIGHT, 0.0, 0.02, 1.0, 0.045 );
	HUDPlace( HUD_MID_BOT, 0.0, 0.06, 1.0, 0.045 );
	HUDSetLayout( StatHUD );
}

function Update()
{
	foreach( survivor in SessionState.AllSurvivors )
	{
		if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
		{
			if ( survivor.GetHealth() < survivor.GetMaxHealth() )
				survivor.SetHealth( survivor.GetHealth() + 1 );
		}
	}
}
