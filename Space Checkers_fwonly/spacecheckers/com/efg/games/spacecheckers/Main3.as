package com.efg.games.spacecheckers
{	//game will be using dev made assets
	import flash.display.Sprite;
	//Adding Mouse functionality
	import flash.events.MouseEvent;
	//Point represents a 2 coordinate[x,y] system (ex. (1,5))
	import flash.geom.Point;
		
	public class Main3 extends Sprite
	{
		//array shows placement of square or monster
		private var fieldArray:Array;
		//Monster Movement; if player picks one up.
		private var pickedMonster:Monster;
		//monsterContainer will hold the asset that will symbolize movement
		//this container will also be manipulated
		private var monsterContainer:Sprite = new Sprite();
		//moveConatiner let's the player know where they can/can't move
		private var moveContainer:Sprite = new Sprite();
		//This is the current location where monster is moved
		private var localX:Number; 
		private var localY:Number;
		//This is the old circle location
		private var oldX:Number;
		private var oldY:Number;
		//This variable holds possible spots for the player to land monster 
		private var possibleLandings:Vector.<Point>;
	
		public function Main3()
		{
			setupLevel();
		}
		
		private function setupLevel():void
		{
			//these variables make the squares and monster pics
			var squareContainer:Sprite = new Sprite();
			addChild(squareContainer);
			addChild(monsterContainer);
			//new moveContainer will show various highlighted place player can/can't move
			addChild(moveContainer);
			
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
					square.x = j * 60;
					square.y = i * 60;
					if(fieldArray[i][j] == 1)
					{
						//this places the monster whenever [i][j] = 1
						monster = new Monster();
						monsterContainer.addChild(monster);
						monster.x = j * 60;
						monster.y = i * 60;
						
						monster.theRow = i;
						monster.theCol = j;
						
						//mouse will change when over button
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
			
			//Move containers will be on the squares, not the monsters
			moveContainer.x = squareContainer.x;
			moveContainer.y = squareContainer.y;
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
			
			checkMonster(pickedMonster);
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
			//pickedMonster.x = oldX; //expanding
			//pickedMonster.y = oldY;
			
			//This move isn't legal; just sayin.
			var legalMove:Boolean = false;
			//Floor returns closest number that is < or = a number
			//this calculates where the picked Monster is on the map 
			//when dropped
			var dropX:int = Math.floor((pickedMonster.x +30)/60);
			var dropY:int = Math.floor((pickedMonster.y +30)/60);
			
			//number = 0, number is less than how many arguments possibleLandings has
			//Count through number
			for (var i:int = 0; i<possibleLandings.length; i++)
			{
				//If possible landings equal each other on x/y coordinates, then this is a true move
				if (possibleLandings[i].x == dropY && possibleLandings[i].y == dropX)
				{
					legalMove = true;
					break;
				}
			}
			
			//if the move isn't legal, put it back in it's original spot
			if (! legalMove)
			{
				pickedMonster.x = oldX;
				pickedMonster.y = oldY;
			}
			
			//else
			else
			{
				var rowOffset:int = (dropY - pickedMonster.theRow) / 2;
				var colOffset:int = (dropX - pickedMonster.theCol) / 2;
				//this is an array of placement just like before: arr = [0,1,1,] etc.
				//These arrays show if the player can move legally in different 
				//directions via what tile the player picked and where 
				//did they drop it, The offsets calculations on what move is legal
				fieldArray[pickedMonster.theRow][pickedMonster.theCol] = 0;
				fieldArray[pickedMonster.theRow + rowOffset][pickedMonster.theCol + colOffset] = 0;
				fieldArray[pickedMonster.theRow + 2 * rowOffset][pickedMonster.theCol + 2 * colOffset] = 1;
				
				
				
				for (i = 0; i < monsterContainer.numChildren; i++)
				{
					var currentMonster:Monster = monsterContainer.getChildAt(i) as Monster;
					
					if(currentMonster.theRow == pickedMonster.theRow + rowOffset && 
					   currentMonster.theCol == pickedMonster.theCol + colOffset)
					{
						monsterContainer.removeChildAt(i);
					}
				}
				pickedMonster.x = dropX * 60;
				pickedMonster.y = dropY * 60;
				
				pickedMonster.theRow = dropY;
				pickedMonster.theCol = dropX;
			}
			
			i = moveContainer.numChildren;
			
			while(i--)
			{
				moveContainer.removeChildAt(i);
			}
			
		}
		
		private function checkMonster(m:Monster):void
		{
			var possibleMove:PossibleMove;
			possibleLandings=new Vector.<Point>();
			
			for (var i:int=0; i<4; i++) 
			{
				var deltaRow:int=(1-i)*(i%2-1);
				var deltaCol:int = (2 - i) * (i % 2);
				if (checkField(m,deltaRow,deltaCol)) 
				{
					possibleMove=new PossibleMove();
					moveContainer.addChild(possibleMove);
					possibleMove.x = oldX + 120 * deltaCol;
					possibleMove.y = oldY + 120 * deltaRow;
					possibleLandings.push(new Point(m.theRow+2*deltaRow,m.theCol+2*deltaCol));
				}
			}
			
			if (possibleLandings.length > 0) 
			{
				var startMove:StartMove=new StartMove();
				moveContainer.addChild(startMove);
				startMove.x = oldX;
				startMove.y = oldY;
			}
			else 
			{
				var wrongMove:WrongMove=new WrongMove();
				moveContainer.addChild(wrongMove);
				wrongMove.x = oldX;
				wrongMove.y = oldY;
			}
		}
		

		private function checkField(m:Monster,rowOffset:int,colOffset:int):Boolean 
		{
			if (fieldArray[m.theRow + 2 * rowOffset] != undefined && 
				fieldArray[m.theRow + 2 * rowOffset][m.theCol + 2 * colOffset] != undefined) 
			{
				if (fieldArray[m.theRow + rowOffset][m.theCol + colOffset] == 1
					&& fieldArray[m.theRow + 2 * rowOffset][m.theCol + 2 * colOffset] == 0)
				{
					return true;
				}
			}
			return false;
		}
	
	}
	
}
