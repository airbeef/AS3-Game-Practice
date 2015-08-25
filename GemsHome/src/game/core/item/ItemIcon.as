package game.core.item
{
	import starling.display.Sprite;

	/**
	 * 飞动的icon 
	 * @author zhouzhanglin
	 * 
	 */	
	public class ItemIcon extends Sprite
	{
//		private var _iconBmp:Bitmap ;
		private var _type:int ;
		private var _isClear:Boolean;
		
		public function ItemIcon(type:int )
		{
//			super();
//			this.mouseChildren = this.mouseEnabled = false ;
//			this._type = type ;
//			if(type==GameData.ICON_TYPE_CLOCK)
//			{
//				_iconBmp = new Resource.ClockIcon() as Bitmap ;
//			}else if(type==GameData.ICON_TYPE_COIN){
//				_iconBmp = new Resource.CoinIcon() as Bitmap ;
//			}else if(type==GameData.ICON_TYPE_REDSTAR){
//				_iconBmp = new Resource.RedStarIcon() as Bitmap ;
//			}
//			_iconBmp.x = -_iconBmp.width*0.5;
//			_iconBmp.y = -_iconBmp.height*0.5;
//			addChild( _iconBmp );
		}
		
		public function moveTo(bezierx:Number , beziery:Number , px:Number , py:Number , isClear:Boolean=true):void 
		{
			_isClear = isClear;
//			TweenMax.to(this, 1 , {bezier:[{x:bezierx, y:beziery}, {x:px, y:py}], ease:Circ.easeOut , onComplete:tweenComplete});
		}
		
		private function tweenComplete():void 
		{
//			if(_isClear){ 
//				TweenLite.to( this , 0.25 , {scaleX:0 , scaleY:0 , alpha:0 , onComplete:dispose}  ) ;
//			}else{
//				var mc:Sprite = GameData.gameView.rightBar["redStarPoint"+this.name] ;
//				mc.addChild(this);
//				this.x=this.y=0;
//			}
		}
		
	}
}