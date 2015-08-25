package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Particle;
	import net.flashpunk.Mask;
	import net.flashpunk.FP;
	import worlds.GameWorld;
	
	
	
	/**
	 * ...
	 * @author JCB
	 */
	public class Fireball extends Entity 
	{
		public static const MAX_SPEED:Number = 220;
		public static const SPIN_SPEED:Number = 720;
		
		protected var image:Image;
		protected var currentSpeed:Number;
		protected var currentSpinSpeed:Number;
		protected var fireballTrail:Emitter;
		
		public function Fireball(x:Number = 0, y:Number = 0, graphic:Graphic = null, mask:Mask = null) 
		{
			//Fireball asset, speed and identifier
			image = new Image(GameConstants.ART_FIREBALL);
			image.centerOrigin();
			image.smooth = true;
			currentSpeed = 0;			
			
			type = "fireball";
		
			super(x, y, graphic, mask);			
		}
		
		override public function added():void
		{
			//fireball Hitbox; particle effect is behind the graphic
			//addGraphic(fireballTrail);
			addGraphic(image);  //graphic = image;
			
			setHitbox(40, 40, -20, -20);
			setOrigin(20, 20);
			
			//Random coin placement
			if (FP.rand(2) > 0)
			{
				//place on the right side of the screen
				x = FP.width + halfWidth;				
				currentSpeed = -MAX_SPEED;
				currentSpinSpeed = SPIN_SPEED;
				image.flipped = true;
			}
			
			else
			{
				//place on left side of screen
				x = -halfWidth;
				currentSpeed = MAX_SPEED;
				currentSpinSpeed = -SPIN_SPEED;
				image.flipped = false;
			}
			
			//spawn across the y access; doesn't allow spawning in middle of screen
			y = FP.rand(FP.height - height) + halfHeight;
			
			super.added();
		}
		
		override public function update():void
		{
			//one fireball moves across the screen and adds spin
			x += FP.elapsed * currentSpeed;
			image.angle += FP.elapsed * currentSpinSpeed;
			
			//added at video ep. 12 and 13
			GameWorld(world).emitFireball(x - width,y - height) //fireballTrail.emit("trail", x, y);
			
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