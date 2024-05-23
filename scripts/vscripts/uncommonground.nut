//-----------------------------------------------------
Msg("Activating Uncommon Ground\n");
Msg("Made by Rayman1103\n");


MutationOptions <-
{
	ActiveChallenge = 1
	cm_DominatorLimit = 5
	cm_MaxSpecials = 5
	SpecialInitialSpawnDelayMin = 0
	SpecialInitialSpawnDelayMax = 0
	ShouldAllowMobsWithTank = true
	ShouldAllowSpecialsWithTank = true

	// convert items that aren't useful
	weaponsToConvert =
	{
		weapon_defibrillator =	"weapon_first_aid_kit_spawn"
	}

	function ConvertWeaponSpawn( classname )
	{
		if ( classname in weaponsToConvert )
		{
			return weaponsToConvert[classname];
		}
		return 0;
	}

	DefaultItems =
	[
		"weapon_pistol",
		"weapon_pistol",
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

function Update()
{
	if( Director.GetCommonInfectedCount() >= 1 )
	{
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_male_tshirt_cargos.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_male_tankTop_jeans.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_male_dressShirt_jeans.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_female_tankTop_jeans.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_female_tshirt_skirt.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_female_tankTop_jeans.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_male_tankTop_overalls.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_male_tankTop_jeans_rain.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_female_tankTop_jeans_rain.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_male_tankTop_overalls_rain.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_male_tshirt_cargos_swamp.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_male_tankTop_overalls_swamp.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_female_tshirt_skirt_swamp.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_male_suit.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_patient_male01_l4d2.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_male_formal.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_female_formal.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
		c <- null;
		while( ( c = Entities.FindByModel( c, "models/infected/common_male_biker.mdl" ) ) != null )
		{
			DoEntFire( "!self", "kill", "", 0, null, c );
		}
	}
}
