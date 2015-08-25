package com.efg.games.driveshesaid
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import com.efg.framework.FrameWorkStates;
	import com.efg.framework.GameFrameWork;
	import com.efg.framework.BasicScreen;
	import com.efg.framework.ScoreBoard;
	import com.efg.framework.SideBySideScoreElement;
	import com.efg.framework.SoundManager;
	
	
	public class Main extends GameFrameWork
	{
		public static const SCORE_BOARD_SCORE:String = "score";
		public static const SCORE_BOARD_TIME_LEFT:String = "timeleft";
		public static const SCORE_BOARD_HEARTS:String = "hearts";
		
		//custom sounds
		public static const SOUND_TITLE_MUSIC:String = "titlemusic";
		public static const SOUND_CAR:String = "car";
		public static const SOUND_CLOCK_PICKUP:String = "clockpickup";
		public static const SOUND_HEART_PICKUP:String = "heartpickup";
		public static const SOUND_GAME_LOST:String = "gamelost";
		public static const SOUND_LEVEL_COMPLETE:String = "levelcomplete";
		public static const SOUND_SKULL_HIT:String = "skullhit";
		public static const SOUND_PLAYER_START:String = "playerstart";
		public static const SOUND_HIT_WALL:String = "hitwall";
		
		//level in screen additions
		private var heartsToCollect:TextField = new TextField();
		

		public function Main() 
		{
			init();
		}
		
		override public function init():void
		{
			game = new DriveSheSaid4();
			game.y = 20;
			game.x = 404;
			setApplicationBackGround(384, 404, false, 0x000000);
			
			game.addEventListener(CustomEventHeartsNeeded.HEARTS_NEEDED, heartsNeededListener, false, 0, true);
			
			//scoreboard updates on second layer
			scoreBoard = new ScoreBoard();
			addChild(scoreBoard);
			scoreBoardTextFormat = new TextFormat("_sans", "11", "0xffffff", "true");
			
			scoreBoard.createTextElement(SCORE_BOARD_SCORE, new SideBySideScoreElement
										 (80, 5, 20, "Score:", scoreBoardTextFormat, 25, "0", scoreBoardTextFormat));
			
			scoreBoard.createTextElement(SCORE_BOARD_TIME_LEFT, new SideBySideScoreElement
										 (180, 5, 20, "Time Left:", scoreBoardTextFormat, 45, "0", scoreBoardTextFormat));
			
			scoreBoard.createTextElement(SCORE_BOARD_HEARTS, new SideBySideScoreElement
										 (280, 5, 20, "Hearts:", scoreBoardTextFormat, 25, "0", scoreBoardTextFormat));
			
			
			//Screens and text
			screenTextFormat = new TextFormat("_sans", "16", "0xffffff", "false");
			screenTextFormat.align = flash.text.TextFormatAlign.CENTER;
		    screenButtonFormat = new TextFormat("_sans", "12", "0x000000", "false");
			
			//Title
			titleScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_TITLE, 384, 404, false, 0x000000);
			titleScreen.createOkButton("Play.", new Point(150,250), 100, 20, screenButtonFormat, 0x000000, 0x00ff0000, 2);
			titleScreen.createDisplayText("Drive She Said.", 200, new Point(100, 150), screenTextFormat);
			
			
			//Instructions
			instructionsScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS, 384, 404, false, 0x000000);
			instructionsScreen.createOkButton("Start.", new Point(150,250), 100, 20, screenButtonFormat, 0x000000, 0xff0000, 2);
			instructionsScreen.createDisplayText("You forgot your \n anniversary.", 200, new Point(100, 150), screenTextFormat);
			
			//Game Over
			gameOverScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_GAME_OVER, 640, 500, false, 0x0000dd);
			gameOverScreen.createOkButton("Play Again.", new Point(150,250), 100, 20, screenButtonFormat, 0x000000, 0xff0000, 2);
			gameOverScreen.createDisplayText("Time's Up.\nGame Over.", 100, new Point(150, 150), screenTextFormat);
			
			
			//Load In Screen
			levelInText = "Level ";
			levelInScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_LEVEL_IN, 384, 404, true, 0xbbff00ff);
			levelInScreen.createDisplayText(levelInText,100, new Point(150, 150), screenTextFormat);
			
			//Hearts
			heartsToCollect.defaultTextFormat = screenTextFormat;
			heartsToCollect.width = 300;
			heartsToCollect.x = 50;
			heartsToCollect.y = 200;
			levelInScreen.addChild(heartsToCollect);
			
			//Initial game state
			switchSystemState(FrameWorkStates.STATE_SYSTEM_TITLE);
			
			//Sound Manager
			soundManager.addSound(SOUND_TITLE_MUSIC, new SoundTitleMusic);			
			soundManager.addSound(SOUND_CAR, new SoundCar);
			soundManager.addSound(SOUND_CLOCK_PICKUP, new SoundClockPickup);
			soundManager.addSound(SOUND_HEART_PICKUP, new SoundHeartPickup);
			soundManager.addSound(SOUND_GAME_LOST, new SoundGameLost);
			soundManager.addSound(SOUND_LEVEL_COMPLETE, new SoundLevelComplete);
			soundManager.addSound(SOUND_SKULL_HIT, new SoundSkullHit);
			soundManager.addSound(SOUND_PLAYER_START, new SoundPlayerStart);
			soundManager.addSound(SOUND_HIT_WALL, new SoundHitWall);
			
			frameRate = 40;
			startTimer();
		}
		
		override public function systemTitle():void
		{
			soundManager.playSound(SOUND_TITLE_MUSIC, false, 999, 20, 1);
			super.systemTitle();
		}
		
		override public function systemNewGame():void
		{
			soundManager.stopSound(SOUND_TITLE_MUSIC);
			super.systemNewGame();
		}
		
		override public function systemLevelIn():void
		{
			levelInScreen.alpha = 1;
			super.systemLevelIn();
		}
		
		override public function systemWait():void
		{
			if (lastSystemState == FrameWorkStates.STATE_SYSTEM_LEVEL_IN)
			{
				game.x -= 2;
					
					if (game.x < 100)
					{
						levelInScreen.alpha -= .01;
						
						if (levelInScreen.alpha < 0)
						{
							levelInScreen.alpha = 0;
						}
					}
						if (game.x <= 0)
						{
							game.x = 0;
							soundManager.playSound(SOUND_PLAYER_START, false, 1, 20,1);
							
							//Game will continue to wait unless this is launched to make it stop waiting.
							
							dispatchEvent(new Event(EVENT_WAIT_COMPLETE));
						}
				}
		}
					
		private function heartsNeededListener(e:CustomEventHeartsNeeded):void
		{
			heartsToCollect.text = "Collect " + e.heartsNeeded + " Hearts";
		}
				
	}
	
}
