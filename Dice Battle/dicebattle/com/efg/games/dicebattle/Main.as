package com.efg.games.dicebattle 
{
	import com.efg.framework.FrameWorkStates;
	import com.efg.framework.GameFrameWork;
	import com.efg.framework.BasicScreen;
	import com.efg.framework.ScoreBoard;
	import com.efg.framework.Game;
	import com.efg.framework.SideBySideScoreElement;
	import com.efg.framework.SoundManager;
	import com.efg.framework.CustomEventSound;
	
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
		public static const SCORE_BOARD_TURN:String = "turn";
		public static const SCORE_BOARD_COMPUTER_LIFE:String = "computerLife";
		public static const SCORE_BOARD_PLAYER_LIFE:String = "playerLife";
		
		//custom soundbytes
		public static const SOUND_CLICK:String = "soundClick";
		public static const SOUND_BONUS:String = "soundBonus";
		public static const SOUND_WIN:String = "soundWin";
		public static const SOUND_LOSE:String = "soundLose";
		public static const SOUND_HIT:String = "soundHit";
		public static const SOUND_SOUND_TRACK_1:String = "soundTrack1";
		public static const SOUND_SOUND_TRACK_2:String = "soundTrack2";

		public function Main() 
		{
			init();
		}
		
		override public function init():void
		{
			game = new DiceBattle (600, 400);
			
			setApplicationBackGround(600, 400, false, 0x000000);
			//add application bg to the screen as the bottom layer
			//add scoreboard to screen as the second layer
			
			scoreBoard = new ScoreBoard();
			addChild(scoreBoard);
			
			var scoreBoardTextFormat1:TextFormat = new TextFormat("_sans", "11", "0xffffff", "true");
			var scoreBoardTextFormat2:TextFormat = new TextFormat("_sans", "11", "0xff0000", "true");
			var scoreBoardTextFormat3:TextFormat = new TextFormat("_sans", "14", "0xffffff", "true");
			var scoreBoardTextFormat4:TextFormat = new TextFormat("_sans", "14", "0xff0000", "true");
			var scoreBoardTextFormat5:TextFormat = new TextFormat("_sans", "10", "0xffffff", "true");
			var scoreBoardTextFormat6:TextFormat = new TextFormat("_sans", "25", "0x00ff00", "true");
			var scoreBoardTextFormat7:TextFormat = new TextFormat("_sans", "25", "0xff0000", "true");
			
			scoreBoard.createTextElement(SCORE_BOARD_SCORE, new SideBySideScoreElement
										 (75, 5, 15, "Score:", scoreBoardTextFormat1, 25, "0", scoreBoardTextFormat2));
			
			scoreBoard.createTextElement(SCORE_BOARD_LEVEL, new SideBySideScoreElement
										 (325, 5, 10, "Level:", scoreBoardTextFormat1, 50, "0", scoreBoardTextFormat2));
			
			scoreBoard.createTextElement(SCORE_BOARD_TURN, new SideBySideScoreElement
										 (250, 380, 10, "Turn:", scoreBoardTextFormat3, 50, "0", scoreBoardTextFormat4));
			
			scoreBoard.createTextElement(SCORE_BOARD_PLAYER_LIFE, new SideBySideScoreElement
										 (25, 150, 10, "Life:", scoreBoardTextFormat5, 20, "0", scoreBoardTextFormat6));
			
			scoreBoard.createTextElement(SCORE_BOARD_COMPUTER_LIFE, new SideBySideScoreElement
										 (480, 150, 10, "Life:", scoreBoardTextFormat5, 20, "0", scoreBoardTextFormat7));
			
			//Screens and text
			screenTextFormat = new TextFormat("_sans", "14", "0xffffff", "true");
		    screenButtonFormat = new TextFormat("_sans", "11", "0x000000", "true");
			
			//Title
			titleScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_TITLE, 600, 400, false, 0x000000);
			titleScreen.createDisplayText("Dice Battle", 250, new Point(255, 150), screenTextFormat);
			titleScreen.createOkButton("Go!", new Point(250,250), 100, 20, screenButtonFormat, 0xffffff, 0x00ff0000, 2);
			
			
			//Instructions
			instructionsScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS, 600, 400, false, 0x000000);
			instructionsScreen.createDisplayText("Beat The Computer.", 250, new Point(255, 150), screenTextFormat);
			instructionsScreen.createOkButton("Play.", new Point(250,250), 100, 20, screenButtonFormat, 0xffffff, 0xff0000, 2);
			
			//Game Over
			gameOverScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_GAME_OVER, 600, 400, false, 0x000000);
			gameOverScreen.createDisplayText("Game Over.", 300, new Point(250, 100), screenTextFormat);
			gameOverScreen.createOkButton("Play Again.", new Point(225,250), 150, 20, screenButtonFormat, 0xffffff, 0xff0000, 2);
			
			
			//Load In Screen
			levelInText = "Level ";
			levelInScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_LEVEL_IN, 600, 400, false, 0x000000);
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
			
			soundManager.addSound(SOUND_SOUND_TRACK_1, new SoundTrack1());
			soundManager.addSound(SOUND_SOUND_TRACK_2, new SoundTrack2());
		
			//Create Timer and run it once
			frameRate = 40;
			startTimer();
			
		}
		
			//The following overrides keep specific information within the Main constructor and not
			//the Gameframework. This keeps the Framework from knowing too much info that could
			//confuse it.
			
			//Note 1.17.12: From previous examples, the Fulton Bros. did the following:	
			//override public function systemTitle():void
			//{
			// 	soundManager.playSomething (yada yada yada);
			// 	blah blah.super;
			//}
			//This is no longer needed. Functions below are the correct examples for CS5/AS3
			
			//1.18.2012: I was wrong. The uncommented functions are neeeded if OUTSIDE
			//the main function. The commented functions only work within the main function
			
			//soundManager.playSound(Main.SOUND_SOUND_TRACK_2, true, 1000,0,1);
			//super.systemTitle();
			
			//soundManager.playSound(Main.SOUND_SOUND_TRACK_2, true, 1000,0,1);
			//super.systemNewGame();
			
			//soundManager.playSound(Main.SOUND_SOUND_TRACK_1, true, 1000,0,1);
			//super.systemGameOver();
			
			override  public function systemTitle():void
			{
				soundManager.playSound(Main.SOUND_SOUND_TRACK_1,true,1000,0,1);
				super.systemTitle();
			}
		
			override  public function systemNewGame():void 
			{
				soundManager.playSound(Main.SOUND_SOUND_TRACK_2,true,1000,0,1);			
				super.systemNewGame();
			}
		
			override public function systemGameOver():void
			{
				soundManager.playSound(Main.SOUND_SOUND_TRACK_1,true,1000,0,1);
				super.systemGameOver();
			
			}
			
	  }
	
}
