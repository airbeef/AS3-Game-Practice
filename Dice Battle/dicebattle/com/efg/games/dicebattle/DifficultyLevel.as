package com.efg.games.dicebattle 
{
	
	public class DifficultyLevel 
	{
		public var allowedColors:Array;
		public var enemyLife:Number;
		public var aiBonus:Number;
		public var minValue:Number;
		public var enemyTile:Number;
	
		public function DifficultyLevel
		(allowedColors:Array, enemyLife:Number, eneyTile:Number, aiBonus:Number, minValue:Number) 
		{
			this.allowedColors = allowedColors;
			this.enemyLife = enemyLife;
			this.aiBonus = aiBonus;
			this.enemyTile = enemyTile;
			this.minValue = minValue;
		}

	}
	
}
