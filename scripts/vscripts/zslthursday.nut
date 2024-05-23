//-----------------------------------------------------
Msg("Activating Thursday Night Jockey Trouble!!\n");
Msg("Made by ANG3Lskye\n");

IncludeScript("zsl_base");

ZSLOptions <-
{
	cm_CommonLimit = 0
	cm_MaxSpecials = 12
	cm_DominatorLimit = 12
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 12
	WitchLimit = 0
	cm_WitchLimit = 0
	cm_SpecialRespawnInterval = 0
	cm_AggressiveSpecials = 1
	cm_AutoReviveFromSpecialIncap = 1
	SpecialInitialSpawnDelayMin = 5
	SpecialInitialSpawnDelayMax = 5
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	cm_BaseCommonAttackDamage = 0
	cm_AllowSurvivorRescue = 0
	ProhibitBosses = false
	TankHitDamageModifierCoop = 0.1

	RandomPrimary =
	[
		"autoshotgun",
		"rifle",
		"rifle_desert",
		"sniper_military",
		"shotgun_spas",
		"rifle_ak47"
	]
	
	function GetDefaultItem(id)
	{
		local PRand = RandomInt(0,RandomPrimary.len()-1);
		if(id == 0) return RandomPrimary[PRand];
		return 0;
	}

	TempHealthDecayRate = 0.001
}

ZSLState <-
{
	ZSL_OnTakeDamageFunc = function( damageTable )
	{
		if ( damageTable.Attacker.IsPlayer() && damageTable.Victim.IsPlayer() )
		{
			if ( damageTable.Attacker.GetZombieType() == DirectorScript.ZOMBIE_JOCKEY && damageTable.Victim.IsSurvivor() )
			{
				local jockey = NetProps.GetPropEntity( damageTable.Victim, "m_jockeyAttacker" );
				if ( (jockey) && (jockey == damageTable.Attacker) )
					damageTable.DamageDone = 12;
			}
		}

		return true;
	}
	IsRaceEvent = false
	WipedWeapons = false
	JockeyRideDamage = {}
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

	player.GiveItem( "molotov" );
	player.GiveItemWithSkin( randWep, wepSkin );
	player.GiveUpgrade( DirectorScript.UPGRADE_LASER_SIGHT );
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( !(GetCharacterDisplayName( player ) in SessionState.JockeyRideDamage) )
		SessionState.JockeyRideDamage[GetCharacterDisplayName( player )] <- {};
	
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

function SpawnMoreTanks()
{
	ZSpawn( { type = 8 } );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SpawnMoreTanks()", 15.0 );
}

function OnGameEvent_tank_spawn( params )
{
	if ( IsMissionFinalMap() )
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SpawnMoreTanks()", 15.0 );
}

function OnGameEvent_player_hurt( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	local attacker = GetPlayerFromUserID( params["attacker"] );
	if ( (!player) || (!player.IsSurvivor()) || (!attacker) || (attacker.GetZombieType() != DirectorScript.ZOMBIE_JOCKEY) )
		return;
	
	if ( NetProps.GetPropEntity( player, "m_jockeyAttacker" ) == attacker )
	{
		local name = GetCharacterDisplayName( player );
		
		if ( !(attacker in SessionState.JockeyRideDamage[name]) )
			SessionState.JockeyRideDamage[name][attacker] <- 0;
		
		SessionState.JockeyRideDamage[name][attacker] += params["dmg_health"];
		
		if ( SessionState.JockeyRideDamage[name][attacker] >= 60 )
		{
			attacker.TakeDamage( attacker.GetHealth(), 0, Entities.First() );
			SessionState.JockeyRideDamage[name].rawdelete(attacker);
		}
	}
}

function OnGameEvent_jockey_ride_end( params )
{
	local jockey = GetPlayerFromUserID( params["userid"] );
	local victim = GetPlayerFromUserID( params["victim"] );
	if ( !jockey || !victim )
		return;
	
	local name = GetCharacterDisplayName( victim );
	
	if ( jockey in SessionState.JockeyRideDamage[name] )
		SessionState.JockeyRideDamage[name].rawdelete(jockey);
}
