//-----------------------------------------------------
Msg("Activating Hot Zone\n");
Msg("Made by Rayman1103\n");

// Various director settings
MutationOptions <-
{
	ActiveChallenge = 1
	
	cm_AllowSurvivorRescue = 0
	//SpecialInitialSpawnDelayMin = 5
	//SpecialInitialSpawnDelayMax = 5
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
			return false;
		
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
		"weapon_molotov",
	]

	function GetDefaultItem( idx )
	{
		if ( idx < DefaultItems.len() )
			return DefaultItems[idx];

		return 0;
	}
	
	TempHealthDecayRate = 0.001
	function RecalculateHealthDecay()
	{
		if ( Director.HasAnySurvivorLeftSafeArea() )
		{
			TempHealthDecayRate = 0.001 // pain_pills_decay_rate default 0.27
		}
	}
}

MutationState <-
{
	LastHPRegenTime = 0
	HPRegenDelay = 2.0
	AllSurvivors = []
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( damageTable.Attacker.GetClassname() == "infected" && NetProps.GetPropInt( damageTable.Victim, "m_iTeamNum" ) == 2 )
	{
		if ( damageTable.Victim.IsIncapacitated() )
			damageTable.DamageDone = 25;
		else
			damageTable.DamageDone = 40;
	}

	return true;
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
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) || (SessionState.AllSurvivors.find( player ) != null) )
		return;

	SessionState.AllSurvivors.append( player );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}

function ForcePanicThink()
{
	EntFire( "info_director", "ForcePanicEvent" );
	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.ForcePanicThink()", 20.0 );
}

function OnGameEvent_player_left_safe_area( params )
{
	if ( !Entities.FindByClassname( null, "trigger_finale" ) )
		ForcePanicThink();
}

function OnGameEvent_round_start_post_nav( params )
{
	EntFire( "prop_minigun", "Kill" );
	EntFire( "prop_minigun_l4d1", "Kill" );
	EntFire( "prop_mounted_machine_gun", "Kill" );

	EntFire( "weapon_spawn", "Kill" );
	foreach( wep, val in MutationOptions.weaponsToRemove )
		EntFire( wep + "_spawn", "Kill" );
}

function OnGameEvent_player_incapacitated( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	local invTable = {};
	GetInvTable( player, invTable );
	if ( "slot1" in invTable )
		invTable["slot1"].Kill();
}

function Update()
{
	if ( (Time() - SessionState.LastHPRegenTime) >= SessionState.HPRegenDelay )
	{
		foreach( survivor in SessionState.AllSurvivors )
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
