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
	import com.efg.framework.BlitSprite;
	
	import com.efg.framework.TileSheet;
	import com.efg.framework.Camera2D;
	import com.efg.framework.BasicFrameTimer;
	import com.efg.framework.LookAheadPoint;
	import com.efg.framework.CarBlitSprite;
	
	public class DriveSheSaid extends Game
	{
		public static const KEY_UP:int = 38;
		public static const KEY_DOWN:int = 40;
		public static const KEY_LEFT:int = 37;
		public static const KEY_RIGHT:int = 39;
		
		public static const TITLE_WALL:int = 0;
		public static const TITLE_MOVE:int = 1;
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
		private var levels:Array = [undefined, new Level1()];
		
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
		private var tileLeft:int = 0;
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
		
		//private var lookAheadPoints:Array = [];
		
		//count down timer
		private var countDownTimer:BasicFrameTimer = new BasicFrameTimer(40);
		
		//Tile Sheet
		private var tileSheet:TileSheet = new TileSheet(new TileSheetPng(0,0), mapTileWidth, mapTileHeight);
		

		public function DriveSheSaid() 
		{
			init();
			this.focusRect = false;
		}
		
		private function init():void
		{}
		
		override public function newGame():void
		{
			switchSystemState(STATE_SYSTEM_GAMEPLAY);
			trace("New Game");
		}
		
		override public function newLevel():void
		{
			stage.focus = this;
			trace("New Level");
		}

		private function restartPlayer():void
		{
			
		}
		
		private function updateScoreBoard():void
		{
			
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
					break;
					
				case STATE_SYSTEM_LEVELOUT:
					systemFunction = systemLevelOut;
					break;
			}
		}
		
		
		private function systemGamePlay():void
		{}
		
		private function systemLevelOut():void
		{}
		
		private function levelOutComplete():void
		{}
		
		private function checkInput():void
		{}
		
		private function checkforEndGame():void
		{}
		
		private function checkforEndLevel():void
		{}
		
		
		private function update():void
		{}
		
		private function checkCollision():void
		{}
		
		private function render():void
		{}
		
		private function drawCamera():void
		{}
		
		private function drawPlayer():void
		{}
		
		private function addToScore(val:Number):void
		{}
		
		private function initTileSheetData():void
		{}
		
		private function setupWorld():void
		{}
		
		private function dispose(object:BlitSprite):void
		{}
		
		private function disposeAll():void
		{}
		
		private function timesUpListener(e:Event):void
		{}
		
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
