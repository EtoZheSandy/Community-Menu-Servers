//-----------------------------------------------------

GunGameBaseOptions <-
{
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

GunGameBaseState <-
{
	GG_OnTakeDamageFunc = null
	AvailableSurvivor = {}
	GiveWeaponSurvivor = {}
	BeingHealed = {}
	HPRegenTime = 4.0
	LastHPRegenTime = 0
	AllowDamage = false
	GG_AllSurvivors = []
}

AddDefaultsToTable( "GunGameBaseOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "GunGameBaseState", g_ModeScript, "MutationState", g_ModeScript );

GunGameBase <-
{
	ListOfRandomWeps =
	[
		"pistol"
		"pistol_magnum"
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
		"pipe_bomb"
		"molotov"
		"vomitjar"
		"grenade_launcher"
		"rifle_m60"
		"chainsaw"
		"random_melee" //baseball_bat
		"smg_mp5"
		"rifle_sg552"
		"random_css_sniper"	//"sniper_scout" //"sniper_awp"
	]

	ListOfRandomSnipers =
	[
		"sniper_scout"
		"sniper_awp"
	]

	ListOfWepSkins =
	{
		pistol_magnum = 2
		smg = 1
		smg_silenced = 1
		pumpshotgun = 1
		shotgun_chrome = 1
		autoshotgun = 1
		rifle = 2
		rifle_ak47 = 2
		hunting_rifle = 1
	}

	function GiveRandomWeapon( userid )
	{
		local player = GetPlayerFromUserID( userid );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		local wepSkin = 0;
		local randWep = ListOfRandomWeps[ RandomInt( 0, ListOfRandomWeps.len() - 1 ) ];
		if ( randWep == "random_melee" )
		{
			local melee = g_ModeScript.SpawnMeleeWeapon( "any", Vector( 0, 0, 0 ), QAngle( 0, 0, 0 ) );
			if ( melee )
			{
				DoEntFire( "!self", "Use", "", 0, player, melee );
				DoEntFire( "!self", "Kill", "", 0.1, null, melee );
			}
		}
		else if ( randWep == "random_css_sniper" )
			player.GiveItem( ListOfRandomSnipers[ RandomInt( 0, ListOfRandomSnipers.len() - 1 ) ] );
		else
		{
			if ( randWep in ListOfWepSkins )
				wepSkin = RandomInt(0, ListOfWepSkins[randWep]);
			player.GiveItemWithSkin( randWep, wepSkin );
		}
		
		local invTable = {};
		GetInvTable( player, invTable );
		foreach( slot, weapon in invTable )
		{
			if ( slot == "slot0" || slot == "slot1" )
			{
				local upgrades = NetProps.GetPropInt( weapon, "m_upgradeBitVec" );
				NetProps.SetPropInt( weapon, "m_upgradeBitVec", ( upgrades | 4 ) );
				player.SwitchToItem( weapon.GetClassname() );
			}
			else if ( slot == "slot2" )
				player.SwitchToItem( weapon.GetClassname() );
		}
	}

	function GiveWeapons()
	{
		foreach( survivor in SessionState.GG_AllSurvivors )
		{
			if ( SessionState.AvailableSurvivor[GetCharacterDisplayName( survivor )] )
			{
				local invTable = {};
				GetInvTable( survivor, invTable );
				foreach( slot, weapon in invTable )
				{
					if ( slot == "slot0" || slot == "slot1" || slot == "slot2" )
						weapon.Kill();
				}
				
				EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GunGameBase.GiveRandomWeapon(" + survivor.GetPlayerUserId() + ")", 0.1 );
			}
			else
			{
				SessionState.GiveWeaponSurvivor[GetCharacterDisplayName( survivor )] <- true;
			}
		}
		
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GunGameBase.GiveWeapons()", 10.0 );
	}

	function GiveWeapon( userid )
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
		
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GunGameBase.GiveRandomWeapon(" + player.GetPlayerUserId() + ")", 0.1 );
	}

	function KillInfected( infectedID, attackerID )
	{
		local infected = GetPlayerFromUserID( infectedID );
		local attacker = GetPlayerFromUserID( attackerID );
		if ( !infected || !attacker )
			return;

		infected.TakeDamage( infected.GetHealth(), 0, attacker );

		if ( NetProps.GetPropInt( infected, "m_lifeState" ) == 0 )
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GunGameBase.KillInfected(" + infectedID + "," + attackerID + ")", 0.1 );
	}

	function OnGameEvent_player_now_it( params )
	{
		local player = GetPlayerFromUserID( params["userid"] );
		if ( (!player) || (player.IsSurvivor()) )
			return;

		local KillTimer = 3.0;
		if ( player.GetZombieType() == DirectorScript.ZOMBIE_TANK )
			KillTimer = 20.0;

		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GunGameBase.KillInfected(" + params["userid"] + "," + params["attacker"] + ")", KillTimer );
	}

	function OnGameEvent_round_start_post_nav( params )
	{
		EntFire( "weapon_spawn", "Kill" );
		foreach( wep, val in SessionOptions.weaponsToRemove )
			EntFire( wep + "_spawn", "Kill" );
		for ( local melee_spawn; melee_spawn = Entities.FindByClassname( melee_spawn, "weapon_melee_spawn" ); )
			melee_spawn.Kill();
	}

	function OnGameEvent_item_pickup( params )
	{
		if ( params["item"] == "gascan" || params["item"] == "cola_bottles" )
		{
			local player = GetPlayerFromUserID( params["userid"] );
			SessionState.AvailableSurvivor[GetCharacterDisplayName( player )] <- false;
		}
	}

	function OnGameEvent_weapon_drop( params )
	{
		if ( !( "propid" in params ) )
			return;

		local weapon = EntIndexToHScript( params["propid"] );
		if ( weapon )
		{
			switch( weapon.GetClassname() )
			{
				case "weapon_gascan":
				case "weapon_propanetank":
				case "weapon_oxygentank":
				case "weapon_gnome":
				case "weapon_cola_bottles":
				case "weapon_fireworkcrate":
				{
					local player = GetPlayerFromUserID( params["userid"] );
					SessionState.AvailableSurvivor[GetCharacterDisplayName( player )] <- true;
					if ( SessionState.GiveWeaponSurvivor[GetCharacterDisplayName( player )] )
					{
						GiveWeapon( player.GetPlayerUserId() );
						SessionState.GiveWeaponSurvivor[GetCharacterDisplayName( player )] <- false;
					}
					break;
				}
			}
		}
	}

	function OnGameEvent_heal_begin( params )
	{
		local player = GetPlayerFromUserID( params["subject"] );
		local healer = GetPlayerFromUserID( params["userid"] );
		
		if ( !player || !healer )
			return;
		
		SessionState.AvailableSurvivor[GetCharacterDisplayName( healer )] <- false;
		SessionState.BeingHealed[GetCharacterDisplayName( player )] <- true;
	}

	function OnGameEvent_heal_end( params )
	{
		local player = GetPlayerFromUserID( params["subject"] );
		local healer = GetPlayerFromUserID( params["userid"] );
		
		if ( !player || !healer )
			return;
		
		SessionState.AvailableSurvivor[GetCharacterDisplayName( healer )] <- true;
		SessionState.BeingHealed[GetCharacterDisplayName( player )] <- false;
		if ( SessionState.GiveWeaponSurvivor[GetCharacterDisplayName( healer )] )
		{
			GiveWeapon( healer.GetPlayerUserId() );
			SessionState.GiveWeaponSurvivor[GetCharacterDisplayName( healer )] <- false;
		}
	}

	function GG_SurvivorPostSpawn( userid )
	{
		local player = GetPlayerFromUserID( userid );
		if ( (!player) || (!player.IsSurvivor()) )
			return;

		if ( SessionState.HPRegenTime )
		{
			player.SetHealthBuffer( 0 );
			player.SetHealth( player.GetMaxHealth() );

			local maxIncap = ("SurvivorMaxIncapacitatedCount" in DirectorScript.GetDirectorOptions()) ? DirectorScript.GetDirectorOptions().SurvivorMaxIncapacitatedCount : Convars.GetFloat( "survivor_max_incapacitated_count" );
			if ( maxIncap > 0 )
			{
				player.SetReviveCount( 0 );
				NetProps.SetPropInt( player, "m_bIsOnThirdStrike", 0 );
				StopSoundOn( "Player.Heartbeat", player );
			}
		}

		SessionState.AvailableSurvivor[GetCharacterDisplayName( player )] <- true;
		SessionState.GiveWeaponSurvivor[GetCharacterDisplayName( player )] <- false;
		SessionState.BeingHealed[GetCharacterDisplayName( player )] <- false;

		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GunGameBase.GiveWeapon(" + userid + ")", 0.1 );
	}

	function OnGameEvent_player_spawn( params )
	{
		local player = GetPlayerFromUserID( params["userid"] );
		if ( (!player) || (!player.IsSurvivor()) || (SessionState.GG_AllSurvivors.find( player ) != null) )
			return;

		SessionState.GG_AllSurvivors.append( player );
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GunGameBase.GG_SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
	}
}

__CollectEventCallbacks( g_ModeScript.GunGameBase, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener );

function OnGameplayStart()
{
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.GunGameBase.GiveWeapons()", 10.0 );
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( NetProps.GetPropInt( damageTable.Victim, "m_iTeamNum" ) == 2 )
	{
		if ( !SessionState.AllowDamage && NetProps.GetPropInt( damageTable.Attacker, "m_iTeamNum" ) == 2 )
			return false;
	}
	else
	{
		if ( damageTable.DamageType == ( DirectorScript.DMG_BLAST | DirectorScript.DMG_BLAST_SURFACE ) )
			damageTable.DamageDone = 1000;
	}

	if ( SessionState.GG_OnTakeDamageFunc )
		return SessionState.GG_OnTakeDamageFunc( damageTable );
	else
		return true;
}

function GunGame_Update()
{
	if ( SessionState.HPRegenTime )
	{
		if ( (Time() - SessionState.LastHPRegenTime) >= SessionState.HPRegenTime )
		{
			foreach( survivor in SessionState.GG_AllSurvivors )
			{
				if ( NetProps.GetPropInt( survivor, "m_lifeState" ) == 0 )
				{
					if ( survivor.GetHealth() < survivor.GetMaxHealth() )
						survivor.SetHealth( survivor.GetHealth() + 1 );
				}
			}
			SessionState.LastHPRegenTime = Time();
		}
	}
}

ScriptedMode_AddUpdate( GunGame_Update );
