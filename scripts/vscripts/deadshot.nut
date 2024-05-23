//-----------------------------------------------------
Msg("Activating Deadshot!\n");
Msg("Made by Rayman1103 and ANG3Lskye\n");

MutationOptions <-
{
	//cm_BaseCommonAttackDamage = 12
	cm_CommonLimit = 40
	cm_DominatorLimit = 0
	cm_MaxSpecials = 0
	AlwaysAllowWanderers = true
	NumReservedWanderers = 40
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 2
	RelaxMaxFlowTravel = 50
	MegaMobMaxSize = 40
	MegaMobMinSize = 40
	MegaMobSize = 40
	MobMaxPending = 40
	MobSpawnMaxTime = 2
	MobSpawnMinTime = 1
	MobSpawnSize = 40
	SurvivorMaxIncapacitatedCount = 1
	
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	SpitterLimit = 0
	JockeyLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0

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
		//weapon_pipe_bomb = 0
		//weapon_molotov = 0
		//weapon_vomitjar = 0
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
		
	]

	function GetDefaultItem( idx )
	{
		if ( idx < DefaultItems.len() )
		{
			return DefaultItems[idx];
		}
		return 0;
	}

	TempHealthDecayRate = 0.001 //100
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
	StartMobTime = 0
	StartMobDelay = 30
	StopMobTime = 0
	StopMobDelay = 90
	MobStartThink = false
	MobStopThink = false
	SpawnedSurvivors = []
	RandomWeps =
	[
		"pumpshotgun"
		"shotgun_chrome"
		"hunting_rifle"
	]
}

function AllowTakeDamage( damageTable )
{
	if ( !damageTable.Attacker || !damageTable.Victim )
		return true;

	if ( damageTable.Weapon )
	{
		if ( damageTable.Victim.GetClassname() == "infected" )
		{
			if ( damageTable.Weapon.GetClassname() == "weapon_pistol" )
			{
				if ( GetDifficulty() == 0 )
					damageTable.DamageDone = 1;
				else
					damageTable.DamageDone = 3;
			}
			else if ( damageTable.Weapon.GetClassname() == "weapon_pistol_magnum" )
			{
				if ( GetDifficulty() == 0 )
					damageTable.DamageDone = 2;
				else
					damageTable.DamageDone = 6;
			}
		}
	}
	if ( (damageTable.Victim.IsPlayer()) && (damageTable.Victim.IsSurvivor()) )
	{
		if ( damageTable.Attacker.GetClassname() == "infected" )
			damageTable.DamageDone = 24;
		else if ( (damageTable.Attacker.IsPlayer()) && (damageTable.Attacker.IsSurvivor()) )
		{
			if ( damageTable.DamageType == 8 )
				return true;
			else
				return false;
		}
	}

	return true;
}

function AllowBash( basher, bashee )
{
	if ( basher.IsSurvivor() && NetProps.GetPropInt( bashee, "m_iTeamNum" ) == 3 )
		return ALLOW_BASH_PUSHONLY;
}

function OnGameEvent_player_incapacitated( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	DoEntFire( "!self", "CancelCurrentScene", "", 0, null, player );
	player.TakeDamage( 999, 0, null );
}

function OnGameEvent_player_death( params )
{
	if ( !("userid" in params) )
		return;
	
	local victim = GetPlayerFromUserID( params["userid"] );
	
	if ( ( !victim ) || ( !victim.IsSurvivor() ) )
		return;
	
	EntFire( "survivor_death_model", "BecomeRagdoll" );
}

function GiveWeapons( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;
	
	player.GiveItem( SessionState.RandomWeps[ RandomInt( 0, SessionState.RandomWeps.len() - 1 ) ] );
	player.GiveItem( "weapon_pipe_bomb" );
	local melee = SpawnMeleeWeapon( "any", Vector( 0, 0, 0 ), QAngle( 0, 0, 0 ) );
	if ( melee )
	{
		DoEntFire( "!self", "Use", "", 0, player, melee );
		DoEntFire( "!self", "Kill", "", 0.1, null, melee );
	}
	player.GiveItem( "weapon_pistol_magnum" );
	player.GiveItem( "weapon_pistol" );
	player.GiveItem( "weapon_pistol" );
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

	if ( SessionState.SpawnedSurvivors.find( player ) == null )
	{
		SessionState.SpawnedSurvivors.append( player );
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
	}
}

function OnGameEvent_round_start_post_nav( params )
{
	EntFire( "tankdoorout_button", "Unlock" );
	EntFire( "tank_sound_timer", "Kill" );
	EntFire( "weapon_melee_spawn", "Kill" );
	EntFire( "weapon_spawn", "Kill" );
	foreach( wep, val in MutationOptions.weaponsToRemove )
		EntFire( wep + "_spawn", "Kill" );
}

function OnGameEvent_player_left_safe_area( params )
{
	EntFire( "info_director", "ForcePanicEvent", "", 20 );
	SessionState.StopMobTime = Time();
	SessionState.MobStopThink = true;
}

function Update()
{
	DirectorOptions.RecalculateHealthDecay();

	if ( SessionState.MobStopThink )
	{
		if ( (Time() - SessionState.StopMobTime) >= SessionState.StartMobDelay )
		{
			SessionOptions.cm_CommonLimit = 0;
			SessionState.StartMobTime = Time();
			SessionState.MobStartThink = true;
			SessionState.MobStopThink = false;
		}
	}
	else if ( SessionState.MobStartThink )
	{
		if ( (Time() - SessionState.StopMobTime) >= SessionState.StartMobDelay )
		{
			SessionOptions.cm_CommonLimit = 40;
			EntFire( "info_director", "ForcePanicEvent" );
			SessionState.StopMobTime = Time();
			SessionState.MobStopThink = true;
			SessionState.MobStartThink = false;
		}
	}
}
