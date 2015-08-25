package com.efg.games.colordrop
{
	public class DifficultyLevel 
	{
		public var allowedColors:Array;
		public var startPlays:Number;
		public var scoreThreshold:Number;

		public function DifficultyLevel(allowedColors:Array, startPlays:Number, scoreThreshold:Number) 
		{
			this.allowedColors = allowedColors;
			this.startPlays = startPlays;
			this.scoreThreshold = scoreThreshold;
		}

	}
	
}
