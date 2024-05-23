//-----------------------------------------------------
Msg("Activating Tuesday Night Tank Fight!!\n");
Msg("Made by ANG3Lskye\n");

IncludeScript("zsl_base");

if ( !IsModelPrecached( "models/infected/hulk.mdl" ) )
	PrecacheModel( "models/infected/hulk.mdl" );
if ( !IsModelPrecached( "models/infected/hulk_dlc3.mdl" ) )
	PrecacheModel( "models/infected/hulk_dlc3.mdl" );
if ( !IsModelPrecached( "models/infected/hulk_l4d1.mdl" ) )
	PrecacheModel( "models/infected/hulk_l4d1.mdl" );

ZSLOptions <-
{
	cm_CommonLimit = 0
	cm_DominatorLimit = 0
	cm_MaxSpecials = 0
	cm_SpecialRespawnInterval = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	TankLimit = 10
	cm_TankLimit = 10
	//cm_TankRun = 1
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 0
	ProhibitBosses = false
	//TankRunSpawnDelay = 0
	cm_AllowSurvivorRescue = 0
	ZombieTankHealth = 1000
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

	RandomPrimary =
	[
		"autoshotgun",
		"rifle",
		"rifle_desert",
		//"sniper_military",
		"shotgun_spas",
		"rifle_ak47"
	]
	RandomSecondary =
	[
		"pistol_magnum",
	]
	
	function GetDefaultItem(id)
	{
		local PRand = RandomInt(0,RandomPrimary.len()-1);
		local SRand = RandomInt(0,RandomSecondary.len()-1);
		if(id == 0) return RandomPrimary[PRand];
		else if(id == 1) return RandomSecondary[SRand];
		return 0;
	}
}

ZSLState <-
{
	ZSL_OnTakeDamageFunc = function( damageTable )
	{
		if ( damageTable.Attacker.IsPlayer() && damageTable.Victim.IsPlayer() )
		{
			if ( damageTable.Victim.IsSurvivor() )
			{
				if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_TANK )
					damageTable.DamageDone = 9;
				if ( damageTable.DamageType == (damageTable.DamageType | DirectorScript.DMG_BURN) )
				{
					if ( !Director.HasAnySurvivorLeftSafeArea() )
						return true;
					if ( ResponseCriteria.GetValue( damageTable.Victim, "instartarea" ) == "0" )
						return false;
				}
			}
		}

		return true;
	}
	IsRaceEvent = false
	SaferoomAward = 1
	TieBreaker = "kills"
	SpawnTank = false
	TriggerRescue = false
	TankModelsBase = [ "models/infected/hulk.mdl", "models/infected/hulk_dlc3.mdl", "models/infected/hulk_l4d1.mdl" ]
	TankModels = [ "models/infected/hulk.mdl", "models/infected/hulk_dlc3.mdl", "models/infected/hulk_l4d1.mdl" ]
	ModelCheck = false
	SpawnTankInterval = 7.0
	WipedWeapons = false
	RandomWeps =
	[
		"autoshotgun"
		"shotgun_spas"
		"rifle"
		"rifle_ak47"
		"rifle_desert"
		//"hunting_rifle"
		//"sniper_military"
		"smg_silenced"
	]
	RandomSkins =
	{
		autoshotgun = 1
		rifle = 2
		rifle_ak47 = 2
		smg_silenced = 1
	}
}

AddDefaultsToTable( "ZSLOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ZSLState", g_ModeScript, "MutationState", g_ModeScript );

function GetNextStage()
{
	if ( SessionState.SpawnTank )
	{
		SessionOptions.ScriptedStageType = STAGE_TANK
		SessionOptions.ScriptedStageValue = 1
		SessionState.SpawnTank = false;
	}
	else if ( !SessionState.SpawnTank )
	{
		SessionOptions.ScriptedStageType = STAGE_DELAY
		SessionOptions.ScriptedStageValue = -1
	}
	if ( SessionState.TriggerRescue )
	{
		SessionOptions.ScriptedStageType = STAGE_ESCAPE
		SessionState.TriggerRescue = false;
	}
}

function SpawnTank()
{
	SessionState.SpawnTank = true;
	Director.ForceNextStage();
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SpawnTank()", SessionState.SpawnTankInterval );
}

function OnGameEvent_player_left_safe_area( params )
{
	if ( IsMissionFinalMap() && SessionState.HasSurvivalFinale )
	{
		SessionState.SpawnTankInterval = 5.0;
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SpawnTank()", 20.0 );
	}
	else
		SpawnTank();
}

function TriggerRescue()
{
	SessionState.TriggerRescue = true;
	Director.ForceNextStage();
	if ( Entities.FindByName( null, "relay_car_ready" ) )
		EntFire( "relay_car_ready", "Trigger" );
}

function OnGameEvent_round_start_post_nav( params )
{
	for ( local gascan; gascan = Entities.FindByModel( gascan, "models/props_junk/gascan001a.mdl" ); )
		gascan.Kill();
}

function OnGameEvent_tank_spawn( params )
{
	local tank = GetPlayerFromUserID( params["userid"] );
	if ( !tank )
		return;

	tank.SetMaxHealth( 1000 );
	tank.SetHealth( 1000 );
	local modelName = tank.GetModelName();

	if ( !SessionState.ModelCheck )
	{
		SessionState.ModelCheck = true;

		if ( SessionState.TankModelsBase.find( modelName ) == null )
		{
			SessionState.TankModelsBase.append( modelName );
			SessionState.TankModels.append( modelName );
		}
	}

	local tankModels = SessionState.TankModels;
	if ( tankModels.len() == 0 )
		SessionState.TankModels.extend( SessionState.TankModelsBase );
	local foundModel = tankModels.find( modelName );
	if ( foundModel != null )
	{
		tankModels.remove( foundModel );
		return;
	}

	local randomElement = RandomInt( 0, tankModels.len() - 1 );
	local randomModel = tankModels[ randomElement ];
	tankModels.remove( randomElement );

	tank.SetModel( randomModel );
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	
	if ( ( !victim ) || ( !victim.IsSurvivor() ) )
		return;
	
	for ( local adrenaline; adrenaline = Entities.FindByClassname( adrenaline, "weapon_adrenaline" ); )
	{
		if ( !NetProps.GetPropEntity( adrenaline, "m_hOwner" ) )
			adrenaline.Kill();
	}
}

function ClearWeapons()
{
	foreach( wep, val in SessionOptions.weaponsToRemove )
	{
		if ( wep == "weapon_pistol" )
			continue;

		for ( local weapon; weapon = Entities.FindByClassname( weapon, wep ); )
		{
			if ( !weapon.GetOwnerEntity() )
				weapon.Kill();
		}
	}
}

function GiveWeapons( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	local wepSkin = 0;
	local randWep = SessionState.RandomWeps[ RandomInt( 0, SessionState.RandomWeps.len() - 1 ) ];
	if ( randWep in SessionState.RandomSkins )
		wepSkin = RandomInt(0, SessionState.RandomSkins[randWep]);

	player.GiveItem( "molotov" );
	player.GiveItem( "adrenaline" );
	player.GiveItemWithSkin( randWep, wepSkin );
	player.GiveUpgrade( DirectorScript.UPGRADE_LASER_SIGHT );
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( !SessionState.WipedWeapons )
	{
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ClearWeapons()", 0.2 );
		SessionState.WipedWeapons = true;
	}

	local invTable = {};
	GetInvTable( player, invTable );
	foreach( weapon in invTable )
		weapon.Kill();
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveWeapons(" + userid + ")", 0.1 );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}
