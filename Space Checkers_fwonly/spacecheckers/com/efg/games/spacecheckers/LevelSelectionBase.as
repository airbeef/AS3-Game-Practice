package com.efg.games.spacecheckers 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class LevelSelectionBase extends Sprite
	{
		private var level:Number;

		public function LevelSelectionBase(n:Number, solved:Boolean):void
		{
			//in this function, level is a number to dictate what 
			//each one is what
			level = n;
			
			//this calls the SetUp class dictating where the assets will be
			var setup:setupClass = new SetUpClass();
			
			//if the level isn't solved, show locked screen
			if (! solved)
			{
				var locked:lockedSreen = new lockedScreenBase();
				addChild(locked);
			}
			
			//Else, listen for player's click
			else
			{
				addEventListener(MouseEvent.CLICK, clicked);
			}
			//whatever the level width, number of horizontal rows, level height and 
			// asset spacing.
			var levelWidth:Number=setup.levelsPerRow*width+(setup.levelsPerRow-1)*setup.levelsHorizontalSpacing;
			var numberOfRows:Number=Math.floor(setup.totalLevels/setup.levelsPerRow);
			var levelHeight:Number=numberOfRows*height+(numberOfRows-1)*setup.levelsVerticalSpacing;
			var xOffset:Number=(setup.gameWidth-levelWidth)/2+setup.levelsOffsetX;
			var yOffset:Number=(setup.gameHeight-levelHeight)/2+setup.levelsOffsetY;
	
			x = n%setup.levelsPerRow*(width+setup.levelsHorizontalSpacing)+xOffset;
			y = Math.floor(n/setup.levelsPerRow)*(height+setup.levelsVerticalSpacing)+yOffset;
			
			//level text will be level + 1 and will tie all of
			leveltext.text=(n+1).toString();
			
			//all sprites[children] become a single unit that will dispatch mouse events 
			//and whatever target the are assigned to
			mouseChildren=false;
			
			//mouse icon changes when it's hovered over a level
			buttonMode=true;
			 
		}
		
		private function clicked(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.CLICK, clicked);
			
			//Parent level choice is attached to a game and ONLY this game
			//Play parent game.
			var theParent:MainG = this.parent.parent as MainG;
			theParent.playGame(level);
		}

	}
	
}
