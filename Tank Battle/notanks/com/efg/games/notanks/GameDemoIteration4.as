package com.efg.games.notanks
{
	import flash.display.Sprite;
	
	//update in code [actual level]
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import com.efg.framework.TileSheet;
	
	//updating for iteration1
	import com.efg.framework.BlitSprite;
	import com.efg.framework.TileByTileBlitSprite;
	
	//updated for iteration2
	import flash.events.*;
	import flash.events.Event;
	
	
	public class GameDemoIteration4 extends Sprite
	{
		//Assigns blit items
		public static const TILE_WALL:int = 0;
		public static const TILE_MOVE:int = 1
		public static const SPRITE_PLAYER:int = 2;
		public static const SPRITE_GOAL:int  = 3;
		public static const SPRITE_AMMO:int = 4;
		public static const SPRITE_ENEMY:int = 5;
		public static const SPRITE_EXPLODE:int = 6;
		public static const SPRITE_MISSLE:int = 7;
		public static const SPRITE_LIVES:int = 8;
		
		//it's dem private arrays fer days, son
		private var playerFrames:Array;
		private var enemyFrames:Array;
		private var explodeFrames:Array;
		private var tileSheetData:Array;
		
		private var missleTiles:Array = [];
		private var explodeSmallTiles:Array;
		private var explodeLargeTiles:Array;
		
		private var ammoFrame:int;
		private var livesFrame:int;
		private var goalFrame:int;
		
		//Tile Variables
		private var tileWidth:int = 32;
		private var tileHeight:int = 32;
		private var mapRowCount:int = 15;
		private var mapColumnCount:int = 20;
		
		//Level Update
		private var level:int = 1;
		private var levelTileMap:Array;
		private var levelData:Level;
		private var levels:Array = [undefined, new Level1()]
		
		//Full screen Blit
		private var canvasBitmapData:BitmapData = new BitmapData 
														(tileWidth * mapColumnCount, tileHeight * mapRowCount,
														true, 0x00000000);
												
		private var canvasBitmap:Bitmap = new Bitmap(canvasBitmapData);
		private var blitPoint:Point = new Point();
		private var tileBlitRectangle:Rectangle = new Rectangle(0,0, tileWidth, tileHeight);
		
		//Tilesheet import
		private var tileSheet:TileSheet = new TileSheet(new TankSheetPng(0,0), tileWidth,tileHeight);
		
		//Update for Iteration movement 
		public static const MOVE_UP:int = 0;
		public static const MOVE_DOWN:int = 1;
		public static const MOVE_LEFT:int = 2;
		public static const MOVE_RIGHT:int = 3;
		public static const MOVE_STOP:int = 4;
		
		//Iteration1 player specific movements
		private var player:TileByTileBlitSprite;
		private var playerStartRow:int;
		private var playerStartCol:int;
		private var playerStarted:Boolean = false;
		private var playerInvincible:Boolean = true;
		private var playerInvincibleCountDown:Boolean = true;
		private var playerInvincibleWait:int = 100;
		private var playerInvincibleCount:int = 0;
		
		//Iteration2
		private var keyPressList:Array = [];
		
		//Iteration4
		private var xMin:int = 16;
		private var yMin:int = 16;
		private var xMax:int = 624;
		private var yMax:int = 464;
		
		private var xTunnelMin:int = -16;
		private var yTunnelMin:int = -16;
		private var xTunnelMax:int = 656;
		private var yTunnelMax:int = 496;
				
		public function GameDemoIteration4() 
		{
			init();

		}
		
		private function init():void
		{
			//iteration2
			this.focusRect = false;
			
			//updated for iteration1
			initTileSheetData();
			
			//this initiates the player; frames assigned by initTileSheet.as
			//game will have aruntime error if this isn't launched first
			player = new TileByTileBlitSprite(tileSheet, playerFrames, 0);
			
			readBackGroundData();
			readSpriteData();
			drawLevelBackGround();
			addChild (canvasBitmap);
			newGame();
			
		}
		
		private function newGame():void
		{
			//Iteration2
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			
			newLevel();
		}
		
		//Iteration2
		private function keyDownListener(e:KeyboardEvent):void
		{
			trace(e.keyCode);
			
			//Iteration 3
			keyPressList[e.keyCode] = true;
		}
		
		//Iteration2
		private function keyUpListener(e:KeyboardEvent):void
		{
			keyPressList[e.keyCode] = false;
		}
		
		private function newLevel():void
		{
			restartPlayer();
			addChild(player);
		}
		
		private function restartPlayer(afterDeath:Boolean = false):void
		{
			trace("restart player");
			
			player.visible = true;
			player.currCol = playerStartCol;
			player.currRow = playerStartRow;
			
			player.x = (playerStartCol * tileWidth)+(.5 * tileWidth);
			player.y = (playerStartRow * tileHeight) + (.5 * tileHeight);
			player.nextX = player.x;
			player.nextY = player.y;
			
			player.currDirection = MOVE_UP;
			playerStarted = true;
			playerInvincible = true;
			playerInvincibleCountDown = true;
			playerInvincibleCount = 0;
			
			//Iteration2
			addEventListener(Event.ENTER_FRAME, runGame, false, 0, true);
		}
		
		//Iteration 3
		public function runGame(e:Event):void
		{
			if (playerStarted)
			{
				checkInput();
			}
			
			//Iteration 4
			update();
			render();
		}
		
		private function checkInput():void
		{
			//var playSound:Boolean = false;
			var lastDirection:int = player.currDirection;
									
			//up
			if (keyPressList[38] && player.inTunnel == false)
			{
				if (checkTile(MOVE_UP, player))
				{
					if (player.currDirection == MOVE_UP || player.currDirection
							== MOVE_DOWN || player.currDirection == MOVE_STOP)
						{
							switchMovement(MOVE_UP, player);
							//playSound = true;
						}
						
					else if (checkCenterTile(player))
					{
						switchMovement(MOVE_UP, player);
						//playSound = true;
					}
					
					else
					{
						trace("can't move up");
					}
				}
			}
				
			//down
			if (keyPressList[40] && player.inTunnel == false)
			{
				if (checkTile(MOVE_DOWN, player))
				{
					if (player.currDirection == MOVE_DOWN || player.currDirection
							== MOVE_UP || player.currDirection == MOVE_STOP)
						{
							switchMovement(MOVE_DOWN, player);
							//playSound = true;
						}
						
					else if (checkCenterTile(player))
					{
						switchMovement(MOVE_DOWN, player);
						//playSound = true;
					}
					
					else
					{
						trace("can't move down");
					}
				}
			}
				
				
				//right
			if (keyPressList[39] && player.inTunnel == false)
			{
				if (checkTile(MOVE_RIGHT, player))
				{
					if (player.currDirection == MOVE_RIGHT || player.currDirection
							== MOVE_LEFT || player.currDirection == MOVE_STOP)
						{
							switchMovement(MOVE_RIGHT, player);
							//playSound = true;
						}
						
					else if (checkCenterTile(player))
					{
						switchMovement(MOVE_RIGHT, player);
						//playSound = true;
					}
					
					else
					{
						trace("can't move right");
					}
				}
			}
				
				//left
			if (keyPressList[37] && player.inTunnel == false)
			{
				if (checkTile(MOVE_LEFT, player))
				{
					if (player.currDirection == MOVE_LEFT || player.currDirection
							== MOVE_RIGHT || player.currDirection == MOVE_STOP)
						{
							switchMovement(MOVE_LEFT, player);
							//playSound = true;
						}
						
					else if (checkCenterTile(player))
					{
						switchMovement(MOVE_LEFT, player);
						//playSound = true;
					}
					
					else
					{
						trace("can't move left");
					}
				}
			}
				
				//Mouse click
				if (keyPressList[32] && player.inTunnel == false)
				{
					// if (ammo > 0) firePlayMissile():
				}
				
				//if (lastDirection == MOVE_STOP && playSound)
				{
					//dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND
					// Main.SOUND_PLAYER_MOVE, false, 1, 0));
				}
		}
		
		private function update():void
		{
			//Iteration 4
			player.nextX = player.x + player.dx * player.moveSpeed;
			player.nextY = player.y + player.dy * player.moveSpeed;
			
			if (player.y < yMin || player.y > yMax 
					|| player.x < xMin || player.x > xMax)
				{
					player.inTunnel = true;
				}
			
			else
				{
					player.inTunnel = false;
				}
			
			if (player.inTunnel)
			{
				switch(player.currDirection)
				{
					case MOVE_UP:
						if (player.nextY == yTunnelMin)
							{
								player.nextY = yTunnelMax;
							}
						else if (player.nextY == yMax)
							{
								player.inTunnel = false;
							}
					break;
					
					case MOVE_DOWN:
						if (player.nextY == yTunnelMax)
							{
								player.nextY = yTunnelMin;
							}
						else if (player.nextY == yMin)
							{
								player.inTunnel = false;
							}
					break;
					
					case MOVE_LEFT:
						if (player.nextX == xTunnelMin)
							{
								player.nextX = xTunnelMax;
							}
						else if (player.nextX == xMax)
							{
								player.inTunnel = false;
							}
					break;
					
					case MOVE_RIGHT:
						if (player.nextX == xTunnelMax)
							{
								player.nextX = xTunnelMin;
							}
						else if (player.nextX == xMin)
							{
								player.inTunnel = false;
							}
					break;
					
					case MOVE_STOP:
					trace("stopped");
					break;
				}
			}
			
			player.currRow = player.nextY/tileWidth;
			player.currCol = player.nextX/tileHeight;
			
			player.updateCurrentTile();
		}
		
		//Iteration 4
		private function render():void
		{
			player.x = player.nextX;
			player.y = player.nextY;
			
			if (checkCenterTile(player))
			{
				if (!player.inTunnel)
				{
					switchMovement(MOVE_STOP, player);
					//setCurrentRegion(player);
				}
			}
		}
		
		private function checkTile(direction:int, object:TileByTileBlitSprite):Boolean
		{
			var row:int = object.currRow;
			var col:int = object.currCol;
			
			switch(direction)
			{
				case MOVE_UP:
				row--;
				
					if (row < 0)
					{
						row = mapRowCount-1;
					}
				
				break;
				
				case MOVE_DOWN:
				row++;
				
					if (row == mapRowCount)
					{
						row = 0;
					}
				
				break;
				
				case MOVE_LEFT:
				col--;
				
					if(col < 0)
					{
						col = mapColumnCount - 1;
					}
				
				break;
				
				case MOVE_RIGHT:
				col++;
				
					if (col == mapColumnCount)
					{
						col = 0;
					}
				
				break;
			} 
			
			//
			if (tileSheetData[levelTileMap[row][col]] == TILE_MOVE)
			{
				//trace("can move");
				return true;
			}
			
			else
			{
				//trace("can't move");
				return false;
			}
		}
		
		private function checkCenterTile(object:TileByTileBlitSprite):Boolean
		{
			var xCenter:int = (object.currCol * tileWidth) + (.5 * tileWidth);
			var yCenter:int = (object.currRow * tileHeight) + (.5 * tileHeight);
			
			if (object.x == xCenter && object.y == yCenter)
				{
					//trace("in center tile");
					return true;
				}
			
			else
				{
					//trace("not in center tile");
					return false;
				}
		}
		
		private function switchMovement(direction:int, object:TileByTileBlitSprite):void
		{
			switch(direction)
			{
				case MOVE_UP:
					//trace("move");
					object.rotation = 0;
					object.dx = 0;
					object.dy = -1;
					object.currDirection = MOVE_UP;
					object.animationLoop = true;
				break;
				
				case MOVE_DOWN:
					//trace("move_down");
					object.rotation = 180;
					object.dx = 0;
					object.dy = 1;
					object.currDirection = MOVE_DOWN;
					object.animationLoop = true;
				break;
				
				case MOVE_LEFT:
					//trace("move left");
					object.currDirection = MOVE_LEFT;
					object.rotation = -90;
					object.dx = -1;
					object.dy = 0;
					object.animationLoop = true;
				break;
				
				case MOVE_RIGHT:
					//trace("move right");
					object.currDirection = MOVE_RIGHT;
					object.rotation = 90;
					object.dx = 1;
					object.dy = 0;
					object.animationLoop = true;
				break;
				
				case MOVE_STOP:
					//trace("move stop");
					object.currDirection = MOVE_STOP;
					object.rotation = 90;
					object.dx = 0;
					object.dy = 0;
					object.animationLoop = false;
				break;
			}
			
			object.nextRow = object.currRow + object.dy;
			object.nextCol = object.currCol + object.dx;
		}
		
		private function initTileSheetData():void
		{
			playerFrames = [];
			enemyFrames = [];
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
				
				else if (tileXML.tile[tileNum].@type == "sprite")
				{
					switch(String(tileXML.tile[tileNum].@name))
					{
						case "player":
						numberToPush = SPRITE_PLAYER;
						playerFrames.push(tileNum);
						break;
						
						case "goal":
						numberToPush = SPRITE_GOAL;
						goalFrame = tileNum;
						break;
						
						case "ammo":
						numberToPush = SPRITE_AMMO;
						ammoFrame = tileNum;
						break;
						
						case "enemy":
						numberToPush = SPRITE_ENEMY;
						enemyFrames.push(tileNum);
						break;
						
						case "lives":
						numberToPush = SPRITE_LIVES;
						livesFrame = tileNum;
						break;
						
						case "missle":
						numberToPush = SPRITE_MISSLE;
						missleTiles.push(tileNum);
						break;
					}
				}
				
				tileSheetData.push(numberToPush);
			}
			
			explodeSmallTiles = tileXML.smallexplode.@tiles.split(",");
			explodeLargeTiles = tileXML.largeexplode.@tiles.split(",");
		}
		
	private function readBackGroundData():void
	{
		levelTileMap = [];
		levelData = levels[level];
		levelTileMap = levelData.backGroundMap;
	}
	
	private function readSpriteData():void
	{
		var tileNum:int;
		var spriteMap:Array = levelData.spriteMap;
		
		for (var rowCtr:int = 0; rowCtr < mapRowCount; rowCtr++)
		{
			for (var colCtr:int = 0; colCtr < mapColumnCount; colCtr++)
			{
				tileNum = spriteMap[rowCtr][colCtr];
				
				switch(tileSheetData[tileNum])
				{
					case SPRITE_PLAYER:
					
					player.animationLoop = false;
					playerStartRow = rowCtr;
					playerStartCol = colCtr;
					player.currRow = rowCtr;
					player.currCol = colCtr;
					player.currDirection = MOVE_STOP;
					
					break;
				}
			}
		}
	}
	
	private function drawLevelBackGround():void
	{
		canvasBitmapData.lock();
		
		var blitTile:int;
		
		for (var rowCtr:int = 0; rowCtr<mapRowCount; rowCtr++)
		{
			for (var colCtr:int = 0; colCtr < mapColumnCount; colCtr++)
			{
				blitTile = levelTileMap [rowCtr][colCtr];
				
				//this is math to determine  the starting X and Y locations for the tiles
				//on the tilesheet [tileBlitRectangle top left corner]
				tileBlitRectangle.x = int(blitTile % tileSheet.tilesPerRow) * tileWidth;
				tileBlitRectangle.y = int (blitTile / tileSheet.tilesPerRow) * tileHeight;
				
				blitPoint.x = colCtr * tileHeight;
				blitPoint.y = rowCtr * tileWidth;
				
				canvasBitmapData.copyPixels(tileSheet.sourceBitmapData, tileBlitRectangle, blitPoint);
			}
		}
		
		canvasBitmapData.unlock();
	}
		
	}
	
}
