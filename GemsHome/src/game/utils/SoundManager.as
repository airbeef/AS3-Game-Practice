package game.utils
{
	import flash.media.AudioPlaybackMode;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.getTimer;
	
	import starling.animation.Tween;
	import starling.core.Starling;

	public class SoundManager
	{
		public function SoundManager()
		{
			if(_instance) throw new Error("只能有一个实例 ");
			_instance = this ;
			SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
		}
		
		private static var _instance:SoundManager;
		public static function get instance():SoundManager
		{
			if(!_instance) _instance = new SoundManager();
			return _instance;
		}
		//===============================================
		
		[Embed(source="/../assets/sounds/click.mp3")]
		private const CLICK:Class
		[Embed(source="/../assets/sounds/loop.mp3")]
		private const LOOP:Class;
		[Embed(source="/../assets/sounds/endgame.mp3")]
		private const ENDGAME:Class;
		[Embed(source="/../assets/sounds/bomb.mp3")]
		private const BOMB:Class;
		[Embed(source="/../assets/sounds/tap-0.mp3")]
		private const TAP:Class;
		[Embed(source="/../assets/sounds/timer.mp3")]
		private const TIMER:Class;
		[Embed(source="/../assets/sounds/miss.mp3")]
		private const MISS:Class;
		[Embed(source="/../assets/sounds/gem-0.mp3")]
		private const GEM0:Class;
		[Embed(source="/../assets/sounds/gem-1.mp3")]
		private const GEM1:Class;
		[Embed(source="/../assets/sounds/gem-2.mp3")]
		private const GEM2:Class;
		[Embed(source="/../assets/sounds/gem-3.mp3")]
		private const GEM3:Class;
		[Embed(source="/../assets/sounds/gem-4.mp3")]
		private const GEM4:Class;
		
		private var _clickSound:Sound ;
		private var _loopSound:Sound;
		private var _endGameSound:Sound;
		private var _bombSound:Sound;
		private var _tapSound:Sound;
		private var _timerSound:Sound;
		private var _missSound:Sound;
		private var _gem0Sound:Sound;
		private var _gem1Sound:Sound;
		private var _gem2Sound:Sound;
		private var _gem3Sound:Sound;
		private var _gem4Sound:Sound;
		
		public function playGem0():void
		{
			if(!_gem0Sound) _gem0Sound = new GEM0();
			_gem0Sound.play();
		}
		public function playGem1():void
		{
			if(!_gem1Sound) _gem1Sound = new GEM1();
			_gem1Sound.play();
		}
		public function playGem2():void
		{
			if(!_gem2Sound) _gem2Sound = new GEM2();
			_gem2Sound.play();
		}
		public function playGem3():void
		{
			if(!_gem3Sound) _gem3Sound = new GEM3();
			_gem3Sound.play();
		}
		public function playGem4():void
		{
			if(!_gem4Sound) _gem4Sound = new GEM4();
			_gem4Sound.play();
		}
		public function playMiss():void
		{
			if(!_missSound) _missSound = new MISS();
			_missSound.play();
		}
		public function playClick():void
		{
			if(!_clickSound) _clickSound = new CLICK();
			_clickSound.play();
		}
		private var _loopChannel:SoundChannel;
		public function playLoop():void
		{
			if(!_loopSound) _loopSound = new LOOP();
			if(!_loopChannel){
				_loopChannel = _loopSound.play(0,int.MAX_VALUE);
			}else{
				var transform:SoundTransform =  _loopChannel.soundTransform;
				var tween:Tween = new Tween(transform,0.5);
				tween.animate("volume",1);
				tween.onUpdate = function():void{
					_loopChannel.soundTransform = transform ;
				};
				Starling.juggler.add(tween);
			}
		}
		public function stopLoop():void
		{
			var transform:SoundTransform =  _loopChannel.soundTransform;
			var tween:Tween = new Tween(transform,0.5);
			tween.animate("volume",0);
			tween.onUpdate = function():void{
				_loopChannel.soundTransform = transform ;
			};
			Starling.juggler.add(tween);
		}
		
		public function playEndGame():void
		{
			if(!_endGameSound) _endGameSound = new ENDGAME();
			_endGameSound.play();
		}
		public function playBomb():void
		{
			if(!_bombSound) _bombSound = new BOMB();
			_bombSound.play();
		}
		private var _tapTime:int ;
		public function playTap():void
		{
			if(!_tapSound) _tapSound = new TAP();
			if(getTimer()-_tapTime>100){
				_tapTime = getTimer();
				_tapSound.play();
			}
		}
		private var _timerChannel:SoundChannel; 
		public function playTimer():void
		{
			if(!_timerSound) _timerSound = new TIMER();
			_timerChannel = _timerSound.play(0,int.MAX_VALUE);
		}
		public function stopTimer():void{
			if(_timerChannel){
				_timerChannel.stop();
			}
		}
	}
}