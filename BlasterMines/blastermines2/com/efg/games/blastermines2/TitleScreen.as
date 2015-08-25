package com.efg.games.blastermines2
{
	import com.efg.framework.BasicScreen;
	import com.efg.framework.SimpleBlitButton;
	import com.efg.framework.CustomEventButtonId;
	import com.efg.framework.FrameWorkStates;
	
	import flash.text.TextFormat;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	
	public class TitleScreen extends BasicScreen
	{
		//This is the override for the Screen's state
		private var m_OverrideNextState:int
		
		private var dummyButton:SimpleBlitButton;
		private var scoreButtonTest:SimpleBlitButton;
		protected var titleRButton:SimpleBlitButton;
		
		public function TitleScreen(id:int, width:Number, height:Number, isTransparent:Boolean, color:uint)
		{
			super(id, width, height, isTransparent,color);
			this.m_OverrideNextState;
		}
		
		//Blank Dummy Page
		public function createDummyButton(text:String, location:Point, width:Number, height:Number, 
											textFormat:TextFormat, positionOffset:Number = 0):void
		{
			dummyButton = new SimpleBlitButton(location.x, location.y, width, height, text,
											0xffffff, 0xff0000, textFormat, positionOffset);
			dummyButton.addEventListener(MouseEvent.CLICK,dummyButtonClickListener, false, 0, true);
			
			addChild(dummyButton); 
		}
		
				
		
		private function dummyButtonClickListener(e:MouseEvent):void
		{
			dispatchEvent(new CustomEventButtonId(CustomEventButtonId.BUTTON_ID,id,FrameWorkStates.STATE_SYSTEM_DUMMY));		
		}
		
		
		//Return to Title.as
		public function createTitleReturnButton(text:String, location:Point, width:Number, height:Number, 
													textFormat:TextFormat, positionOffset:Number = 0):void
		{
			titleRButton = new SimpleBlitButton(location.x, location.y, width, height, text,
											0xffffff, 0xff0000, textFormat, positionOffset);
			
			titleRButton.addEventListener(MouseEvent.CLICK,titleRButtonClickListener, false, 0, true);	
			
			addChild(dummyButton); 
		}
		
		//Return Title Click Listener
		private function titleRButtonClickListener(e:MouseEvent):void
		{
			dispatchEvent(new CustomEventButtonId(CustomEventButtonId.BUTTON_ID,id,FrameWorkStates.STATE_SYSTEM_TITLE));		
		}
		
		
		/*
		TitleScreen.as
		* Play Button that will go to game
		* Options Button that will go to Audio options
		* Scroll Button: Twitter/Website/Email [external links]
		* Score Button: Goes to top score
		*/
	}
	
}
