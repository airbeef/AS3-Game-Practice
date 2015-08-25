package game.core.item
{
	import starling.animation.Tween;
	import starling.core.Starling;
	
	public class Card extends BaseCard
	{		
		private var _iconType:int ; //图标
		
		public function Card(type:int)
		{
			super(type);
		}
		

		public function get iconType():int
		{
			return _iconType;
		}
		
		public function addIcon( type:int ):void 
		{
			this._iconType = type ;
//			var bmp:Bitmap ;
//			if(type==GameData.ICON_TYPE_CLOCK){ 
//				bmp = new Resource.ClockIcon() as Bitmap ;
//			}else if(type==GameData.ICON_TYPE_COIN){ 
//				bmp = new Resource.CoinIcon() as Bitmap ;
//			}else if(type==GameData.ICON_TYPE_REDSTAR){
//				bmp = new Resource.RedStarIcon() as Bitmap ;
//			}else if(type==GameData.ICON_TYPE_STAR){
//				bmp = new Resource.StarIcon() as Bitmap ;
//			}
//			bmp.x = -bmp.width*0.5;
//			bmp.y = -bmp.height*0.5 ;
//			addChild(bmp);
		}

		public function clone():Card
		{
			var card:Card = new Card(this.type);
			card.tx = tx ;
			card.ty = ty ;
			return card ;
		}
		
		 
		public function destroy():void 
		{
			var tween:Tween = new Tween(this,0.15);
			tween.scaleTo(0);
			tween.onComplete = remove;
			Starling.juggler.add(tween);
		}
		
		private function remove():void{
			this.removeFromParent( true );
		}
		
	}
}