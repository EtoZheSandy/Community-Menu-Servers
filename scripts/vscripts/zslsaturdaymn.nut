//-----------------------------------------------------
Msg("Activating Saturday Morning Special Edition!!\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

IncludeScript("zsl_base");

ZSLOptions <-
{
	cm_CommonLimit = 0
	cm_DominatorLimit = 10
	cm_MaxSpecials = 10
	cm_SpecialRespawnInterval = 0
	SpecialInitialSpawnDelayMin = 10
	SpecialInitialSpawnDelayMax = 10
	ShouldAllowSpecialsWithTank = true
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	cm_AutoReviveFromSpecialIncap = 1
	cm_BaseCommonAttackDamage = 0.0
	//TankHitDamageModifierCoop = 0.1

	SmokerLimit = 1
	BoomerLimit = 2
	HunterLimit = 2
	SpitterLimit = 1
	JockeyLimit = 2
	ChargerLimit = 2
	//TankLimit = 0
	//cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0

	RandomPrimary =
	[
		/*"autoshotgun",
		"rifle",
		"rifle_desert",
		"sniper_military",
		"shotgun_spas",
		"rifle_ak47"*/
		"smg",
		"smg_silenced",
		"smg_mp5",
		"pumpshotgun",
		"shotgun_chrome"
	]
	RandomSecondary =
	[
		"pistol"
	]
	
	function GetDefaultItem(id)
	{
		local PRand = RandomInt(0,RandomPrimary.len()-1);
		local SRand = RandomInt(0,RandomSecondary.len()-1);
		if(id == 0) return RandomPrimary[PRand];
		else if(id == 1) return RandomSecondary[SRand];
		return 0;
	}

	TempHealthDecayRate = 0.001
}

ZSLState <-
{
	IsRaceEvent = false
	SpawnTank = false
	TriggerRescue = false
	WipedWeapons = false
	RandomWeps =
	[
		"smg"
		"smg_silenced"
		"smg_mp5"
		"pumpshotgun"
		"shotgun_chrome"
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
