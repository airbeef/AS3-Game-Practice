package game.core
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class App extends Sprite
	{
		private static var _instance:App ;
		public static function get instance():App{
			if(!_instance) _instance = new App();
			return _instance ;
		}
		//==========================================
		
		[Embed(source="../assets/Bg.jpg")]
		public static const BG:Class;
		
		[Embed(source="../assets/scorefont.png")]
		public static const SCOREFONT:Class;
		[Embed(source="../assets/scorefont.fnt",mimeType="application/octet-stream")]
		public static const SCOREFONT_FNT:Class;
		
		
		private var _sceneContainer:Sprite ;
		
		
		public function App()
		{
			super();
			if(_instance) throw new Error("只能实例化一个App");
			_instance = this ;
			addEventListener(Event.ADDED_TO_STAGE , addedHandler);
		}
		
		private function addedHandler( e:Event) :void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			
			var bg:Image = new Image(Texture.fromBitmap(new BG(),false));
			bg.touchable=false;
			bg.width = stage.stageWidth ;
			bg.height = stage.stageHeight ;
			addChild(bg);
			
			var numberFont:BitmapFont=new BitmapFont(Texture.fromBitmap(new SCOREFONT(),false),XML(new SCOREFONT_FNT()));
			TextField.registerBitmapFont( numberFont , "NumberFont");
			
			_sceneContainer = new Sprite();
			addChild(_sceneContainer);
			
			showScene(new MainScene());
		}
		
		public function showScene( scene:Sprite):void
		{
			_sceneContainer.removeChildren(0,-1,true);
			_sceneContainer.addChild(scene);
		}
	}
}