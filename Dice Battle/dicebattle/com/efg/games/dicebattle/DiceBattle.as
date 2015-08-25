package com.efg.games.dicebattle
{
	import flash.display.Sprite;
	import flash.events.*;
	
	import com.efg.framework.Game;
	import com.efg.framework.CustomEventLevelScreenUpdate;
	import com.efg.framework.CustomEventScoreBoardUpdate;
	import com.efg.framework.CustomEventSound;
	import com.efg.framework.TileSheet;
	import flashx.textLayout.utils.CharacterUtil;
	
	public class DiceBattle extends com.efg.framework.Game
	{
		private var gameWidth:int;
		private var gameHeight:int;
		
		//Game const grid block starting position
		private static const Y_PAD:int = 75;
		private static const X_PAD:int = 150;
		
		//Pixel spacing
		private static const ROW_SPACING:int = 4;
		private static const COL_SPACING:int = 4;
		
		//Define dimensions
		private static const DIE_HEIGHT:int = 50;
		private static const DIE_WIDTH:int = 50;
		
		//how many rows/columns will appear on screen
		private static const DIE_ROWS:int = 5;
		private static const DIE_COLS:int = 6;
		
		private static const CHAR_WIDTH:int = 64;
		private static const CHAR_HEIGHT:int = 64;
		
		private static const TURN_PLAYER:String = "Player's";
		private static const TURN_COMPUTER:String = "Computer's";
		
		//In game values
		private var score:int;
		private var level:int;
		private var plays:int;
		private var computerLife:int;
		private var playerLife:int;
		private var turn:String;
		
		//difficulty level
		private var difficultyLevelArray:Array;
		private var currentLevel:DifficultyLevel;
		private var playerLifeStart:int = 100;
		private const DICE_BONUS:int = 2;
		
		//Block values
		private var clickedDiceArray:Array;
		private var board:Array;
		private var tempDie:Die;
		
		//Gamestate machine
		private var gameState:int = 0;
		private var nextGameState:int = 0;
		private var framesToWait:int = 0;
		private var framesWaited:int = 0;
		
		//Tilesheet
		private var tileSheet:TileSheet;
		private var charSheet:TileSheet;
			
		private var enemyTile:Character; 
		private var playerTile:Character;

		public function DiceBattle(gW:int, gH:int) 
		{
			this.gameWidth =  gW;
			this.gameHeight = gH;
			
			init();
			
			gameState = GameStates.STATE_INITIALIZING;
		}
		
		public function init():void
		{
			tileSheet = new TileSheet(new DiceSheet(0,0), DIE_WIDTH, DIE_HEIGHT);
			charSheet = new TileSheet(new Characters(0,0), CHAR_WIDTH, CHAR_HEIGHT);
			
			difficultyLevelArray = new Array();
			
			difficultyLevelArray.push(new DifficultyLevel([Die.DIE_COLOR_WHITE],100,1,0,0));
			difficultyLevelArray.push(new DifficultyLevel([Die.DIE_COLOR_WHITE],125,2,10,6));
			difficultyLevelArray.push(new DifficultyLevel([Die.DIE_COLOR_WHITE],150,3,20,7));
			
			difficultyLevelArray.push(new DifficultyLevel([Die.DIE_COLOR_WHITE,Die.DIE_COLOR_BLUE],175,4,30,7));
			difficultyLevelArray.push(new DifficultyLevel([Die.DIE_COLOR_WHITE,Die.DIE_COLOR_BLUE],200,5,40,7));
			difficultyLevelArray.push(new DifficultyLevel([Die.DIE_COLOR_WHITE,Die.DIE_COLOR_BLUE],225,6,50,7));
			difficultyLevelArray.push(new DifficultyLevel([Die.DIE_COLOR_WHITE,Die.DIE_COLOR_BLUE],250,7,60,7));
			
			difficultyLevelArray.push(new DifficultyLevel([Die.DIE_COLOR_WHITE,Die.DIE_COLOR_BLUE, Die.DIE_COLOR_GREEN],275,8,70,7));
			difficultyLevelArray.push(new DifficultyLevel([Die.DIE_COLOR_WHITE,Die.DIE_COLOR_BLUE, Die.DIE_COLOR_GREEN],300,9,80,7));
			difficultyLevelArray.push(new DifficultyLevel([Die.DIE_COLOR_WHITE,Die.DIE_COLOR_BLUE, Die.DIE_COLOR_GREEN],325,10,90,7));
		}
		
		override public function newGame():void
		{
			level = 0;
			score = 0;
			plays = 0;
			
			//Lives
			playerLife = 0;
			computerLife = 0;
		}
		
		override public function newLevel(): void
		{
			//reset all object holder arrays
			level++;
			
			var tempLevel:int = level;
			
			if (tempLevel > (difficultyLevelArray.length - 1))
			{
				tempLevel = difficultyLevelArray.length - 1
			}
			
			currentLevel = difficultyLevelArray[tempLevel - 1];
			
			//Calculate Bonus Life
			var bonusLife:int = (Math.ceil(playerLife/10));
			playerLife = playerLifeStart + bonusLife;
			computerLife = currentLevel.enemyLife;
			turn = " ";
		
			board = new Array();
			for (var r:int = 0; r < DIE_ROWS; r++)
			{
				board[r] = new Array();
				
				for (var c:int = 0; c < DIE_COLS; c++)
				{
					board[r][c] = null;
				}
			}
			
			//Puts enemy and character tiles in view
			clickedDiceArray = new Array();
			
			enemyTile = new Character(charSheet, currentLevel.enemyTile);
			playerTile = new Character(charSheet, 0);
			
			playerTile.x = 50;
			playerTile.y = 100;
			enemyTile.x = 525;
			enemyTile.y = 100;
			
			this.addChild(playerTile);
			this.addChild(enemyTile);
			
			dispatchEvent (new CustomEventLevelScreenUpdate(CustomEventLevelScreenUpdate.UPDATE_TEXT, String(level)));
			dispatchEvent (new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_SCORE, String(score)));
			dispatchEvent (new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_LEVEL, String(level)));
			dispatchEvent (new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_COMPUTER_LIFE, String(computerLife)));
			dispatchEvent (new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_PLAYER_LIFE, String(computerLife)));

			gameState = GameStates.STATE_CHANGE_TURN;
		}

		override public function runGame():void
		{
			switch(gameState)
			{
				case GameStates.STATE_INITIALIZING:
					break;
				
				case GameStates.STATE_CHANGE_TURN:
					if(turn == TURN_COMPUTER || turn == " ")
					{
						turn = TURN_PLAYER;
					}
					else
					{
						turn = TURN_COMPUTER;
					}
					
					dispatchEvent(new CustomEventScoreBoardUpdate
								  (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_TURN, String(turn)));
					gameState = GameStates.STATE_START_REPLACING;
					break;
				
				case GameStates.STATE_START_REPLACING:
					replaceDice();
					
					if (turn == TURN_PLAYER)
					{
						nextGameState = GameStates.STATE_WAITING_FOR_INPUT;
					}
					else
					{
						nextGameState = GameStates.STATE_START_AI;
					}
					gameState = GameStates.STATE_FALL_DICE_WAIT;
					break;
					
				case GameStates.STATE_WAITING_FOR_INPUT:
					break;
				
				case GameStates.STATE_START_AI:
					createAIMove();
					framesToWait = 15;
					framesWaited = 0;
					nextGameState = GameStates.STATE_REMOVE_CLICKED_DICE;
					gameState = GameStates.STATE_WAIT;
					break;
				
				case GameStates.STATE_REMOVE_CLICKED_DICE:
					removeClickedDice();
					gameState = GameStates.STATE_CHECK_FOR_END;
					break;
				
				case GameStates.STATE_CHECK_FOR_END:
					if(checkforEndLevel())
						{
							nextGameState = GameStates.STATE_END_LEVEL;
							fadeDice();
							gameState = GameStates.STATE_FADE_DICE_WAIT;
						}
					else if (checkForEndGame())
						{
							nextGameState = GameStates.STATE_END_GAME;
							makeDiceFall()
							gameState = GameStates.STATE_FALL_DICE_WAIT;
						}
					else
						{
							gameState = GameStates.STATE_CHANGE_TURN;
						}
					break;
					
				case GameStates.STATE_FADE_DICE_WAIT:
					if (!checkForFadingDice())
						{
							gameState = nextGameState;
						}
					break;
				
				case GameStates.STATE_FALL_DICE_WAIT:
					if (!checkForFallingDice())
						{
							gameState = nextGameState;
						}
					break;
								
				case GameStates.STATE_END_LEVEL:
					endLevel();
					gameState = GameStates.STATE_INITIALIZING;
					break;
				
				case GameStates.STATE_END_GAME:
					endGame();
					break;
				
				case GameStates.STATE_WAIT:
					framesWaited++;
					if (framesWaited >= framesToWait)
						{
							gameState = nextGameState;
						}
					break;
			}
			
			update();
			render();
		}
		
		//check for falling blocks that match
		private function checkForFallingDice():Boolean
		{
			var falling:Boolean = false;
			
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board [r].length; c++)
				{
					tempDie = board [r][c];
					
					if (tempDie != null)
					{
						if (tempDie.isFalling)
						{
							falling = true;
						}
					}
				}
			}
			
			return falling;
		}
		
		//check for fading blocks that match
		private function checkForFadingDice():Boolean
		{
			var fading:Boolean = false;
			
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempDie = board[r][c];
					
					if (tempDie!= null)
					{
						if(tempDie.isFading)
						{
							fading = true;
						}
					}
				}

			}
			
			return fading;
		}
		
	
		//Add replace block when empty space arises
		private function replaceDice():void
		{
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					if (board[r][c] == null)
					{
						board[r][c] = addDie(r,c);
					}
				}
			}
		}
			

		//add blocks randomly
		private function addDie(row:Number, col:Number):Die
		{
			var randomColor:Number = Math.floor(Math.random() * currentLevel.allowedColors.length);
			var dieColor:Number = currentLevel.allowedColors[randomColor];
			var dieValue:Number = Math.floor(Math.random() * 6) + 1;
			
			tempDie = new Die(dieValue, dieColor, tileSheet, row, col, (row * DIE_HEIGHT) 
								  + Y_PAD + (row *ROW_SPACING), (Math.random() * 10) + 10);
			
			tempDie.x = (col * DIE_WIDTH) + X_PAD + (col * COL_SPACING);
			tempDie.y = 0 - DIE_HEIGHT;
			tempDie.addEventListener(CustomEventClickDie.EVENT_CLICK_DIE, dieClickListener, false, 0, true);
			this.addChild(tempDie);
			return tempDie;
		}
		
		private function update():void
		{
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempDie = board[r][c];
					
					if (tempDie != null)
					{
						if (tempDie.isFalling)
						{
							tempDie.update();
						}
					}
				}
			}
		}
		
		private function render():void
		{
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempDie = board[r][c];
					
					if (tempDie != null)
					{
						if (tempDie.isFalling || tempDie.isFading)
						{
							tempDie.render();
						}
					}
				}
			}
		}
		
		private function checkforEndLevel():Boolean
		{
			var retval:Boolean = false
			
			if (computerLife <= 0)
				{
					dispatchEvent (new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_WIN, false, 1,0,1));
					retval = true;
				}
				
			return retval;
		}
		
		private function checkForEndGame():Boolean
		{
			var retval:Boolean = false
			
			if (playerLife <= 0)
				{
					dispatchEvent (new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_LOSE, false, 1,0,1));
					retval = true;
				}
				
			return retval;
		}
		
		private function endGame():void
		{
			cleanUpLevel();
			dispatchEvent(new Event(GAME_OVER));
		}
		
		private function endLevel():void
		{
			cleanUpLevel();
			dispatchEvent(new Event(NEW_LEVEL));
		}
		
		private function fadeDice():void
		{
			var boardLength:int = board.length;
			
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempDie = board[r][c];
					
					if(tempDie != null)
					{
						tempDie.startFade((Math.random() * .9) + .1);
					}
				}
			}
		}
		
		private function makeDiceFall():void
		{
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempDie = board[r][c];
					
					if(tempDie != null)
					{
						tempDie.startFalling(gameHeight + DIE_HEIGHT, (Math.random() * 15)+ 10);
					}
				}
			}
		}
		
		private function addToScore(val:Number):void
		{
			score += int(val);
			computerLife -= int(val);
			
			dispatchEvent(new CustomEventScoreBoardUpdate
						  (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SCORE,String(score)));
			dispatchEvent(new CustomEventScoreBoardUpdate
						  (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_COMPUTER_LIFE,String(computerLife)));
		}
		
		private function removeDie(rd:Die):void
		{
			var boardLength:int = board.length;
			
			for (var r:int = 0; r < boardLength; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempDie = board[r][c];
					
					if (tempDie == rd)
					{
						tempDie.removeEventListener(CustomEventClickDie.EVENT_CLICK_DIE, dieClickListener);
						tempDie.dispose();
						removeChild(tempDie);
						board[r][c] = null;
					}
				}
			}
		}
		
		private function cleanUpLevel():void
		{
			var boardLength:int = board.length;
			
			for (var r:int = 0; r < boardLength; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					if (tempDie != null)
					{
						removeDie(tempDie);
					}
				}
			}
		}
		
		//the previous functions are made private so the 
		//system won't get confused between the player and AI moves
		
		
		//Calculates what the AI will do when player against Human opponent
		public function createAIMove():void
		{
			var dieSets:Array = new Array();
			var diceTested:Array = new Array();
			var testSet:Array = new Array();
			var testValue:Number = 0;
			
			//Part One: Tests and sets dice so board won't
			//go into an infinite loop
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempDie = board[r][c];
					
					if (diceTested.indexOf(tempDie) == -1)
					{
						testSet = findLikeColoredDice(tempDie);
						testValue = getDiceValue(testSet);
						dieSets.push([Number(testValue),tempDie]);
						
						while(testSet.length > 0)
						{
							diceTested.push(testSet.pop())
						}
					}
				}
			}
			
			dieSets.sortOn("0", Array.NUMERIC);
			
			//Part Two: Erase Like Values in Die Drops
			var lastValue:Number = 0;
			
			for (var ii:int = dieSets.length - 1; ii >=0; ii--)
			{
				if(dieSets[ii][0] == lastValue)
				{
					dieSets.splice(ii, 1);
				}
				
				else
				{
					lastValue = dieSets[ii][0];
				}
			}
			
			//Part Three: Remove all die sets lower than the minimum value
			if (dieSets[dieSets.length-1][0] > currentLevel.minValue)
			{
				for (ii = dieSets.length - 1; ii >= 0; ii--)
				{
					if (dieSets[ii][0] < currentLevel.minValue)
					{
						dieSets.splice(ii, 1);
					}
				}
			}
			
			//Part Four: sets player's number of chances against
			//AI plays
			var aiVal:Number = 0;
			
			if (dieSets.length > 1)
			{
				var pChance:Number = Math.floor(Math.random() * 100);
				pChance += currentLevel.aiBonus;
				
				var pVal:Number = Math.floor(99/dieSets.length);
				aiVal = Math.floor(pChance/pVal);
				
				if(aiVal > dieSets.length - 1)
					{
						aiVal = dieSets.length - 1;
					}
			}
				else
					{
						aiVal = 0;
					}
					
					
			//Part Five: AI attacks Player
			tempDie = dieSets[aiVal][1];
			clickedDiceArray = findLikeColoredDice(tempDie);
			
			for (var cd:int = 0; cd < clickedDiceArray.length; cd++)
			{
				clickedDiceArray[cd].makeDieClickedComputer();
			}
			
			playerLife -= dieSets[aiVal][0];
			
			dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_HIT, false, 1,0,1));
			dispatchEvent(new CustomEventScoreBoardUpdate
						  (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_PLAYER_LIFE, String(playerLife)));
			
		}
		
		public function getDiceValue(tdice:Array):Number
		{
			var value:int = 0;
			var bonusPoints:int = 0;
			
			for (var d:int = 0; d < tdice.length; d++)
			{
				tempDie = tdice[d];
				value += (tempDie.dieValue + bonusPoints);
				bonusPoints += DICE_BONUS;
			}
			
			return value;
		}
		
		public function dieClickListener(e:CustomEventClickDie):void
		{
			if (gameState == GameStates.STATE_WAITING_FOR_INPUT)
			{
				dispatchEvent (new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_CLICK, false,1,0,1));
				tempDie = e.die;
				clickedDiceArray = findLikeColoredDice(tempDie);
				
				for (var i:int =0; i < clickedDiceArray.length; i++)
				{
					clickedDiceArray[i].makeDieClicked();
				}
				
				var dicevalue:Number = getDiceValue(clickedDiceArray);
				dispatchEvent (new CustomEventScoreBoardUpdate
							   (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_COMPUTER_LIFE, String(computerLife)));
				
				addToScore(dicevalue);
				framesToWait = 15;
				framesWaited = 0;
				dispatchEvent (new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_BONUS, false,1,0,1));
				nextGameState = GameStates.STATE_REMOVE_CLICKED_DICE;
				gameState = GameStates.STATE_WAIT;
			}
		}
		
		public function removeClickedDice():void
		{
			removeClickedDiceFromScreen();
			moveDiceDown();
			clickedDiceArray = new Array();
		}
		
		public function findLikeColoredDice(tDie:Die):Array
		{
			var diceToCheck:Array = new Array();
			var diceMatched:Array = new Array();
			var diceTested:Array = new Array();
			var rowList:Array = [-1, 0, 1, -1, 1, -1, 0, 1];
			var colList:Array = [-1, -1,- 1, 0, 0, 1, 1, 1];
			
			var tColor:Number = tDie.dieColor;
			var tValue:int = tDie.dieValue;
			
			diceToCheck.push(tDie);
			
			while (diceToCheck.length > 0)
			{
				tempDie = diceToCheck.pop();
				if (tempDie.dieColor == tColor && tempDie.dieValue == tValue)
				{
					diceMatched.push(tempDie);
				}
				
				
			var tB2:Die;
			
			for (var i:int = 0; i < rowList.length; i++)
			{
				if ((tempDie.row + rowList[i]) >= 0 && (tempDie.row + rowList[i]) < 
					DIE_ROWS && (tempDie.col + colList[i]) >= 0 && (tempDie.col + colList[i]) < DIE_COLS)
					{
						var tr:int = tempDie.row + rowList[i];
						var tc:int = tempDie.col + colList[i];
						tB2 = board[tr][tc];
						
						if (tB2.dieColor == tColor && tB2.dieValue == tValue && diceToCheck.indexOf(tB2)
							== -1 && diceTested.indexOf(tB2) == -1)
						{
							diceToCheck.push(tB2);
						}
					}
			}
				
				diceTested.push(tempDie);
				
			}
			
			return diceMatched;
		}
		
		//Removed points calcualtion and moved it to clickdielistener()
		public function removeClickedDiceFromScreen():void
		{
			var dieLength:int = clickedDiceArray.length - 1;
						
			while(clickedDiceArray.length > 0)
			{
				tempDie = clickedDiceArray.pop();
				removeDie(tempDie);
			}
		}
		
		public function moveDiceDown():void
		{
			var collength:int = DIE_COLS - 1;
			
			for (var c:int = collength; c >= 0; c--)
			{
				var rowLength:int = DIE_ROWS - 1;
				var missing:Number = 0;
				
				for (var r:int = rowLength; r >= 0; r--)
				{
					tempDie = board[r][c];
					
					if (tempDie != null)
					{
						missing = 0;
						
						if (r < DIE_ROWS)
						{
							for (var m:int = r + 1; m < DIE_ROWS; m++)
							{
								if (board[m][c] == null)
								{
									missing++;
								}
							}
						}
						
						if(missing > 0)
						{
							tempDie.row = r + missing;
							tempDie.col = c;
							board[r + missing][c] = tempDie;
							board[r][c] = null;
							tempDie.startFalling(tempDie.y + (missing * DIE_HEIGHT) + (missing * ROW_SPACING), 10);
						}
					}
				}
			}
		}
	}
}
