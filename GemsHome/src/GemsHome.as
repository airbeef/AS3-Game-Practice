package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import game.core.App;
	
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	public class GemsHome extends Sprite
	{
		private var _starl:Starling ;
		
		public function GemsHome()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.color=0;
			stage.frameRate=60;
			
			Starling.handleLostContext = isAndroid ; 
			Starling.multitouchEnabled = false ;
			
			
			//游戏设计的宽高
			var stageW:Number = 640 ;
			var stageH:Number = 960 ;
			
			var factor:Number = stageW/stageH ;
			if(stage.fullScreenWidth/stage.fullScreenHeight>factor)
			{
				//宽了，如iphone5，所以需要重新设置宽，高则不变
				stageW = stageH*stage.fullScreenWidth/stage.fullScreenHeight ;
			}
			else
			{
				//高了
				stageH = stageW*stage.fullScreenHeight/stage.fullScreenWidth;
			}
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageW, stageH), 
				new Rectangle(0, 0,stage.fullScreenWidth , stage.fullScreenHeight ), 
				ScaleMode.SHOW_ALL,false);
			
			_starl=  new Starling(App,stage,viewPort);
			_starl.stage.stageWidth = stageW;
			_starl.stage.stageHeight = stageH ;
			_starl.showStats = true ;
			_starl.showStatsAt("left","bottom");
			_starl.addEventListener("context3DCreate" , onContextCreated);
		}
		
		private function onContextCreated():void
		{
			_starl.removeEventListener("context3DCreate" , onContextCreated);
			_starl.start();
			
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE , activeHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE , deactiveHandler);
		}
		
		private function activeHandler(e:Event):void
		{
			_starl.start() ;
		}
		
		private function deactiveHandler(e:Event):void
		{
			_starl.stop() ;
			if(isAndroid)
				NativeApplication.nativeApplication.exit();
		}
		
		//---------------------------------------------------------------
		private function  get isAndroid():Boolean{
			return Capabilities.manufacturer.indexOf('Android') > -1;
		}
		private function  get isIOS():Boolean{
			return Capabilities.manufacturer.indexOf('iOS') > -1;
		}
	}
}