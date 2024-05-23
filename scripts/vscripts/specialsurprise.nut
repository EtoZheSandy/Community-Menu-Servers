//-----------------------------------------------------
Msg("Activating Special Surprise\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	cm_DominatorLimit = 14
	cm_MaxSpecials = 14
	cm_ProhibitBosses = true
	SpecialInitialSpawnDelayMin = 999999
	SpecialInitialSpawnDelayMax = 999999
	//ZombieTankHealth = 5000
	
	BoomerLimit = 14
	SmokerLimit = 14
	HunterLimit = 14
	ChargerLimit = 14
	SpitterLimit = 14
	JockeyLimit = 14
	
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
		//weapon_melee = 0
		//weapon_chainsaw = 0
		//weapon_pipe_bomb = 0
		//weapon_molotov = 0
		//weapon_vomitjar = 0
		//weapon_first_aid_kit = 0
		//weapon_pain_pills = 0
		//weapon_adrenaline = 0
		//weapon_defibrillator = 0
		//weapon_upgradepack_incendiary = 0
		//weapon_upgradepack_explosive = 0
		//upgrade_item = 0
		ammo = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
			return false;
		
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

MutationState <-
{
	WipedWeapons = false
	SpawnedSurvivors = []
	RandomWeps =
	[
		"smg"
		"smg_silenced"
		"pumpshotgun"
		"shotgun_chrome"
		"autoshotgun"
		"shotgun_spas"
		"rifle"
		"rifle_ak47"
		"rifle_desert"
		"hunting_rifle"
		"sniper_military"
		"smg_mp5"
		"rifle_sg552"
		//"sniper_scout"
		//"sniper_awp"
	]
}

function ClearWeapons()
{
	foreach( wep, val in MutationOptions.weaponsToRemove )
	{
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

	player.GiveItem( SessionState.RandomWeps[ RandomInt( 0, SessionState.RandomWeps.len() - 1 ) ] );
	player.GiveItem( "pistol_magnum" );
	player.GiveUpgrade( DirectorScript.UPGRADE_LASER_SIGHT );
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	player.SetHealthBuffer( 0 );
	player.SetHealth( player.GetMaxHealth() );
	player.SetReviveCount( 0 );
	NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
	StopSoundOn( "Player.Heartbeat", player );

	if ( !SessionState.WipedWeapons )
	{
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ClearWeapons()", 0.2 );
		SessionState.WipedWeapons = true;
	}

	local invTable = {};
	GetInvTable( player, invTable );
	foreach( slot, weapon in invTable )
	{
		if ( slot == "slot0" || slot == "slot1" )
			weapon.Kill();
	}
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveWeapons(" + userid + ")", 0.1 );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( SessionState.SpawnedSurvivors.find( player ) == null )
	{
		SessionState.SpawnedSurvivors.append( player );
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
	}
}

function OnGameEvent_player_death( params )
{
	local victim = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( ( !victim ) || ( victim.IsPlayer() ) )
		return;
	
	local attacker = GetPlayerFromUserID( params["attacker"] );
	if ( !attacker )
		return;
	
	if ( victim.GetClassname() == "infected" )
	{
		local boss_chance = RandomInt( 0, 99 );
		if ( boss_chance == 1 )
			ZSpawn( { type = RandomInt( 7, 8 ), pos = victim.GetOrigin() } );
		else
		{
			local random_chance = RandomInt( 0, 9 );
			if ( random_chance == 1 )
				ZSpawn( { type = RandomInt( 1, 6 ), pos = victim.GetOrigin() } );
		}
	}
}
