package game.core.item
{
	import game.utils.Assets;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	
	public class Hint extends Image
	{
		public function Hint()
		{
			super( Assets.instance.getUITexture("hint"));
			this.pivotX=this.width>>1;
			this.pivotY=this.height>>1;
			addEventListener(Event.ADDED_TO_STAGE,added);
		}
		
		private function added(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,added);
			var tween:Tween = new Tween(this,0.5);
			tween.fadeTo(0);
			tween.repeatCount=int.MAX_VALUE;
			tween.reverse=true;
			Starling.juggler.add(tween);
		}
		
		override public function dispose():void
		{
			super.dispose();
			Starling.juggler.removeTweens(this);
		}
	}
}