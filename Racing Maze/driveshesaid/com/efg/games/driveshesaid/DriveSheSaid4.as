package com.efg.games.driveshesaid 
{
	import flash.display.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.events.KeyboardEvent;
	
	import com.efg.framework.CustomEventSound;
	import com.efg.framework.Game;
	import com.efg.framework.CustomEventLevelScreenUpdate;
	import com.efg.framework.CustomEventScoreBoardUpdate;
	import com.efg.framework.BlitSprite;
	import com.efg.framework.CustomEventSound;
	
	import com.efg.framework.TileSheet;
	import com.efg.framework.Camera2D;
	import com.efg.framework.BasicFrameTimer;
	import com.efg.framework.LookAheadPoint;
	import com.efg.framework.CarBlitSprite;
	
	public class DriveSheSaid4 extends Game
	{
		public static const KEY_UP:int = 38;
		public static const KEY_DOWN:int = 40;
		public static const KEY_LEFT:int = 37;
		public static const KEY_RIGHT:int = 39;
		
		public static const TILE_WALL:int = 0;
		public static const TILE_MOVE:int = 1;
		public static const SPRITE_PLAYER:int = 2;
		public static const SPRITE_GOAL:int = 3;
		public static const SPRITE_CLOCK:int = 4;
		public static const SPRITE_SKULL:int = 5;
		public static const SPRITE_HEART:int = 6;
		
		public static const STATE_SYSTEM_GAMEPLAY:int = 0;
		public static const STATE_SYSTEM_LEVELOUT:int = 1;
		
		private var systemFunction:Function;
		private var currentSystemState:int;
		private var nextSystemState:int;
		private var lastSystemState:int;
		
		private var level:int = 0;
		private var levelData:Level;
		private var levels:Array = [undefined, new Level1()]
		
		//tiles
		private var mapTileWidth:int = 32;
		private var mapTileHeight:int = 32;
		
		//display
		private var canvasBitmapData:BitmapData;
		private var backgroundBitmapData:BitmapData;
		private var canvasBitmap:Bitmap;
		private var backgroundBitmap:Bitmap;
		
		//world
		private var world:Array = new Array();
		private var worldCols:int = 50;
		private var worldRows:int = 50;
		private var worldWidth:int = worldCols * mapTileWidth;
		private var worldHeight:int = worldRows * mapTileHeight;
		
		//camera
		private var camera:Camera2D = new Camera2D();
		
		//drawing Camera Area Tiels
		private var tileRect:Rectangle;
		private var tilePoint:Point;
		private var tileSheetData:Array;
		
		//game specific
		private var heartsTotal:int = 0;
		private var heartsNeeded:int = 0;
		private var heartsCollected:int = 0;
		private var timeLeft:int = 0;
		private var score:int = 0;
		private var goalReached:Boolean = false;
		
		//level specific
		private var levelHeartScore:int;
		private var levelPlayerStartFacing:int;
		private var levelTimerStartSeconds:int;
		private var levelSkullAdjust:Number;
		private var levelWallAdjust:Number;
		private var levelClockAdd:int;
		private var levelBackGroundTile:int;
		private var levelPrecentNeeded:Number;
		private var levelWallDriveColor:Number;
		
		//player car stuff
		private var player:CarBlitSprite;
		private var playerFrameList:Array;
		private var playerStarted:Boolean = false;
		
		//sounds
		private var carSoundDelayList:Array = [90, 80,70, 60, 50, 40, 30, 20, 15, 10, 0];
		private var carSoundTime:int = getTimer();
		
		//keyboard input
		private var keyPressList:Array = [];
		private var keyListenersInit:Boolean = false;
		
		//game loop
		private var gameOver:Boolean = false;
		
		//Look ahead points
		// vector class requires  Flash Player 10 publishing
		//it can be swapped with an Array is only Flash player 9 available
		
		private var lookAheadPoints:Array = [];
		
		//count down timer
		private var countDownTimer:BasicFrameTimer = new BasicFrameTimer(40);
		
		//Tile Sheet
		private var tileSheet:TileSheet = new TileSheet(new TileSheetPng(0,0), mapTileWidth, mapTileHeight);
		

		public function DriveSheSaid4() 
		{
			init();
			this.focusRect = false;
		}
		
		private function init():void
		{
			//camera size on screen
			camera.width = 384;
			camera.height = 384;
			camera.cols = 12;
			camera.rows = 12;
			
			camera.x = 0;
			camera.y = 0;
			
			camera.bufferBD = new BitmapData(camera.width + mapTileWidth, camera.height + mapTileHeight, true, 0x00000000);
			camera.bufferRect = new Rectangle(0,0, camera.width, camera.height);
			camera.bufferPoint = new Point (0,0);
			
			tileRect = new Rectangle(0,0, mapTileWidth, mapTileHeight);
			tilePoint = new Point(0,0);
			
			//canvas Bitmap
			canvasBitmapData = new BitmapData(camera.width, camera.height, true, 0x00000000);
			canvasBitmap = new Bitmap(canvasBitmapData);
			
			backgroundBitmapData = new BitmapData(camera.width, camera.height, false, 0x000000);
			backgroundBitmap = new Bitmap(backgroundBitmapData);
			
			addChild(backgroundBitmap);
			addChild(canvasBitmap);
			
			//lookahead Points
			lookAheadPoints[0] = new LookAheadPoint(0, 0, this);
			lookAheadPoints[1] = new LookAheadPoint(0, 0, this);
			lookAheadPoints[2] = new LookAheadPoint(0, 0, this);
			
			//shows 'look ahead points' in development
			lookAheadPoints[0].show();
			lookAheadPoints[1].show();
			lookAheadPoints[2].show();
			
			}
		
		override public function newGame():void
		{
			switchSystemState(STATE_SYSTEM_GAMEPLAY);
			
			initTileSheetData();
			
			player = new CarBlitSprite(tileSheet, playerFrameList, 0);
			
			addChild(player);
			level = 0;
			score = 0;
			gameOver = false;
			
			//updates score, hearts and time left
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SCORE, String(score)));
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_TIME_LEFT,"00"));
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_HEARTS, String(0)));
			
			//key Listeners
			if (!keyListenersInit)
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
				stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
				keyListenersInit = true;
			}
			
			countDownTimer.addEventListener(BasicFrameTimer.TIME_IS_UP, timesUpListener, false, 0, true);

		}
		
		//initializes,assigns and loops through XML data for graphics
		private function initTileSheetData():void
		{
			playerFrameList = [];
			tileSheetData = [];
			
			var numberToPush:int = 99;
			var tileXML:XML = TilesheetDataXML.XMLData;
			var numTiles:int = tileXML.tile.length();
			
			for (var tileNum:int = 0; tileNum < numTiles; tileNum++)
			{
				if (String(tileXML.tile[tileNum].@type) == "walkable")
				{
					numberToPush = TILE_MOVE;
				}
				
				else if (String(tileXML.tile[tileNum].@type) == "nonwalkable")
				{
					numberToPush = TILE_WALL;
				}
				
				else if (String(tileXML.tile[tileNum].@type) == "sprite")
				{
					switch(String(tileXML.tile[tileNum].@name))
					{
						case "player":
						numberToPush= SPRITE_PLAYER;
						playerFrameList.push(tileNum);
						break;
						
						case "goal":
						numberToPush= SPRITE_GOAL;
						break;
						
						case "heart":
						numberToPush= SPRITE_HEART;
						break;
						
						case "skull":
						numberToPush= SPRITE_SKULL;
						break;
						
						case "clock":
						numberToPush= SPRITE_CLOCK;
						break;
					}
				}
				
				tileSheetData.push(numberToPush);
			}
		}
		
		//builds level specific to tilesheet data on specified Level.as
		private function setupWorld():void
		{
			world = [];
			
			var tileNum:int;
			var numberToPush:int;
			
			levelData = levels[level];
			levelBackGroundTile = levelData.backGroundTile;
			levelTimerStartSeconds = levelData.timerStartSeconds;
			levelHeartScore = levelData.heartScore;
			levelPlayerStartFacing = levelData.playerStartFacing;
			
			levelSkullAdjust = levelData.skullAdjust;
			levelWallAdjust = levelData.wallAdjust;
			levelClockAdd = levelData.clockAdd;
			levelPrecentNeeded = levelData.precentNeeded;
			levelWallDriveColor = levelData.wallDriveColor;
			
			for (var rowCtr:int = 0; rowCtr < worldRows; rowCtr++)
			{
				var tempArray:Array = new Array();
				
				for (var colCtr:int = 0; colCtr < worldCols; colCtr++)
				{
					tileNum = levelData.map[rowCtr][colCtr];
					
					if (int(tileSheetData[tileNum]) == TILE_WALL || int(tileSheetData[tileNum]) == TILE_MOVE)
					{
						numberToPush = tileNum;
					}
					
					else
					{
						switch(tileSheetData[tileNum])
						{
							case SPRITE_PLAYER:
								numberToPush = levelBackGroundTile;
								player.worldX = (colCtr * mapTileWidth) + (.5 * mapTileWidth);
								player.worldY = (rowCtr * mapTileHeight) + (.5 * mapTileHeight);
								break;
								
							case SPRITE_HEART:
								numberToPush = tileNum;
								heartsTotal++;
								break;
								
							case SPRITE_SKULL:
								numberToPush = tileNum;
								break;
								
							case SPRITE_GOAL:
								numberToPush = tileNum;
								break;
								
							case SPRITE_CLOCK:
								numberToPush = tileNum;
								break;
						}
					}
					
					tempArray.push(numberToPush);
				}
				
				world.push(tempArray);
			}
			
			heartsNeeded = int(heartsTotal * levelPrecentNeeded);
		}
		
		//loads new level protocol
		override public function newLevel():void
		{
			stage.focus = this;
			//trace("New Level"); 
			
			if (level == levels.length - 1) level = 0;
			
			level++;
			
			heartsTotal = 0;
			heartsNeeded = 0;
			heartsCollected = 0;
			setupWorld();
			
			countDownTimer.seconds = levelTimerStartSeconds;
			countDownTimer.min = 0;
			
			goalReached = false;
			
			dispatchEvent(new CustomEventLevelScreenUpdate(CustomEventLevelScreenUpdate.UPDATE_TEXT, String(level)));
			
			dispatchEvent(new CustomEventHeartsNeeded(CustomEventHeartsNeeded.HEARTS_NEEDED, String(heartsNeeded)));
			
			restartPlayer();
		}
		
		
		//find the region of the map the player is in
		private function restartPlayer():void
		{
			camera.x = player.worldX - (.5 * camera.width);
			camera.y = player.worldY - (.5 * camera.height);
			
			//X Axis
			if (camera.x < 0)
			{
				camera.x = 0;
				player.x = player.worldX + camera.x;
			}
			else if ((camera.x + camera.width) > worldWidth)
			{
				camera.x = worldWidth - camera.width;
				player.x = player.worldX - camera.x
			}
			else
			{
				player.x = .5 * camera.width;
			}
			
			//Y Axis
			if (camera.y < 0)
			{
				camera.y = 0;
				player.y = player.worldY + camera.y;
			}
			else if ((camera.y + camera.height) > worldHeight)
			{
				camera.y = worldHeight - camera.height;
				player.y = player.worldY - camera.y
			}
			else
			{
				player.y = .5 * camera.height;
			}
			
			//camera follow and player attributes
			camera.nextX = camera.x;
			camera.nextY = camera.y;
			
			player.nextX = player.x;
			player.nextY = player.y;
			player.worldNextX = player.worldX;
			player.worldNextY = player.worldY;
			
			player.dx = 0;
			player.dy = 0;
			player.nextRotation = levelPlayerStartFacing;
			player.turnSpeed = .3;
			player.maxTurnSpeed = .6;
			player.minTurnSpeed = .3;
			player.maxVelocity = 10;
			player.acceleration = .05;
			player.deceleration = .03;
			player.radius = .5 * player.width;
			player.reverseVelocityModifier = .3;
			player.animationDelay = 3;
			player.velocity = 0;
			
			
			//reset Look Aheads
			lookAheadPoints[0].x = lookAheadPoints[0].y = 0;
			lookAheadPoints[1].x = lookAheadPoints[1].y = 0;
			lookAheadPoints[2].x = lookAheadPoints[2].y = 0;
						
			player.visible = false;
			
			//draw the level so it will roll in from the side
			drawCamera();
		}
		
		private function updateScoreBoard():void
		{
			dispatchEvent (new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SCORE, String(score)));
			
			dispatchEvent (new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_TIME_LEFT, String(timeLeft)));

			dispatchEvent (new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_HEARTS,
														   String(heartsCollected) + "/" + String(heartsNeeded)));
			
			timeLeft = countDownTimer.seconds;

		}
		
		override public function runGame():void
		{
			systemFunction();
			trace("Run Game");
		}
		
		public function switchSystemState(stateval:int):void
		{
			lastSystemState = currentSystemState;
			currentSystemState = stateval;
			
			switch(stateval)
			{
				case STATE_SYSTEM_GAMEPLAY:
					systemFunction = systemGamePlay;
					break;f
					
				case STATE_SYSTEM_LEVELOUT:
					systemFunction = systemLevelOut;
					break;
			}
		}
		
		
		private function systemGamePlay():void
		{
			if (!countDownTimer.started)
			{
				countDownTimer.start();
				playerStarted = true;
				player.visible = true;
			}
				
			if (playerStarted)
			{
				checkInput();
			}
			
			update();
			checkCollisions();
			render();
			checkforEndLevel();
			checkforEndGame();
			countDownTimer.update();
			updateScoreBoard();
		}
		
		private function systemLevelOut():void
		{
			this.x = 4;
			
			if(this.x >= 404)
			{
				this.x = 404;
				levelOutComplete();
			}
			
		}
		
		private function levelOutComplete():void
		{
			dispatchEvent(new Event(NEW_LEVEL));
			switchSystemState(STATE_SYSTEM_GAMEPLAY);
		}
		
		private function checkInput():void
		{
			if (keyPressList[KEY_UP])
			{
				player.velocity += player.acceleration;
				if (player.velocity > player.maxVelocity) player.velocity = player.maxVelocity;
			}
			
			if (!keyPressList[KEY_UP] && player.velocity > 0)
			{
				player.velocity -= player.deceleration;
				if (player.velocity <0) player.velocity = 0;
			}
			
			if (keyPressList[KEY_DOWN])
			{
				player.velocity -= player.acceleration;
				if (player.velocity < - player.maxVelocity * player.reverseVelocityModifier)
					player.velocity = -player.maxVelocity * player.reverseVelocityModifier;
			}
			
			if (!keyPressList[KEY_DOWN] && player.velocity < 0)
			{
				player.velocity += player.deceleration;
				if (player.velocity > 0) player.velocity = 0;
			}
			
			if (keyPressList[KEY_LEFT])
			{
				player.nextRotation -= (player.velocity) * player.turnSpeed;
			}
			
			if (keyPressList[KEY_RIGHT])
			{
				player.nextRotation += (player.velocity) * player.turnSpeed;
			}
		}
		
		private function checkforEndGame():void
		{
			if (gameOver)
			{
				dispatchEvent (new CustomEventSound (CustomEventSound.PLAY_SOUND, Main.SOUND_GAME_LOST, false, 1, 0));
				
				dispatchEvent (new Event(GAME_OVER));
				countDownTimer.stop();
				disposeAll();
			}
		}
		
		private function checkforEndLevel():void
		{
			if (goalReached)
			{
				disposeAll();
				switchSystemState(STATE_SYSTEM_LEVELOUT);
				countDownTimer.stop();
				
			}
		}
		
		
		private function update():void
		{
			player.move = true;
			
			//update turnspeed based on velocity
			
			if (player.velocity == 0)
			{
				player.turnSpeed = 0;
			}
			
			else
			{
				player.turnSpeed = player.minTurnSpeed + (Math.abs(player.velocity/10));
				
				if (player.turnSpeed > player.maxTurnSpeed)	player.turnSpeed = player.maxTurnSpeed;
			}
			
			player.rotation = player.nextRotation;
			
			var carRadians:Number = (player.nextRotation / 360) * (2.0 * Math.PI);
			var lookRadians:Number;
			
			player.dx = Math.cos(carRadians) * player.velocity;
			player.dy = Math.sin(carRadians) * player.velocity;
			
			player.worldNextX += player.dx;
			player.worldNextY += player.dy;
			
			camera.nextX = player.worldNextX - (camera.width * .5);
			camera.nextY = player.worldNextY - (camera.height * .5);
			
			if (camera.nextX < 0)
			{
				camera.nextX = 0;
				player.nextX += player.dx;
			}
			
			else if (camera.nextX > (worldWidth - camera.width - 1))
			{
				camera.nextX = (worldWidth - camera.width - 1);
				player.nextX += player.dx;
			}
			
			if (camera.nextY < 0)
			{
				camera.nextY = 0;
				player.nextY += player.dy;
			}
			
			else if (camera.nextX > (worldHeight - (camera.height - 1)))
			{
				camera.nextY = (worldHeight - (camera.height - 1));
				player.nextY += player.dy;
			}
			
			if (player.velocity < 0)
			{
				player.reverse = true;
				lookRadians = ((player.nextRotation - 45) / 360) * (2.0 *Math.PI);
				lookAheadPoints[0].x = (player.nextX - Math.cos(lookRadians) * player.radius);
				lookAheadPoints[0].y = (player.nextY - Math.sin(lookRadians) * player.radius);
				
				lookAheadPoints[1].x = player.nextX-Math.cos(carRadians) * player.radius;
				lookAheadPoints[1].y = player.nextY - Math.sin(carRadians) * player.radius;
				
				lookRadians = ((player.nextRotation + 45) / 360) * (2.0 * Math.PI);
				lookAheadPoints[2].x = (player.nextX - Math.cos(lookRadians) * player.radius);
				lookAheadPoints[2].y = (player.nextY - Math.sin(lookRadians) * player.radius);
			}
			
			else
			{
				player.reverse = false;
				
				lookRadians = ((player.nextRotation + 45) / 360) * (2.0 *Math.PI);
				lookAheadPoints[0].x = (player.nextX + Math.cos(lookRadians) * player.radius);
				lookAheadPoints[0].y = (player.nextY + Math.sin(lookRadians) * player.radius);
				
				lookAheadPoints[1].x = player.nextX + Math.cos(carRadians) * player.radius;
				lookAheadPoints[1].y = player.nextY + Math.sin(carRadians) * player.radius;
				
				lookRadians = ((player.nextRotation + 45) / 360) * (2.0 * Math.PI);
				lookAheadPoints[2].x = (player.nextX + Math.cos(lookRadians) * player.radius);
				lookAheadPoints[2].y = (player.nextY + Math.sin(lookRadians) * player.radius);
			}
			
			
		}
		
		private function checkCollisions():void
		{
			var lookAheadLength:int = lookAheadPoints.length;
			var row:int;
			var col:int;
			var tileType:int;
			
			//loop through all look ahead points
			
			for (var ctr:int = 0; ctr < lookAheadLength; ctr++)
			{
				row = (lookAheadPoints[ctr].y + camera.y) / mapTileHeight;
				col = (lookAheadPoints[ctr].x + camera.x) / mapTileWidth;
				
				tileType = tileSheetData[world[row][col]];
				
				switch(tileType)
				{
					case TILE_MOVE:
						//Nothing needs to be done here
						break;
				
				case TILE_WALL:
				if (canvasBitmapData.getPixel(lookAheadPoints[ctr].x, lookAheadPoints[ctr].y) != levelWallDriveColor)
					{
						if (Math.abs(player.velocity) > 1)
						{
							//no engine sound if close to WALL_TILE
							//Play hit wall sound instead
							
							dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_HIT_WALL, false, 1, 0));
						}
						
						//Check for stuck cars
						//this can be used for player car
						
						if (player.reverse && player.velocity > .1)
							{
								player.velocity = -1;
							}
						
						else if (!player.reverse && player.velocity < .1)
							{
								player.velocity = 1;
							}
						
						trace ("player.velocity =" +player.velocity);
						player.velocity *= -levelWallAdjust;
						
						player.dx *= -levelWallAdjust;
						player.dy *= -levelWallAdjust;
						player.move = false;
					}
					
				break;
				
				case SPRITE_SKULL:
				player.dx *= -levelSkullAdjust;
				player.dy *= -levelSkullAdjust;
				player.velocity = -levelSkullAdjust;
				
				dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_SKULL_HIT, false, 1, 0));
				
				break;
				
				case SPRITE_CLOCK:
				countDownTimer.seconds += levelClockAdd;
				dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_CLOCK_PICKUP, false, 1, 0));
				world[row][col] = levelBackGroundTile;
				
				break;
				
				case SPRITE_HEART:
				heartsCollected++;
				score += levelHeartScore;
				dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_HEART_PICKUP, false, 1, 0));
				world[row][col] = levelBackGroundTile;
				
				break;
				
				case SPRITE_GOAL:
				if (heartsCollected >= heartsNeeded)
					{
						goalReached = true;
						
						dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_LEVEL_COMPLETE, false, 1, 0));
						
						break;
					}
				}
			}
		}
		
		
		private function render():void
		{
			drawCamera();
			drawPlayer();
		}
		
		private function drawCamera():void
		{
			//calculate starting tile position
			if (player.move)
			{
				camera.x = camera.nextX;
				camera.y = camera.nextY;
			}
			
			//find starting tiles
			var tileCol:int = int (camera.x/mapTileWidth);
			var tileRow:int = int(camera.y / mapTileHeight);
			
			var rowCtr:int = 0;
			var colCtr:int = 0;
			var tileNum:int;
			
			//camera buffer is 1 tile larger [51]
			//for last tile row, copy only 50
			//this function is to catch the exception
			
			for (rowCtr = 0; rowCtr <= camera.rows; rowCtr++)
			{
				if (rowCtr + tileRow == worldRows)
				break;
				
				for (colCtr = 0; colCtr <= camera.cols; colCtr++)
				{
					if (colCtr + tileCol == worldCols)
					break;
				
				tileNum = world[rowCtr + tileRow][colCtr + tileCol];
				tilePoint.x = colCtr * mapTileWidth;
				tilePoint.y = rowCtr * mapTileHeight;
				tileRect.x = int((tileNum % tileSheet.tilesPerRow)) * mapTileWidth;
				tileRect.y = int((tileNum / tileSheet.tilesPerRow)) * mapTileHeight;
				
				camera.bufferBD.copyPixels(tileSheet.sourceBitmapData, tileRect, tilePoint);
				}
			}
			
			//put buffer rect in correct position what pixel
			// to start the copy on in the left hand top tile
			
			camera.bufferRect.x = camera.x % mapTileWidth;
			camera.bufferRect.y = camera.y % mapTileHeight;
			
			//trace(bufferRect.x + ", " + bufferRect.y);
			
			canvasBitmapData.lock();
			canvasBitmapData.copyPixels(camera.bufferBD, camera.bufferRect, camera.bufferPoint);
			canvasBitmapData.unlock();
		}
		
		private function drawPlayer():void
		{
			if (player.velocity == 0)
			{
				player.move = false;
			}
			
			if (player.move)
			{
				player.animationDelay = player.maxVelocity - player.velocity;
				player.animationLoop = true;
				
				player.updateCurrentTile();
				player.renderCurrentTile();
				
				player.x = player.nextX;
				player.y = player.nextY;
				
				player.worldX = player.worldNextX;
				player.worldY = player.worldNextY;
			}
			
			else
			{
				player.animationLoop = false;
			}
			
			if (getTimer() > carSoundTime + carSoundDelayList [Math.abs(int(player.velocity))])
			{
				dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_CAR, false, 1, 0));
				
				carSoundTime = getTimer();
			}
		}
		
		private function addToScore(val:Number):void
		{
			score += val;
		}
		
		private function dispose(object:BlitSprite):void
		{
			object.dispose();
			removeChild(object);	
		}
		
		private function disposeAll():void
		{
			if(gameOver)
			{
				countDownTimer.removeEventListener(BasicFrameTimer.TIME_IS_UP, timesUpListener);
				dispose(player);
			}
		}
		
		private function timesUpListener(e:Event):void
		{
			countDownTimer.stop();
			gameOver = true;
		}
		
		private function keyDownListener(e:KeyboardEvent):void
		{
			keyPressList[e.keyCode] = true;
		}
		
		private function keyUpListener(e:KeyboardEvent):void
		{
			keyPressList[e.keyCode] = false;
		}
	}
}
