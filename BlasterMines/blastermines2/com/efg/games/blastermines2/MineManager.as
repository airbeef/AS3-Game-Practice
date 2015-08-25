package com.efg.games.blastermines2 
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.display.Shape;
	import flash.geom.Point;
	
	import com.efg.framework.BlitArrayAsset;
	
	public class MineManager 
	{
		public var mineBitmapData:BitmapData;
		public var mineAnimationFrames:Array = [];
		public var mines:Array;
		public var tempMine:Mine;
		public var mineCount:int;
		
		private var drawingCanvas:Shape = new Shape();
		private var point0:Point = new Point(0,0);

		public function MineManager() 
		{
			//open constructor
		}
		
		public function createLevelMines(spriteGlowFilter:GlowFilter, level:int, levelColor:uint):void
		{
			//Mines look
			mineBitmapData = new BitmapData(32, 32, true, 0x00000000);
			
			var tempBlitArrayAsset:BlitArrayAsset = new BlitArrayAsset();
			drawingCanvas.graphics.clear();
			
			drawingCanvas.graphics.lineStyle(2, 0xffffff);
			drawingCanvas.graphics.moveTo(6,6);
			drawingCanvas.graphics.lineTo(25,6);
			drawingCanvas.graphics.lineTo(25,22);
			drawingCanvas.graphics.lineTo(6,22);
			drawingCanvas.graphics.lineTo(6,6);
			drawingCanvas.graphics.moveTo(18,8);
			drawingCanvas.graphics.lineTo(18,16);
			drawingCanvas.graphics.lineTo(12, 16);
			drawingCanvas.graphics.lineTo(12, 12);
			drawingCanvas.graphics.moveTo(9, 23);
			drawingCanvas.graphics.lineTo(9, 25);
			drawingCanvas.graphics.moveTo(15, 23); //15
			drawingCanvas.graphics.lineTo(15,25);
			drawingCanvas.graphics.moveTo(21, 23);
			drawingCanvas.graphics.lineTo(21, 25);
			
			trace("drawingCanvas.height=" + drawingCanvas.height);
			trace("drawingCanvas.width=" + drawingCanvas.width);
			
			spriteGlowFilter.color = levelColor;
			mineBitmapData.draw(drawingCanvas);
			mineBitmapData.applyFilter(mineBitmapData, mineBitmapData.rect, point0, spriteGlowFilter);
			tempBlitArrayAsset = new BlitArrayAsset();
			mineAnimationFrames = tempBlitArrayAsset.createRotationBlitArrayFromBD(mineBitmapData, 1, 90);
			trace(mineAnimationFrames.length);
			
			//create mines for level
			mines = [];
			
			for (var ctr:int = 0; ctr< 30 + 20 * level; ctr++)
			{
				var tempMine:Mine = new Mine(5,765,5,765); // (5,765,5,765); Where the mines can bounce on screen
				
				tempMine.dx = Math.cos(6.28 * ((Math.random() * 360) - 90) / 360.0);
				tempMine.dy = Math.sin(6.28 * ((Math.random() * 360) - 90) / 360.0);
				
				if (level % 2 == 0)
				{
					tempMine.y = 700;
				}
				
				else
				{
					tempMine.y = 100;
				}
				
				tempMine.x = 100;
				tempMine.nextX = tempMine.x;
				tempMine.nextY = tempMine.y;
				tempMine.frame = int((Math.random() * 359)); //359
				tempMine.animationList = mineAnimationFrames;
				tempMine.bitmapData = tempMine.animationList[tempMine.frame];
				tempMine.speed = (Math.random() * 1) + 2 + level;
				mines.push(tempMine);
				
			}
			
		}

	}
	
}
