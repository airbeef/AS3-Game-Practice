package com.efg.games.stubgame
{
	// import necessary classes from all flash libraries
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
		
	import com.efg.framework.Game;
	import com.efg.framework.CustomEventLevelScreenUpdate;
	import com.efg.framework.CustomEventScoreBoardUpdate;
	
	/**
	* @you know who
	*
	**/
	
	public class StubGame extends Game
	{
		//Create constants for simple custom events
		public static const GAME_OVER:String = "game over";
		public static const NEW_LEVEL:String = "new level";
		
		private var clicks:int = 0;
		private var gameLevel:int = 1;
		private var gameOver:Boolean = false;
		
		public function StubGame()
		{
			
		}
		
		override public function newGame():void
		{
			clicks = 0;
			gameOver = false;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownEvent);
			
			dispatchEvent(new CustomEventScoreBoardUpdate
						(CustomEventScoreBoardUpdate.UPDATE_TEXT,
						 Main.SCORE_BOARD_CLICKS,String(clicks)));
		}
		
		override public function newLevel():void
		{
			dispatchEvent(new CustomEventLevelScreenUpdate
						 (CustomEventLevelScreenUpdate.UPDATE_TEXT,
						  String(gameLevel)));
		}
		
		override public function runGame():void
		{
			if (clicks >= 10)
				{
					gameOver = true;
				}
			checkforEndGame();
		}
		
		public function onMouseDownEvent(e:MouseEvent):void
		{
			clicks++;
			dispatchEvent(new CustomEventScoreBoardUpdate
						 (CustomEventScoreBoardUpdate.UPDATE_TEXT,
						  Main.SCORE_BOARD_CLICKS, String(clicks)));
			
			trace("mouse click number" + clicks);
		}
		
		private function checkforEndGame():void
		{
			if (gameOver)
			{
				dispatchEvent(new Event(GAME_OVER));
			}
		}
		
		
	}
	
}