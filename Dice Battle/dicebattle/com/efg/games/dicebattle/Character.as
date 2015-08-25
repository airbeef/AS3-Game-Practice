package com.efg.games.dicebattle
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import com.efg.framework.BlitSprite;
	import com.efg.framework.TileSheet;
	
	public class Character extends BlitSprite
	{

		public function Character(ts:TileSheet, tile:Number) 
		{
			super(ts, [tile], 0);
		}

	}
	
}
