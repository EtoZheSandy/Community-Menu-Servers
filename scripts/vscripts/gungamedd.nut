//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: Death's Door\n");
Msg("Made by Rayman1103\n");

IncludeScript("community5");
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
