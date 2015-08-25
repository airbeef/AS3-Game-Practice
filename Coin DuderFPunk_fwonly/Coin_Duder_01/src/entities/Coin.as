package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	
	/**
	 * 
	 * @author JCB
	 */
	public class Coin extends Entity 
	{
		[Embed(source = "../../assets/images/coinGold.png")]
		
		protected static const ART_COIN:Class;
		
		protected var image:Image;
		protected var currentSpeed:Number;
		
		public static const MAX_SPEED:Number = 180;
		
		public function Coin(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			image = new Image(ART_COIN);
			image.centerOrigin();
			image.smooth = true;
			currentSpeed = 0;
			
			type = "coin";
			
			//super(x, y, graphic, mask);
			
		}
		
		override public function added():void
		{
			//Coin Hitbox
			graphic = image;
			setHitbox(40, 40, -20, -20);
			setOrigin(20, 20);
			
			//Random coin placement
			if (FP.rand(2) > 0)
			{
				//place on the right side of the screen
				x = FP.width + halfWidth;				
				currentSpeed = -MAX_SPEED;
			}
			
			else
			{
				//place on left side of screen
				x = -halfWidth;
				currentSpeed = MAX_SPEED;
			}
			
			//spawn across the y access; doesn't allow spawning in middle of screen
			y = FP.rand(FP.height - height) + halfHeight;
			
			super.added();
		}
		
		override public function update():void
		{
			//one coin moves across the screen
			x += FP.elapsed * currentSpeed;
			
			//if the coin is off the screen
			if ( x < -width || x > FP.width + width)
			{
				//recycle coin to save memory
				world.recycle(this);
			}
			
			super.update();
		}
		
	}

}