//-----------------------------------------------------
Msg("Activating Friday Morning Gnome Patrol!!\n");
Msg("Made by ANG3Lskye\n");

IncludeScript("zsl_base");

ZSLOptions <-
{
	cm_CommonLimit = 15
	cm_MaxSpecials = 5
	cm_DominatorLimit = 5
	BoomerLimit = 2
	SmokerLimit = 0
	HunterLimit = 1
	ChargerLimit = 0
	SpitterLimit = 2
	JockeyLimit = 0
	TankLimit = 0
	cm_TankLimit = 0
	WitchLimit = 0
	cm_WitchLimit = 0
	cm_SpecialRespawnInterval = 15
	cm_AggressiveSpecials = 1
	SpecialInitialSpawnDelayMin = 10
	SpecialInitialSpawnDelayMax = 10
	cm_WanderingZombieDensityModifier = 0.0
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	cm_AllowSurvivorRescue = 0
	ProhibitBosses = false
	SurvivorMaxIncapacitatedCount = 0

	DefaultItems =
	[
		"weapon_gnome",
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

ZSLState <-
{
	IsRaceEvent = false
	SaferoomWeaponNeeded = "weapon_gnome"
	EventRules = "[RULES] Make it to the saferoom (with the Gnome) for 1 point. Finale (escape) map is now a survival round, last one standing gets the bonus point. Most points at the end wins!!"
}

AddDefaultsToTable( "ZSLOptions", g_ModeScript, "MutationOptions", g_ModeScript );
AddDefaultsToTable( "ZSLState", g_ModeScript, "MutationState", g_ModeScript );

function SurvivorPostSpawn( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	local buttons = NetProps.GetPropInt( player, "m_afButtonDisabled" );
	if ( !(buttons == ( buttons | DirectorScript.IN_ATTACK )) )
		NetProps.SetPropInt( player, "m_afButtonDisabled", ( buttons | DirectorScript.IN_ATTACK ) );
}

function OnGameEvent_player_spawn( params )
{
	local player = GetPlayerFromUserID( params["userid"] );
	if ( (!player) || (!player.IsSurvivor()) )
		return;

	EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.SurvivorPostSpawn(" + params["userid"] + ")", 0.1 );
}

function GetClosestGnome( survivor )
{
	local dist = null;
	local ent = null;
	
	for ( local entity; entity = Entities.FindByClassname( entity, "prop_physics" ); )
	{
		if ( entity.GetModelName() == "models/props_junk/gnome.mdl" )
		{
			if ( !dist || (entity.GetOrigin() - survivor.GetOrigin()).Length() < dist )
			{
				dist = (entity.GetOrigin() - survivor.GetOrigin()).Length();
				ent = entity;
			}
		}
	}
	
	return ent;
}

function PickupGnome( userid )
{
	local player = GetPlayerFromUserID( userid );
	if ( (!player) || (!player.IsSurvivor()) || (!IsPlayerABot( player )) )
		return;
	
	local gnome = GetClosestGnome( player );
	if ( gnome )
		DoEntFire( "!self", "Use", "", 0, player, gnome );
}

function OnGameEvent_lunge_pounce( params )
{
	local hunter = GetPlayerFromUserID( params["userid"] );
	local victim = GetPlayerFromUserID( params["victim"] );
	if ( ( !hunter ) || (!victim) || ( !victim.IsSurvivor() ) )
		return;

	hunter.TakeDamage( hunter.GetHealth(), 0, Entities.First() );
	
	if ( IsPlayerABot( victim ) )
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.PickupGnome(" + params["victim"] + ")", 2.5 );
}

function OnGameEvent_player_bot_replace( params )
{
	local bot = GetPlayerFromUserID( params["bot"] );
	if ( ( !bot ) || ( !bot.IsSurvivor() ) )
		return;

	local buttons = NetProps.GetPropInt( bot, "m_afButtonDisabled" );
	if ( !(buttons == ( buttons | DirectorScript.IN_ATTACK )) )
		NetProps.SetPropInt( bot, "m_afButtonDisabled", ( buttons | DirectorScript.IN_ATTACK ) );
}

function OnGameEvent_bot_player_replace( params )
{
	local player = GetPlayerFromUserID( params["player"] );
	if ( ( !player ) || ( !player.IsSurvivor() ) )
		return;

	local buttons = NetProps.GetPropInt( player, "m_afButtonDisabled" );
	if ( !(buttons == ( buttons | DirectorScript.IN_ATTACK )) )
		NetProps.SetPropInt( player, "m_afButtonDisabled", ( buttons | DirectorScript.IN_ATTACK ) );
}
