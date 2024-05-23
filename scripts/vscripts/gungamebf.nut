//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: Brute Force\n");
Msg("Made by Rayman1103\n");

IncludeScript("bruteforce");
IncludeScript("gungame_base");

GunGameOptions <-
{
	cm_DominatorLimit = 10 //12
	cm_MaxSpecials = 10 //12
	
	SmokerLimit = 0
	BoomerLimit = 2
	HunterLimit = 2
	SpitterLimit = 2
	JockeyLimit = 2
	ChargerLimit = 2
}

GunGameState <-
{
	GG_OnTakeDamageFunc = function( damageTable )
	{
		if ( damageTable.Attacker.IsPlayer() && damageTable.Victim.IsPlayer() )
		{
			if ( damageTable.Victim.IsSurvivor() )
			{
				if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_BOOMER )
					damageTable.DamageDone = 5;
				else if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_HUNTER )
					damageTable.DamageDone = 10;
				else if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_SPITTER && damageTable.DamageType == (1 << 7) )
					damageTable.DamageDone = 5;
				else if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_JOCKEY )
					damageTable.DamageDone = 5;
				else if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_CHARGER )
					damageTable.DamageDone = 10;
			}
		}

		return true;
	}
}

AddDefaultsToTable( "GunGameOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "GunGameState", g_ModeScript, "MutationState", g_ModeScript );

// Remove the vomitjar from the Gun Game weapon list
local foundVomitjar = GunGameBase.ListOfRandomWeps.find( "vomitjar" );
if ( foundVomitjar != null )
	GunGameBase.ListOfRandomWeps.remove( foundVomitjar );

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
	// Intentionally left blank to override function in bruteforce.nut
}

function OnGameEvent_choke_start( params )
{
	Convars.SetValue( "tongue_force_break", "1" );
}
