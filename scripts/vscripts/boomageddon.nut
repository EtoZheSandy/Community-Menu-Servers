//-----------------------------------------------------
Msg("Activating Boomageddon\n");

IncludeScript("ass_base");

ASSOptions <-
{
	cm_MaxSpecials = 14
	cm_DominatorLimit = 14
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	BoomerLimit = 14
}

ASSState <-
{
	ASS_RoundStartFunc = function()
	{
		EntFire( "tankdoorout_button", "Unlock" );
		EntFire( "tank_sound_timer", "Kill" );
		EntFire( "spawn_church_zombie", "AddOutput", "population boomer" );
	}
}

AddDefaultsToTable( "ASSOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ASSState", g_ModeScript, "MutationState", g_ModeScript );

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( damageTable.Attacker.IsPlayer() && damageTable.Victim.IsPlayer() )
	{
		if ( damageTable.Victim.IsSurvivor() )
		{
			if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_BOOMER )
				ScriptedDamageInfo.DamageDone = 24; //33
		}
	}

	return true;
}
