package com.efg.games.flakcannon 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	public class Ship extends Sprite
	{
		public var imageBitmapData:BitmapData;
		public var image:Bitmap;
		
		public function Ship() 
		{
			init();
		}
		
		public function init():void
		{
			imageBitmapData = new ShipGif(0,0);
			
			image = new Bitmap(imageBitmapData);
			addChild(image);
		}
		
		public function dispose():void
		{
			removeChild(image);
			imageBitmapData.dispose();
			image = null;
		}

	}
	
}
