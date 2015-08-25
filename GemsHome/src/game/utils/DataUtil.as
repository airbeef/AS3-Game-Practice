package game.utils
{
	import flash.net.SharedObject;

	public class DataUtil
	{
		private static var _instance:DataUtil ;
		public static function get instance():DataUtil{
			if(!_instance) _instance = new DataUtil();
			return _instance ;
		}
		//================================
		
		private var _cookie:Cookie ;
		
		public function DataUtil()
		{
			_cookie = new Cookie();
			if(_cookie.contains("highScore")){
				_highScore = int(_cookie.get("highScore"));
			}
		}
		
		private var _highScore:int 
		public function get highScore():int
		{
			return _highScore;
		}

		public function set highScore(value:int):void
		{
			if(value>_highScore){
				_highScore = value;
				//保存
				_cookie.put( "highScore",_highScore);
			}
		}

	}
}