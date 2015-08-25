package game.core.item
{
	import game.utils.Assets;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class BaseCard extends Sprite
	{
		public var type:int=-1 ;
		public var tx:int ;
		public var ty:int ;
		public var cardImg:Image ;
		public var lightImg:Image ;
		
		private var _timeoutId:int ;
		
		override public function get width():Number{
			return 80;
		}
		override public function get height():Number{
			return 80;
		}
		
		public function BaseCard( type:int )
		{
			super();
			this.type = type ;
			createCard();
		}
		
		private function createCard():void
		{
			if(type>-1)
			{
				if(type>0){
					cardImg = new Image(Assets.instance.getGemsTexture("Gem"+type) );
				}else{
					cardImg = new Image(Assets.instance.getGemsTexture("Bomb") );
				}
				
				cardImg.x=  -cardImg.width>>1;
				cardImg.y = -cardImg.height>>1 ;
				this.addChild(cardImg);
				
				
				
				lightImg = new Image( Assets.instance.getGemsTexture("Light") ); 
				lightImg.touchable = false ;
				lightImg.pivotX = lightImg.width>>1;
				lightImg.pivotY = lightImg.height>>1;
				lightImg.x = lightImg.y = -15 ;
				this.addChild(lightImg);
				lightImg.visible =false ;
				if(type==1)
				{
					lightImg.y =-5 ;
					lightImg.x=-20 ;
				}
				else if(type==5)
				{
					lightImg.x=-20 ;
					lightImg.y = 15 ;
				}
				else if(type==0)
				{
					lightImg.x = 0;
					lightImg.y= 0 ;
					this.scaleX=this.scaleY = 0;
					var tween:Tween = new Tween(this,0.2);
					tween.scaleTo(1);
					Starling.juggler.add(tween);
				}
				Starling.juggler.delayCall( showLight , 1+Math.random()*2 );
			}
		}

		protected function showLight():void
		{
			if(!lightImg.visible && Math.random()>0.2 ){
				lightImg.visible =true ;
				lightImg.scaleX = lightImg.scaleY = 0;
				var tween:Tween = new Tween(lightImg, 1 );
				tween.scaleTo(1);
				tween.reverse = true ;
				tween.repeatCount=2;
				tween.onComplete = removeLightImg;
				Starling.juggler.add(tween);
			}
		}
		
		protected function removeLightImg():void
		{
			Starling.juggler.removeTweens( lightImg );
			lightImg.visible = false ;
			Starling.juggler.delayCall( showLight , 1+Math.random()*2 );
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(lightImg && lightImg.visible){
				Starling.juggler.removeTweens( lightImg );
			}
		}
	}
}