//-----------------------------------------------------
Msg("Activating: Silent But Deadly\n");
Msg("Made by Karma Jockey\n");

MutationOptions <- 
{
	ActiveChallenge = 1

	cm_MaxSpecials = 0
	cm_DominatorLimit = 0
	cm_CommonLimit = 60
	cm_WitchLimit = 12
	cm_TankLimit = 4
	cm_ProhibitBosses = 0
	cm_NoRescueClosets = 1
	SurvivorMaxIncapacitatedCount = 2
	cm_NoSurvivorBots = 1
	cm_BaseCommonAttackDamage = 10
	cm_WanderingZombieDensityModifier = 0.01
	
	BoomerLimit = 0
	SmokerLimit = 0
	HunterLimit = 0
	ChargerLimit = 0
	JockeyLimit = 0
	SpitterLimit = 0

	DefaultItems =
	{
		"weapon_first_aid_kit",
		"weapon_pain_pills",
	}

	function GetDefaultItem( idx )
	{
		if ( idx < DefaultItems.len() )
		{
			return DefaultItems[idx];
		}
		return 0;
	}
}
	
