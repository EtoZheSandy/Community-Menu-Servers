//-----------------------------------------------------
Msg("Activating ZSL Tankball!!\n");
Msg("Made by ANG3Lskye\n");

IncludeScript("zsl_survival_base");

ZSLOptions <-
{
	TankLimit = 12
	cm_TankLimit = 12
	TankHitDamageModifierCoop = 0.25
	SurvivorMaxIncapacitatedCount = 0

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
		weapon_chainsaw = 0
		weapon_molotov = 0
		weapon_pipe_bomb = 0
		weapon_vomitjar = 0
		weapon_first_aid_kit = 0
		weapon_adrenaline = 0
		weapon_pain_pills = 0
		weapon_defibrillator = 0
		weapon_upgradepack_incendiary = 0
		weapon_upgradepack_explosive = 0
		weapon_melee = 0
		upgrade_item = 0
		ammo = 0
	}

	DefaultItems =
	[
		"weapon_pistol",
		"weapon_adrenaline",
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

ZSLState <-
{
	ZSL_OnTakeDamageFunc = function( damageTable )
	{
		if ( damageTable.Attacker.IsPlayer() && damageTable.Victim.IsPlayer() )
		{
			if ( damageTable.Attacker.IsSurvivor() && damageTable.Victim.GetZombieType() == DirectorScript.ZOMBIE_TANK )
				return false;
		}

		return true;
	}
}

AddDefaultsToTable( "ZSLOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ZSLState", g_ModeScript, "MutationState", g_ModeScript );

ZSLBase.ZSLSpawnTank = function()
{
	ZSpawn( { type = 8 } );
	SessionState.ZSLTanksSpawned++;
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ZSLBase.ZSLSpawnTank()", 5.0 );
}

ZSLBase.ZSLAutoStart = function()
{
	if ( SessionState.AutoStarted )
		return;

	ZSLSpawnTank();
	SessionState.HPDecayActive = true;
	SessionState.AutoStarted = true;
}
