//-----------------------------------------------------
Msg("Activating Uncommon Ambush\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	cm_AggressiveSpecials = 1
	cm_CommonLimit = 0
	cm_DominatorLimit = 5
	cm_MaxSpecials = 5
	cm_SpecialRespawnInterval = 15
	cm_SpecialSlotCountdownTime = 0
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	//cm_ProhibitBosses = true
	SpecialInfectedAssault = 1
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 5
	//ShouldAllowSpecialsWithTank = true
	//ZombieTankHealth = 5000
	FarAcquireRange = 999999
	NearAcquireRange = 999999
	FarAcquireTime = 0.0
	NearAcquireTime = 0.0
	
	BoomerLimit = 2
	SmokerLimit = 2
	HunterLimit = 2
	ChargerLimit = 2
	SpitterLimit = 2
	JockeyLimit = 2
}

function OnGameEvent_player_death( params )
{
	local victim = ("userid" in params) ? GetPlayerFromUserID( params["userid"] ) : EntIndexToHScript( params["entityid"] );
	if ( !victim )
		return;

	if ( victim.GetClassname() == "infected" || NetProps.GetPropInt( victim, "m_iTeamNum" ) == 2 )
		return;

	local RandomZombieModels =
	[
		"common_male_ceda"
		"common_male_mud"
		"common_male_roadcrew"
		"common_male_riot"
		"common_male_clown"
	]
	
	local randomType = false;
	local amount = 5;
	local vectorOverride = 10;
	if ( victim.GetClassname() == "witch" )
	{
		randomType = true;
		amount = 20;
	}
	else if ( victim.IsPlayer() )
	{
		if ( victim.GetZombieType() == DirectorScript.ZOMBIE_BOOMER )
		{
			for ( local player; player = Entities.FindByClassname( player, "player" ); )
			{
				if ( player.IsSurvivor() )
					continue;

				if ( player.GetZombieType() != DirectorScript.ZOMBIE_TANK )
					player.TakeDamage( player.GetHealth(), 0, null );
			}
			randomType = true;
			amount = 10;
		}
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_TANK )
		{
			randomType = true;
			amount = 30;
		}
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_SMOKER )
			Convars.SetValue( "z_forcezombiemodelname", "common_male_roadcrew" );
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_HUNTER )
			Convars.SetValue( "z_forcezombiemodelname", "common_male_mud" );
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_CHARGER )
			Convars.SetValue( "z_forcezombiemodelname", "common_male_riot" );
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_SPITTER )
			Convars.SetValue( "z_forcezombiemodelname", "common_male_ceda" );
		else if ( victim.GetZombieType() == DirectorScript.ZOMBIE_JOCKEY )
			Convars.SetValue( "z_forcezombiemodelname", "common_male_clown" );
	}
		
	for ( local i = 0; i < amount; i++ )
	{
		if ( randomType )
			Convars.SetValue( "z_forcezombiemodelname", RandomZombieModels[ RandomInt( 0, RandomZombieModels.len() -1 ) ] );
		
		ZSpawn( { type = 0, pos = victim.GetOrigin() + Vector( vectorOverride, 0, 0 ) } );
		vectorOverride += 10;
	}
	for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
		NetProps.SetPropInt( infected, "m_mobRush", 1 );
}

function Update()
{
	for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
	{
		local gender = NetProps.GetPropInt( infected, "m_Gender" );
		if ( gender > 10 && gender < 18 )
			continue;

		infected.Kill();
	}
}
