package com.efg.games.dicebattle 
{
	public class GameStates
	{

			public static const STATE_INITIALIZING:int = 10;
			public static const STATE_CHANGE_TURN:int = 20;
			public static const STATE_START_REPLACING:int = 30;
			public static const STATE_START_AI:int = 40;
			public static const STATE_WAITING_FOR_INPUT:int = 60;
			
			public static const STATE_REMOVE_CLICKED_DICE:int = 70;
			public static const STATE_CHECK_FOR_END:int = 80;
			public static const STATE_FADE_DICE_WAIT:int = 90;
			public static const STATE_FALL_DICE_WAIT:int = 100;
			
			public static const STATE_END_GAME:int = 110;
			public static const STATE_END_LEVEL:int = 120;
			public static const STATE_WAIT:int = 130;
	}
	
}
