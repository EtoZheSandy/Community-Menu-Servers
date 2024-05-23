// On round start, we execute any script file of the name <mapname>_<gamemode>.nut
// This file is executed in the MAP_SCRIPT layer

///////////////////////////////////////////////////////////////////////////////
// We hand define (for now! would be cool if more flexible eventually) first 10 waves
//  then we have an outline of waves after that, where we randomize some values and just run it
//  with a small add based on wave #, so it slowly goes up
// Then there are a few special events for now (tank barn, witch wave)
//  which we "hand manage" in the callbacks
///////////////////////////////////////////////////////////////////////////////


//---------------------------------------------------------
// Include all entity group interfaces needed for this mode
// Entities in the MapSpawns table will be included and spawned on map start by default unless otherwise specified.
// MapSpawn table contains at minimum the group name. E.g., [ "WallBarricade" ]
// and at most four parameters: group name, spawn location, file to include, and spawn flags. E.g., [ "WallBarricade", "wall_barricade_spawn", "wall_barricade_group", SPAWN_FLAGS.SPAWN ]
// If you provide only the group name the spawn location and file to include will be generated, and the default 'spawn' flag will be used
// E.g., [ "WallBarricade" ]
// If you provide two parameters it assumes they are the group name and spawn flag, and will auto generate the spawn location and file to include
// E.g., [ "WallBarricade", SPAWN_FLAGS.NOSPAWN ]
// If you provide three parameters it assumes group name, spawn location, and file to include.  It will use the default 'spawn' flag
// E.g., [ "WallBarricade", "my_barricade_spawn", "my_barricade_group" ]
//---------------------------------------------------------
MapSpawns <- 
[
	["Rifle", "trader_rifle_spawn", "trader_rifle_group"],
	["RifleAK47", "trader_rifle_ak47_spawn", "trader_rifle_ak47_group"],
	["RifleDesert", "trader_rifle_desert_spawn", "trader_rifle_desert_group"],
	["RifleSG552", "trader_rifle_sg552_spawn", "trader_rifle_sg552_group"],
	["Pistol", "trader_pistol_spawn", "trader_pistol_group"],
	["PistolMagnum", "trader_pistol_magnum_spawn", "trader_pistol_magnum_group"],
	["IncendiaryAmmo", "trader_incendiary_ammo_spawn", "trader_incendiary_ammo_group"],
	["ExplosiveAmmo", "trader_explosive_ammo_spawn", "trader_explosive_ammo_group"],
	["LaserSight", "trader_laser_sight_spawn", "trader_laser_sight_group"],
	["SMG", "trader_smg_spawn", "trader_smg_group"],
	["SMGSilenced", "trader_smg_silenced_spawn", "trader_smg_silenced_group"],
	["SMGMP5", "trader_smg_mp5_spawn", "trader_smg_mp5_group"],
	["PumpShotgun", "trader_pumpshotgun_spawn", "trader_pumpshotgun_group"],
	["ShotgunChrome", "trader_shotgun_chrome_spawn", "trader_shotgun_chrome_group"],
	["PipeBomb", "trader_pipe_bomb_spawn", "trader_pipe_bomb_group"],
	["Molotov", "trader_molotov_spawn", "trader_molotov_group"],
	["VomitJar", "trader_vomitjar_spawn", "trader_vomitjar_group"],
	["PainPills", "trader_pain_pills_spawn", "trader_pain_pills_group"],
	["Adrenaline", "trader_adrenaline_spawn", "trader_adrenaline_group"],
	["FirstAidKit", "trader_first_aid_kit_spawn", "trader_first_aid_kit_group"],
	["Defibrillator", "trader_defibrillator_spawn", "trader_defibrillator_group"],
	["UpgradePackIncendiary", "trader_upgradepack_incendiary_spawn", "trader_upgradepack_incendiary_group"],
	["UpgradePackExplosive", "trader_upgradepack_explosive_spawn", "trader_upgradepack_explosive_group"],
	["HuntingRifle", "trader_hunting_rifle_spawn", "trader_hunting_rifle_group"],
	["SniperMilitary", "trader_sniper_military_spawn", "trader_sniper_military_group"],
	["SniperScout", "trader_sniper_scout_spawn", "trader_sniper_scout_group"],
	["SniperAWP", "trader_sniper_awp_spawn", "trader_sniper_awp_group"],
	["AutoShotgun", "trader_autoshotgun_spawn", "trader_autoshotgun_group"],
	["ShotgunSpas", "trader_shotgun_spas_spawn", "trader_shotgun_spas_group"],
	["GrenadeLauncher", "trader_grenade_launcher_spawn", "trader_grenade_launcher_group"],
	["RifleM60", "trader_rifle_m60_spawn", "trader_rifle_m60_group"],
	["GasCan", "trader_gascan_spawn", "trader_gascan_group"],
	["PropaneTank", "trader_propanetank_spawn", "trader_propanetank_group"],
	["OxygenTank", "trader_oxygentank_spawn", "trader_oxygentank_group"],
	["FireworkCrate", "trader_fireworkcrate_spawn", "trader_fireworkcrate_group"],
	["Ammo", "trader_ammo_spawn", "trader_ammo_group"],
	["Chainsaw", "trader_chainsaw_spawn", "trader_chainsaw_group"],
	["Melee", "trader_melee_spawn", "trader_melee_group"],
	["Sell", "trader_sell_spawn", "trader_sell_group"],
	["Bill", "trader_bill_spawn", "trader_bill_group"],
	["Zoey", "trader_zoey_spawn", "trader_zoey_group"],
	["Francis", "trader_francis_spawn", "trader_francis_group"],
	["Louis", "trader_louis_spawn", "trader_louis_group"],
]


//-------------------------------------
// entities to sanitize on map spawn
//
// 'Sanitizing' is deleting entities from a map that are not wanted or 
// needed by this scripted mode. This frees up memory and CPU.
// And is sometimes needed to remove events from a map that you dont want in your mode
//-------------------------------------
SanitizeTable <-
[
	// fire these outputs on map load
	{ targetname	= "relay_intro_start", input = "kill" },
	{ targetname	= "survivorPos_*", input = "kill" },
	{ targetname	= "trader_nav_blocker", input = "blocknav" },
	{ classname		= "logic_choreographed_scene", input = "kill" },
	{ classname		= "info_remarkable", input = "kill" },
	{ classname		= "info_game_event_proxy", input = "kill" },
]


//---------------------------------------------------------
//---------------------------------------------------------
MapOptions <-
{
	SpawnSetRule = SPAWN_POSITIONAL
	SpawnSetRadius = 3000
	SpawnSetPosition = Vector( 846, 5267, 158 )
}
