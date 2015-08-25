package com.efg.games.blastermines2
{
	import com.efg.framework.Game;
	import com.efg.framework.GameFrameWork;
	import com.efg.framework.BasicBlitArrayParticle;
	import com.efg.framework.BasicBlitArrayProjectile;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.filters.*;
	
	import com.efg.framework.BasicBlitArrayObject;
	import com.efg.framework.BlitArrayAsset;
	import com.efg.framework.CustomEventLevelScreenUpdate;
	import com.efg.framework.CustomEventScoreBoardUpdate;
	import com.efg.framework.CustomEventSound;
	
	//Timer
	//import com.efg.framework.BasicFrameTimer;
	//import flash.utils.Timer;
	
	public class BlasterMinesImg2 extends Game 
	{
		public static const GAME_OVER:String = "game over";
		public static const NEW_LEVEL:String = "new level";
		
		public static const STATE_SYSTEM_GAME_PLAY:int = 0;
		//public static const STATE_SYSTEM_LEVEL_OUT;int = 1;
		public static const STATE_SYSTEM_PLAYER_EXPLODE:int = 2;
		 
		
		//game states
		private var systemFunction:Function;
		private var currentSystemState:int;
		private var nextSystemState:int;
		private var lastSystemState:int;
		
		//game loop
		private var gameOver:Boolean = false;
		
		//level data
		private var levelColors:Array = [NaN, 0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0x00ffff, 0xffaa00, 0xaaff00, 0x00ffaa, 0x00aaff];
		private var levelColor:uint;
		
		private var level:int = 0;
		private var score:int = 0;
		private var shield:int = 10;
		private var maxLevel:int = levelColors.length;
		private var playerStarted:Boolean = false;
		private var playerExplosionParticles:Array = [];
		
		//canvas and background
		private var backgroundBitmapData:BitmapData = new BitmapData(800,800, false, 0x000000); //800
		//private var backgroundBitmapData:BitmapData = new PHBackgroundLrg(0,0);
		private var canvasBitmapData:BitmapData = new BitmapData(800, 800, false, 0x000000); //800
		private var canvasBitmap:Bitmap = new Bitmap(canvasBitmapData);
		private var canvasRect:Rectangle = new Rectangle(0,0, 400,400); // 400,400
		
		//private var camera:Camera2D = new Camera2D(0, 399, 0, 399);
		//private var viewBitmap:Bitmap;
		
		//drawing
		private var drawingCanvas:Shape = new Shape();
		
		//player
		private var player:BlitArrayPlayerFollowMouse = new BlitArrayPlayerFollowMouse(1, 767, 1, 767);
		
		//Mine Manager
		private var mineManager:MineManager = new MineManager();
		public var tempMine:Mine;
		
		//Projectile Manager
		private var projectileManager:ProjectileManager = new ProjectileManager();
		private var tempProjectile:com.efg.framework.BasicBlitArrayProjectile;
		
		//Particle Manager particles
		private var particleManager:ParticleManager = new ParticleManager();
		private var tempParticle:com.efg.framework.BasicBlitArrayParticle;
		
		//Reused Rectangle/Points
		//private var rect8:Rectangle = new Rectangle(0,0 8,8);
		private var rect32:Rectangle = new Rectangle(0,0, 32,32);
		private var point0:Point = new Point(0,0);
		
		private var spriteGlowFilter:GlowFilter = new GlowFilter(0x0066ff, 1, 3, 3, 3, 3, false, false);
		private var canvasBitmapGlowFilter:GlowFilter = new GlowFilter(0x0066ff, .5, 400, 400, 1,1, true, false);
		
		//Timer
		//private var countDownTimer:BasicFrameTimer = new BasicFrameTimer(40);
		//private var levelTimerStartSeconds:int;
		//private var timeLeft:int = 0;
		//private var timerStartSeconds:int;
		
		
		//Scoreboard objects: Optimization
		private var customScoreBoardEventScore:CustomEventScoreBoardUpdate = new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SCORE, "");
		private var customScoreBoardEventShield:CustomEventScoreBoardUpdate = new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_SHIELD, "");
		private var customScoreBoardEventLevel:CustomEventScoreBoardUpdate = new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_LEVEL, "");
		
		private var customScoreBoardEventParticlePool:CustomEventScoreBoardUpdate = new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_PARTICLE_POOL, "");
		private var customScoreBoardEventParticleActive:CustomEventScoreBoardUpdate = new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_PARTICLE_ACTIVE, "");
		private var customScoreBoardEventProjectilePool:CustomEventScoreBoardUpdate = new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_PROJECTILE_POOL, "");
		private var customScoreBoardEventProjectileActive:CustomEventScoreBoardUpdate = new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT, Main.SCORE_BOARD_PROJECTILE_ACTIVE, "");


		//Math Look Up Tables
		private var rotationVectorList:Array = [];
		//private var rotationVectorList:Vector.<Point> = new Vector.<Point>(360, false);
		
		//radar
		private var radarBitmap:Bitmap = new Bitmap(canvasBitmapData);
		
		
		public function BlasterMinesImg2() 
		{
			trace("constructor");
			
			init();
		}
		
		/*override public function setRendering(profiledRate:int, framerate:int):void
		{
			var percent:Number = profiledRate / framerate;
			
			trace("frame percent =" + percent);
			trace ("stage=" + stage);
			
			if (percent >= .85)
			{
				frameRateMultiplier = 2;
			}
			trace ("frameRateMultiplier=" + frameRateMultiplier);
		}
		*/
		
		private function init():void
		{
			this.focusRect = false;
			
			//Init Radar
			radarBitmap.x = 420; //harhar
			radarBitmap.y = 230;
			radarBitmap.scaleX = .2;
			radarBitmap.scaleY = .2;
			
			createLookupTables();
			player.createPlayerShip(spriteGlowFilter);
			projectileManager.createProjectiles(spriteGlowFilter);
			projectileManager.createProjectilePool(50);
			
			canvasBitmap.scrollRect = new Rectangle(200, 200, 400, 400); //(200, 200, 400, 400);
			
			addChild(canvasBitmap);
			addChild(radarBitmap);
			
		}
		
		//This dictates rotation movement
		private function createLookupTables():void
		{
			for (var ctr:int = 0; ctr < 359; ctr++) //359
			{
				var point:Point = new Point();
				point.x = Math.cos((Math.PI * ctr) / 180);
				point.y = Math.sin((Math.PI * ctr) / 180);
				rotationVectorList[ctr] = point;
			}
		}
		
		override public function newGame():void
		{
			if (frameRateMultiplier == 2)
			{
				stage.quality = StageQuality.BEST;
			}
			else
			{
				stage.quality = StageQuality.MEDIUM
			}
			
			trace("new game");
			switchSystemState(STATE_SYSTEM_GAME_PLAY);
			score = 0;
			level = 0;
			shield = 10;
			//timeLeft = 0;
			gameOver = false;
			playerExplosionParticles = [];
			playerStarted = false;
			
			customScoreBoardEventShield.value = shield.toString()
			customScoreBoardEventScore.value = score.toString()
			customScoreBoardEventLevel.value = level.toString()
			
			dispatchEvent(customScoreBoardEventScore);
			dispatchEvent(customScoreBoardEventShield);
			dispatchEvent(customScoreBoardEventLevel);
			
			//dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_TIME_LEFT,"00"));
			//countDownTimer.addEventListener(BasicFrameTimer.TIME_IS_UP, timesUpListener, false, 0, true);
			//levelTimerStartSeconds = level.timerStartSeconds;
		}
		
		override public function newLevel():void
		{
			stage.focus = this;
			trace("new level");
			mineManager.mines = [];
			projectileManager.projectiles = [];
			stage.focus = this;
			level++;
			
			if (level > maxLevel)
			{
				level = 1;
			}
			levelColor = levelColors[level];
			
			spriteGlowFilter = new GlowFilter(levelColor, .75, 2, 2, 1.5, 2, false, false);
			createLevelbackground();
			mineManager.createLevelMines(spriteGlowFilter, level, levelColor);
			particleManager.createLevelParticles(spriteGlowFilter, levelColor);
			particleManager.createParticlePool(particleManager.particlePoolMax * frameRateMultiplier);
			
			canvasBitmapGlowFilter.color = levelColor;
			//canvasBitmap.filters = [canvasBitmapGlowFilter];
			
			player.x = 400;
			player.y = 400;
			player.nextX = player.x;
			player.nextY = player.y;
			playerStarted = true;
			player.bitmapData = player.animationList[0]; //
			render();
			
			dispatchEvent(new CustomEventLevelScreenUpdate(CustomEventLevelScreenUpdate.UPDATE_TEXT, String(level)));
			//dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_MUSIC_IN_GAME,true, 999, 8, 1));
						
			customScoreBoardEventLevel.value = level.toString();
			dispatchEvent(customScoreBoardEventLevel);
			
			//countDownTimer.seconds = levelTimerStartSeconds;
			//countDownTimer.min = 0;
						
		}
					
			private function createLevelbackground():void
			{
			//background
				drawingCanvas.filters = [spriteGlowFilter];
			
				drawingCanvas.graphics.clear();
				drawingCanvas.graphics.lineStyle(2, 0xaaaaaa);
				drawingCanvas.graphics.moveTo(6, 6);
				drawingCanvas.graphics.lineTo(25, 6);
				drawingCanvas.graphics.lineTo(25, 22);
				drawingCanvas.graphics.lineTo(6, 22);
				drawingCanvas.graphics.lineTo(6, 6);
				drawingCanvas.graphics.moveTo(18, 8);
				drawingCanvas.graphics.lineTo(18, 16);
				drawingCanvas.graphics.lineTo(12, 16);
				drawingCanvas.graphics.lineTo(12, 12);
				drawingCanvas.graphics.moveTo(9, 24);
				drawingCanvas.graphics.lineTo(9, 25);
				drawingCanvas.graphics.moveTo(15, 24);
				drawingCanvas.graphics.lineTo(15, 25);
				drawingCanvas.graphics.moveTo(21, 24);
				drawingCanvas.graphics.lineTo(21, 25); 
				
			//Mini Map
			var scaleTranslateMatrix:Matrix = new Matrix();
			scaleTranslateMatrix.scale(20, 20);
			scaleTranslateMatrix.translate(100, 100);
			
			var faceColorTransform:ColorTransform = new ColorTransform(1, 1, 1, .2 );
			
			backgroundBitmapData.draw(drawingCanvas, scaleTranslateMatrix, faceColorTransform,BlendMode.LAYER)
			scaleTranslateMatrix = null;
			faceColorTransform = null;
			
			//draw box around background
			drawingCanvas.graphics.clear();
			drawingCanvas.graphics.lineStyle(2,0xffffff);
			drawingCanvas.graphics.drawRect(5, 5, 790, 790);
			backgroundBitmapData.draw(drawingCanvas);
			
			//draw 800 random stars on the background
			for (var ctr:int = 0; ctr < 800; ctr ++)
			{
				backgroundBitmapData.setPixel32(int(Math.random() * 799), int(Math.random() * 799), 0x0066ff);
			}
			
		} 
		
		override public function runGameTimeBased(paused:Boolean = false, timeDifference:Number = 1):void
		{
			if(!paused)
			{
				systemFunction(timeDifference);
			}
		}
		
		
		private function switchSystemState(stateval:int):void
		{
			lastSystemState = currentSystemState;
			currentSystemState = stateval;
			
			switch(stateval)
			{
				case STATE_SYSTEM_GAME_PLAY:
				systemFunction = systemGamePlay;
				break
				
				case STATE_SYSTEM_PLAYER_EXPLODE:
				systemFunction = systemPlayerExplode;
				break
			}
		}
		
		private function systemGamePlay(timeDifference:Number = 0):void
		{
			//timer
			//if (!countDownTimer.started)
			//{
				//countDownTimer.start();
				//playerStarted = true;
				//trace("counterstarted/systemGamePlay");
			//}
			
			//countDownTimer.update();
			
			update(timeDifference);
			checkCollisions();
			render();
			updateScoreBoard();
			checkforEndLevel();
			checkforEndGame();
	   }
		
		private function checkforEndGame():void
		{
			if (gameOver)
			{
				//dispatchEvent(new CustomEventSound(CustomEventSound.STOP_SOUND, Main.SOUND_MUSIC_IN_GAME, true));
				//dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_PLAYER_EXPLODE, false, 1,8,1));
				canvasBitmapData.copyPixels(backgroundBitmapData, new Rectangle(0,0,32,32), player.point);
				playerStarted = false;
				createPlayerExplode(player.x +16, player.y + 16, 300);
				switchSystemState(STATE_SYSTEM_PLAYER_EXPLODE);
				
				//countDownTimer.stop();
			}
		}
		
		
		private function checkforEndLevel():void
		{
			if (mineManager.mines.length == 0 && particleManager.particles.length <25)
			{
				//dispatchEvent(new CustomEventSound(CustomEventSound.STOP_SOUND, Main.SOUND_MUSIC_IN_GAME, true));
				disposeAll();
				playerStarted = false;
				
				//erase player from screen
				canvasBitmapData.copyPixels(backgroundBitmapData, new Rectangle (0,0,32,32), player.point);
				dispatchEvent(new Event(NEW_LEVEL));
				
				//countDownTimer.stop();
			}
		}
		
		private function systemPlayerExplode(timeDifference:Number = 0):void
		{
			update(timeDifference);
			render();
			if (playerExplosionParticles.length == 0)
			{
				playerExplodeComplete();
			}
		}
		
		private function playerExplodeComplete():void
		{
			dispatchEvent(new Event(GAME_OVER));
			disposeAll();
		}
		
		private function update(timeDifference:Number = 0):void
		{
			//trace("update");
			//time based movement modifier calculation
			//trace ("timeDifference=" + timeDifference);
			//trace ("timeDifference/1000=" + String (time/Difference/1000));
			//trace ("timeBasedUpdateModifier=" + timeBasedUpdateModifier)
			//trace("step=" + step);
			var step:Number = (timeDifference / 1000) * timeBasedUpdateModifier;
			
			//auto fire
			autoShoot(step);
			
			if (playerStarted)
			{
				player.update(this.mouseX + canvasBitmap.scrollRect.x, this.mouseY + canvasBitmap.scrollRect.y, 20, step);
			}
			
			
			for each (tempMine in mineManager.mines)
			{
				tempMine.update(step);
				tempMine.updateFrame(5);
			}
			
			
			particleManager.particleCount = particleManager.particles.length-1;
			for (var ctr:int = particleManager.particleCount; ctr >= 0; ctr--)
			{
				tempParticle = particleManager.particles[ctr];
				if (tempParticle.update(step))
				{
					tempParticle.frame = 0;
					particleManager.particlePool.push(tempParticle);
					particleManager.particles.splice(ctr, 1);
				}
			}
			
			var projectileLength:int = projectileManager.projectiles.length - 1;
			
			for (ctr = projectileLength; ctr>=0; ctr--)
			{
				tempProjectile = projectileManager.projectiles[ctr];
				//tempProjectile.update(player.xMove, player.yMove)
				
				if (tempProjectile.update(player.xMove, player.yMove,step))
				{
					tempProjectile.frame = 0;
					projectileManager.projectilePool.push(tempProjectile);
					projectileManager.projectiles.splice(ctr,1);
				}
				else
				{
					tempProjectile.updateFrame(1);
				}
			}
			
			for (ctr = playerExplosionParticles.length-1; ctr >=0; ctr--)
			{
				tempParticle = playerExplosionParticles[ctr];
				if (tempParticle.update())
				{
					tempParticle = null;
					
					playerExplosionParticles.splice(ctr,1);
				}
			}
		}
			
			
			private function autoShoot(step:Number):void
			{
				projectileManager.projectilePoolCount = projectileManager.projectilePool.length - 1;
				mineManager.mineCount = mineManager.mines.length;
			
			if (projectileManager.lastProjectileShot > 3 && projectileManager.projectilePoolCount > 0 && playerStarted && mineManager.mineCount > 0)
			{
				//dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_PLAYER_SHOOT, false, 0,8,1));
				tempProjectile = projectileManager.projectilePool.pop();
				
				var projectileRadians:Number = (player.frame/360) * 6.28;
				// + 16 to get it to center
				tempProjectile.x = (player.point.x+16) + Math.cos(projectileRadians);
				tempProjectile.y = (player.point.y+16) + Math.sin(projectileRadians);				
				tempProjectile.x = player.x + 16;
				tempProjectile.y = player.y + 16;
				tempProjectile.nextX = tempProjectile.x;
				tempProjectile.nextY = tempProjectile.y;
				tempProjectile.dx = rotationVectorList[player.frame].x;
				tempProjectile.dy = rotationVectorList[player.frame].y;
				
				tempProjectile.speed = 5;
				tempProjectile.frame = 0;
				tempProjectile.bitmapData = tempProjectile.animationList[0];
				
				projectileManager.projectiles.push(tempProjectile);
				projectileManager.lastProjectileShot = 0;
			}
			
			else
			{
				projectileManager.lastProjectileShot += step;
			}
			
		}
		
		
		private function checkCollisions():void
		{
			mineManager.mineCount = mineManager.mines.length - 1; //- 1
			projectileManager.projectileCount = projectileManager.projectiles.length - 1;
			
			mines: for (var  mineCtr:int = mineManager.mineCount; mineCtr >= 0; mineCtr--)
			{
				tempMine = mineManager.mines[mineCtr];
				tempMine.point.x = tempMine.x;
				tempMine.point.y = tempMine.y;
				
				projectiles: for (var projectileCtr:int = projectileManager.projectileCount; projectileCtr >=0; projectileCtr--)
				{
					tempProjectile = projectileManager.projectiles[projectileCtr];
					tempProjectile.point.x = tempProjectile.x;
					tempProjectile.point.y = tempProjectile.y
					
					//if (circleChecl(tempProjectile.point.x, tempMine.point.x, tempProjectile.point.y, tempMine.point.y, 8, 12,)){
					//use pixel hit because circle circle for these was causing false negatices on ship shield hit <-- jibberish -jc
					
					if (tempProjectile.bitmapData.hitTest(tempProjectile.point, 255, tempMine.bitmapData, tempMine.point,255))
					{
						//dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_MINE_EXPLODE, false, 0, 8, 1));
						createExplode(tempMine.x+16, tempMine.y + 16, particleManager.particlesPerExplode * frameRateMultiplier);
						tempMine = null;
						mineManager.mines.splice(mineCtr, 1);
						tempProjectile.frame = 0;
						projectileManager.projectilePool.push(tempProjectile);
						projectileManager.projectiles.splice(projectileCtr, 1);
						
						
						score += 5 * level;
						
						break mines;
						break projectiles;
						//trace("oh boy!");
					}
				}
				
				if (circleCheck(player.point.x, tempMine.point.x, player.point.y, tempMine.point.y, 12,12))
				{
					//dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_MINE_EXPLODE, false, 0, 8, 1));
					createExplode(tempMine.x+16, tempMine. y+16, particleManager.particlesPerExplode * frameRateMultiplier);
					tempMine = null;
					mineManager.mines.splice(mineCtr, 1);
					score += 5* level;
					
					//trace ("hit");
					if (!player.shieldRender) 
					{
						//trace("start shield");
						shield--;
						//trace("sheild=" + sheild);
						if (shield < 0)
						{
							shield = 0;
							gameOver = true;
						}
						
						else
						{
							//dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_PLAYER_HIT, false, 0, 8, 1));
							player.shieldRender = true;
							player.shieldCount = 0;
						}
					}
					
					else
					{
						//trace(sheild already started");
					}
				}
			}
			
		}
		
		
		private function render():void
		{
			canvasBitmapData.lock();
			canvasBitmapData.copyPixels(backgroundBitmapData, backgroundBitmapData.rect, point0);
			
			
			if (playerStarted)
			{
				player.render(canvasBitmapData);
			}
			
			for each (tempMine in mineManager.mines)
			{
				tempMine.render(canvasBitmapData);
			}
			
			for each (tempParticle in particleManager.particles)
			{
				tempParticle.render(canvasBitmapData);
			}
			
			for each (tempProjectile in projectileManager.projectiles)
			{
				tempProjectile.render(canvasBitmapData);
			}
			
			for each (tempParticle in playerExplosionParticles)
			{
				tempParticle.render(canvasBitmapData);
			}
			
			
			if (player.shieldRender)
			{
				//trace("render shield");
				canvasBitmapData.copyPixels(player.shieldBitmapData, player.shieldBitmapData.rect, player.point);
				
				player.shieldCount++;
				
				if (player.shieldCount > player.shieldLife)
				{
					player.shieldCount = 0;
					player.shieldRender = false;
				}
			}
			
			canvasBitmapData.unlock();
			
			
			if (playerStarted)
			{
				canvasRect.x = player.x - 200;
				canvasRect.y = player.y - 200;
				
				if (canvasRect.x < 0) canvasRect.x = 0;
				if (canvasRect.y < 0) canvasRect.y = 0;
				
				if (canvasRect.x > 399) canvasRect.x = 399;
				if (canvasRect.y > 399) canvasRect.y = 399;
				
				canvasBitmap.scrollRect = canvasRect;
			}
		}
		
				
		private function updateScoreBoard():void
		{
			customScoreBoardEventScore.value = score.toString();
			customScoreBoardEventShield.value = shield.toString();
			
			customScoreBoardEventParticlePool.value = String(particleManager.particlePool.length);
			customScoreBoardEventParticleActive.value = String(particleManager.particles.length);
			customScoreBoardEventParticleActive.value = String(projectileManager.projectilePool.length);
			customScoreBoardEventProjectileActive.value = String(projectileManager.projectiles.length);
			
			dispatchEvent(customScoreBoardEventScore);
			dispatchEvent(customScoreBoardEventShield);
			
			dispatchEvent(customScoreBoardEventParticlePool);
			dispatchEvent(customScoreBoardEventParticleActive);
			dispatchEvent(customScoreBoardEventProjectilePool);
			dispatchEvent(customScoreBoardEventProjectileActive);
			
			//Timer
			//dispatchEvent(new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_TIME_LEFT,String(timeLeft) ));
			//timeLeft = countDownTimer.seconds;
		}
		
		private function addToScore(val:Number):void
		{
			score += val;
			//dispatchEvent(new CustomEvent(CustomEvent.CUSTOMEVENT_SBUPDATE, {object:"score", value:String(score)}));
		}
		
		private function circleCheck(x1:Number, x2:Number, y1:Number, y2:Number, radius1:Number, radius2:Number):Boolean
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			return dist < radius1 + radius2;
			
		}
		
		private function createExplode(xval:Number, yval:Number, parts:int):void
		{
			for (var explodeCtr:int = 0; explodeCtr < parts; explodeCtr++)
			{
				particleManager.particlePoolCount = particleManager.particlePool.length-1;
				
				if(particleManager.particlePoolCount > 0)
				{
					//tempParticle = particleManager.particlePool[particleManager.particlePoolCount - 1];
					tempParticle = particleManager.particlePool.pop();
					//particleManager.particlePool.splice(particleManager.particlePoolCount, 1);
					//tempParticle = particleManger.particlePool.splice(particleManager.particlePoolCount, 1);
					tempParticle.lifeDelayCount = 0;
					tempParticle.x = xval;
					tempParticle.y = yval; 
					tempParticle.nextX = xval;
					tempParticle.nextY = yval;
					tempParticle.speed = (Math.random() * 3) + 1;
					tempParticle.frame = 0;
					tempParticle.animationList = particleManager.particleAnimationFrames;
					tempParticle.bitmapData = tempParticle.animationList[tempParticle.frame];
					
					var randInt:int = int(Math.random()* 359);
					
					tempParticle.dx = rotationVectorList[randInt].x;
					tempParticle.dy = rotationVectorList[randInt].y
					
					//tempParticle.dx = Math.cos(2.0 * Math.PI * ((Math.random() * 360) - 90)/360.0);
					//tempParticle.dy = Math.sin(2.0 * Math.PI * ((Math.random() * 360) - 90) / 360.0);
					tempParticle.lifeDelay = int(Math.random() * 10);
					//trace("tempParticle.lifedela = "  + tempParticle.lifedealy);
					particleManager.particles.push(tempParticle);
				}
			}
		}
		
		private function createPlayerExplode(xval:Number, yval:Number, parts:int):void
		{
			for (var explodeCtr:int = 0; explodeCtr < parts; explodeCtr++)
			{
				var tempParticle: BasicBlitArrayParticle = new BasicBlitArrayParticle(0, 799, 0, 799);
				tempParticle.lifeDelayCount = 0;
				tempParticle.x = xval;
				tempParticle.y = yval;
				tempParticle.nextX = xval;
				tempParticle.nextY = yval;
				tempParticle.speed = (Math.random() * 10) + 1;
				tempParticle.frame = 0;
				tempParticle.animationList = projectileManager.projectileAnimationFrames;
				tempParticle.bitmapData = tempParticle.animationList[tempParticle.frame];
				
				var randInt:int = int(Math.random() * 359);
				tempParticle.dx = rotationVectorList[randInt].x;
				tempParticle.dy = rotationVectorList[randInt].y;
				tempParticle.lifeDelay = int(Math.random() * 5);
				playerExplosionParticles.push(tempParticle);
			}
		}
		
		private function disposeAll():void
		{
			particleManager.particleCount = particleManager.particles.length-1;
			
			for (var ctr:int = particleManager.particleCount; ctr >=0; ctr--)
			{
				tempParticle = particleManager.particles.pop();
				tempParticle.frame = 0;
				particleManager.particlePool.push(tempParticle);
			}
			
			for (ctr = 0; ctr < mineManager.mineAnimationFrames.length; ctr++)
			{
				mineManager.mineAnimationFrames[ctr].dispose();
			}
			
			mineManager.mineAnimationFrames = null;
			mineManager.mines = null;
			mineManager.mineBitmapData = null;
			
			for (ctr = 0; ctr < particleManager.particleAnimationFrames.length; ctr++)
			{
				particleManager.particleAnimationFrames[ctr].dispose();
			}
			
			particleManager.particleAnimationFrames = null;
			particleManager.particleBitmapData = null;
			particleManager.particlePool = null;
			
			trace("disposed");
			
			if (gameOver)
			{
				//timer
				//countDownTimer.removeEventListener(BasicFrameTimer.TIME_IS_UP, timesUpListener);
				
				playerExplosionParticles = null;
			}
		}
		
		private function timesUpListener(e:Event):void
		{
			//countDownTimer.stop();
			gameOver = true;
		}
		
	}
	
}

