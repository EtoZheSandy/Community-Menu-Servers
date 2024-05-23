//-----------------------------------------------------
Msg("Activating Tuesday Morning Spitter Rage\n");
Msg("Made by ANG3Lskye\n");

IncludeScript("zsl_base");

ZSLOptions <-
{
	cm_CommonLimit = 0
	cm_MaxSpecials = 14
	cm_DominatorLimit = 14
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 14
	JockeyLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	cm_ProhibitBosses = 1
	cm_AllowSurvivorRescue = 0
	cm_SpecialRespawnInterval = 12
	SpecialInitialSpawnDelayMin = 10
	SpecialInitialSpawnDelayMax = 10
	ShouldAllowSpecialsWithTank = true
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	cm_BaseCommonAttackDamage = 0
	TankHitDamageModifierCoop = 0.5
	cm_AggressiveSpecials = 1
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
		upgrade_item = 0
		ammo = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return false;
		}
		return true;
	}

	DefaultItems =
	[
		"weapon_pistol_magnum",
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
	IsRaceEvent = false
	TieBreaker = "kills"
	AutoTriggerEvents = false
}

AddDefaultsToTable( "ZSLOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ZSLState", g_ModeScript, "MutationState", g_ModeScript );

function KillSpitters( userid )
{
	local spitter = GetPlayerFromUserID( userid );
	if ( (!spitter) || (!spitter.IsValid()) )
		return;

	spitter.TakeDamage( spitter.GetHealth(), 0, Entities.First() );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (player.GetZombieType() != DirectorScript.ZOMBIE_SPITTER) )
		return;

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.KillSpitters(" + params["userid"] + ")", 30.0 );
}

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
