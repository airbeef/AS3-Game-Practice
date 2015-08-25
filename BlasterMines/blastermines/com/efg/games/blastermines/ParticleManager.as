package com.efg.games.blastermines 
{
	import flash.display.BitmapData;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.filters.GlowFilter;
	
	import com.efg.framework.BlitArrayAsset;
	import com.efg.framework.BasicBlitArrayParticle;
	
	public class ParticleManager 
	{
		public var particleBitmapData:BitmapData;
		public var particleAnimationFrames:Array = [];
		public var particles:Array = [];
		public var particlePool:Array = [];
		public var particleCount:int = 0;
		public var particlePoolCount:int = 0;
		public var tempParticle:BasicBlitArrayParticle;
		public var particlePoolMax:int = 500;
		public var particlesPerExplode:int = particlePoolMax / 20;
		
		private var drawingCanvas:Shape = new Shape();
		private var point0:Point = new Point (0,0);

		public function ParticleManager()
		{
			// open and empty
		}
		
		public function createParticlePool(maxParticles:int):void
		{
			particlePool = [];
			particles = [];
			
			for (var particleCtr:int = 0; particleCtr < maxParticles; particleCtr++)
			{
				var tempParticle:BasicBlitArrayParticle = new BasicBlitArrayParticle(0, 799, 0, 799);
				particlePool.push(tempParticle);
			}
		}
		
		public function createLevelParticles(spriteGlowFilter:GlowFilter, levelColor:uint):void
		{
			var tempBlitArrayAsset:BlitArrayAsset = new BlitArrayAsset();
			
			particleBitmapData = new BitmapData(8,8, true, 0x00000000);
			drawingCanvas.graphics.clear();
			drawingCanvas.graphics.lineStyle(1,0xffffff);
			drawingCanvas.graphics.drawRect(3, 3, 2, 2);
			
			particleBitmapData.draw(drawingCanvas);
			spriteGlowFilter.color = levelColor;
			particleBitmapData.applyFilter(particleBitmapData, particleBitmapData.rect, point0, spriteGlowFilter);
			tempBlitArrayAsset = new BlitArrayAsset();
			tempBlitArrayAsset.createFadeOutBlitArrayFromBD(particleBitmapData, 30);
			particleAnimationFrames = tempBlitArrayAsset.tileList;
			
			trace("particleManager.particleAnimationFrames.length =" + particleAnimationFrames.length);
			
		}

	}
	
}
