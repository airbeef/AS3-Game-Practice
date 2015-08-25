package  game.utils
{
	import game.core.item.Card;

	public class CardFactory
	{
		public static function randomCreateCard():Card
		{
			var index:int = Math.random()*100 ;
//			if(index<=20){
//				index=1;
//			}else if(index<=40){
//				index=2;
//			}else if(index<=60){
//				index=3;
//			}else if(index<=80){
//				index=4;
//			}else if(index<=100){
//				index=5;
//			}else if(index<=120){
//				index=6;
//			}
			
			if(index<=20){
				index=1;
			}else if(index<=40){
				index=2;
			}else if(index<=60){
				index=6;
			}else if(index<=80){
				index=4;
			}else if(index<=100){
				index=5;
			}
			
			
			return new Card(index);
		}
	}
}