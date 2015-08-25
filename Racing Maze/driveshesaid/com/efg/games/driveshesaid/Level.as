package com.efg.games.driveshesaid 
{
	//this base class stores level specific data and keeps final build as a single SWF file
	
	public class Level
	{ 
		public var map:Array;
		
		public var wallAdjust:Number;
		public var skullAdjust:Number;
		public var precentNeeded:Number;
		public var playerStartFacing:int;
		
		public var timerStartSeconds:int;
		public var backGroundTile:int;
		public var heartScore:int;
		public var clockAdd:int;
		public var wallDriveColor:uint;

		public function Level() 
		{
			// Empty container
		}

	}
	
}
