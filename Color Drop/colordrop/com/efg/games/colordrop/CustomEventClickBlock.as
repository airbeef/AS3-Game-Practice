package com.efg.games.colordrop 
{
	import flash.events.*;
	
	public class CustomEventClickBlock extends Event
	{
		public var block:Block;
		
		public static const EVENT_CLICK_BLOCK:String = "eventClickBlock";

		public function CustomEventClickBlock(type:String, block:Block, bubbles:Boolean =  false, cancelable:Boolean = false) 
		{
			super (type, bubbles, cancelable);
			this.block = block;
		}
		
		public override function clone():Event
		{
			return new CustomEventClickBlock(type, block, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString(type, "type", "bubbles", "cancelable", "eventPhase");
		}

	}
	
}
