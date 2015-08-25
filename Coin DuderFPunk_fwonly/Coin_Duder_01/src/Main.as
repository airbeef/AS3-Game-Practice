package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import worlds.GameWorld
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * ...
	 * @author JCB
	 */
	public class Main extends Engine
	{
		
		public function Main():void 
		{
			super(640, 480);
		}
		
		override public function init():void
		{
			trace("Main initialized.");
			super.init();
			FP.world = new GameWorld();
			
			//FP.console.enable();
		}
		
	}
	
}