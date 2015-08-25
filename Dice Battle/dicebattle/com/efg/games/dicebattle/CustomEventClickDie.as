package com.efg.games.dicebattle 
{
	import flash.events.*;
	
	public class CustomEventClickDie extends Event
	{
		public var die:Die;
		public static const EVENT_CLICK_DIE:String = "eventClickDie";

		public function CustomEventClickDie (type:String, die:Die, bubbles:Boolean =  false, cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
			this.die = die;
		}
		
		public override function clone():Event
		{
			return new CustomEventClickDie(type, die, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString(type, "type", "bubbles", "cancelable", "eventPhase");
		}

	}
	
}
