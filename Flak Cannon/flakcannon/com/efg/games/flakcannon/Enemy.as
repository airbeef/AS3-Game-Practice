package com.efg.games.flakcannon 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class Enemy extends Sprite
	{
		//images
		public var imageBitmapData:BitmapData;
		public var image:Bitmap;
		
		//location flags
		private var startLocation:Point;
		private var endLocation:Point;
		public var nextLocation:Point;
		
		//keeping track of current angle and speed
		private var speed:int = 5;
		public var finished:Boolean;
		public var dir:Number;
		public var angle:Number;
		
		//direction of enemy flight path
		public static const DIR_DOWN:int = 1;
		public static const DIR_RIGHT:int = 2;
		public static const DIR_LEFT:int = 3;

		public function Enemy(startX:Number, startY:Number, endY:Number, speed:Number, dir:int) 
		{
			startLocation = new Point(startX, startY);
			endLocation = new Point(0,endY);
			nextLocation = new Point (0,0);
			this.dir = dir;
			this.speed = speed;
			init();
		}
		
		public function init():void
		{
			x = startLocation.x;
			y = startLocation.y;
			
			switch(dir)
			{
				case DIR_DOWN:
				//image that will be used when enemy is going down
				imageBitmapData = new PlaneGif(0,0);
				angle = 90;
				break;
				
				case DIR_RIGHT:
				//image that will be used when enemy is going down
				imageBitmapData = new PlaneRightGif(0,0);
				angle = 45;
				break;
				
				case DIR_LEFT:
				//image that will be used when enemy is going down
				imageBitmapData = new PlaneLeftGif(0,0);
				angle = 135;
				break;
			}
			
			image = new Bitmap(imageBitmapData);
			addChild(image);
			finished = false;
		}
		
		public function update():void
		{
			if (y < endLocation.y)
			{
				var radians:Number = angle * Math.PI / 180;
				nextLocation.x = x + Math.cos(radians) * speed;
				nextLocation.y = y + Math.sin(radians) * speed;
			}
			else
			{
				finished = true;
			}
		}
		
		public function render():void
		{
		 x = nextLocation.x;
		 y = nextLocation.y;
		}
		
		public function dispose():void
		{
			removeChild(image);
			imageBitmapData.dispose();
			image = null;
		}

	}
	
}
