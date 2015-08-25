package game.utils
{
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		private static var _instance:Assets ;
		public static function get instance():Assets{
			if(!_instance) _instance = new Assets();
			return _instance ;
		}
		//==========================================
		
		[Embed(source="/../assets/Gems_HD.png")]
		public static const Gems_HD:Class
		[Embed(source="/../assets/Gems_HD.xml",mimeType="application/octet-stream")]
		public static const Gems_HD_XML:Class
		
		[Embed(source="/../assets/UI_SD.png")]
		public static const UI_SD:Class;
		[Embed(source="/../assets/UI_SD.xml",mimeType="application/octet-stream")]
		public static const UI_SD_XML:Class;
		
		private var _textures:Dictionary = new Dictionary();
		private var _gemsAtlas:TextureAtlas ;
		private var _uiAtlas:TextureAtlas ;
		
		public function Assets()
		{
			_gemsAtlas = new TextureAtlas( Texture.fromBitmap( new Gems_HD(),false,false,2)  , XML( new Gems_HD_XML()) );
			
			_uiAtlas = new TextureAtlas( Texture.fromBitmap( new UI_SD(),false)  , XML( new UI_SD_XML()) );
		}
		
		
		public function getGemsTexture( name:String ):Texture
		{
			if(!_textures.hasOwnProperty(name)){
				var texture:Texture = _gemsAtlas.getTexture(name);
				_textures[name] = texture ;
			}
			return _textures[name] as Texture ;
		}
		
		
		public function getUITexture( name:String ):Texture
		{
			if(!_textures.hasOwnProperty(name)){
				var texture:Texture = _uiAtlas.getTexture(name);
				_textures[name] = texture ;
			}
			return _textures[name] as Texture ;
		}
	}
}