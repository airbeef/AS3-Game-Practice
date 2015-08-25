package com.efg.games.flakcannon 
{
	//import necessary classes from flash libraries
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Explosion extends Sprite
	{
		public var images:Array;
		public var image:Bitmap;
		public var currentImageIndex:int = -1;
		public var finished:Boolean;
		private var frameCounter: int = 0;
		private var frameDelay:int = 1;

		public function Explosion() 
		{
			init();
		}
		
		public function init():void
		{
			image = new Bitmap();
			this.addChild(image);
			
			images =
			[new Ex21Gif(0,0),
			 new Ex22Gif(0,0),
			 new Ex23Gif(0,0),
			 new Ex24Gif(0,0),
			 new Ex25Gif(0,0)];
			
			setNextImage();
			frameCounter = 0;
			finished = false;
			
		}
		
		public function setNextImage():void
		{
			currentImageIndex++;
			
			if (currentImageIndex > images.length - 1)
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
