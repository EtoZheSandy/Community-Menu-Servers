//-----------------------------------------------------
Msg("Activating Left 4 Gun Game: Tank Splitters\n");
Msg("Made by Rayman1103\n");

IncludeScript("tanksplitters");
IncludeScript("gungame_base");

GunGameOptions <-
{
	cm_ShouldHurry = 1
	cm_AllowSurvivorRescue = 0
	cm_InfiniteFuel = 1
	cm_ProhibitBosses = 1
	cm_CommonLimit = 0
	cm_DominatorLimit = 0
	cm_MaxSpecials = 0
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	TankLimit = 15
	cm_TankLimit = 15
	
	EscapeSpawnTanks = false
}

GunGameState <-
{
	HPRegenTime = 3.0
	TankSpawnDelay = 10
}

AddDefaultsToTable( "GunGameOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "GunGameState", g_ModeScript, "MutationState", g_ModeScript );

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( damageTable.Attacker.IsPlayer() && damageTable.Victim.IsPlayer() )
	{
		if ( damageTable.Victim.IsSurvivor() && damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_TANK )
			damageTable.DamageDone = 10;
		else if ( damageTable.Victim.GetZombieType() == DirectorScript.ZOMBIE_TANK && damageTable.Attacker.IsSurvivor() )
		{
			if ( (damageTable.Inflictor) && (damageTable.Inflictor.GetClassname() == "pipe_bomb_projectile") )
				damageTable.DamageDone = 2000;
			else if ( damageTable.Weapon )
			{
				if ( damageTable.Weapon.GetClassname() == "weapon_melee" )
					damageTable.DamageDone = 6000;
				if ( damageTable.Weapon.GetClassname() == "weapon_chainsaw" )
					damageTable.DamageDone = 500;
			}
		}
	}

	return true;
}

function OnGameEvent_player_spawn( params )
{
	// Intentionally left blank to override function in tanksplitters.nut
}
