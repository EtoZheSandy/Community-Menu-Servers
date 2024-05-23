//-----------------------------------------------------
Msg("Activating Spitter Showdown\n");

IncludeScript("ass_base");

ASSOptions <-
{
	cm_MaxSpecials = 14
	cm_DominatorLimit = 14
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	SpitterLimit = 14
	
	TempHealthDecayRate = 0.001
	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 0.334 // pain_pills_decay_rate default 0.27
		}
	}
}

ASSState <-
{
	ASS_RoundStartFunc = function()
	{
		EntFire( "tankdoorout_button", "Unlock" );
		EntFire( "tank_sound_timer", "Kill" );
		EntFire( "spawn_church_zombie", "AddOutput", "population spitter" );
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
			if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_SPITTER && damageTable.DamageType == (1 << 7) )
				damageTable.DamageDone = 15;
		}
	}

	return true;
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();
}
