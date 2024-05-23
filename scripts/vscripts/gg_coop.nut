//-----------------------------------------------------
Msg("Activating Gun Game\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	//cm_CommonLimit = 0
	//cm_DominatorLimit = 14
	cm_MaxSpecials = 3
	cm_SpecialRespawnInterval = 30
	SpecialInitialSpawnDelayMin = 20
	SpecialInitialSpawnDelayMax = 20
	
	/*SmokerLimit = 3
	BoomerLimit = 2
	HunterLimit = 3
	SpitterLimit = 2
	JockeyLimit = 2
	ChargerLimit = 2*/
	
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
		weapon_chainsaw = 0
		weapon_pipe_bomb = 0
		weapon_molotov = 0
		weapon_vomitjar = 0
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
		{
			return false;
		}
		return true;
	}
	
	function ShouldAvoidItem( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return true;
		}
		return false;
	}
	
	DefaultItems =
	[
		
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
	PlayerGun = {}
}

::GunState <-
{
	GunProgress = {}
}

::ListOfWeps <-
[
	"random_melee"
	"chainsaw"
	"pistol"
	"dual_pistols"
	"pistol_magnum"
	"sniper_scout"
	"pumpshotgun"
	"sniper_awp"
	"shotgun_chrome"
	"smg"
	"smg_silenced"
	"sniper_military"
	"hunting_rifle"
	"rifle_desert"
	"smg_mp5"
	"rifle_sg552"
	"shotgun_spas"
	"rifle_ak47"
	"autoshotgun"
	"rifle"
	"pipe_bomb"
	"molotov"
	"rifle_m60"
	"grenade_launcher"
]

function GiveWeapons( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	local invTable = {};
	GetInvTable( player, invTable );
	foreach( slot, weapon in invTable )
	{
		if ( slot == "slot0" || slot == "slot1" || slot == "slot2" )
			weapon.Kill();
	}
	
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveAdvancedGun(" + userid + ")", 0.1 );
}

function GiveAdvancedGun( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	local weapon = ListOfWeps[GunState.GunProgress[ GetCharacterDisplayName( player ) ]];
	if ( weapon == "dual_pistols" )
	{
		player.GiveItem( "pistol" );
		player.GiveItem( "pistol" );
	}
	else if ( weapon == "random_melee" )
	{
		local melee = SpawnMeleeWeapon( "any", Vector( 0, 0, 0 ), QAngle( 0, 0, 0 ) );
		if ( melee )
		{
			DoEntFire( "!self", "Use", "", 0, player, melee );
			DoEntFire( "!self", "Kill", "", 0.1, null, melee );
		}
	}
	else
	{
		player.GiveItem( weapon );
	
		local items = {};
		GetInvTable( player, items );
		foreach( item in items )
		{
			if ( item.GetClassname() == "weapon_" + weapon )
				SessionState.PlayerGun[ GetCharacterDisplayName( player ) ] <- item;
		}
	}
}

function AdvanceGun( player )
{
	local invTable = {};
	GetInvTable( player, invTable );

	local weapon = ListOfWeps[ GunState.GunProgress[ GetCharacterDisplayName( player ) ] ];
	if ( weapon == "dual_pistols" )
	{
		invTable["slot1"].Kill();
		//invTable["slot1"].Kill();
	}
	else if ( weapon == "random_melee" )
		invTable["slot1"].Kill();
	else
	{
		foreach( item in invTable )
		{
			if ( item.GetClassname() == "weapon_" + weapon )
				item.Kill();
		}
	}
	
	if ( weapon == "grenade_launcher" )
		GunState.GunProgress[ GetCharacterDisplayName( player ) ] = 0;
	else
		GunState.GunProgress[ GetCharacterDisplayName( player ) ]++;

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveAdvancedGun(" + player.GetPlayerUserId() + ")", 0.1 );
}

function OnShutdown()
{
	if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_ROUND_RESTART )
	{
		SaveTable( "gungame_progress", GunState.GunProgress );
	}
	else if ( SessionState.ShutdownReason == SCRIPT_SHUTDOWN_LEVEL_TRANSITION )
	{
		local nextMap = "";
		local changelevel = null;
		if ( changelevel = Entities.FindByClassname( changelevel, "info_changelevel" ) )
			nextMap = NetProps.GetPropString( changelevel, "m_mapName" );
		else if ( changelevel = Entities.FindByClassname( changelevel, "trigger_changelevel" ) )
			nextMap = NetProps.GetPropString( changelevel, "m_mapName" );

		if ( SessionState.NextMap != nextMap )
			return;

		SaveTable( "gungame_progress", GunState.GunProgress );
	}
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( NetProps.GetPropInt( damageTable.Victim, "m_iTeamNum" ) == 2 )
	{
		if ( damageTable.Attacker.GetClassname() == "infected" )
		{
			if ( GetDifficulty() == 0 || GetDifficulty() == 1 )
				damageTable.DamageDone = 5;
			else if ( GetDifficulty() == 2 )
				damageTable.DamageDone = 10;
			else if ( GetDifficulty() == 3 )
				damageTable.DamageDone = 20;
		}
		else if ( damageTable.Attacker.IsPlayer() )
		{
			if ( damageTable.Attacker.IsSurvivor() && IsPlayerABot( damageTable.Attacker ) )
				return false;
		}
	}
	else
	{
		if ( damageTable.DamageType == ( DirectorScript.DMG_BLAST | DirectorScript.DMG_BLAST_SURFACE ) )
			damageTable.DamageDone = 1000;
	}

	return true;
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	
	if ( !victim )
		return;
	
	if ( victim.IsSurvivor() )
	{
		local weapon = ListOfWeps[ GunState.GunProgress[ GetCharacterDisplayName( victim ) ] ];
		if ( weapon != "pistol" && weapon != "dual_pistols" && weapon != "random_melee" && weapon != "chainsaw" )
			SessionState.PlayerGun[ GetCharacterDisplayName( victim ) ].Kill();
	}
	else
	{
		local attacker = GetPlayerFromUserID( params["attacker"] );
		if ( (attacker) && (attacker.IsSurvivor()) )
		{
			local weapon = params["weapon"];
			local weapon_progress = ListOfWeps[ GunState.GunProgress[ GetCharacterDisplayName( attacker ) ] ];

			if ( weapon == "entityflame" || weapon == "inferno" )
				weapon = "molotov";
			else if ( weapon == "grenade_launcher_projectile" )
				weapon = "grenade_launcher";
			else if ( weapon == "melee" )
				weapon = "random_melee";
			
			if ( weapon == weapon_progress )
				AdvanceGun( attacker );
		}
	}
}

function OnGameEvent_round_start_post_nav( params )
{
	RestoreTable( "gungame_progress", GunState.GunProgress );

	EntFire( "weapon_spawn", "Kill" );
	foreach( wep, val in MutationOptions.weaponsToRemove )
		EntFire( wep + "_spawn", "Kill" );
	
	for ( local melee_spawn; melee_spawn = Entities.FindByClassname( melee_spawn, "weapon_melee_spawn" ); )
		melee_spawn.Kill();
	
	EntFire( "weapon_pipe_bomb", "Kill" );
	EntFire( "weapon_molotov", "Kill" );
	EntFire( "weapon_vomitjar", "Kill" );
}

function OnGameEvent_revive_success( params )
{
	local player = GetPlayerFromUserID( params["subject"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;
	
	local weapon = ListOfWeps[ GunState.GunProgress[ GetCharacterDisplayName( player ) ] ];
	if ( weapon != "pistol" && weapon != "dual_pistols" )
	{
		local invTable = {};
		GetInvTable( player, invTable );
		if ( "slot1" in invTable )
			invTable["slot1"].Kill();
	}
}

function OnGameEvent_defibrillator_used( params )
{
	if ( !("subject" in params) )
		return;
	
	local player = GetPlayerFromUserID( params["subject"] );
	
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;
	
	local weapon = ListOfWeps[ GunState.GunProgress[ GetCharacterDisplayName( player ) ]] ;
	if ( weapon != "random_melee" && weapon != "chainsaw" )
		GiveWeapons( params["subject"] );
}

function OnGameEvent_survivor_rescued( params )
{
	if ( !("victim" in params) )
		return;

	GiveWeapons( params["victim"] );
}

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	if ( !(GetCharacterDisplayName( player ) in GunState.GunProgress) )
		GunState.GunProgress[ GetCharacterDisplayName( player ) ] <- 0;
	
	SessionState.PlayerGun[ GetCharacterDisplayName( player ) ] <- null;
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GiveWeapons(" + userid + ")", 0.1 );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}
