package com.efg.games.blastermines
{
	import com.efg.framework.BasicBlitArrayObject;
	
	public class PowerUp extends BasicBlitArrayObject
	{

		public function PowerUp(xMin:int, xMax:int, yMin:int, yMax:int) 
		{
			super (xMin, xMax, yMin, yMax);
		}
		
		public function update(step:Number = 1):void
		{
			
			//Updates every time the player moves. Power Up base
			
			nextX += dx * speed * step;
			nextY += dy * speed * step;
			
			if (nextX > xMax)
			{
				nextX = xMax;
				dx *= -1;
			}
			
			else if (nextX < xMin)
			{
				nextX = xMin;
				dx *= -1;
			}
			
			if (nextY > yMax)
			{
				nextY = yMax;
				dy *= -1;
			}
			
			else if (nextY < yMin)
			{
				nextY = yMin;
				dy *= -1;
			}
		}

	}
	
}
