package com.efg.games.spacecheckers
{
	import flash.display.Sprite;
	
	public class Main extends Sprite
	{
		private var fieldArray:Array;

		public function Main()
		{
			setupLevel();
		}
		
		private function setupLevel():void
		{
			//these variables make the squares and monster pics
			var squareContainer:Sprite = new Sprite();
			var monsterContainer:Sprite = new Sprite();
			addChild(squareContainer);
			addChild(monsterContainer);
			// I don't know what this is yet, but I will figure it out
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

	}
	
}
