package com.efg.games.stubgame
{
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.geom.Point;
	
	import flash.events.Event;
	
	import com.efg.framework.FrameWorkStates;
	import com.efg.framework.GameFrameWork;
	import com.efg.framework.BasicScreen;
	import com.efg.framework.ScoreBoard;
	import com.efg.framework.SideBySideScoreElement;

	public class Main extends GameFrameWork
	{
		
		//custom score board elements
		public static const SCORE_BOARD_CLICKS:String = "clicked";
		
		public function Main()
		{
			init();
		}
		
		override public function init():void
		{
			game = new StubGame();
			
			setApplicationBackGround(400, 400, false, 0x000000);
			
			//add scoreboard to the screen as the second layer
			scoreBoard = new ScoreBoard();
			addChild(scoreBoard);
			
			scoreBoardTextFormat = new TextFormat
			("_sans", "11", "0xffffff", "true");
			
			scoreBoard.createTextElement(SCORE_BOARD_CLICKS,new SideBySideScoreElement(25, 5, 15, "Clicks",
				scoreBoardTextFormat, 25, "0", scoreBoardTextFormat));
			
				
			//screen text initializations
			screenTextFormat = new TextFormat("_sans", "16", "0xffffff","false" );
			
			screenTextFormat.align = flash.text.TextFormatAlign.CENTER;
			
			screenButtonFormat = new TextFormat("_sans", "12", "0x000000", "false");
			
			
			//title screen initializations
			titleScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_TITLE,
										  	400, 400, false,0x0000dd);
			
			titleScreen.createOkButton("OK", new Point(170,250), 40, 20, 
									   screenButtonFormat, 0x000000, 0xff0000, 2);
			
			titleScreen.createDisplayText("Stub Game", 100, 
										  new Point(145, 150), screenTextFormat);
			
			
			//instruction screen initializations
			instructionsScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS,
												400, 400, false, 0x0000dd);
			
			instructionsScreen.createOkButton("Play", new Point(150, 250), 80, 20, 
											 screenButtonFormat, 0x000000, 0xff0000, 2);
			
			instructionsScreen.createDisplayText("Click the mouse\n10 times", 150, 
												new Point(120,150), screenTextFormat);
			
			
			//game over screen initializations
			gameOverScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_GAME_OVER,
											 400, 400, false, 0x0000dd);
			
			gameOverScreen.createOkButton("OK", new Point(170, 250), 40, 20,
											screenButtonFormat, 0x000000, 0xff0000, 2);
			
			gameOverScreen.createDisplayText("Game Over", 100, 
												new Point(140,150), screenTextFormat);
			
			
			//level in screen initializations
			levelInScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_LEVEL_IN,
											400, 400, true, 0xaaff0000);
			
			levelInText = "Level";
			
			levelInScreen.createDisplayText(levelInText, 100,
											new Point(150,150), screenTextFormat);
			
			//Set standard wait time between levels
			waitTime = 30;
			
			//set initial games state
			
			switchSystemState(FrameWorkStates.STATE_SYSTEM_TITLE);
			
			//create timer and run it one time
			frameRate = 30;
			
			startTimer();
		}
	}
}