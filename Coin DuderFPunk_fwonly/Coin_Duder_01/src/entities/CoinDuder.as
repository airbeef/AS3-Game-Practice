package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.FP;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	
	/**
	 * The dudiest of the coin dudes
	 * @author JCB
	 */
	public class CoinDuder extends Entity 
	{
		[Embed(source = "../../assets/images/p1_front.png")]
		
		protected static const ART_COINDUDER:Class;
		public static const MAX_SPEED:Number = 200;
		protected var playerImage:Image;
		
		public function CoinDuder(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			playerImage = new Image(ART_COINDUDER);
			//asset identifier
			type = "coinDuder";
		}
		
		override public function added():void
		{
			super.added();
			
			//image and bitmapdata container 
			graphic = playerImage;
			setHitbox(66, 92, 0, 0);
			
			//Player Location
			x = FP.halfWidth - halfWidth;
			y = FP.halfHeight - halfHeight;
			
		}	
		
	}

}