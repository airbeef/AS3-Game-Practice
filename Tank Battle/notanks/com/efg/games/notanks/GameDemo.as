package com.efg.games.notanks
{
	import flash.display.Sprite;
	
	//update in code [actual level]
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import com.efg.framework.TileSheet;
	
	
	public class GameDemo extends Sprite
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

		public function GameDemo() 
		{
			initTileSheetData();
			
			trace("tileSheetData.length = " + tileSheetData.length);
			trace("playerFrames.length = " + playerFrames.length);
			trace("enemyFrames.length = " + enemyFrames.length);
			trace("missileTiles.length = " +            missleTiles.length);
			trace("explodeSmallTiles.length = " + explodeSmallTiles.length);
			trace("explodeLargeTiles.length = " + explodeLargeTiles.length);
			
			//update
			readBackGroundData();
			readSpriteData();
			drawLevelBackGround();
			
			addChild (canvasBitmap);
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
		//place holder for reading sprite data and initiating sprites on screen
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
