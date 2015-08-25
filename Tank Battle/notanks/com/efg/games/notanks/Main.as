package com.efg.games.notanks 
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.geom.Point;
	
	import com.efg.framework.FrameWorkStates;
	import com.efg.framework.GameFrameWork;
	import com.efg.framework.BasicScreen;
	import com.efg.framework.ScoreBoard;
	import com.efg.framework.SideBySideScoreElement;
	import com.efg.framework.SoundManager;
	
	public class Main extends GameFrameWork
	{
		//custom score board
		public static const SCORE_BOARD_SCORE:String = "score";
		public static const SCORE_BOARD_AMMO:String = "ammo";
		public static const SCORE_BOARD_TANKS:String = "tanks";
		public static const SCORE_BOARD_HEALTH:String = "health";
		
		//custom soundbytes
		public static const SOUND_ENEMY_FIRE:String = "enemyfire";
		public static const SOUND_EXPLODE:String = "explode";
		public static const SOUND_PLAYER_EXPLODE:String = "playerexplode";
		public static const SOUND_PLAYER_FIRE:String = "playerfire";
		public static const SOUND_PLAYER_MOVE:String = "playermove";
		
		public static const SOUND_PICK_UP:String = "pickup";
		public static const SOUND_GOAL:String = "goal";
		public static const SOUND_HIT:String = "hit";
		public static const SOUND_MUSIC:String = "music";
		public static const SOUND_HIT_WALL:String = "hitwall";
		public static const SOUND_LIFE:String = "soundlife";

		public function Main() 
		{
			init();
		}
		
		override public function init():void
		{
			game = new NoTanks();
			game.y = 20;
			setApplicationBackGround(640, 500, false, 0x000000);
			
			//add scoreboard to screen as second layer
			scoreBoard = new ScoreBoard();
			addChild(scoreBoard);
			
			scoreBoardTextFormat = new TextFormat ("_sans", "11", "0xffffff", "true");
			scoreBoard.createTextElement(SCORE_BOARD_SCORE, new SideBySideScoreElement
										(80, 5, 20, "Score", scoreBoardTextFormat, 25, "0", scoreBoardTextFormat));
			
			scoreBoard.createTextElement(SCORE_BOARD_AMMO, new SideBySideScoreElement
										(180, 5, 20, "Ammo", scoreBoardTextFormat, 25, "0/0", scoreBoardTextFormat));
			
			scoreBoard.createTextElement(SCORE_BOARD_TANKS, new SideBySideScoreElement
										(280, 5, 20, "Tanks", scoreBoardTextFormat, 25, "0%", scoreBoardTextFormat));
			
			scoreBoard.createTextElement(SCORE_BOARD_HEALTH, new SideBySideScoreElement
										(380, 5, 20, "Health", scoreBoardTextFormat, 25, "0%", scoreBoardTextFormat));
			
			//Screens and text
			screenTextFormat = new TextFormat("_sans", "16", "0xffffff", "false");
		    screenTextFormat.align = flash.text.TextFormatAlign.CENTER;
			screenButtonFormat = new TextFormat("_sans", "12", "0x000000", "false");
			
			//Title
			titleScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_TITLE, 640, 500, false, 0x0000dd);
			titleScreen.createOkButton("Play", new Point(250,250), 100, 20, screenButtonFormat, 0x000000, 0xff0000, 2);
			titleScreen.createDisplayText("No Tanks!", 120, new Point(245, 150), screenTextFormat);
			
			//Instructions
			instructionsScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS, 640, 500, false, 0x0000dd);
			instructionsScreen.createOkButton("Start", new Point(250,250), 100, 20, screenButtonFormat, 0x000000, 0xff0000, 2);
			instructionsScreen.createDisplayText("Find Treasure. \n Shoot Shit. \n ??? \n Profit.", 120, new Point(180, 150), screenTextFormat);
			
			//Game Over
			gameOverScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_GAME_OVER, 640, 500, false, 0x0000dd);
			gameOverScreen.createOkButton("Restart", new Point(250,250), 100, 20, screenButtonFormat, 0x000000, 0xff0000, 2);
			gameOverScreen.createDisplayText("Game Over.", 100, new Point(250, 150), screenTextFormat);
			
			//Load In Screen
			levelInScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_LEVEL_IN, 640, 500, true, 0xaaff0000);
			levelInText = "Level ";
			levelInScreen.createDisplayText(levelInText, 100, new Point(250, 150), screenTextFormat);
			
			//set Initional Game State
			switchSystemState(FrameWorkStates.STATE_SYSTEM_TITLE);
			
			//Wait
			waitTime = 30;
			
			//Sound Manager
			/*
			soundManager.addSound(SOUND_ENEMY_FIRE, new SoundEnemyFire);
			soundManager.addSound(SOUND_EXPLODE, new SoundExplode);
			soundManager.addSound(SOUND_PLAYER_EXPLODE, new SoundPlayerExplode);
			soundManager.addSound(SOUND_PLAYER_FIRE, new SoundPlayerFire);
			soundManager.addSound(SOUND_PLAYER_MOVE, new SoundPlayerMove);
			
			soundManager.addSound(SOUND_PICK_UP, new SoundPickUp);
			soundManager.addSound(SOUND_GOAL, new SoundGoal);
			soundManager.addSound(SOUND_HIT, new SoundHit);
			soundManager.addSound(SOUND_MUSIC, new SoundMusic);
			soundManager.addSound(SOUND_HIT_WALL, new SoundHitWall);
			soundManager.addSound(SOUND_LIFE, new SoundLife);
			*/
			
			//Create Timer and run it once
			frameRate = 30;
			startTimer();
		}
		
		override public function systemTitle():void
		{
			//soundManager.playerSound(SOUND_MUSIC, false, 999, 0, 1);
			super.systemTitle();
		}
		
		override public function systemNewGame():void
		{
			//soundManager.stopSound(SOUND_MUSIC);
			super.systemNewGame();
		}
	}
}
