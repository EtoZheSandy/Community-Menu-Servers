//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: The Very End of You\n");

IncludeScript("veryend");
IncludeScript("gungame_base");

GunGameState <-
{
	GG_OnTakeDamageFunc = function( damageTable )
	{
		if ( damageTable.Attacker.IsPlayer() && damageTable.Victim.IsPlayer() )
		{
			if ( damageTable.Victim.IsSurvivor() )
			{
				if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_HUNTER )
					damageTable.DamageDone = 10;
			}
		}

		return true;
	}
}

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
