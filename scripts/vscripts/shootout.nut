//-----------------------------------------------------
Msg("Activating Gun of the Gods (SvS)\n");

IncludeScript("pvp_base");

PVPOptions <-
{
	DefaultItems =
	[
		"weapon_pistol_magnum",
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

AddDefaultsToTable( "PVPOptions", g_ModeScript, "MutationOptions", g_ModeScript );
