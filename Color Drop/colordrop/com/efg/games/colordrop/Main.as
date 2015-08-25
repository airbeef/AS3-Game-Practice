package com.efg.games.colordrop
{
	
	import com.efg.framework.FrameWorkStates;
	import com.efg.framework.GameFrameWork;
	import com.efg.framework.BasicScreen;
	import com.efg.framework.ScoreBoard;
	import com.efg.framework.Game;
	import com.efg.framework.SideBySideScoreElement;
	import com.efg.framework.SoundManager;
	
	import flash.display.Bitmap
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	
	public class Main extends GameFrameWork
	{
		//custom score board
		public static const SCORE_BOARD_SCORE:String = "score";
		public static const SCORE_BOARD_LEVEL:String = "level";
		public static const SCORE_BOARD_PLAYS:String = "plays";
		public static const SCORE_BOARD_THRESHOLD:String = "threshold";
		public static const SCORE_BOARD_LEVEL_SCORE:String = "levelScore";
		
		//custom soundbytes
		public static const SOUND_CLICK:String = "soundClick";
		public static const SOUND_BONUS:String = "soundBonus";
		public static const SOUND_WIN:String = "soundWin";
		public static const SOUND_LOSE:String = "soundLose";
		
		public function Main() 
		{
			init();
		}
		
		override public function init():void
		{
			game = new ColorDrop(600, 400);
			setApplicationBackGround(600, 500, false, 0x000000);
			
			//add scoreboard to screen as second layer
			scoreBoard = new ScoreBoard();
			addChild(scoreBoard);
			
			scoreBoardTextFormat = new TextFormat ("_sans", "11", "0xffffff", "true");
			scoreBoard.createTextElement(SCORE_BOARD_SCORE, new SideBySideScoreElement
										(10, 5, 15, "Score", scoreBoardTextFormat, 50, "0", scoreBoardTextFormat));
			
			scoreBoard.createTextElement(SCORE_BOARD_LEVEL, new SideBySideScoreElement
										(125, 5, 15, "Level", scoreBoardTextFormat, 40, "0", scoreBoardTextFormat));
			
			scoreBoard.createTextElement(SCORE_BOARD_PLAYS, new SideBySideScoreElement
										(225, 5, 15, "Plays", scoreBoardTextFormat, 40, "0", scoreBoardTextFormat));
			
			scoreBoard.createTextElement(SCORE_BOARD_THRESHOLD, new SideBySideScoreElement
										(300, 5, 20, "Threshold", scoreBoardTextFormat, 80, "0", scoreBoardTextFormat));
			
			scoreBoard.createTextElement(SCORE_BOARD_LEVEL_SCORE, new SideBySideScoreElement
										(425, 5, 15, "Level Score", scoreBoardTextFormat, 80, "0", scoreBoardTextFormat));
			
			//Screens and text
			screenTextFormat = new TextFormat("_sans", "14", "0xffffff", "true");
		    screenButtonFormat = new TextFormat("_sans", "11", "0x000000", "true");
			
			//Title
			titleScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_TITLE, 600, 400, false, 0x0000dd);
			titleScreen.createDisplayText("Color Drop", 250, new Point(255, 100), screenTextFormat);
			titleScreen.createOkButton("Go!", new Point(250,250), 100, 20, screenButtonFormat, 0xffffff, 0x00ff0000, 2);
			
			
			//Instructions
			instructionsScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS, 600, 400, false, 0x000000);
			instructionsScreen.createDisplayText("Click Colored Blocks.", 300, new Point(210, 100), screenTextFormat);
			instructionsScreen.createOkButton("Play", new Point(250,250), 100, 20, screenButtonFormat, 0xffffff, 0xff0000, 2);
			
			//Game Over
			gameOverScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_GAME_OVER, 600, 400, false, 0x000000);
			gameOverScreen.createDisplayText("FAIL!", 300, new Point(250, 100), screenTextFormat);
			gameOverScreen.createOkButton("Play Again.", new Point(250,250), 150, 20, screenButtonFormat, 0xffffff, 0xff0000, 2);
			
			
			//Load In Screen
			levelInText = "Level ";
			levelInScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_GAME_OVER, 600, 400, false, 0x000000);
			levelInScreen.createDisplayText(levelInText,300, new Point(275,100), screenTextFormat);
			
			//Set Initial Game State
			switchSystemState(FrameWorkStates.STATE_SYSTEM_TITLE);
			
			//Wait
			waitTime = 40;
			
			//Sound Manager
			soundManager.addSound(SOUND_CLICK, new SoundClick());
			soundManager.addSound(SOUND_BONUS, new SoundBonus());
			soundManager.addSound(SOUND_WIN, new SoundWin());
			soundManager.addSound(SOUND_LOSE, new SoundLose());
		
			//Create Timer and run it once
			frameRate = 40;
			startTimer();
		}
		
		
	}
}
