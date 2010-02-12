package net.petosky.metaplay {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;		

	/**
	 * <p>
	 * Your main class should extend this if you intend to use the Metaplay
	 * framework. This class contains all the behind-the-scenes code used to
	 * make Metaplay automatically work.
	 * </p><p>
	 * Be sure to explicitly call the super constructor from your main!
	 * </p><p>
	 * I suppose you could also instantiate this and add it as a child, with
	 * all your metaplay-enabled stuff below it, but it's untested and
	 * probably harder than just extending it.
	 * </p>
	 * @author Cory Petosky
	 */
	public class BaseGame extends Sprite {
		private var FILL_ALL:Rectangle;

		private var _screenData:BitmapData;
		private var _screen:Bitmap;
		
		private var _baseColor:uint;
		private var _gameState:GameState;
		
		private var _container:RenderableContainer;
		
		private var _thingsToPreload:int = 0;
		private var _initComplete:Boolean = false;
		
		private var _lastFrame:uint = 0;

		
		/**
		 * Sets the width, height, and background color of your game.
		 * 
		 * @param width width (in pixels)
		 * @param height height (in pixels)
		 * @param baseColor background color of game (ARGB hex format)
		 */
		public function BaseGame(width:uint, height:uint, baseColor:uint = 0xFFCCAAFF) {
			_container = new RenderableContainer(width, height);
			_screenData = new BitmapData(width, height, true, baseColor);
			_baseColor = baseColor;
			
			FILL_ALL = new Rectangle(0, 0, width, height);
			
			addEventListener(Event.ADDED_TO_STAGE, stageListener);
		}
		
		private function stageListener(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageListener);
			
			_gameState = new GameState(stage);
			_container.setGameState(_gameState);
			
			_screen = new Bitmap(_screenData);
			addChild(_screen);
			
			if (!_thingsToPreload && !_initComplete)
				init();
		}

		
		
		private function frameListener(event:Event):void {
			var delta:uint = getTimer() - _lastFrame;
			_lastFrame = getTimer();
			_screenData.fillRect(FILL_ALL, 0xFFCCAAFF);

			update(delta);
			draw(_screenData, new Point());
		}
		
		
		/**
		 * Ensures all objects passed in are preloaded before beginning the
		 * main update/draw loop. The preloader expects each object passed
		 * in to dispatch Event.COMPLETE.
		 * 
		 * If an object fails to eventually dispatch Event.COMPLETE, your
		 * game will never start.
		 * 
		 * @param args All objects you wish to preload
		 */
		public function preload(...args):void {
			_thingsToPreload += args.length;
			for each (var eventDispatcher:IEventDispatcher in args)
				eventDispatcher.addEventListener(Event.COMPLETE, preloadCompleteListener);
		}
		
		private function preloadCompleteListener(event:Event):void {
			if (--_thingsToPreload == 0 && !_initComplete)
				init();
		}

		
		/**
		 * Called when game is preloaded and ready to initialize your data. You
		 * can override this to provide custom init functionality, but you MUST
		 * call super.init() or your game will not function.
		 */
		public function init():void {
			_initComplete = true;
			addEventListener(Event.ENTER_FRAME, frameListener);		
		}
		
		/**
		 * @see RenderableContainer.attach
		 */
		final public function attach(renderable:Renderable, point:Point = null):void {
			trace("Attaching to baseGame, _gameState:", _gameState);
			point ||= new Point(0, 0);
			_container.attach(renderable, point);
		}
		
		/**
		 * @see Renderable.update
		 */
		public function update(delta:uint):void {
			gameState.$commandGroup = GameState.$NO_COMMAND_GROUP_YET;
			_container.update(delta);
		}
		
		/**
		 * @see Renderable.draw
		 */
		public function draw(target:BitmapData, destPoint:Point):void {
			target.fillRect(FILL_ALL, _baseColor);
			_container.draw(target, destPoint);
		}
		
		
		
		/**
		 * @see Renderable.gameState
		 */
		public function get gameState():GameState {
			return _gameState;
		}
	}
}

