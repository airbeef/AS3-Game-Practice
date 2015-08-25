package com.efg.games.spacecheckers
{
	public class SetUpClass
	{
		//Basic game width and height
		public var gameWidth:Number = 640;
		public var gameHeight:Number = 480;
		
		//how many levels are there
		public var totalLevels:Number = 40;
		public var levelsPerRow:Number = 8;
		public var levelsHorizontalSpacing:Number = 5;
		public var levelVerticalSpacing:Number = 5;
		//space inbetween level squares
		public var levelsOffsetX:Number = 0;
		public var levelsOffsetY:Number = 30;
		
		//game play button
		public var playGameButtonX:Number = 320;
		public var playGameButtonY:Number = 230;
		
		//Back button
		public var homeButtonX:Number = 560;
		public var homeButtonY:Number = 0;
		
		//level complete
		public var completedReplayButtonX:Number = 320;
		public var completedReplayButtonY:Number = 200;
		public var completedPlayNextButtonX:Number = 320;
		public var completedPlayNextButtonY:Number = 240;
		public var completedShowLevelButtonX:Number = 320;
		public var completedShowLevelButtonY:Number = 280;
		
		//level failed
		public var failedReplayButtonX:Number = 320;
		public var failedReplayButtonY:Number = 320;
		public var failedShowLevelsButtonX:Number = 320;
		public var failedShowLevelsButtonY:Number = 360;
		
	}
	
}
