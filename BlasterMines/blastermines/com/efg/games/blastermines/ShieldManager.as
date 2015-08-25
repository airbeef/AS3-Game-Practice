package com.efg.framework
{
	import com.efg.games.blastermines.PowerUp;
	
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.display.Shape;
	import flash.geom.Point;
	/*
	 Shield Manager will:
	 	- Update shield count for longer play
	 	- Appear randomly from enemies shot
		- Will not add score points
		- Will not be plentiful
		- Will bounce slower than mine enemies
	*/
	
	public class ShieldManager 
	{
		public var shieldBitmapData:BitmapData;
		public var shieldAnimationFrames:Array = [];
		public var shield:Array;
		public var tempShield:Shield;
		public var shieldCount:int;
		
		private var drawingCanvas:Shape = new Shape();
		private var point0:Point = new Point(0,0);
		
		public function ShieldManager()
		{
			
		}
		
		public function createLevelShields(spriteGlowFilter:GlowFilter, level:int, levelColor:uint)
		{
			shieldBitmapData = new BitmapData(50, 50, truce,0x00000000);
			
			var tempBlitArrayAsset:BlitArrayAsset = new BlitArrayAsset();
			
			drawingCanvas.graphics.clear();
			
			drawingCanvas.graphics.lineTo(6,22);
			drawingCanvas.graphics.lineTo(6,6);
			drawingCanvas.graphics.moveTo(18,8);
			drawingCanvas.graphics.lineTo(18,16);
			drawingCanvas.graphics.lineTo(12, 16);
			drawingCanvas.graphics.lineTo(12, 12);
			
			trace("drawingCanvas.height=" + drawingCanvas.height);
			trace("drawingCanvas.width=" + drawingCanvas.width);
			
			spriteGlowFilter.color = levelColor;
			shieldBitmapData.draw(drawingCanvas);
			shieldBitmapData.applyFilter(mineBitmapData, mineBitmapData.rect, point0, spriteGlowFilter);
			tempBlitArrayAsset = new BlitArrayAsset();
			shieldAnimationFrames = tempBlitArrayAsset.createRotationBlitArrayFromBD(mineBitmapData, 1, 90);
			trace(mineAnimationFrames.length);
			
			shield = [];
			
			//This is where shield spawning will go
			for (ctr:int = 0; ctr < 1 + level; ctr++)
			{
				//location of bounce
				var tempShield:Shield = new Shield(5, 765, 5, 765);
				
				//random movement
				tempShield.dx = Math.cos(6.28 * ((Math.random() * 360) - 90) / 360.0);
				tempShield.dy = Math.sin(6.28 * ((Math.random() * 360) - 90) / 360.0);
				
				
				tempShield.x = 100;
				tempShield.nextX = tempMine.x;
				tempShield.nextY = tempMine.y;
				tempShield.frame = int((Math.random() * 359));
				tempShield.animationList = mineAnimationFrames;
				tempShield.bitmapData = tempShield.animationList[tempShield.frame];
				tempShield.speed = (Math.random() * 1) + 2 + level;
				shield.push(tempShield);
								 
			}
			
		}
		
	}
	
}
