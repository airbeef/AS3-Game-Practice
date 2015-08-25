package com.efg.games.superclick
{
	//Flash Packages
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.geom.Point;

	//My core packages
	import com.efg.framework.FrameWorkStates;
	import com.efg.framework.GameFrameWork;
	import com.efg.framework.BasicScreen;
	import com.efg.framework.ScoreBoard;
	import com.efg.framework.SideBySideScoreElement;

	public class Main extends GameFrameWork
	{
		//custom scoreboard element
		public static const SCORE_BOARD_SCORE:String = "score";
		public static const SCORE_BOARD_CLICKED:String = "clicked";
		public static const SCORE_BOARD_PERCENT_NEEDED:String = "percent needed";
		public static const SCORE_BOARD_PERCENT_ACHIEVED:String = "percent achieved";

		public function Main()
		{
			// init dis bitch
			init();
		}
		
	
		override public function init():void
		{
			
			game = new SuperClick();

			setApplicationBackGround(400, 400, false, 0x000000);

			//add teh scoreboard to the screen: second layer
			scoreBoard = new ScoreBoard();
			addChild(scoreBoard);
			scoreBoardTextFormat = new TextFormat
			("_sans", "11", "0xffffff", "true");

			scoreBoard.createTextElement(SCORE_BOARD_SCORE, new SideBySideScoreElement
			 (25, 5, 15,"Score", scoreBoardTextFormat, 25, "0", scoreBoardTextFormat));

			scoreBoard.createTextElement(SCORE_BOARD_CLICKED, new SideBySideScoreElement
			 (85, 5, 10,"Clicked", scoreBoardTextFormat, 40, "0/0", scoreBoardTextFormat));

			scoreBoard.createTextElement(SCORE_BOARD_PERCENT_NEEDED, new SideBySideScoreElement
			 (170, 5, 10,"%Needed", scoreBoardTextFormat, 50, "0%", scoreBoardTextFormat));

			scoreBoard.createTextElement(SCORE_BOARD_PERCENT_ACHIEVED, new SideBySideScoreElement
			 (260, 5, 10,"%Achieved", scoreBoardTextFormat, 60, "0%", scoreBoardTextFormat));
			
			
			//screen text inits
			screenTextFormat = new TextFormat("_sans","16",0xffffff,"false");
			screenTextFormat.align = flash.text.TextFormatAlign.CENTER;
			screenButtonFormat = new TextFormat("_sans","12",0x000000,"false");


			//title screen
			titleScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_TITLE, 400, 400, false, 0x0000dd);
			titleScreen.createOkButton("OK", new Point(170, 250), 40, 20, screenButtonFormat, 0x000000, 0xff0000, 2);
			titleScreen.createDisplayText("Super Click", 100, new Point(145, 150), screenTextFormat);
			
			//test
			//titleScreen.createDummyButton("Dummy", new Point(100, 250), 50, 20, screenButtonFormat, 0x0000, 0xff0000, 2);
			
			
			//instruction screen
			instructionsScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS, 400, 400, false, 0X0000dd);
			instructionsScreen.createOkButton("Play", new Point(150,250), 80, 20, screenButtonFormat, 0x000000, 0xff0000, 2);
			instructionsScreen.createDisplayText("Click The Blue \n Circles.",150, new Point(120, 150), screenTextFormat);
			


			//game over screen
			gameOverScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_GAME_OVER, 400, 400, false, 0X0000dd);
			gameOverScreen.createOkButton("Ok", new Point(170, 250), 40, 20, screenButtonFormat, 0x000000, 0xff0000, 2);
			gameOverScreen.createDisplayText("Game Ovah!", 100, new Point(140,150), screenTextFormat);

			//Level In Screen
			levelInScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_LEVEL_IN, 400, 400, true, 0xaaff0000);
			levelInText = "Level ";
			levelInScreen.createDisplayText(levelInText, 100, new Point(150,150), screenTextFormat);

			//Switch game states
			switchSystemState(FrameWorkStates.STATE_SYSTEM_TITLE);

			waitTime = 40;

			//create timer and run it one time
			frameRate = 30;
			startTimer();

		}

	}

}