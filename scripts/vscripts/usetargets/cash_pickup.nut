Enabled <- false; // Variable to keep track of if the button is usable.

// Called when the entity spawns.
function Precache()
{
	self.SetProgressBarFinishTime( 0 );
	self.SetProgressBarCurrentProgress( 0.0 );
	self.CanShowBuildPanel( false );
	Enabled = true;
}

function Remove()
{
	EntFire( self.GetUseModelName(), "Kill" );
	EntFire( self.GetName(), "Kill" );
}

// Called when a player tries to use the button.
// Return false to disable the third-person use animation.
function OnUseStart()
{
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
	
	if ( Enabled )
	{
		SessionState.PlayerCash[g_ModeScript.GetSurvivorName( UsingPlayer )] += 100;
		Enabled = false;
		Remove();
	}
}

// Called when the progress bar is full.
function OnUseFinished()
{
	Enabled = false;
	EntFire( self.GetUseModelName(), "Kill" )
	EntFire( self.GetName(), "Kill" )
}