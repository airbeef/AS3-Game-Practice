package game.utils
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import game.comm.GameData;
	import game.core.item.Card;

	public class CardUtil
	{
		/**
		 * 查询目标周围的类型相同的card  
		 * @param target 目标
		 * @param items 数组
		 * @return 返回target周围的item,包括了target本身
		 */			
		public static function cardSearchRoundSame( target:Card , items:Array ):Vector.<Card>
		{
			var cards:Vector.<Card> = new Vector.<Card>();
			cards.push(target);
			roundFourItem(cards,target , items );
			return cards;
		}
		
		public static function roundFourItem(cards:Vector.<Card> , target:Card , items:Array ):void
		{
			if(cards==null || target==null ){
				return ;
			}
			if(target.ty+1<GameData.ROWS && items[target.ty+1][target.tx].y==items[target.ty+1][target.tx].ty*target.height ){
				if(items[target.ty+1][target.tx].type==target.type && !itemIsInArray(cards,items[target.ty+1][target.tx])){
					cards.push( items[target.ty+1][target.tx] );
					roundFourItem(cards,items[target.ty+1][target.tx],items);
				}
			}
			if( target.ty-1>=0 && items[target.ty-1][target.tx].y==items[target.ty-1][target.tx].ty*target.height ){
				if(items[target.ty-1][target.tx].type==target.type && !itemIsInArray(cards,items[target.ty-1][target.tx])){
					cards.push( items[target.ty-1][target.tx] );
					roundFourItem(cards,items[target.ty-1][target.tx],items);
				}
			}
			if( target.tx+1<GameData.COLS && items[target.ty][target.tx+1].y==items[target.ty][target.tx+1].ty*target.height ){
				if(items[target.ty][target.tx+1].type==target.type && !itemIsInArray(cards,items[target.ty][target.tx+1])){
					cards.push( items[target.ty][target.tx+1] );
					roundFourItem(cards,items[target.ty][target.tx+1],items);
				}
			}
			if( target.tx-1>=0 &&items[target.ty][target.tx-1].y==items[target.ty][target.tx-1].ty*target.height ){
				if( items[target.ty][target.tx-1].type==target.type && !itemIsInArray(cards,items[target.ty][target.tx-1])){
					cards.push( items[target.ty][target.tx-1] );
					roundFourItem(cards,items[target.ty][target.tx-1],items);
				}
			}
		}
		
		/**
		 * 判断item是否已经在数组中 
		 * @param arr
		 * @param temp
		 * @return 如果在数组中返回true
		 */		
		private static function itemIsInArray(cards:Vector.<Card> , target:Card ):Boolean
		{
			if(cards==null || target==null ){
				return false;
			}
			for each( var card:Card in cards){
				if(card==target){
					return true;
				}
			}
			return false;
		}
		
		/**
		 *　判断两个对象是否是邻居
		 */
		public static function isNear(item1:Card , item2:Card ):Boolean
		{
			if (item1 != null && item2 != null)
			{
//				if( item1.y != item1.ty*item1.height || item2.y != item2.ty*item2.height  ){
//					return false;
//				}
				
				if(item1.visible == false || item2.visible == false ){
					return false;
				}
				
				if (Math.abs(item1.tx - item2.tx) == 1 && item1.ty == item2.ty )
				{
					return true;
				}
				else if ( Math.abs(item1.ty-item2.ty)==1 && item1.tx==item2.tx )
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 判断两个item是否类型相等
		 * @param item1
		 * @param item2
		 * @return 相等返回真
		 */
		public static function ItemEquals(item1:Card , item2:Card ):Boolean
		{
			if(item1.visible == false || item2.visible == false ){
				return false;
			}
			if (item1.type == -1 || item2.type == -1)
			{
				return false;
			}
			if (item1 != item2 && item1.type == item2.type)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 获得targetCard一行一列 
		 * @param items
		 * @param tx
		 * @param ty
		 * @param rowOrCol 1为行,2为列,3为行列全部
		 * @return 
		 */		
		public static function getRowColCards( items:Array , tx:int , ty:int , rowOrCol:int ):Vector.<Card>
		{
			var size:int = 80 ;
			var card:Card ;
			var temp:Vector.<Card> = new Vector.<Card>();
			//列
			for(var i:int = 0 ; i<GameData.ROWS ; i++)
			{
				card = items[i][tx] as Card;
				if(card&& card.y == size*card.ty ){
					temp.push( card);
				}
			}
			//行
			if( rowOrCol!=2){
				for( var j:int = 0 ; j<GameData.COLS ; j++)
				{
					card = items[ty][j] as Card;
					if(card && card.type>0  && card.y == size*card.ty ){
						temp.push( card);
					}
				}
			}
			return temp ;
		}

		/**
		 * 获取周围九个card 
		 * @param items
		 * @param cardPoint 网格坐标
		 * @return 
		 */		
		public static function getRoundItem(items:Array , cardPoint:Point ):Vector.<Card>
		{
			var size:int = 80 ;
			var arr:Vector.<Card> = new Vector.<Card>();
			var rect:Rectangle = new Rectangle( (cardPoint.x-1)*size ,  (cardPoint.y-1)*size , size*3,size*3);
			if(rect.x<0) rect.x = 0 ;
			else if(rect.x+rect.width>size*GameData.COLS)
			{
				rect.x = size*GameData.COLS -rect.width ;
			}
			
			if(rect.y<0) rect.y = 0 ;
			else if(rect.y+rect.height>size*GameData.ROWS)
			{
				rect.y = size*GameData.COLS -rect.height ;
			}
			
			var tempItem:Card ;
			var tempRect:Rectangle=new Rectangle(0,0,size,size);
			for (var i:int = 0; i<GameData.ROWS ; i++)
			{
				for (var j:int = 0; j<GameData.COLS ; j++)
				{
					tempItem = items[i][j] as Card ;
					tempRect.x = tempItem.x;
					tempRect.y = tempItem.y;
					if(rect.intersects(tempRect))
					{
						arr.push( tempItem);
					}
				}
			}
			return arr ;
		}
		
		/**
		 * 判断是否还有可消的 
		 * @param items
		 * @return 
		 */		
		public static function checkGemsEnable( items:Array ):Card
		{
			var card:Card ;
			var nextCard:Card ;
			for (var i:int = 0; i<GameData.ROWS-1 ; i++)
			{
				for (var j:int = 0; j<GameData.COLS-1 ; j++)
				{
					card = items[i][j] as Card ;
					if(card && card.type>-1 && card.y==80*card.ty){
						nextCard = items[i+1][j] as Card ;
						if(card.type==nextCard.type){
							return card ;
						}
						nextCard = items[i][j+1] as Card ;
						if(card.type==nextCard.type){
							return card ;
						}
					}
				}
			}
			return null ;
		}
	}
}