package com.efg.games.flakcannon 
{

	import com.efg.framework.FrameWorkStates;
	import com.efg.framework.GameFrameWork;
	import com.efg.framework.BasicScreen;
	import com.efg.framework.ScoreBoard;
	import com.efg.framework.Game;
	import com.efg.framework.SideBySideScoreElement;
	import com.efg.framework.SoundManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	
	public class Main extends GameFrameWork 
	{
		//custom score board elements
		public static const SCORE_BOARD_SCORE:String = "score";
		public static const SCORE_BOARD_SHOTS:String = "shots";
		public static const SCORE_BOARD_SHIPS:String = "ships";
		
		//custom sounds
		public static const SOUND_BONUS:String = "sound bonus";
		public static const SOUND_BONUS_SHIP:String = "sound bonus ship";
		public static const SOUND_SHOOT:String = "sound shoot";
		public static const SOUND_NOSHOTS:String = "sound no shots";
		public static const SOUND_EXPLODE_PLANE:String = "sound eplode plane";
		public static const SOUND_EXPLODE_FLAK:String = "sound explode flak";
		public static const SOUND_EXPLODE_SHIP:String = "sound explode ship";
		

		public function Main() 
		{
			init();
		}
		
		override public function init():void
		{
			//game and background size
			game = new FlakCannon(550,400);
			setApplicationBackGround(550,400, false, 0x0042AD);
			
			//Score stuff
			scoreBoard = new ScoreBoard();
			addChild(scoreBoard);
			
			scoreBoardTextFormat = new TextFormat("_sans", "11", "0xffffff", "true");
			
			scoreBoard.createTextElement(SCORE_BOARD_SCORE, new SideBySideScoreElement
										 (80, 5, 15, "Score", scoreBoardTextFormat, 25, "0", scoreBoardTextFormat));
			
			scoreBoard.createTextElement(SCORE_BOARD_SHOTS, new SideBySideScoreElement
										 (240, 5, 10, "Shots", scoreBoardTextFormat, 40, "0", scoreBoardTextFormat));
			
			scoreBoard.createTextElement(SCORE_BOARD_SHIPS, new SideBySideScoreElement
										 (400, 5, 10, "Score", scoreBoardTextFormat, 50, "0", scoreBoardTextFormat));
			
			
			screenTextFormat = new TextFormat("_sans", "14", "0xffffff", "true");
			screenButtonFormat = new TextFormat("_sans", "11", "0x000000", "true");
			
			//Game Screens//
			
			//title screen
			titleScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_TITLE, 550, 400, false, 0x0042AD);
			titleScreen.createDisplayText("Flak Cannon", 250, new Point(255, 100), screenTextFormat);
			titleScreen.createOkButton("Go!", new Point(250,250), 100, 20, screenButtonFormat, 0xffffff, 0xff0000, 2);
			
			//instruction screen
			instructionsScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS, 600, 400, false, 0x0042AD);
			instructionsScreen.createDisplayText("Shoot The Enemy Planes", 300, new Point(210, 100), screenTextFormat);
			instructionsScreen.createOkButton("Play!", new Point(250,250), 100, 20, screenButtonFormat, 0xffffff, 0xff0000, 2);
			
			//game over screen
			gameOverScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_GAME_OVER, 600, 400, false, 0x0042AD);
			gameOverScreen.createDisplayText("Game Over", 300, new Point(255, 100), screenTextFormat);
			gameOverScreen.createOkButton("Go!", new Point(225,250), 150, 20, screenButtonFormat, 0xffffff, 0xff0000, 2);
			
			//level in screens
			levelInText ="Level";
			levelInScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_GAME_OVER, 600,400, false, 0x0042ad);
			levelInScreen.createDisplayText(levelInText, 300, new Point(275, 100), screenTextFormat);
			
			switchSystemState(FrameWorkStates.STATE_SYSTEM_TITLE);
			waitTime = 50;
			
			//sound manager
			soundManager.addSound (SOUND_BONUS, new SoundBonus());
			soundManager.addSound (SOUND_BONUS_SHIP, new SoundBonusShip());
			soundManager.addSound (SOUND_SHOOT, new SoundShoot());
			soundManager.addSound (SOUND_NOSHOTS, new SoundNoShots());
			soundManager.addSound (SOUND_EXPLODE_PLANE, new SoundExplodePlane());
			soundManager.addSound (SOUND_EXPLODE_FLAK, new SoundExplodeFlak());
			soundManager.addSound (SOUND_EXPLODE_SHIP, new SoundExplodeShip());
			
			
			//start the frame timer
			frameRate = 30;
			startTimer();
		}
		
	}
	
}
