//-----------------------------------------------------
Msg("Activating Versus Training - Tanks\n");
Msg("Made by Rayman1103\n");


MutationOptions <-
{
	// Challenge vars
	ActiveChallenge = 1
	
	// Always convert to the TANK!!!
	function ConvertZombieClass( iClass )
	{
		return 8;
	}
}