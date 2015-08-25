package com.efg.games.dicebattle
{
	import flash.filters.GlowFilter;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import com.efg.framework.TileSheet;
	import com.efg.framework.BlitSprite;
	
	public class Die extends BlitSprite
	{
		public var dieColor:Number;
		public var dieValue:Number;
		
		public var isFalling:Boolean;
		public var isFading:Boolean;
		public var fadeValue:Number = .05;
		public var fallEndY:Number;
		public var speed:int = 10;
		public var nextYLocation:int = 0;
		
		public var row:Number;
		public var col:Number;
		
		public static const DIE_COLOR_WHITE:int = 0;
		public static const DIE_COLOR_GREEN:int = 1;
		public static const DIE_COLOR_BLUE:int = 2;
		

		public function Die(dieValue:Number, dieColor:Number, tileSheet:TileSheet, row:Number, col:Number, endY:Number, speed:Number)
		{
			this.dieColor = dieColor;
			this.dieValue = dieValue;
			
			this.row = row;
			this.col = col;
			isFalling = false;
			isFading = false;
			
			var tile:int = (dieValue - 1) + (dieColor) * 6;
			super(tileSheet, [tile], 0);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownListener, false, 0,true);
			this.buttonMode = true;
			this.useHandCursor = true;
			startFalling(endY, speed);
		}
		
		//blocks fall
		public function startFalling(endY:Number, speed:Number):void
		{
			this.speed = speed;
			fallEndY = endY;
			isFalling = true;
		}
		
		//blocks fade when matching
		public function startFade(fadeValue:Number):void
		{
			this.fadeValue = fadeValue;
			isFading = true;
		}
		
		//updates function; sees if blockisFalling it true and updates yLocation
		public function update():void
		{
			if (isFalling)
			{
				nextYLocation = y + speed;
			}
		}
		
		//render double checks update function and makes sure blocks fall correctly on it's Y coordinate.
		public function render():void
		{
			//block is falling
			if (isFalling)
			{
				y = nextYLocation;
				
				if (y >= fallEndY)
				{
					y = fallEndY;
					isFalling = false;
				}
			}
			
			//if blocks match; they fade
			if (isFading)
			{
				alpha -= fadeValue;
				if (alpha <= 0)
				{
					alpha = 0;
					isFading = false;
				}
			}
		}
		
		//presumably getter/setter that calls new event CustomEventClickBlock class
		public function onMouseDownListener(e:MouseEvent):void
		{
			dispatchEvent(new CustomEventClickDie
						  (CustomEventClickDie.EVENT_CLICK_DIE, this));
		}
		
		//glow outline when box is clicked
		public function makeDieClicked():void
		{
			this.filters = [new GlowFilter(0xFFFFFF, 70,4,4,3,3, false, false)]
		}
		
		public function makeDieClickedComputer():void
		{
			this.filters = [new flash.filters.GlowFilter(0xff0000, 70, 4,4,3,3,false,false)]
		}
	}
	
}
