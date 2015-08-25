package com.efg.games.flakcannon
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import flash.ui.Mouse;
	
	import com.efg.framework.Game;
	import com.efg.framework.CustomEventLevelScreenUpdate;
	import com.efg.framework.CustomEventScoreBoardUpdate;
	//import com.efg.framework.CustomEventSound;
	
	public class FlakCannon extends com.efg.framework.Game
	{
		// constructor
		private var gameWidth:int;
		private var gameHeight:int;
		
		//new game
		private var score:int;
		private var level:int;
		private var ships:int;
		private var shots:int;
		private var isGameOver:Boolean = false;
		
		private var extraShipCount:int = 0;
		
		//new level
		private var explodeArray:Array;
		private var shotArray:Array;
		private var shipArray:Array;
		private var enemyArray:Array;
		private var flakArray:Array;
		private var bonusPlaneArray:Array;
		private var crosshairs:Bitmap;
		
		private var incomingCount:int;
		
		//Difficulty Settings
		private var enemyWaveDelay:int = 30;
		private var numEnemies:int;
		private var enemyFrameCounter:int;
		private var enemySpeed:int = 0;
		private var enemyWaveMax:Number = 0;
		private var enemyWaveMultipleChance:Number = 0;
		private var enemySideFloor:Number = 100;
		private var enemySideChance:Number = 10;
		private var bonusPlaneFrameCounter:Number = 0;
		private var bonusPlaneDelay:Number = 1;
		private var startShots:int = 30;
		private var scoreNeededForExtraShip:int = 10000;
		
		//new variables for ships, score and movement
		private var baseEnemyScore:int = 250;
		private var enemyHitBonus:int = 500;
		private var baseBonusPlaneScore:int = 500;
		private var maxBonusPlanes:int = 1;
		private var maxVisibleShips:int = 3;
		private var bonusPlaneMaxY:int = 350;
		private var bonusPlaneSpeed:int = 3;
		private var shipYPadding:int = 0;
		
		//Temp Holders for resuable settings
		private var tempShip:Ship;
		private var tempShot:Shot;
		private var tempFlak:Flak;
		private var tempEnemy:Enemy;
		private var tempExplode:Explosion;
		private var tempBonusPlane:BonusPlane;
		
		//Points
		private var enemyPoint:Point = new Point(0,0);
		private var flakPoint:Point = new Point(0,0);
		private var bonusPlanePoint:Point = new Point (0,0);
		private var shipPoint:Point = new Point(0,0);
	
		public function FlakCannon(gW:int, gH:int)
		{
			
			gameWidth = gW;
			gameHeight = gH;
			
			/*
			this.gameWidth = gameWidth;
			this.gameHeight = gameHeight;
			*/
			
			//trace ("Start Game Width & Height");
			
		}

		override public function newGame():void
		{
			level = 0;
			score = 0;
			ships = 3;
			shots = 0;
			extraShipCount = 0;
			isGameOver = false;
			
			dispatchEvent(new CustomEventScoreBoardUpdate
						  (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SCORE, "0"));
			
			dispatchEvent(new CustomEventScoreBoardUpdate
						  (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SHOTS,String(shots)));
			
		}
		
		override public function newLevel():void
		{
			explodeArray = [];
			flakArray = [];
			shotArray = [];
			shipArray = [];
			enemyArray = [];
			bonusPlaneArray = [];
			
			incomingCount = 0;
			level++;
			
			
			//Variable   		Max Conditions   		     Max     		Calculation
			numEnemies		 =(numEnemies > 100)             ? 100 			:level * 10 +(level * 5);
			
			enemyWaveDelay 	 =(enemyWaveDelay < 20)        	 ? 20 			:60 - (level -1) * 2;
			
			enemyWaveMax     =(enemyWaveMax > 8)             ? 8 			:1 * level+1;
			
			
			enemyWaveMultipleChance = (enemyWaveMultipleChance > 100) ? 100 :10 * level;
			
			
			enemySpeed       =(enemySpeed > 8)              ? 8 			:2 + (.5 * (level-1));
			
			enemySideChance  =(enemySideChance > 70)        ? 70 			:10 * (level-1);
			
			enemySideFloor   =(enemySideFloor > 300)        ? 300 			:100 + 25 * (level-1);
			
			
			
			bonusPlaneDelay  =(bonusPlaneDelay > 450)      ? 450 			:350 + 10 * (level-1);
			
			bonusPlaneSpeed  =(bonusPlaneSpeed > 12)        ? 12 			:4 + (1 * level);
			
			
			bonusPlaneFrameCounter = 0;
			enemyFrameCounter = enemyWaveDelay;
			startShots = 30;
			shots += startShots;
			
			
			scoreNeededForExtraShip = 1000;
			
			baseEnemyScore = 100;
			enemyHitBonus = 500;
			baseBonusPlaneScore = 500;
			maxBonusPlanes = 1;
			maxVisibleShips = 3;
			bonusPlaneMaxY = 350;
			shipYPadding = 5;
			
			//update score, shots and ships
			dispatchEvent (new CustomEventLevelScreenUpdate 
						   (CustomEventLevelScreenUpdate.UPDATE_TEXT, String(level)));
			dispatchEvent (new CustomEventScoreBoardUpdate 
						   (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SHOTS, String(shots)));
			
			
			dispatchEvent (new CustomEventScoreBoardUpdate 
						   (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SHIPS, String(ships)));
			
			//Listens for Mouse down to fire shot
			stage.addEventListener(MouseEvent.MOUSE_DOWN, shootListener, false, 0, true);
			
			trace ("Mouse_Down 'New Level'" +shootListener);
			
			//this changes the mouse cursor to crosshairs
			if (crosshairs == null)
			{
				Mouse.hide();
				
				crosshairs = new Bitmap(new CrosshairsGif(0,0));
				
				crosshairs.x = gameWidth/2;
				crosshairs.y = gameHeight/2;
				addChild(crosshairs);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener, false, 0, true);
				
				trace ("Mouse_Move 'New Level'"  +mouseMoveListener);
			}
			
			placeShips();
		}
		
		
		private function placeShips():void
		{
			var ctr:int;
			var xSpacing:int;
			
			var tShips:int = ships;
			if (tShips > maxVisibleShips)
			{
				tShips = maxVisibleShips;
			}
			
			xSpacing = (gameWidth/tShips);
			for (ctr = 0; ctr < tShips; ctr++)
			{
				tempShip = new Ship();
				tempShip.x = ((xSpacing * (ctr+1)) - xSpacing/2) - (tempShip.width/2);
				tempShip.y = gameHeight - tempShip.height - shipYPadding;
				shipArray.push(tempShip);
				this.addChild(tempShip);
			}
			
		}
		
		
		//runGame()is called repeatedly by Main.as as a loop )
		//Make sure to call render() only if DISPLAY_UPDATE_NORMAL is passed in
		
		//Run game loop
		
		override public function runGame():void 
		{
			checkEnemies();
			checkBonusPlane();
			update();
			checkCollisions();
			render();
			checkforEndLevel();
			checkforEndGame();
			
			//trace ("Run Game.");
		}
		
				
		private function checkEnemies():void
		{
			enemyFrameCounter++;
			
			if((enemyFrameCounter >= enemyWaveDelay) && (incomingCount < numEnemies))
			{
				
				var chance:int = Math.floor(Math.random() * 100) + 1;
				var enemiesToCreate:int = 1;
				
				if (chance <= enemyWaveMultipleChance)
				{
					enemiesToCreate = Math.floor(Math.random() * enemyWaveMax) + 1;
				}
				
				if (enemiesToCreate > (numEnemies-incomingCount))
				{
					enemiesToCreate = (numEnemies-incomingCount);
				}
				
				for (var ctr:int = 0; ctr < enemiesToCreate; ctr++)
				{
					var startX:int = 0;
					var startY:int = 0;
					var endX:int = 0;
					var endY:int = 0;
					var dir:int = 0;
					
					chance = Math.floor(Math.random() * 100) + 1;
					if (chance <+ enemySideChance)
					{
						var leftOrRight:int = Math.floor(Math.random() * 2);
						
						startY = Math.floor(Math.random () * enemySideFloor) + 1;
						endY = gameHeight;
						switch (leftOrRight)
						{
							//left
							case 0:
								startX = gameWidth;
								dir = Enemy.DIR_LEFT;
								break;
								
							//right
							case 1:
								startX = -32;
								dir = Enemy.DIR_RIGHT;
								break;
						}
					}
					
					else 
					{
						startX = Math.floor(Math.random() * (gameWidth-32));
						startY = -32;
						endY = gameHeight;
						dir = Enemy.DIR_DOWN;
					}
					
					tempEnemy = new Enemy(startX, startY, endY, enemySpeed, dir);
					this.addChild(tempEnemy);
					enemyArray.push(tempEnemy);
					incomingCount++;
				}
				
				enemyFrameCounter = 0;
			}
			
		}
		
		
		private function checkBonusPlane():void
		{
			bonusPlaneFrameCounter++;
			
			if (bonusPlaneFrameCounter >= bonusPlaneDelay)
			{
				if (bonusPlaneArray.length < maxBonusPlanes)
				{
					var randomY:int = Math.floor(Math.random() * bonusPlaneMaxY);
					
					tempBonusPlane = new BonusPlane (-32, randomY, gameWidth+32, randomY, bonusPlaneSpeed, 10);
					bonusPlaneArray.push(tempBonusPlane)
					this.addChild (tempBonusPlane);
				}
				
				else
				{
					bonusPlaneFrameCounter = 0;
				}
			}

		}
		
		
		private function checkBonusShips():void
		{
			if ((score - (extraShipCount * scoreNeededForExtraShip) >= scoreNeededForExtraShip))
			{
				ships++;
				extraShipCount++;
				
				//dispatchEvent(new CustomEventSound (CustomEventSound.PLAY_SOUND, Main.SOUND_BONUS_SHIP, false, 1,0,1));
				dispatchEvent (new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SHIPS, String(ships)));
			}
			
		}
		
		//updates used assets and removes them for memory management
		private function update():void
		{
			for each (tempShot in shotArray)
			{
				if (tempShot.finished)
				{
					//add Flak explosion
					
					tempFlak = new Flak();
					tempFlak.x = tempShot.x - (tempShot.width/2);
					tempFlak.y= tempShot.y - (tempShot.height/2);
					
					this.addChild(tempFlak);
					flakArray.push(tempFlak);
					//dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_EXPLODE_FLAK, false,1,0,1));
					dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SHIPS,String(ships)));
				}
				
				else
				{
					tempShot.update();
				}
			}
			
			//update temp flak shot
			for each (tempFlak in flakArray)
			{
				if (tempFlak.finished)
				{
					removeItemFromArray (tempFlak, flakArray);
				}
				else
				{
					tempFlak.update();
				}
			}

			//update temp enemy
			for each (tempEnemy in enemyArray)
			{
				if (tempEnemy.finished)
				{
					removeItemFromArray(tempEnemy, enemyArray);
				}
				else
				{
					tempEnemy.update();
				}
			}
			
			//update temp explosions
			for each (tempExplode in explodeArray)
			{
				if (tempExplode.finished)
				{
					removeItemFromArray(tempExplode, explodeArray);
				}
				else
				{
					tempExplode.update();
				}
			}
			
			//update bonus plane
			for each (tempBonusPlane in bonusPlaneArray)
			{
				if (tempBonusPlane.finished)
				{
					removeItemFromArray(tempBonusPlane, bonusPlaneArray);
				}
				else
				{
					tempBonusPlane.update();
				}
			}
			
		}
		
		
			
		//check collison of ships, planes, bullets and explosions
		private function checkCollisions():void
		{
			var enemyLength:int = enemyArray.length - 1;
			var flakLength:int = flakArray.length - 1;
			var shipLength:int = shipArray.length - 1;
			var bonusPlaneLength:int = bonusPlaneArray.length - 1;
			
			enemy: for (var ctr2:int = enemyLength; ctr2 >= 0; ctr2--)
			{
				tempEnemy = enemyArray[ctr2];
				enemyPoint.x = tempEnemy.x;
				enemyPoint.y = tempEnemy.y
				
				for (var ctr:int = flakLength; ctr >= 0; ctr--)
			{
				tempFlak = flakArray[ctr];
				flakPoint.x = tempFlak.x
				flakPoint.y = tempFlak.y
				
				
				if (tempFlak.image.bitmapData.hitTest(flakPoint, 255, tempEnemy.image.bitmapData, enemyPoint)) 
				{
					//remove item from array, play explosion, show explosion and tally score
					removeItemFromArrayByIndex(ctr2, enemyArray);
					//dispatchEvent (new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_EXPLODE_PLANE, false, 1, 0, .5));
					makeExplosion(tempEnemy.x, tempEnemy.y);
					addToScore(baseEnemyScore + (tempFlak.hits * enemyHitBonus))
					tempFlak.hits++;
					
					break enemy;
					
					//trace for null reference: tempFlak
					trace("tempFlak" +tempFlak);
					trace("tempFlak.image" +tempFlak.image);
					trace("tempFlak.image.bitmapData" +tempFlak.image.bitmapData);
					
					//trace for null reference: tempEnemy
					trace("tempEnemy" +tempEnemy);
					trace("tempEnemy.image" +tempEnemy.image);
					trace("tempEnemy.image.bitmapData" +tempEnemy.image.bitmapData);
					
				}
				
			}
			
		}
		
			bonusplane: for (ctr2 = bonusPlaneLength; ctr2 >= 0; ctr2--)
			{
				tempBonusPlane = bonusPlaneArray[ctr2];
				bonusPlanePoint.x = tempBonusPlane.x;
				bonusPlanePoint.y = tempBonusPlane.y;
				
				for (ctr = flakLength; ctr >= 0; ctr--)
				{
					tempFlak = flakArray[ctr];
					flakPoint.x = tempFlak.x;
					flakPoint.y = tempFlak.y;
					
					if (tempFlak.image.bitmapData.hitTest(flakPoint, 255, tempBonusPlane.image.bitmapData, bonusPlanePoint))//bitmapData
					{
						//dispatchEvent (new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_BONUS, false, 1,0,1));
						shots += tempBonusPlane.bonusValue;			
						dispatchEvent (new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SHOTS, String(shots)));
						trace ("Load Bonus Plane Shots");
						
						makeExplosion(tempBonusPlane.x + tempBonusPlane.width/2, tempBonusPlane.y + tempBonusPlane.height/2);
						addToScore(baseBonusPlaneScore + (tempFlak.hits * enemyHitBonus));
						tempFlak.hits++;
						
						removeItemFromArrayByIndex(ctr2, bonusPlaneArray);
						
						break bonusplane;
						
						//trace for null reference: tempFlak
					trace("tempFlakBP" +tempFlak);
					trace("tempFlakBP.image" +tempFlak.image);
					trace("tempFlakBP.image.bitmapData" +tempFlak.image.bitmapData);
					
					//trace for null reference: tempEnemy
					trace("tempBonusPlane" +tempBonusPlane);
					trace("tempBonusPlane.image" +tempBonusPlane.image);
					trace("tempBonusPlane.image.bitmapData" +tempBonusPlane.image.bitmapData);
					}
				}
			}
			
			ship: for (ctr = shipLength; ctr >= 0; ctr--)
			{
				tempShip = shipArray[ctr];
				shipPoint.x = tempShip.x;
				shipPoint.y = tempShip.y;
				enemyLength = enemyArray.length-1;
				
			for (ctr2 = enemyLength; ctr2 >= 0; ctr2--)
			{
				tempEnemy = enemyArray[ctr2];
				
				if (tempEnemy.y > gameHeight - tempShip.height - tempEnemy.height - shipYPadding)
				{
					enemyPoint = new Point(tempEnemy.x, tempEnemy.y);
					
					try
					{
						if (tempShip.hitTestObject (tempEnemy))
						{
							removeItemFromArrayByIndex(ctr2, enemyArray);
							//dispatchEvent (new CustomEventSound (CustomEventSound.PLAY_SOUND, Main.SOUND_EXPLODE_SHIP, false, 1,0,1));
							makeExplosion(tempEnemy.x, tempEnemy.y);
							makeExplosion(tempShip.x + 25, tempShip.y + 5);
							makeExplosion(tempShip.x + tempShip.width - 40, tempShip.y + 10);
							makeExplosion(tempShip.x + tempShip.width/2, tempShip.y + 3);
							
							removeItemFromArrayByIndex(ctr, shipArray);
							ships--;
							dispatchEvent(new CustomEventScoreBoardUpdate (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SHIPS, String (ships)));
							
							break ship;
						}
					}
					
					catch(e:Error)
					{
						trace("error:" + e.message);
					}
				}
			}
		}
		
		}
		
				
		// make explosions happen
		private function makeExplosion(explodeX:int, explodeY:int):void
		{
			tempExplode = new Explosion();
			tempExplode.x = explodeX;
			tempExplode.y = explodeY;
			this.addChild(tempExplode);
			explodeArray.push(tempExplode);
			//trace("Explosions Work");
		}
		
		
		private function render():void
		{
			for each (tempShot in shotArray)
			{
				tempShot.render();
			}
			
			for each (tempFlak in flakArray)
			{
				tempFlak.render();
			}
			
			for each (tempEnemy in enemyArray)
			{
				tempEnemy.render();
			}
			
			for each (tempExplode in explodeArray)
			{
				tempExplode.render();
			}
			
			for each (tempBonusPlane in bonusPlaneArray)
			{
				tempBonusPlane.render();
			}
			
			//trace ("Render Running.");
		}
		
		
		//check loop for end of game
		private function checkforEndGame():void
		{
			if (ships <=0)
			{
				dispatchEvent(new Event(Game.GAME_OVER));
				removeChild(crosshairs);
				Mouse.show();
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
				cleanUpLevel();
				crosshairs = null;
			}
			
			//trace ("End Game");
		}
		
		//check for end of level and give player score
		private function checkforEndLevel():void
		{
			if (enemyArray.length <= 0 && incomingCount >= numEnemies && 
				explodeArray.length <=0 &&flakArray.length <=0 && bonusPlaneArray.length <=0)
			{
				addToScore(10 * shots);
				cleanUpLevel();
				dispatchEvent (new Event (Game.NEW_LEVEL));
			}
			
			//trace ("Check End Level");
		}
		
		private function addToScore(val:Number):void
		{
			score += int(val);
			checkBonusShips();
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SCORE, String(score)));
			
			//trace ("Adding to score");
		}
		
		//removes various variables from array
		private function removeItemFromArray(item:Object, group:Array):void
		{
			var index:int = group.indexOf(item);
			group[index].dispose();
			removeChild(group[index]);
			group.splice(index, 1);
			
			//trace ("Remove Array Item");
		}
		
		//removes varous items from Arrays from specified indexes
		private function removeItemFromArrayByIndex(index:int, group:Array):void
		{
			group[index].dispose();
			removeChild(group[index]);
			group.splice(index, 1);
			
			//trace ("Remove Item from Index Array");
		}
		
		//Cleans up level for memor purposes
		private function cleanUpLevel():void
		{
			var ctr:int = 0;
			
			for (ctr = shotArray.length-1; ctr >=0; ctr--)
			{
				removeItemFromArrayByIndex(ctr, shotArray);
			}
			
			for (ctr = flakArray.length-1; ctr >=0; ctr--)
			{
				removeItemFromArrayByIndex(ctr, flakArray);
			}
			
			for (ctr = enemyArray.length-1; ctr >=0; ctr--)
			{
				removeItemFromArrayByIndex(ctr, enemyArray);
			}
			
			for (ctr = explodeArray.length-1; ctr >=0; ctr--)
			{
				removeItemFromArrayByIndex(ctr, explodeArray);
			}
			
			for (ctr = shipArray.length-1; ctr >=0; ctr--)
			{
				removeItemFromArrayByIndex(ctr, explodeArray);
			}
			
			for (ctr = bonusPlaneArray.length-1; ctr >=0; ctr--)
			{
				removeItemFromArrayByIndex(ctr, explodeArray);
			}
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, shootListener);
			trace ("Mouse_Down 'CleanUp Level'" +shootListener);
		}
		
		public function shootListener(e:MouseEvent):void
		{
			if (shots > 0) 
			{				
				tempShot = new Shot(gameWidth/2,gameHeight,mouseX-(crosshairs.width/2),mouseY-(crosshairs.height/2));
				trace ("tempshot");
				this.addChild(tempShot);
				trace ("addchild tempshot");
				shotArray.push(tempShot);
				trace ("shotArray push");
				shots--;
				trace ("shots --");
				dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_SHOTS,String(shots)));
				trace ("update event score shot");
			 	//dispatchEvent( new CustomEventSound(CustomEventSound.PLAY_SOUND,Main.SOUND_SHOOT,false,1,0,.5));
				trace ("shotSound");
			}
			
			else 
			{
					//dispatchEvent( new CustomEventSound(CustomEventSound.PLAY_SOUND,Main.SOUND_NOSHOTS,false,1,0,.75));
			}
			
			trace ("Mouse_Down 'ShootListener'"  +shootListener);
		}
		
		//mouse listener that contains crosshairs gif
		public function mouseMoveListener (e:MouseEvent):void
		{
			crosshairs.x = e.stageX - (crosshairs.width/2);
			crosshairs.y = e.stageY - (crosshairs.height/2);
		}
	
	}
	
}
