//-----------------------------------------------------
//Msg("Processing United We Stand ResponseRules\n");

function UnitedCheckL4D2SurvivorResponse( speaker, query )
{
	local survivor = ResponseCriteria.GetValue( NetProps.GetPropEntity( speaker, "m_survivor" ), "who" );
	local responses =
	{
		Coach = [ "Coach_CallForRescue01", "Coach_CallForRescue02", "Coach_CallForRescue03", "Coach_CallForRescue04", "Coach_CallForRescue05",
					"Coach_CallForRescue06", "Coach_CallForRescue07", "Coach_CallForRescue08", "Coach_CallForRescue09", "Coach_CallForRescue10",
					"Coach_CallForRescue11", "Coach_CallForRescue12", "Coach_CallForRescue13", "Coach_CallForRescue14", "Coach_CallForRescue15",
					"Coach_CallForRescue16" ]
		Gambler = [ "Gambler_CallForRescue01", "Gambler_CallForRescue02", "Gambler_CallForRescue03", "Gambler_CallForRescue04",
					"Gambler_CallForRescue05", "Gambler_CallForRescue06", "Gambler_CallForRescue07", "Gambler_CallForRescue08",
					"Gambler_CallForRescue09", "Gambler_CallForRescue10", "Gambler_CallForRescue11", "Gambler_CallForRescue12" ]
		Mechanic = [ "Mechanic_CallForRescue01", "Mechanic_CallForRescue02", "Mechanic_CallForRescue03", "Mechanic_CallForRescue04",
						"Mechanic_CallForRescue05", "Mechanic_CallForRescue06", "Mechanic_CallForRescue07", "Mechanic_CallForRescue08",
						"Mechanic_CallForRescue09", "Mechanic_CallForRescue10", "Mechanic_CallForRescue11", "Mechanic_CallForRescue12",
						"Mechanic_CallForRescue13", "Mechanic_CallForRescue14", "Mechanic_CallForRescue15", "Mechanic_CallForRescue16",
						"Mechanic_CallForRescue17", "Mechanic_CallForRescue18", "Mechanic_CallForRescue19" ]
		Producer = [ "Producer_CallForRescue01", "Producer_CallForRescue02", "Producer_CallForRescue03", "Producer_CallForRescue04",
						"Producer_CallForRescue05", "Producer_CallForRescue06", "Producer_CallForRescue07", "Producer_CallForRescue08",
						"Producer_CallForRescue09", "Producer_CallForRescue10", "Producer_CallForRescue11", "Producer_CallForRescue12" ]
	}
	
	if ( !(survivor in responses) )
		return;
	
	EmitSoundOn( responses[survivor][ RandomInt( 0, responses[survivor].len() - 1 ) ], speaker );
}

if ( Director.GetSurvivorSet() == 1 )
{
	local unitedrules_l4d1 =
	[
		{
			name = "PlayerCallForRescueUnknown",
			criteria =
			[
				[ "concept", "CallForRescue" ],
				[ "who", "Unknown" ],
			],
			responses =
			[
				{
					func = g_ModeScript.UnitedCheckL4D2SurvivorResponse,
				},
			],
			group_params = g_rr.RGroupParams({ permitrepeats = true, sequential = false, norepeat = false })
		},
		{
			name = "C11M5PlaneCrashCoach",
			criteria =
			[
				[ "concept", "PlaneCrashResponse" ],
				[ "who", "Coach" ],
			],
			responses =
			[
				{
					scenename = "scenes/Coach/ReactionNegative01.vcd",
					delay = RandomFloat( 0.5, 2.0 ),
				},
				{
					scenename = "scenes/Coach/ReactionNegative15.vcd",
					delay = RandomFloat( 0.5, 2.0 ),
				}
			],
			group_params = g_rr.RGroupParams({ permitrepeats = true, sequential = false, norepeat = false })
		},
		{
			name = "C11M5PlaneCrashGambler",
			criteria =
			[
				[ "concept", "PlaneCrashResponse" ],
				[ "who", "Gambler" ],
			],
			responses =
			[
				{
					scenename = "scenes/Gambler/ReactionNegative04.vcd",
					delay = RandomFloat( 0.5, 2.0 ),
				},
				{
					scenename = "scenes/Gambler/ReactionNegative05.vcd",
					delay = RandomFloat( 0.5, 2.0 ),
				}
			],
			group_params = g_rr.RGroupParams({ permitrepeats = true, sequential = false, norepeat = false })
		},
		{
			name = "C11M5PlaneCrashMechanic",
			criteria =
			[
				[ "concept", "PlaneCrashResponse" ],
				[ "who", "Mechanic" ],
			],
			responses =
			[
				{
					scenename = "scenes/Mechanic/ReactionNegative02.vcd",
					delay = RandomFloat( 0.5, 2.0 ),
				},
				{
					scenename = "scenes/Mechanic/ReactionNegative04.vcd",
					delay = RandomFloat( 0.5, 2.0 ),
				}
			],
			group_params = g_rr.RGroupParams({ permitrepeats = true, sequential = false, norepeat = false })
		},
		{
			name = "C11M5PlaneCrashProducer",
			criteria =
			[
				[ "concept", "PlaneCrashResponse" ],
				[ "who", "Producer" ],
			],
			responses =
			[
				{
					scenename = "scenes/Producer/ReactionNegative08.vcd",
					delay = RandomFloat( 0.5, 2.0 ),
				},
				{
					scenename = "scenes/Producer/ReactionNegative21.vcd",
					delay = RandomFloat( 0.5, 2.0 ),
				}
			],
			group_params = g_rr.RGroupParams({ permitrepeats = true, sequential = false, norepeat = false })
		},
	]
	g_rr.rr_ProcessRules( unitedrules_l4d1 );
}
