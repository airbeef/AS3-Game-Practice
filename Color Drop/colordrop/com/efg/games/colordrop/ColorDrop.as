package com.efg.games.colordrop 
{
	import flash.display.Sprite;
	import flash.events.*;
	
	import com.efg.framework.Game;
	import com.efg.framework.CustomEventLevelScreenUpdate;
	import com.efg.framework.CustomEventScoreBoardUpdate;
	import com.efg.framework.CustomEventSound;
	import com.efg.framework.TileSheet;
	
	public class ColorDrop extends com.efg.framework.Game
	{
		private var gameWidth:int;
		private var gameHeight:int;
		
		//Game const grid block starting position
		private static const Y_PAD:int = 50;
		private static const X_PAD:int = 135;
		
		//Pixel spacing
		private static const ROW_SPACING:int = 2;
		private static const COL_SPACING:int = 2;
		
		//Define dimensions
		private static const BLOCK_HEIGHT:int = 32;
		private static const BLOCK_WIDTH:int = 32;
		
		//how many rows/columns will appear on screen
		private static const BLOCK_ROWS:int = 10;
		private static const BLOCK_COLS:int = 10;
		
		//In game values
		private var score:int;
		private var level:int;
		private var plays:int;
		private var levelScore:int;
		
		//difficulty level
		private var difficultyLevelArray:Array;
		private var currentLevel:DifficultyLevel;
		
		//Difficulty Settings
		private static var BONUS_PER_BLOCK:Number = .25;
		private static var POINTS_PER_BLOCK:Number = 1;
		
		//Block values
		private var clickedBlocksArray:Array;
		private var board:Array;
		private var tempBlock:Block;
		
		//Gamestate machine
		private var gameState:int = 0;
		private var nextGameState:int = 0;
		private var framesToWait:int = 0;
		private var framesWaited:int = 0;
		
		//Tilesheet
		private var tileSheet:TileSheet;
		
		public function ColorDrop(gW:int, gH:int) 
		{
			gameWidth =  gW;
			gameHeight = gH;
			
			init();
			
			gameState = GameStates.STATE_INITIALIZING;
		}
		
		public function init():void
		{
			tileSheet = new TileSheet(new ColorSheet(0,0), BLOCK_WIDTH, BLOCK_HEIGHT);
			
			//level difficulty array
			difficultyLevelArray = new Array();
			
			difficultyLevelArray.push(new DifficultyLevel
									  ([Block.BLOCK_COLOR_RED, Block.BLOCK_COLOR_GREEN, Block.BLOCK_COLOR_BLUE], 10, 500));
			
			difficultyLevelArray.push(new DifficultyLevel
									  ([Block.BLOCK_COLOR_RED, Block.BLOCK_COLOR_GREEN, Block.BLOCK_COLOR_BLUE, 
										Block.BLOCK_COLOR_VIOLET], 10, 500));
			
			difficultyLevelArray.push(new DifficultyLevel
									  ([Block.BLOCK_COLOR_RED, Block.BLOCK_COLOR_GREEN, Block.BLOCK_COLOR_BLUE, 
										Block.BLOCK_COLOR_VIOLET, Block.BLOCK_COLOR_ORANGE], 10, 500));
			
			difficultyLevelArray.push(new DifficultyLevel
									  ([Block.BLOCK_COLOR_RED, Block.BLOCK_COLOR_GREEN, Block.BLOCK_COLOR_BLUE, 
										Block.BLOCK_COLOR_VIOLET, Block.BLOCK_COLOR_ORANGE, Block.BLOCK_COLOR_YELLOW], 10, 500));
			
			difficultyLevelArray.push(new DifficultyLevel
									  ([Block.BLOCK_COLOR_RED, Block.BLOCK_COLOR_GREEN, Block.BLOCK_COLOR_BLUE,
										Block.BLOCK_COLOR_VIOLET, Block.BLOCK_COLOR_ORANGE, Block.BLOCK_COLOR_YELLOW, Block.BLOCK_COLOR_PURPLE], 10, 500));
		}
		
		override public function newGame():void
		{
			level = 0;
			score = 0;
			plays = 0;
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
			plays += currentLevel.startPlays;
			levelScore = 0;
			
			dispatchEvent (new CustomEventLevelScreenUpdate(CustomEventLevelScreenUpdate.UPDATE_TEXT, String(level)));
			dispatchEvent (new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_PLAYS, String(plays)));
			dispatchEvent (new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_LEVEL, String(level)));
			dispatchEvent (new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_THRESHOLD, String(currentLevel.scoreThreshold)));
			
			board = new Array();
			
			for (var r:int = 0; r < BLOCK_ROWS; r++)
			{
				board[r] = new Array();
				
				for (var c:int = 0; c < BLOCK_COLS; c++)
				{
					board[r][c] = null;
				}
			}
			
			clickedBlocksArray = new Array();
			gameState = GameStates.STATE_START_REPLACING;
		}
		
		override public function runGame():void
		{
			switch(gameState)
			{
				case GameStates.STATE_INITIALIZING:
				break;
				
				case GameStates.STATE_START_REPLACING:
				replaceBlocks();
				nextGameState = GameStates.STATE_WAITING_FOR_INPUT;
				gameState = GameStates.STATE_FALL_BLOCKS_WAIT;
				break;
				
				case GameStates.STATE_WAITING_FOR_INPUT:
				checkforEndLevel();
				break;
				
				case GameStates.STATE_REMOVE_CLICKED_BLOCKS:
				removeClickedBlocks();
				gameState = GameStates.STATE_START_REPLACING;
				break;
				
				case GameStates.STATE_FADE_BLOCKS_WAIT:
				if (!checkForFadingBlocks())
				{
					gameState = nextGameState;
				}
				break;
				
				case GameStates.STATE_FALL_BLOCKS_WAIT:
				if (!checkForFallingBlocks())
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
		public function checkForFallingBlocks():Boolean
		{
			var isFalling:Boolean = false;
			
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board [r].length; c++)
				{
					tempBlock = board [r][c];
					
					if (tempBlock.isFalling)
					{
						isFalling = true;
					}
				}
			}
			
			return isFalling;
		}
		
		//check for fading blocks that match
		public function checkForFadingBlocks():Boolean
		{
			var isFading:Boolean = false;
			
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempBlock = board[r][c];
					
					if (tempBlock.isFading)
					{
						isFading = true;
					}
				}

			}
			
			return isFading;
		}
		
		//Add replace blockwhen empty space arises
		public function replaceBlocks():void
		{
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					if (board[r][c] == null)
					{
						board[r][c] = addBlock(r,c);
					}
				}
			}
		}
		
		//add blocks randomly
		public function addBlock(row:Number, col:Number):Block
		{
			var randomColor:Number = Math.floor(Math.random() * currentLevel.allowedColors.length);
			var blockColor:Number = currentLevel.allowedColors[randomColor];
			
			tempBlock = new Block(blockColor, tileSheet, row, col, (row * BLOCK_HEIGHT) 
								  + Y_PAD + (row *ROW_SPACING), (Math.random() * 10) + 10);
			
			tempBlock.x = (col * BLOCK_WIDTH) + X_PAD + (col * COL_SPACING);
			tempBlock.y = 0 - BLOCK_HEIGHT;
			tempBlock.addEventListener(CustomEventClickBlock.EVENT_CLICK_BLOCK, blockClickListener, false, 0, true);
			this.addChild(tempBlock);
			return tempBlock;
		}
		
		public function update():void
		{
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempBlock = board[r][c];
					
					if (tempBlock != null)
					{
						if (tempBlock.isFalling)
						{
							tempBlock.update();
						}
					}
				}
			}
		}
		
		public function render():void
		{
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempBlock = board[r][c];
					
					if (tempBlock != null)
					{
						if (tempBlock.isFalling || tempBlock.isFading)
						{
							tempBlock.render();
						}
					}
				}
			}
		}
		
		public function checkforEndLevel():void
		{
			if (levelScore >= currentLevel.scoreThreshold)
			{
				dispatchEvent (new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_WIN, false, 1,0,1));
				nextGameState = GameStates.STATE_END_LEVEL;
				fadeBlocks();
				gameState = GameStates.STATE_FADE_BLOCKS_WAIT;
			}
			
			else if (plays <=0)
			{
				nextGameState = GameStates.STATE_END_GAME;
				dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_LOSE, false, 1,0,1));
				makeBlocksFall();
				gameState = GameStates.STATE_FALL_BLOCKS_WAIT;
			}
		}
		
		public function endGame():void
		{
			cleanUpLevel();
			dispatchEvent(new Event(GAME_OVER));
		}
		
		public function endLevel():void
		{
			cleanUpLevel();
			dispatchEvent(new Event(NEW_LEVEL));
		}
		
		public function fadeBlocks():void
		{
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempBlock = board[r][c];
					tempBlock.startFade((Math.random() * .9) + .1);
				}
			}
		}
		
		public function makeBlocksFall():void
		{
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempBlock = board[r][c];
					tempBlock.startFalling(gameHeight + BLOCK_HEIGHT, (Math.random() * 15)+ 10);
				}
			}
		}
		
		public function addToScore(val:Number):void
		{
			score += int(val);
			levelScore += int(val);
			
			dispatchEvent(new CustomEventScoreBoardUpdate
						  (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SCORE,String(score)));
			dispatchEvent(new CustomEventScoreBoardUpdate
						  (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_LEVEL_SCORE,String(levelScore)));
		}
		
		public function removeBlock(blockToRemove:Block):void
		{
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempBlock = board[r][c];
					if (tempBlock == blockToRemove)
					{
						tempBlock.removeEventListener(CustomEventClickBlock.EVENT_CLICK_BLOCK, blockClickListener);
						tempBlock.dispose();
						removeChild(tempBlock);
						board[r][c] = null;
					}
				}
			}
		}
		
		public function cleanUpLevel():void
		{
			for (var r:int = 0; r < board.length; r++)
			{
				for (var c:int = 0; c < board[r].length; c++)
				{
					tempBlock = board[r][c];
					removeBlock(tempBlock);
				}
			}
		}
		
		public function blockClickListener(e:CustomEventClickBlock):void
		{
			if (gameState == GameStates.STATE_WAITING_FOR_INPUT)
			{
				dispatchEvent (new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_CLICK, false,1,0,1));
				tempBlock = e.block;
				clickedBlocksArray = findLikeColoredBlocks(tempBlock);
				
				framesToWait = 15;
				framesWaited = 0;
				plays--;
				nextGameState = GameStates.STATE_REMOVE_CLICKED_BLOCKS;
				gameState = GameStates.STATE_WAIT;
			}
		}
		
		public function removeClickedBlocks():void
		{
			removeClickedBlocksFromScreen();
			moveBlocksDown();
			clickedBlocksArray = new Array();
			dispatchEvent (new CustomEventScoreBoardUpdate
						   (CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_PLAYS, String(plays)));
		}
		
		public function findLikeColoredBlocks(blocksToMatch:Block):Array
		{
			var blocksToCheck:Array = new Array();
			var blocksMatched:Array = new Array();
			var blocksTested:Array = new Array();
			var rowList:Array = [-1, 0, 1, -1, 1, -1, 0, 1];
			var colList:Array = [-1, -1,- 1, 0, 0, 1, 1, 1];
			
			var colorToMatch:Number = blocksToMatch.blockColor;
			
			blocksToCheck.push(blocksToMatch);
			
			while (blocksToCheck.length > 0)
			{
				tempBlock = blocksToCheck.pop();
				if (tempBlock.blockColor == colorToMatch)
				{
					blocksMatched.push(tempBlock);
					tempBlock.makeBlockClicked();
				}
				
				
			var tempBlock2:Block;
			
			for (var i:int = 0; i < rowList.length; i++)
			{
				if ((tempBlock.row + rowList[i]) >= 0 && (tempBlock.row + rowList[i]) < 
					BLOCK_ROWS && (tempBlock.col + colList[i]) >= 0 && (tempBlock.col + colList[i]) < BLOCK_COLS)
					{
						var tr:int = tempBlock.row + rowList[i];
						var tc:int = tempBlock.col + colList[i];
						tempBlock2 = board[tr][tc];
						
						if (tempBlock2.blockColor == colorToMatch && blocksToCheck.indexOf(tempBlock2)
							== -1 && blocksTested.indexOf(tempBlock2) == -1)
						{
							blocksToCheck.push(tempBlock2);
						}
					}
			}
				
				blocksTested.push(tempBlock);
				
			}
			
			return blocksMatched;
		}
		
		public function removeClickedBlocksFromScreen():void
		{
			var blockLength:int = clickedBlocksArray.length - 1;
			var pointsPerBlock:Number = POINTS_PER_BLOCK;
			
			dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_BONUS, false, 1,0,1));
			
			while(clickedBlocksArray.length > 0)
			{
				addToScore(Math.floor(pointsPerBlock));
				tempBlock = clickedBlocksArray.pop();
				removeBlock(tempBlock);
				pointsPerBlock += POINTS_PER_BLOCK;
			}
		}
		
		public function moveBlocksDown():void
		{
			var collength:int = BLOCK_COLS - 1;
			
			for (var c:int = collength; c >= 0; c--)
			{
				var rowLength:int = BLOCK_ROWS - 1;
				var missing:Number = 0;
				
				for (var r:int = rowLength; r >= 0; r--)
				{
					tempBlock = board[r][c];
					
					if (tempBlock != null)
					{
						missing = 0;
						
						if (r < BLOCK_ROWS)
						{
							for (var m:int = r + 1; m < BLOCK_ROWS; m++)
							{
								if (board[m][c] == null)
								{
									missing++;
								}
							}
						}
						
						if(missing > 0)
						{
							tempBlock.row = r + missing;
							tempBlock.col = c;
							board[r + missing][c] = tempBlock;
							board[r][c] = null;
							tempBlock.startFalling(tempBlock.y + (missing * BLOCK_HEIGHT) + (missing * ROW_SPACING), 10);
						}
					}
				}
			}
		}
	}
}
