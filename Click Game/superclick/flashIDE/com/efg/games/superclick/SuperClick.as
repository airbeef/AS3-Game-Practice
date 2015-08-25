
package com.efg.games.superclick 
{
	//import flash libraries
	import flash.display.Sprite;
	import flash.events.*
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	//import my libraries
	import com.efg.framework.Game;
	import com.efg.framework.CustomEventLevelScreenUpdate;
	import com.efg.framework.CustomEventScoreBoardUpdate;
		
	
	public class SuperClick extends com.efg.framework.Game
	{
		//private game logic and flow
		private var score:int;
		private var level:int;
		private var percent:Number;
		private var clicked:int;
		private var gameOver:Boolean;
		private var circles:Array;
		private var tempCircle:Circle;
		private var numCreated:int;
		
		//messaging
		private var scoreTexts:Array;
		private var tempScoreText:ScoreTextField;
		private var textFormat:TextFormat = new TextFormat("_sans", 12, "0xffffff", "true");
						
		//game level and difficulty
		private var maxScore:int = 50;
		private var numCircles:int;
		private var circleGrowSpeed:Number;
		private var circleMaxSize:Number;
		private var percentNeeded:Number;
		private var maxCirclesOnscreen:int;
		private var percentBadCircles:Number;
		

		public function SuperClick() 
		{
			// constructor code will be overrridden
		}
		
		override public function newGame():void
		{
			trace("new game");
			level = 0;
			score = 0;
			gameOver = false;
			
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_SCORE, "0"));
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_CLICKED, "0/0"));
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_PERCENT_NEEDED, "0%"));
			dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_PERCENT_ACHIEVED, "0%"));
		}
		
		//new level function will start a new level if player still plays
		override public function newLevel():void
		{
	
			trace("new level");
			percent = 0;
			clicked = 0;
			circles = [];
			scoreTexts = [];
			level++;
			
			numCircles = level * 25;
			circleGrowSpeed = .01 * level;
			circleMaxSize = (level < 5) ? 5-level : 1;
			percentNeeded = 10 + (5 * level);
			
			if (percentNeeded > 90)	percentNeeded = 90;
	
			maxCirclesOnscreen = 10 * level;
			numCreated = 0;
			percentBadCircles = (level < 25) ? level + 9 : 40;
			
			
			dispatchEvent(new CustomEventScoreBoardUpdate (CustomEventScoreBoardUpdate.UPDATE_TEXT,
														   Main.SCORE_BOARD_PERCENT_NEEDED, String(percentNeeded)));
			
			dispatchEvent(new CustomEventScoreBoardUpdate (CustomEventScoreBoardUpdate.UPDATE_TEXT, 
														   Main.SCORE_BOARD_CLICKED, String(clicked + "/" +numCircles)));
			
			dispatchEvent(new CustomEventLevelScreenUpdate (CustomEventLevelScreenUpdate.UPDATE_TEXT, String(level)));
			
		}
		
		//this is a listener for the game to update frameworks
		override public function runGame():void
		{
			trace("run game");
			
			update();
			
			checkCollisions();
			
			render();
			
			checkforEndLevel();
			
			checkforEndGame();
		}

		
		//this updates what the circles [good & bad] will do. Adding/Subtracting
		private function update():void
		{
			if (circles.length < maxCirclesOnscreen && numCreated < numCircles)
				{
					var newCircle:Circle;
					
					if (int(Math.random() * 100) <= percentBadCircles)
						{
							newCircle =  new Circle(Circle.CIRCLE_BAD)
						}
					else
						{
							newCircle = new Circle(Circle.CIRCLE_GOOD)
							numCreated ++;
						}
					
					addChild(newCircle);
					circles.push(newCircle);
				}
				
		//Checks circles every frame for size; adds to their nextScale property
		//if nextScale is larger than the max, remove circle
			var circleLength:int = circles.length-1;
			
			for (var counter:int = circleLength; counter >= 0; counter--)
				{
					tempCircle = circles[counter];
					tempCircle.update(circleGrowSpeed);
					
					if (tempCircle.nextScale > circleMaxSize || tempCircle.alpha < 0)
					{
						removeCircle(counter);
					}
				}
				
		//This updates the score counter	
			var scoreTextLength:int = scoreTexts.length-1;
			
			for (counter = scoreTextLength; counter >= 0; counter--)
				{
					tempScoreText = scoreTexts[counter];
					
					if (tempScoreText.update())
					{
						//returns true if life is over
						removeScoreText(counter);
					}
				
				}
		}
		
				
		//This checks the collision of circles so they will not overlap each other
		private function checkCollisions():void
		{
			var circleLength:int = circles.length-1;
			
			for (var counter:int = circleLength; counter >=0; counter--)
			{
				tempCircle = circles[counter];
				
					if (tempCircle.clicked && !tempCircle.fadingOut)
					{
						tempCircle.fadingOut = true;
					
						if (tempCircle.type == Circle.CIRCLE_GOOD && tempCircle.alpha == 1)
						{
							var scoreAdjust:Number = 1 / tempCircle.scaleX;
							var scoreAdd:int =  maxScore * scoreAdjust;
							
							addToScore(scoreAdd);
							
							tempScoreText = new ScoreTextField
								(String(scoreAdd), textFormat, tempCircle.x, tempCircle.y, 20);
								
							scoreTexts.push(tempScoreText);
							
							addChild(tempScoreText);
					}
					
					else if (tempCircle.type == Circle.CIRCLE_BAD)
					{
						gameOver = true;
					}
				}
			}
		}
			
		//called by thecheck collision function to update score when circles are clicked
			private function addToScore(scoreAdd:Number):void
			{
				score += scoreAdd;
				
				dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,
															  Main.SCORE_BOARD_SCORE, String(score)));
				
				clicked++;
				
				percent = 100 * (clicked / numCircles);
				
				dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, 
															  Main.SCORE_BOARD_PERCENT_ACHIEVED, String(percent)));
				
				dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, 
															  Main.SCORE_BOARD_CLICKED, String(clicked + "/" +numCircles)));
			}
			
		//Loops through Circles and sets x and y to it's Scalevalue.
			private function render():void
			{
				var circleLength:int = circles.length-1;
				
				for (var counter:int = circleLength; counter >=0; counter--)
				{
					tempCircle = circles[counter];
					tempCircle.scaleX = tempCircle.nextScale;
					tempCircle.scaleY = tempCircle.nextScale;
				}
				
			}
			
		private function checkforEndLevel():void
			{
				if (circles.length == 0 && numCreated ==numCircles && scoreTexts.length == 0)
				{
					if (percent >= percentNeeded)
						{
							dispatchEvent(new Event(NEW_LEVEL));
						}
					else
						{
							gameOver = true;
						}
				}
			}
			
			
			private function checkforEndGame():void
			{
				if (gameOver)
				{
					dispatchEvent(new Event(GAME_OVER));
					cleanUp();
				}
			}
			
			
			private function cleanUp():void
			{
				
				var circleLength:int = circles.length-1;
				
				for (var counter:int = circleLength; counter >=0; counter--)
				{
					removeCircle(counter);
				}
				
				var scoreTextLength:int = scoreTexts.length-1;
				
				for (counter = scoreTextLength; counter >= 0; counter --)
				{
					removeScoreText(counter);
				}
			}
			
		//removes Circles from play
		private function removeCircle(counter:int):void
		{
			tempCircle = circles[counter];
			tempCircle.dispose();
			removeChild(tempCircle);
			circles.splice(counter, 1);
			
		}
			
			//this removes score from score array
		private function removeScoreText(counter:int):void
		{
			tempScoreText = scoreTexts[counter];
			tempScoreText.dispose();
			removeChild(tempScoreText);
			scoreTexts.splice(counter, 1);
		}
				
		
	}
	
}
	
