package com.efg.games.flakcannon 
{
	//import necessary clases from the flakcannon
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Flak extends Sprite
	{
		public var images:Array;
		public var image:Bitmap;
		public var currentImageIndex:int = -1;
		public var finished:Boolean;
		private var frameCounter:int = 0;
		private var frameDelay:int = 2;
		public var hits:int;

		public function Flak() 
		{
			hits = 0;
			init();
		}
		
		public function init():void
		{
			image = new Bitmap();
			addChild(image);
			
			/*
			images = 
			[new Exp1Gif().bitmapData,
			 new Exp2Gif().bitmapData,
			 new Exp3Gif().bitmapData,
			 new Exp4Gif().bitmapData,
			 new Exp5Gif().bitmapData,
			 new Exp6Gif().bitmapData,
			 new Exp7Gif().bitmapData];
			 
			 //Molly [Before Change: 11.3.11]
			 The crashing problem (seems like both with and without shooting) is because Exp1Gif etc are of type BitmapData and not of type Bitmap. 
			 So this made your array of images that you were trying to blit all null which was what was crashing. 
			 This was happening when I looked at the debugger in Flak.as init function.
			 
			 */
			
			images = 
			[new Exp1Gif(),
			 new Exp2Gif(),
			 new Exp3Gif(),
			 new Exp4Gif(),
			 new Exp5Gif(),
			 new Exp6Gif(),
			 new Exp7Gif()];
			
			setNextImage();
			
			frameCounter = 0;
			finished = false;
		}
		
		public function setNextImage():void
		{
			currentImageIndex++;
			
			if(currentImageIndex > images.length-1)
			{
				finished = true;
			}
			else
			{
				image.bitmapData = images[currentImageIndex];
			}
		}
		
		public function update():void
		{
			frameCounter++;
		}

		public function render():void
		{
			if (frameCounter >= frameDelay && !finished)
			{
				setNextImage();
				frameCounter = 0;
			}
		}
		
		public function dispose():void
		{
			removeChild(image);
			
			for each (var tempImage:BitmapData in images)
			{
				tempImage.dispose();
			}
			images = null;
			
		}
		
	}
	
}
