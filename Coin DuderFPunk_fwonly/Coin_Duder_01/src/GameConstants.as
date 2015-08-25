package  
{
	/**
	 * Game Constants
	 * @author JCB
	 */
	public class GameConstants 
	{
		//Embedded Fireball constants and effects
		[Embed(source="../assets/images/fireball.png")]
		public static const ART_FIREBALL:Class;
		
		[Embed(source="../assets/images/fireball_animation.png")]
		public static const FIREBALL_PARTICLE:Class;
		
		//Heads Up Display
		[Embed(source = "../assets/images/hud_heartFull.png")]
		public static const HUD_HEARTFULL:Class;
		
		[Embed(source = "../assets/images/hud_heartEmpty.png")]
		public static const HUD_HEARTEMPTY:Class;
		
		//Coin Counter
		[Embed(source = "../assets/images/coinBronze.png")]
		public static const BRONZE_COIN:Class;
		
		//changing font
		[Embed(source = "../assets/images/Sniglet.ttf", embedAsCFF = "false", fontFamily = 'sniglet')]
		public static const FONT_SNIGLET:Class;
		
		
		
		
	}

}