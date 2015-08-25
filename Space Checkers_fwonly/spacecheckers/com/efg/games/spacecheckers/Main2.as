package com.efg.games.spacecheckers
{	//Adding Mouse functionality
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Main2 extends Sprite
	{
		private var fieldArray:Array;
		//Monster Movement; if player picks one up.
		private var pickedMonster:Monster;
		private var monsterContainer:Sprite = new Sprite();
		//This is the current location where monster is moved
		private var localX:Number; 
		private var localY:Number;
		//This is the old circle location
		private var oldX:Number;
		private var oldY:Number;

		public function Main2()
		{
			setupLevel();
		}
		
		private function setupLevel():void
		{
			//these variables make the squares and monster pics
			var squareContainer:Sprite = new Sprite();
			addChild(squareContainer);
			addChild(monsterContainer);
			//These call the art assets and make them into variables
			var square:Square;
			var monster:Monster;
			
			//this is the array for 3 layers of square containers.
			fieldArray = [[0,0,1,0,0,0],
						  [1,1,0,1,1,0], 
						  [0,0,0,0,0,0]];
			trace(fieldArray);
			
			//This is a nested 'for' loop going through the arrays
			for( var i:int = 0; i<fieldArray.length; i++)
			{
				for(var j:int = 0; j<fieldArray[i].length; j++)
				{
					//this calls in the square sprite and places them 60 x 60
					square = new Square();
					squareContainer.addChild(square);
					square.x = j*60;
					square.y = i*60;
					if(fieldArray[i][j] == 1)
					{
						//this places the monster whenever [i][j] = 1
						monster = new Monster();
						monsterContainer.addChild(monster);
						monster.x = j *60;
						monster.y = i * 60;
						monster.buttonMode = true;
						
						//change added here
						monster.addEventListener(MouseEvent.MOUSE_DOWN, pickMonster);
					}
				}
			}
			//centers square grid to stage
			squareContainer.x = (stage.stageWidth - squareContainer.width)/2;
			squareContainer.y = (stage.stageWidth - squareContainer.height)/2;
			
			//centers monsters on stage
			monsterContainer.x = squareContainer.x;
			monsterContainer.y = squareContainer.y;	
		}

		//This function moves the mouse when held and moves it back when mouse is released
		private function pickMonster(e:MouseEvent):void
		{
			//the current space is equal to where the mouse is clicking [e]
			localX = e.localX;
			localY = e.localY;
			
			
			//pickedMonster equals what asset the mouse picks
			//target means that it will be animated [png,bmp,sprite]
			//as means that pickMonster will be the Monster icon and NOTHING else
			pickedMonster = e.target as Monster;
			
			
			//saving the old location of the asset
			oldX = pickedMonster.x;
			oldY = pickedMonster.y;
			
			//setChildIndex changes the layering positions of the assets
			//number of Children =numChildren
			//I don't understand this at all.
			monsterContainer.setChildIndex(pickedMonster,monsterContainer.numChildren - 1);
			
			//Listeners if the monster Mouse event will move up or down
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveMonster);
			stage.addEventListener(MouseEvent.MOUSE_UP, dropMonster);
			
		}
	

		private function moveMonster(e:MouseEvent):void
		{
			//Player can move and interact with monsters with mouse
			pickedMonster.x = mouseX - monsterContainer.x - localX;
			pickedMonster.y = mouseY - monsterContainer.y - localY;
		}
		
		//when the player releases the monster it will remove the listeners and place the 
		//monster in it's original spot.
		private function dropMonster(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveMonster);
			stage.removeEventListener(MouseEvent.MOUSE_UP,dropMonster);
			pickedMonster.x = oldX;
			pickedMonster.y = oldY;
		}	

	}
	
}
