//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: Air Raid\n");
Msg("Made by Rayman1103\n");

IncludeScript("airraid");
IncludeScript("gungame_base");

GunGameOptions <-
{
	cm_AllowSurvivorRescue = false
	SurvivorMaxIncapacitatedCount = 1
}

GunGameState <-
{
	GG_OnTakeDamageFunc = function( damageTable )
	{
		if ( damageTable.Attacker.IsPlayer() && damageTable.Victim.IsPlayer() )
		{
			if ( damageTable.Victim.IsSurvivor() )
			{
				if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_HUNTER )
					ScriptedDamageInfo.DamageDone = 10;
			}
		}

		return true;
	}
}

AddDefaultsToTable( "GunGameOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "GunGameState", g_ModeScript, "MutationState", g_ModeScript );

function OnGameEvent_revive_success( params )
{
	if ( !("subject" in params) )
		return;
	
	local player = GetPlayerFromUserID( params["subject"] );
	
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;
	
	player.SetHealth( 25 );
	player.SetHealthBuffer( 0 );
}

function OnGameEvent_player_spawn( params )
{
	// Intentionally left blank to override function in airraid.nut
}
