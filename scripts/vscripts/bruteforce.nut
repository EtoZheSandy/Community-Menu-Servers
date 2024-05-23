//-----------------------------------------------------
Msg("Activating Brute Force\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

IncludeScript("ass_base");

ASSOptions <-
{
	cm_AutoReviveFromSpecialIncap = 1
	cm_DominatorLimit = 14 //10
	cm_MaxSpecials = 14 //10
	cm_SpecialRespawnInterval = 5
	SpecialInitialSpawnDelayMin = 2
	SpecialInitialSpawnDelayMax = 3
	ShouldAllowSpecialsWithTank = true
	
	SmokerLimit = 0
	BoomerLimit = 3
	HunterLimit = 3
	SpitterLimit = 3
	JockeyLimit = 2
	ChargerLimit = 3

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
		weapon_pipe_bomb = 0
		weapon_molotov = 0
		weapon_vomitjar = 0
		weapon_first_aid_kit = 0
		weapon_pain_pills = 0
		weapon_adrenaline = 0
		weapon_defibrillator = 0
		weapon_upgradepack_incendiary = 0
		weapon_upgradepack_explosive = 0
		//upgrade_item = 0
		ammo = 0
	}
	
	TempHealthDecayRate = 0.334 //0.001
}

AddDefaultsToTable( "ASSOptions", g_ModeScript, "MutationOptions", g_ModeScript );

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( damageTable.Attacker.IsPlayer() && damageTable.Victim.IsPlayer() )
	{
		if ( damageTable.Victim.IsSurvivor() )
		{
			if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_BOOMER )
				damageTable.DamageDone = 10;
			else if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_SPITTER && damageTable.DamageType == (1 << 7) )
				damageTable.DamageDone = 10;
			else if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_JOCKEY )
				damageTable.DamageDone = 10;
			else if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_CHARGER )
				damageTable.DamageDone = 10;
		}
	}

	return true;
}
