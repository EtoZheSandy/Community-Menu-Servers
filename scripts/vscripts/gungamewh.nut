//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: Witching Hour\n");
Msg("Made by Rayman1103\n");

IncludeScript("witchinghour");
IncludeScript("gungame_base");

GunGameState <-
{
	GG_OnTakeDamageFunc = function( damageTable )
	{
		if ( damageTable.Attacker.GetClassname() == "witch" && damageTable.Victim.IsPlayer() )
		{
			if ( damageTable.Victim.IsSurvivor() )
			{
				if ( GetDifficulty() == 0 )
					damageTable.DamageDone = 3;
				else if ( GetDifficulty() == 1 )
					damageTable.DamageDone = 4;
				else if ( GetDifficulty() == 2 )
					damageTable.DamageDone = 5;
				else if ( GetDifficulty() == 3 )
					damageTable.DamageDone = 10;
			}
		}

		return true;
	}
	HPRegenTime = 0
}

AddDefaultsToTable( "GunGameState", g_ModeScript, "MutationState", g_ModeScript );

// Remove the vomitjar from the Gun Game weapon list
local foundVomitjar = GunGameBase.ListOfRandomWeps.find( "vomitjar" );
if ( foundVomitjar != null )
	GunGameBase.ListOfRandomWeps.remove( foundVomitjar );

function OnGameEvent_player_spawn( params )
{
	// Intentionally left blank to override function in witchinghour.nut
}

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
