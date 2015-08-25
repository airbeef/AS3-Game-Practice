package worlds 
{
	import entities.Coin;
	import entities.CoinDuder;
	import entities.Fireball;
	
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.Entity;
	
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Ease;
	
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;
	
	/**
	 * Main Game world for Coin Duder
	 * @author JCB
	 */
	public class GameWorld extends World 
	{
		protected static const MIN_SPAWN_RATE:Number = 0.5;
		protected static const MAX_SPAWN_RATE:Number = 2;
		
		protected var coinDuder:CoinDuder;
		protected var timeLeft:Number;
		protected var flameEmitter:Emitter;
		
		protected var hudCoinIcon:Image;
		protected var hudCoinCount:Text;
		
		protected var healthIcons:Vector.<Entity>;
		
		
		public function GameWorld() 
		{
			//start timer
			timeLeft = 1;
			
			//Change Game font
			Text.font = "sniglet";
			
			//return back to flashpunk world class
			super();
		}
		
		override public function begin():void
		{
			//Game Variables
			GameVariables.PlayerHealth = 3;
			GameVariables.CoinCount = 0;
			
			//new player
			coinDuder = new CoinDuder();
			
			//Flame particle effect; this came from Fireball.as
			flameEmitter = new Emitter(GameConstants.FIREBALL_PARTICLE, 70, 70);
			flameEmitter.newType("trail", [0, 1, 2, 3]); //goes through frames of FIREBALL_PARTICLE
			
			//add easing to make the flame more believable: vid 14
			flameEmitter.setMotion("trail", 0, 25, 0.5, 360, 25, .5, Ease.cubeInOut); //("trail", 0, 100, 1, 25, 50, .5); 
			flameEmitter.setAlpha("trail", 0.5, 0);
			
			//fireballTrail.emit("trail", x, y);
			//flameEmitter.scrollX = 0;
			//flameEmitter.scrollY = 0;
			
			//add fireball
			addGraphic(flameEmitter);
			
			//Add player
			add(coinDuder);
		
			//add coin changed with updateSpawner(), video 11?
			//add(new Coin);
			
			//Begin HUD setup: vid 15
			hudCoinCount = new Text("x 0", 48, 10);
			hudCoinCount.size = 32;
			
			hudCoinIcon = new Image(GameConstants.BRONZE_COIN);
			hudCoinIcon.x = -10;
			hudCoinIcon.y = -10;
			
			//Player Health Setup vid 18
			healthIcons = new Vector.<Entity>();
			
			healthIcons.push(addGraphic(new Image(GameConstants.HUD_HEARTFULL)));
			healthIcons.push(addGraphic(new Image(GameConstants.HUD_HEARTFULL)));
			healthIcons.push(addGraphic(new Image(GameConstants.HUD_HEARTFULL)));
			
			//Was not consolidated as health should be: vid 18
			//healthIcons.push(new Image(GameConstants.HUD_HEARTFULL));
			//healthIcons.push(new Image(GameConstants.HUD_HEARTFULL));
			//healthIcons.push(new Image(GameConstants.HUD_HEARTFULL));
			
			updateHealth();
			
			//adding HUD graphics
			addGraphic(new Graphiclist(hudCoinCount, hudCoinIcon));
			
			super.begin();	
		}
		
		override public function update():void
		{
			//create coins
			updateSpawn();	
		
			//handler player input
			var xInput:int = 0;
			var yInput:int = 0;
			
			//movement
			if (Input.check(Key.LEFT)) xInput--;			//trace("Left.")
			if (Input.check(Key.RIGHT)) xInput++;			//trace("Right.")
			if (Input.check(Key.UP)) yInput--;				//trace("Up.")
			if (Input.check(Key.DOWN)) yInput++;			//trace("Down.")
			
			coinDuder.x += CoinDuder.MAX_SPEED * FP.elapsed * xInput;
			coinDuder.y += CoinDuder.MAX_SPEED * FP.elapsed * yInput;
			
			//returns player collision with coin
			var collisionCoin:Coin = Coin(coinDuder.collideTypes("coin", coinDuder.x, coinDuder.y));
			
			if (collisionCoin != null)
			{
				//Increment Coin Count HUD number
				collectCoin();
				
				//recycle coin if it goes off the screen
				recycle(collisionCoin);
			}
			
			//Collision between player and fireball
			var collisionFireball:Fireball = Fireball(coinDuder.collideTypes("fireball", coinDuder.x, coinDuder.y));
			
			if (collisionFireball != null)
			{
				if (GameVariables.PlayerHealth > 1)
				{
					GameVariables.PlayerHealth--;
				}
				else
				{
					trace("No subtraction");				
				}
				
				updateHealth();	
				//recycle coin if it goes off the screen				
				recycle(collisionFireball);	
			} 
			super.update();
		}
		
		//Coin collected
		protected function collectCoin():void
		{
			GameVariables.CoinCount++;
			
			hudCoinCount.text = GameVariables.CoinCount.toString();
		}
		
		
		protected function updateHealth():void
		{
			for (var i:uint = 0; i < 3; i++)
			{
				if (GameVariables.PlayerHealth > i)
				{
					healthIcons[i].graphic = new Image(GameConstants.HUD_HEARTFULL);
				}
				else
				{
					healthIcons[i].graphic = new Image(GameConstants.HUD_HEARTEMPTY);
				}
				healthIcons[i].x = FP.width - 54 * (i + 1) //healthIcons[i].width
			}
			
			//addGraphic(new Graphiclist(healthIcons[0], healthIcons[1], healthIcons[2]));
			
		}
		
		protected function updateSpawn():void
		{
			timeLeft -= FP.elapsed;
			
			//if the time is over
			if (timeLeft <= 0)
			{
				trace("test");
				
				//Decide to create fireball or coin
				if (FP.random < 0.25)
				{
					create(Fireball, true);
				}
				
				else
				{
				
					create(Coin, true);
				}
				
				//Reset timer
				timeLeft += FP.random * (MAX_SPAWN_RATE - MIN_SPAWN_RATE) + MIN_SPAWN_RATE;
			}
			
			
		}
		
		public function emitFireball(xLocation:int, yLocation:int):void
		{
			flameEmitter.emit("trail", xLocation, yLocation);
		}
		
		
		
		
	}

}