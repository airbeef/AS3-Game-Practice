package com.efg.games.blastermines2
{
	import com.efg.framework.BasicScreen;
	import com.efg.framework.SimpleBlitButton;
	import com.efg.framework.CustomEventButtonId;
	import com.efg.framework.FrameWorkStates;
	
	import flash.text.TextFormat;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	
	public class DummyScreen extends BasicScreen
	{
		private var m_OverrideNextState:int;
		private var d_backButton:SimpleBlitButton;
		
		//Test Score Screen
		private var scoreButtonTest:SimpleBlitButton;

		public function DummyScreen (id:int, width:Number, height:Number, isTransparent:Boolean, color:uint)
		{
			super(id,width,height,isTransparent, color);
			this.m_OverrideNextState;
		}
		
		//back button creation
		public function createBackButton(text:String, location:Point, width:Number, height:Number, 
											textFormat:TextFormat, positionOffset:Number = 0):void
		{
			d_backButton = new SimpleBlitButton(location.x, location.y, width, height, text,
											0xffffff, 0xff0000, textFormat, positionOffset);
			
			addChild(d_backButton);
			
			d_backButton.addEventListener(MouseEvent.CLICK, d_backButtonClickListener, false, 0, true);
		}
		
		//Score Screen Test
		public function createScoreTest(text:String, location:Point, width:Number, height:Number, 
											textFormat:TextFormat, positionOffset:Number = 0):void
		{
			scoreButtonTest = new SimpleBlitButton(location.x, location.y, width, height, text,
											0xffffff, 0xff0000, textFormat, positionOffset);
			
			addChild(scoreButtonTest);
			
			scoreButtonTest.addEventListener(MouseEvent.CLICK, scoreButtonTestClickListener, false, 0, true);
			
		}
		
		////back button listener
		private function d_backButtonClickListener(e:MouseEvent):void
		{
			dispatchEvent(new CustomEventButtonId(CustomEventButtonId.BUTTON_ID,id, 
												  FrameWorkStates.STATE_SYSTEM_TITLE));
		}
		
		//Score Screen Test
		private function scoreButtonTestClickListener(e:MouseEvent):void
		{
			dispatchEvent(new CustomEventButtonId(CustomEventButtonId.BUTTON_ID,id, 
												  FrameWorkStates.STATE_SYSTEM_SCORE_SCREEN));
		}
		
		
		
		/*
		Dummy screen will be an option screen
		* Mute button [music, SFX]
		* Back Button to return to Game
		* Back Button to return to Title Screen
		*/
	
	}
	
}
