package game.core
{
	import flash.filters.GlowFilter;
	import flash.utils.setTimeout;
	
	import game.utils.Assets;
	import game.utils.DataUtil;
	import game.utils.SoundManager;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	
	public class MainScene extends Sprite
	{
		private var _gems:Array ;
		private var _gemsAnim:Sprite ;
		private var _kGemSize:int = 50;
		private var title:Image;
		private var btnPlay:Button;
		private var btnAbout:Button ;
		private var highScore:TextField ;
		private var txt:TextField ;
		
		public function MainScene()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler(e:Event):void
		{
			SoundManager.instance.playLoop();
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			
			_gems = [] ;
			
			_gemsAnim = new Sprite();
			_gemsAnim.touchable=false;
			addChild(_gemsAnim);
			
			title = new Image( Assets.instance.getUITexture("title")); 
			title.touchable = false ;
			title.pivotX = title.width>>1;
			title.pivotY = title.height >>1;
			title.x = stage.stageWidth>>1;
			title.y = 220;
			title.rotation = deg2rad(-15);
			title.scaleX = title.scaleY = 0;
			var titleTween:Tween = new Tween(title,0.5,Transitions.EASE_OUT_BOUNCE);
			titleTween.scaleTo(1);
			Starling.juggler.add( titleTween);
			addChild( title );
			
			
			btnPlay = new Button( Assets.instance.getUITexture("BtnPlay") );
			btnPlay.pivotX = btnPlay.width>>1;
			btnPlay.pivotY = btnPlay.height>>1;
			btnPlay.scaleX = btnPlay.scaleY = 0;
			btnPlay.x = stage.stageWidth>>1;
			btnPlay.y = 540 ;
			var btnPlayTween:Tween = new Tween(btnPlay,0.5,Transitions.EASE_OUT_BOUNCE);
			btnPlayTween.delay = 0.25 ;
			btnPlayTween.scaleTo(1);
			Starling.juggler.add( btnPlayTween);
			addChild(btnPlay);
			
			
			btnAbout = new Button( Assets.instance.getUITexture("BtnAbout") );
			btnAbout.pivotX = btnAbout.width>>1;
			btnAbout.pivotY = btnAbout.height>>1;
			btnAbout.scaleX = btnAbout.scaleY = 0;
			btnAbout.x = stage.stageWidth>>1;
			btnAbout.y = 740 ;
			var btnAboutTween:Tween = new Tween(btnAbout,0.5,Transitions.EASE_OUT_BOUNCE);
			btnAboutTween.delay = 0.5 ;
			btnAboutTween.scaleTo(1);
			Starling.juggler.add( btnAboutTween);
			addChild(btnAbout);
			
			highScore = new TextField( stage.stageWidth,80,DataUtil.instance.highScore+"","NumberFont",64,0xffffff);
			highScore.y = stage.stageHeight-150 ;
			highScore.touchable=false;
			addChild(highScore);
			
			txt = new TextField( stage.stageWidth,64,"High Score","",32,0xffffff,true);
			txt.y = highScore.y+50 ;
			txt.nativeFilters = [ new GlowFilter(0)];
			txt.touchable =false ;
			addChild(txt);
			
			
			this.addEventListener(EnterFrameEvent.ENTER_FRAME , update );
			btnPlay.addEventListener(Event.TRIGGERED , onPlay);
		}
		
		private function onPlay(e:Event):void
		{
			e.stopPropagation() ;
			SoundManager.instance.playClick();
			
			removeEventListener(EnterFrameEvent.ENTER_FRAME , update );
			this.removeChild( highScore , true );
			this.removeChild( txt , true );
			
			for (var i:int = 0; i < this._gemsAnim.numChildren; i++)
			{
				var gem:DisplayObject = this._gemsAnim.getChildAt(i);
				var tween:Tween = new Tween(gem,0.25);
				tween.fadeTo(0);
				Starling.juggler.add(tween);
			}
			
			var titleTween:Tween = new Tween(title,0.25);
			titleTween.scaleTo(0);
			titleTween.moveTo(title.x,title.y+100);
			Starling.juggler.add( titleTween);
			
			var btnPlayTween:Tween = new Tween(btnPlay,0.25);
			btnPlayTween.scaleTo(0);
			btnPlayTween.moveTo(btnPlay.x,btnPlay.y+100);
			Starling.juggler.add( btnPlayTween);
			
			var btnAboutTween:Tween = new Tween(btnAbout,0.25 );
			btnAboutTween.scaleTo(0);
			btnAboutTween.moveTo(btnAbout.x,btnAbout.y+100);
			btnAboutTween.onComplete = showGameScene;
			Starling.juggler.add( btnAboutTween);
			
			
			touchable=false;
		}
		
		private function showGameScene():void
		{
			Starling.juggler.purge() ;
			var gameScene:GameScene = new GameScene();
			App.instance.showScene( gameScene );
		}
		
		private function update(e:Event):void
		{
			var gem:Object ;
			
			if (Math.random() < 0.02)
			{
				var sprt:Image = new Image( Assets.instance.getGemsTexture("Gem"+Math.ceil(Math.random()*6)) );
				sprt.pivotX  = sprt.width>>1;
				sprt.pivotY = sprt.height>>1;
				
				var x:Number = Math.random()*stage.stageWidth;
				var y:Number = - _kGemSize/2;
				var scale:Number = 0.2 + 0.8 * Math.random();
				
				var speed:Number = 4*scale*_kGemSize/40;
				
				sprt.x = x ;
				sprt.y = y ;
				
				sprt.scaleX = sprt.scaleY = scale
				
				gem = {sprt:sprt, speed:speed};

				this._gems.push(gem);
				this._gemsAnim.addChild(sprt);
			}
			
			for (var i:int = this._gems.length-1; i >= 0; i--)
			{
				gem = this._gems[i];
				
				gem.sprt.y += gem.speed;
				
				if (gem.sprt.y > stage.stageHeight + _kGemSize/2)
				{
					this._gemsAnim.removeChild(gem.sprt, true);
					this._gems.splice(i, 1);
				}
			}
		}
	}
}