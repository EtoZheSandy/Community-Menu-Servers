//=========================================================
// Base Trader
// Used in the Wave mode for purchasable items.
//=========================================================

// Overrides 
// This file is intended to be IncludeScripted at the top of other files
// in order to factor out common functionality. The following
// variables should be overwritten in the host file.
BuyTime <- 0
ItemType <- "Base Item"
ItemCost <- 0
BuyText <- "Base Item Text"

// Player last bought data
SessionState.BuyDelay <- {};

//
// Game engine hooks
//

Enabled <- true;

// Called by the game engine when the entity first spawns, immediately after this script is run.
function Precache()
{
	self.SetProgressBarText( BuyText );
	self.SetProgressBarFinishTime( BuyTime );
	self.SetProgressBarCurrentProgress( 0.0 );
	self.CanShowBuildPanel( true );

	// Initialize to disabled
	Enabled = true;
}

// Called when a player tries to use the button.
// Return false to disable the third-person use animation.
function OnUseStart()
{
	local UsedEntity = null;
	for ( local ent; ent = Entities.FindByClassname( ent, "*" ); )
	{
		if ( ent.GetEntityHandle() == this.UseModelEntity )
		{
			UsedEntity = ent;
			break;
		}
	}

	local UsingPlayer = null;
	for ( local player; player = Entities.FindByClassname( player, "player" ); )
	{
		if ( !player.IsSurvivor() )
			continue;

		if ( player.GetEntityHandle() == this.PlayerUsingMe )
		{
			UsingPlayer = player;
			break;
		}
	}
	
	if ( !(g_ModeScript.GetSurvivorName( UsingPlayer ) in SessionState.BuyDelay) )
		SessionState.BuyDelay[g_ModeScript.GetSurvivorName( UsingPlayer )] <- null;
	
	if ( ItemType == "sell" )
	{
		if ( SessionState.BuyDelay[g_ModeScript.GetSurvivorName( UsingPlayer )] != null && Time() <= SessionState.BuyDelay[g_ModeScript.GetSurvivorName( UsingPlayer )] + 0.5 )
			self.StopUse();
		else
		{
			local Weapon = UsingPlayer.GetActiveWeapon().GetClassname();
			local Value = GetWeaponValue( Weapon );
			SessionState.PlayerCash[g_ModeScript.GetSurvivorName( UsingPlayer )] += Value;
			UsingPlayer.GetActiveWeapon().Kill();
			SessionState.BuyDelay[g_ModeScript.GetSurvivorName( UsingPlayer )] = Time();
		}
	}
	else
	{
		if ( SessionState.PlayerCash[g_ModeScript.GetSurvivorName( UsingPlayer )] < ItemCost )
			self.StopUse();
		else if ( SessionState.BuyDelay[g_ModeScript.GetSurvivorName( UsingPlayer )] != null && Time() <= SessionState.BuyDelay[g_ModeScript.GetSurvivorName( UsingPlayer )] + 0.5 )
			self.StopUse();
		else
		{
			if ( ItemType == "incendiary_ammo" || ItemType == "explosive_ammo" || ItemType == "laser_sight" )
			{
				local upgrade = null;
				if ( ItemType == "incendiary_ammo" )
					upgrade = UPGRADE_INCENDIARY_AMMO;
				else if ( ItemType == "explosive_ammo" )
					upgrade = UPGRADE_EXPLOSIVE_AMMO;
				else if ( ItemType == "laser_sight" )
					upgrade = UPGRADE_LASER_SIGHT;
				
				UsingPlayer.GiveUpgrade( upgrade );
				local invTable = {};
				GetInvTable( UsingPlayer, invTable );
				if (!("slot0" in invTable))
				{
					self.StopUse();
					return;
				}
			}
			else if ( ItemType == "bill" )
			{
				local origin = UsedEntity.GetOrigin();
				local angles = UsedEntity.GetAngles();
				UsedEntity.Kill();
				local l4d1Spawn = SpawnEntityFromTable( "info_l4d1_survivor_spawn", { origin = origin, angles = angles.ToKVString(), character = 4 } );
				if ( l4d1Spawn )
				{
					DoEntFire( "!self", "SpawnSurvivor", "", 0, null, l4d1Spawn );
					DoEntFire( "!self", "Kill", "", 0, null, l4d1Spawn );
				}
			}
			else if ( ItemType == "francis" )
			{
				local origin = UsedEntity.GetOrigin();
				local angles = UsedEntity.GetAngles();
				UsedEntity.Kill();
				local l4d1Spawn = SpawnEntityFromTable( "info_l4d1_survivor_spawn", { origin = origin, angles = angles.ToKVString(), character = 6 } );
				if ( l4d1Spawn )
				{
					DoEntFire( "!self", "SpawnSurvivor", "", 0, null, l4d1Spawn );
					DoEntFire( "!self", "Kill", "", 0, null, l4d1Spawn );
				}
			}
			else if ( ItemType == "louis" )
			{
				local origin = UsedEntity.GetOrigin();
				local angles = UsedEntity.GetAngles();
				UsedEntity.Kill();
				local l4d1Spawn = SpawnEntityFromTable( "info_l4d1_survivor_spawn", { origin = origin, angles = angles.ToKVString(), character = 7 } );
				if ( l4d1Spawn )
				{
					DoEntFire( "!self", "SpawnSurvivor", "", 0, null, l4d1Spawn );
					DoEntFire( "!self", "Kill", "", 0, null, l4d1Spawn );
				}
			}
			else if ( ItemType == "zoey" )
			{
				local origin = UsedEntity.GetOrigin();
				local angles = UsedEntity.GetAngles();
				UsedEntity.Kill();
				local l4d1Spawn = SpawnEntityFromTable( "info_l4d1_survivor_spawn", { origin = origin, angles = angles.ToKVString(), character = 5 } );
				if ( l4d1Spawn )
				{
					DoEntFire( "!self", "SpawnSurvivor", "", 0, null, l4d1Spawn );
					DoEntFire( "!self", "Kill", "", 0, null, l4d1Spawn );
				}
			}
			else
			{
				local invTable = {};
				GetInvTable( UsingPlayer, invTable );
				
				foreach (ent in invTable)
				{
					local entity = ent.GetClassname();
					if ( entity == "weapon_" + ItemType && ( ItemType != "pistol" ) )
					{
						self.StopUse();
						return;
					}
				}
				UsingPlayer.GiveItem( ItemType );
			}
			SessionState.PlayerCash[g_ModeScript.GetSurvivorName( UsingPlayer )] -= ItemCost;
			SessionState.BuyDelay[g_ModeScript.GetSurvivorName( UsingPlayer )] = Time();
		}
	}
}

// Called when the progress bar is full.
function OnUseFinished()
{
	//Enabled = false;
	//EntFire( self.GetUseModelName(), "stopglowing" )
}

function GetWeaponValue( weapon )
{
	if ( weapon == "weapon_rifle" )
		return 150;
	else if ( weapon == "weapon_rifle_ak47" )
		return 150;
	else if ( weapon == "weapon_rifle_desert" )
		return 150;
	else if ( weapon == "weapon_rifle_sg552" )
		return 150;
	else if ( weapon == "weapon_hunting_rifle" )
		return 250;
	else if ( weapon == "weapon_sniper_military" )
		return 250;
	else if ( weapon == "weapon_sniper_scout" )
		return 250;
	else if ( weapon == "weapon_sniper_awp" )
		return 250;
	else if ( weapon == "weapon_autoshotgun" )
		return 200;
	else if ( weapon == "weapon_shotgun_spas" )
		return 200;
	else if ( weapon == "weapon_smg" )
		return 50;
	else if ( weapon == "weapon_smg_silenced" )
		return 50;
	else if ( weapon == "weapon_smg_mp5" )
		return 50;
	else if ( weapon == "weapon_pumpshotgun" )
		return 100;
	else if ( weapon == "weapon_shotgun_chrome" )
		return 100;
	else if ( weapon == "weapon_pipe_bomb" )
		return 50;
	else if ( weapon == "weapon_molotov" )
		return 50;
	else if ( weapon == "weapon_vomitjar" )
		return 50;
	else if ( weapon == "weapon_pain_pills" )
		return 25;
	else if ( weapon == "weapon_adrenaline" )
		return 25;
	else if ( weapon == "weapon_first_aid_kit" )
		return 75;
	else if ( weapon == "weapon_defibrillator" )
		return 50;
	else if ( weapon == "weapon_upgradepack_incendiary" )
		return 75;
	else if ( weapon == "weapon_upgradepack_explosive" )
		return 75;
	else if ( weapon == "weapon_grenade_launcher" )
		return 250;
	else if ( weapon == "weapon_rifle_m60" )
		return 250;
	else if ( weapon == "weapon_chainsaw" )
		return 200;
	else if ( weapon == "weapon_melee" )
		return 125;
	else if ( weapon == "weapon_pistol" )
		return 25;
	else if ( weapon == "weapon_pistol_magnum" )
		return 50;
	else if ( weapon == "weapon_gascan" )
		return 25;
	else if ( weapon == "weapon_propanetank" )
		return 25;
	else if ( weapon == "weapon_oxygentank" )
		return 25;
	else if ( weapon == "weapon_fireworkcrate" )
		return 25;
	else if ( weapon == "weapon_cola_bottles" )
		return 1000;
	else
		return 0;
}