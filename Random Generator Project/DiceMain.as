package  
{	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class DiceMain extends MovieClip
	{
		public function DiceMain()
		{
			var minNum = 1;
			var maxNum = 5;
			
			dieCheck(RandRoll(1, 5), 
			RandRoll(1, 5), 
			RandRoll(1, 5), 
			RandRoll(1, 5), 
			RandRoll(1, 5));
		}
		
		//Dice and Dice Faces
		public function dieCheck(die1:uint, die2:uint, die3:uint, die4:uint, die5:uint)
		{
			//Empty variables for dice faces
			var box1:uint = 0;
			var box2:uint = 0;
			var box3:uint = 0;
			var box4:uint = 0;
			var box5:uint = 0;
			var box6:uint = 0;
			
			var dieArray:Array = new Array(die1, die2, die3, die4, die5);
						
			for (var i:int = 0; i < dieArray.length; i++)
			{
				
				trace("dieArray["+i+"] is: " + dieArray[i]);
				
				if (dieArray[i] == 1)
				{
					box1++;
				}
				
				else if (dieArray[i] == 2)
				{
					box2++;
				}
				
				else if (dieArray[i] == 3)
				{
					box3++;
				}
				
				else if (dieArray[i] == 4)
				{
					box4++;
				}
				
				else if (dieArray[i] == 5)
				{
					box5++;
				}
				
				else if (dieArray[i] == 6)
				{
					box6++;
				}
				
				trace("Dice array length is: " + dieArray.length);
			}
			
			trace("Box Number 1: " + box1);
			trace("Box Number 2: " + box2);
			trace("Box Number 3: " + box3);
			trace("Box Number 4: " + box4);
			trace("Box Number 5: " + box5);
			
		
		//Compare array results
		var dieResults:Array = new Array(box1, box2, box3, box4, box5);
		
		for (var i:int = 0; i < dieResults.length; i++)
		{
			if (dieResults == 3)
			{
				trace("You have three of a kind");
			}
			
			else if (dieResults == 4)
			{
				trace("You have four of a kind.");
			}
			
			else if (dieResults == 5)
			{
				trace("Congrats; you have five of a kind. You get 50 points.");
			}
			
			else
			{
				trace("No Matches.")
			}
		}
		
		//Scoring
		var dieScore:
		
	
		
		
		
	//Random Generator for testing	
	public function RandRoll(minNum:uint, maxNum:uint) :Number
	{
		var randNum:Number = Math.random();
		trace("randNum is: " + randNum);
		randNum = randNum*10;
		
		
		if(randNum > maxNum)
		{
			randNum = maxNum;
		}
		
		if(randNum < minNum)
		{
			randNum = minNum;
		}
		trace("randNum is: " + randNum);
		return randNum;
	}
	
	}
}
	

	



