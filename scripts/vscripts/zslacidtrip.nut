//-----------------------------------------------------
Msg("Activating ZSL Acid Trip\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

IncludeScript("zsl_survival_base");

ZSLOptions <-
{
	cm_ShouldHurry = 1
	TankHitDamageModifierCoop = 0.5
	cm_BaseCommonAttackDamage = 0
	
	SpitterLimit = 12
	TankLimit = 4
	cm_TankLimit = 4
	SurvivorMaxIncapacitatedCount = 0
	
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
		"weapon_adrenaline",
	]
	
	function GetDefaultItem(id)
	{
		local PRand = RandomInt(0,RandomPrimary.len()-1);
		local SRand = RandomInt(0,RandomSecondary.len()-1);
		local TRand = RandomInt(0,RandomTertiary.len()-1);
		if(id == 0) return RandomPrimary[PRand];
		else if(id == 1) return RandomSecondary[SRand];
		else if(id == 2) return RandomTertiary[TRand];
		return 0;
	}
}

AddDefaultsToTable( "ZSLOptions", g_ModeScript, "MutationOptions", g_ModeScript );

function ModifySpit()
{
	for ( local spit; spit = Entities.FindByClassname( spit, "spitter_projectile" ); )
		spit.__KeyValueFromInt( "solid", 1 );
}

function OnGameEvent_ability_use( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( !player )
		return;

	if ( player.GetZombieType() == DirectorScript.ZOMBIE_SPITTER )
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ModifySpit()", 0.2 );
}
