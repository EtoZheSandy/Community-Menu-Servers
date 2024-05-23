//-----------------------------------------------------
Msg("Activating ZSL Jockey Trouble\n");
Msg("Made by ANG3Lskye\n");

IncludeScript("zsl_survival_base");

ZSLOptions <-
{
	JockeyLimit = 12
	TankLimit = 4
	cm_TankLimit = 4
	cm_BaseCommonAttackDamage = 0
	TankHitDamageModifierCoop = 0.5

	RandomPrimary =
	[
		"autoshotgun",
		"rifle",
		"rifle_desert",
		"sniper_military",
		"shotgun_spas",
		"rifle_ak47"
	]
	RandomSecondary =
	[
		"weapon_pistol_magnum",
	]
	
	RandomTertiary =
	[
		"weapon_molotov",
	]
	
	Random4th =
	[
		"weapon_adrenaline",
	]
	
	function GetDefaultItem(id)
	{
		local PRand = RandomInt(0,RandomPrimary.len()-1);
		local SRand = RandomInt(0,RandomSecondary.len()-1);
		local TRand = RandomInt(0,RandomTertiary.len()-1);
		local FourRand = RandomInt(0,Random4th.len()-1);
		if(id == 0) return RandomPrimary[PRand];
		else if(id == 1) return RandomSecondary[SRand];
		else if(id == 2) return RandomTertiary[TRand];
		else if(id == 3) return Random4th[FourRand];
		return 0;
	}
}

ZSLState <-
{
	JockeyRideDamage = {}
}

AddDefaultsToTable( "ZSLOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ZSLState", g_ModeScript, "MutationState", g_ModeScript );

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( !(GetCharacterDisplayName( player ) in SessionState.JockeyRideDamage) )
		SessionState.JockeyRideDamage[GetCharacterDisplayName( player )] <- {};
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}

function OnGameEvent_player_hurt( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	local attacker = GetPlayerFromUserID( params["attacker"] );
	if ( (!player) || (!player.IsSurvivor()) || (!attacker) || (attacker.GetZombieType() != DirectorScript.ZOMBIE_JOCKEY) )
		return;
	
	if ( NetProps.GetPropEntity( player, "m_jockeyAttacker" ) == attacker )
	{
		local name = GetCharacterDisplayName( player );
		
		if ( !(attacker in SessionState.JockeyRideDamage[name]) )
			SessionState.JockeyRideDamage[name][attacker] <- 0;
		
		SessionState.JockeyRideDamage[name][attacker] += params["dmg_health"];
		
		if ( SessionState.JockeyRideDamage[name][attacker] >= 40 )
		{
			attacker.TakeDamage( attacker.GetHealth(), 0, Entities.First() );
			SessionState.JockeyRideDamage[name].rawdelete(attacker);
		}
	}
}

function OnGameEvent_jockey_ride_end( params )
{
	local jockey = GetPlayerFromUserID( params["userid"] );
	local victim = GetPlayerFromUserID( params["victim"] );
	if ( !jockey || !victim )
		return;
	
	local name = GetCharacterDisplayName( victim );
	
	if ( jockey in SessionState.JockeyRideDamage[name] )
		SessionState.JockeyRideDamage[name].rawdelete(jockey);
}
