package net.petosky.metaplay {
	import flash.events.Event;
	import flash.events.EventDispatcher;		

	/**
	 * <p>
	 * The MovieClipManager singleton is used to load and instantiate MovieClips
	 * and convert them to bitmaps for use in Metaplay autmatically. You should
	 * call cacheClips in your BaseGame's preload handler to ensure that all
	 * your art is available immediately when requested in-game.
	 * </p><p>
	 * This class automatically parses MovieClips into stateful objects using a
	 * special frame label syntax: <code>stateName#repeatCount->nextState</code>
	 * </p>
	 * 
	 * @author Cory Petosky
	 */
	public class MovieClipManager extends EventDispatcher {
		private static var __instance:MovieClipManager;
		
		public static function get instance():MovieClipManager {
			if (!__instance)
				__instance = new MovieClipManager(new SingletonEnforcer());
			return __instance;
		}
		
		private var _clipsToCache:int = 0;
		private var _cachedClips:Object = {}; // MovieClip (Class) -> CachedMovieClip
		
		public function MovieClipManager(enforcer:SingletonEnforcer) {
			
		}
		
		
		
		public function cacheClips(...args):void {
			_clipsToCache += args.length;
			for (var i:uint = 0, n:uint = args.length; i < n; ++i) {
				var klass:Class = args[i] as Class;
								
				var cache:CachedMovieClip = new CachedMovieClip();
				cache.addEventListener(Event.COMPLETE, cacheCompleteListener);
				cache.cache(new klass());
				_cachedClips[klass] = cache;
			}
		}
		
		public function instantiate(klass:Class, frameRate:uint):RenderableMovieClip {
			return new RenderableMovieClip(_cachedClips[klass], frameRate);
		}

		
		
		private function cacheCompleteListener(event:Event):void {
			if (--_clipsToCache == 0) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}

class SingletonEnforcer { }