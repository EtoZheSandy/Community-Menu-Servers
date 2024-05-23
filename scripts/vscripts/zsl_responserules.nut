//-----------------------------------------------------
//Msg("Processing ZSL ResponseRules\n");

local zslrules =
[
	{
		name = "PlayerIncapacitatedOverride",
		criteria = [ [ "concept", "PlayerIncapacitated" ] ],
		responses = [ { scenename = "" } ],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	},
	{
		name = "RevivedByFriendOverride",
		criteria = [ [ "concept", "RevivedByFriend" ] ],
		responses = [ { scenename = "" } ],
		group_params = g_rr.RGroupParams({ permitrepeats = true })
	}
]
g_rr.rr_ProcessRules( zslrules );
