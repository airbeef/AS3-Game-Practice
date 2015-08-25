package com.efg.games.driveshesaid
{
	import flash.events.Event;
	
	public class CustomEventHeartsNeeded extends Event
	{
		public static const HEARTS_NEEDED:String = "hearts needed";
		
		public var heartsNeeded:String;
		
		public function CustomEventHeartsNeeded(type:String, heartsNeeded:String,
												bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.heartsNeeded = heartsNeeded;
			
		}
		
		public override function clone():Event
		{
			return new CustomEventHeartsNeeded(type, heartsNeeded, bubbles, cancelable)
		}

	}
	
}
