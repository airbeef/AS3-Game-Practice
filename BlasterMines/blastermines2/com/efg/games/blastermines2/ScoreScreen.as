package com.efg.games.blastermines2
{
	import com.efg.framework.BasicScreen;
	import com.efg.framework.FrameWorkStates;
	import com.efg.framework.SimpleBlitButton;
	import com.efg.framework.CustomEventButtonId;
	import com.efg.framework.CustomEventScoreBoardUpdate;
	
	import flash.text.*;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.net.SharedObject;
	
	public class ScoreScreen extends BasicScreen
	{
		//Override hard coded state and button functionality
		private var m_OverrideNextState:int;
		private var s_backButton:SimpleBlitButton;
		
		
								
		//This is the Scoreboard Override
		public function ScoreScreen(id:int, width:Number, height:Number, isTransparent:Boolean, color:int) 
		{
			super(id, width, height, isTransparent,color);
			this.m_OverrideNextState;
		}
		
		//This is the Local Scorebaord back button that goes to Title
		public function scoreBackButton(text:String, location:Point, width:Number, height:Number,
										textFormat:TextFormat, positionOffset:Number = 0):void
		{
			s_backButton = new SimpleBlitButton(location.x, location.y, width, height, text,
												0xffffff, 0xff0000, textFormat, positionOffset);
			
			addChild(s_backButton);
			
			s_backButton.addEventListener(MouseEvent.CLICK, s_backButtonClickListener, false, 0, true);
		}
		
		//Testing to see if this works with Dummy Screen
		private function s_backButtonClickListener(e:MouseEvent):void
		{
			dispatchEvent(new CustomEventButtonId(CustomEventButtonId.BUTTON_ID, id, FrameWorkStates.STATE_SYSTEM_TITLE));
		}
		
		//This is a start of scoreboard code
		//Dynamic text field [4]
		//Title
		//Way to have a title that won't act faggy
		//Collect score, level
		//Allow player to input name [3 characters]
		//Use score in a array; Highest on top/lowest on bottom
		//Allow page to be seperate from game score
		//Allow player to see scores from Title page
		//Allow player clear score
		/*
		public function scoreFinalScore():void
		{
			protected var arrs:Array = Main.Ins.saveData("Top Scores") as Array;
			public var score_obj:Object = new Object();
			
			score_obj.name = Main.TYPEDNAME;
			score_obj.score = Main.LastScore;
			score_obj.level = Main.LevelShit;
			
			arrs.push(Main.LastScore);
			arr.sortOn(Array.NUMERIC | Array.DESCENDING);
			
			if(arrs.length > 4)
			{
				arrs.pop();
			}
			
			Main.Ins.saveData("Stop Scores", arrs);
			
		}
		*/
		
	}
	
}
