//-----------------------------------------------------
Msg("Activating Nuclear Gnome\n");
Msg("Made by Rayman1103\n");

MutationOptions <-
{
	cm_VIPTarget = 1
	cm_ShouldHurry = 1
	//cm_CommonLimit = 0
	//cm_DominatorLimit = 14
	//cm_MaxSpecials = 3
	cm_SpecialRespawnInterval = 30
	SpecialInitialSpawnDelayMin = 20
	SpecialInitialSpawnDelayMax = 20
	
	/*SmokerLimit = 3
	BoomerLimit = 2
	HunterLimit = 3
	SpitterLimit = 2
	JockeyLimit = 2
	ChargerLimit = 2*/
}

MutationState <-
{
	GnomeExploded = false
	GnomeCarrier = null
	GnomeTimer = 60
}

function OnGameplayStart()
{
	if ( GetDifficulty() == 0 )
		SessionState.GnomeTimer = 60;
	else if ( GetDifficulty() == 1 )
		SessionState.GnomeTimer = 45;
	else if ( GetDifficulty() == 2 )
		SessionState.GnomeTimer = 30;
	else if ( GetDifficulty() == 3 )
		SessionState.GnomeTimer = 15;
	
	HUDManageTimers( 0, DirectorScript.TIMER_STOP, 0 );
	HUDManageTimers( 0, DirectorScript.TIMER_SET, SessionState.GnomeTimer );
}

function KillEverything()
{
	local gnome = Entities.FindByModel( null, "models/props_junk/gnome.mdl" );
	local gnomeNuke =
	{
		classname = "env_explosion"
		fireballsprite = "sprites/explosion_huge_h.spr" //zerogxplode
		//ignoredClass = "0"
		iMagnitude = "10000"
		iRadiusOverride = "512"
		rendermode = "5"
		spawnflags = 0 //1852
		origin = gnome.GetOrigin()
	};

	local nuke = CreateSingleSimpleEntityFromTable( gnomeNuke );
	DoEntFire( "!self", "Explode", "", 0, null, nuke );
	local nukeExplosion = { classname = "ambient_generic", health = "10", message = "weapons/hegrenade/explode3.wav", pitch = "100", pitchstart = "100", radius = "1250", spawnflags = "33", origin = Vector( 0, 0, 0 ) };
	local explosion = CreateSingleSimpleEntityFromTable( nukeExplosion );
	DoEntFire( "!self", "PlaySound", "", 0, null, explosion );
	DoEntFire( "!self", "Kill", "", 0.1, null, explosion );
	gnome.Kill();
	
	for ( local player; player = Entities.FindByClassname( player, "player" ); )
	{
		player.SetReviveCount( 2 );
		player.TakeDamage( player.GetMaxHealth(), DirectorScript.DMG_BLAST, Entities.First() );
	}
	for ( local witch; witch = Entities.FindByClassname( witch, "witch" ); )
		witch.TakeDamage( witch.GetMaxHealth(), DirectorScript.DMG_BLAST, Entities.First() );
	for ( local infected; infected = Entities.FindByClassname( infected, "infected" ); )
		infected.TakeDamage( infected.GetMaxHealth(), DirectorScript.DMG_BLAST, Entities.First() );
}

function OnGameEvent_round_start_post_nav( params )
{
	for ( local gnome; gnome = Entities.FindByModel( gnome, "models/props_junk/gnome.mdl" ); )
	{
		if ( gnome.GetClassname() == "prop_physics" )
			gnome.Kill();
	}
}

function OnGameEvent_item_pickup( params )
{
	if ( params["item"] == "gnome" )
	{
		SessionState.GnomeCarrier = GetPlayerFromUserID( params["userid"] );
		HUDManageTimers( 0, DirectorScript.TIMER_STOP, 0 );
	}
}

function SetupModeHUD()
{
	GnomeHUD <-
	{
		Fields =
		{
			timer =
			{
				slot = HUD_SCORE_TITLE ,
				staticstring = "Hold the Gnome or it detonates in: ",
				name = "timer",
				flags = DirectorScript.HUD_FLAG_COUNTDOWN_WARN | DirectorScript.HUD_FLAG_BEEP | DirectorScript.HUD_FLAG_ALIGN_CENTER | DirectorScript.HUD_FLAG_NOBG,
				special = HUD_SPECIAL_TIMER0
			}
		}
	}
	HUDPlace( HUD_SCORE_TITLE, 0.0, 0.00, 1.0, 0.045 );
	HUDSetLayout( GnomeHUD );
}

function Update()
{
	if ( Director.HasAnySurvivorLeftSafeArea() && !SessionState.GnomeExploded )
	{
		if ( SessionState.GnomeCarrier )
		{
			local carrierWeapon = SessionState.GnomeCarrier.GetActiveWeapon();
			if ( (carrierWeapon) && (carrierWeapon.GetClassname() == "weapon_gnome") )
				NetProps.SetPropInt( SessionState.GnomeCarrier, "m_iShovePenalty", 0 );
			else
			{
				SessionState.GnomeCarrier = null;
				HUDManageTimers( 0, DirectorScript.TIMER_COUNTDOWN, HUDReadTimer( 0 ) );
			}
		}
		else
		{
			if ( HUDReadTimer( 0 ) <= 0 )
			{
				KillEverything();
				SessionState.GnomeExploded = true;
			}
		}
	}
}
