//-----------------------------------------------------
Msg("Activating Jockapocalypse\n");

IncludeScript("ass_base");

ASSOptions <-
{
	cm_BaseCommonAttackDamage = 100
	cm_MaxSpecials = 14
	cm_DominatorLimit = 14
	PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	JockeyLimit = 14
	
	TempHealthDecayRate = 0.334 //0.001
}

AddDefaultsToTable( "ASSOptions", g_ModeScript, "MutationOptions", g_ModeScript );
