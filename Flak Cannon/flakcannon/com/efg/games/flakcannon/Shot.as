package com.efg.games.flakcannon
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class Shot extends Sprite
	{
		//this is to modify and manipulate the images
		public var imageBitmapData:BitmapData;
		public var image:Bitmap;
		
		//this is to calculate vector points for planes
		private var startLocation:Point;
		private var endLocation:Point;
		private var xunits:Number;
		private var yunits:Number;
		
		//this is to store vector shot calculations before the are fired
		private var nextLocation:Point;
		
		//this is used to set speed
		private var speed:int = 15;
		
		//this holds the humber of moves before shots are finished
		private var moves:int = 0;
		
		//this is to see if there are any more shots left
		public var finished:Boolean;
		
		public function Shot(startX:Number, startY:Number, endX:Number, endY:Number)
		{
			startLocation = new Point(startX, startY);
			endLocation = new Point(endX, endY);
			nextLocation = new Point(0,0);
			init();
		}
		
		//this function calculates how that shot cursor moves around [Verlet Integration]
		public function init():void
		{
			x = startLocation.x;
			y = startLocation.y;
			
			var xd:Number = endLocation.x - x;
			var yd:Number = endLocation.y - y;
			var distance:Number = Math.sqrt(xd*xd + yd*yd);
			
			moves = Math.floor(Math.abs(distance/speed));
			
			xunits = (endLocation.x - x)/moves;
			yunits = (endLocation.y - y)/moves;
			
			//image that is being used
			imageBitmapData = new ShotGif(0,0);
			
			image = new Bitmap(imageBitmapData);
			
			addChild(image);
			
			finished = false;
		}
		
		//this update call for the main Game class [sets new movement values]
		public function update():void
		{
			if (moves > 0)
			{
				nextLocation.x = x + xunits;
				nextLocation.y = y + yunits;
				moves--;
			}
			
			else
			{
				finished = true;
			}
		}
		
		//This does the physical work of update()
		public function render():void
		{
			x = nextLocation.x;
			y = nextLocation.y;
		}
		
		//this cleans up bitmap and bitmapdata for better memory and speed when completed
		public function dispose():void
		{
			removeChild(image);
			imageBitmapData.dispose();
			image = null;
		}
		
		
		
		
		
	}
}