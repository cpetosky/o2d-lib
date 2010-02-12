package net.petosky.metaplay {
	import net.petosky.bitmap.convertSpriteToBitmapData;
	
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;		

	/**
	 * @author Cory Petosky
	 */
	internal class CachedMovieClip extends EventDispatcher {
		
		private var _source:MovieClip;
		private var _states:Object = {};
		private var _defaultState:State;
		
		private var _width:uint;
		private var _height:uint;
		
		private var _cacheThisFrame:Boolean = false;

		private var _bitmapCache:Array = [];
		private var _collisionCache:Array = [];
		private var _renderCache:Array = [];
		

		public function cache(clip:MovieClip):void {
			clip.gotoAndStop(1);
			clip.addEventListener(Event.ENTER_FRAME, frameListener);
			
			_source = clip;
			
			// Initialize states
			var labels:Array = _source.currentLabels;
			if (labels.length == 0)
				labels.push(new FrameLabel("default", 1));
			
			var lastState:State;
			for each (var label:FrameLabel in labels) {
				if (lastState)
					lastState.length = label.frame - lastState.start;
				
				lastState = new State(label.frame, label.name);

				// Parse name for #<quantity>-><nextState>
				var tokens:Array = label.name.split("#");
				if (tokens.length > 1) {
					tokens[1] = tokens[1].split("->");
					lastState.name = tokens[0];
					lastState.repeat = parseInt(tokens[1][0]);
					lastState.next = tokens[1][1];
				}
				
				if (!_defaultState) {
					_defaultState = lastState;
				}
				
				_states[lastState.name] = lastState;
			}
			lastState.length = _source.totalFrames - lastState.start + 1;
		}
		
		private function frameListener(event:Event):void {
			if (_cacheThisFrame) {
				var cacheIndex:int = _source.currentFrame;
				
				// Cache new bitmap and its data
				if (!_bitmapCache[cacheIndex]) {
					var bitmap:BitmapData = convertSpriteToBitmapData(_source);
					_bitmapCache[cacheIndex] = bitmap;
	
					_collisionCache[cacheIndex] = _source.getBounds(_source);
//					
//					collisionRect.x -= _leftBoundary;
//					collisionRect.width += _rightBoundary + _leftBoundary;
//					collisionRect.y -= _topBoundary;
//					collisionRect.height += _bottomBoundary + _topBoundary;
//					 = collisionRect;
					
					_renderCache[cacheIndex] = new Rectangle(
						0, 0,
						bitmap.width,
						bitmap.height
					);
					
					if (bitmap.width > _width)
						_width = bitmap.width;
						
					if (bitmap.height > _height)
						_height = bitmap.height;
				}
			
				if (_source.currentFrame < _source.totalFrames) {	
					_source.gotoAndStop(_source.currentFrame + 1);
				} else {
					_source.removeEventListener(Event.ENTER_FRAME, frameListener);
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
			
			_cacheThisFrame = !_cacheThisFrame;
		}
		
		
		
		public function get defaultState():State {
			return _defaultState;
		}
		
		
		
		public function get bitmapCache():Array {
			return _bitmapCache.concat();
		}
		
		
		
		public function get collisionCache():Array {
			var copy:Array = [];
			for each (var rect:Rectangle in _collisionCache)
				copy.push(rect.clone());
			return copy;
		}
		
		
		
		public function get renderCache():Array {
			return _renderCache.concat();
		}
		
		
		
		public function get states():Object {
			return _states;
		}
		
		
		
		public function get width():uint {
			return _width;
		}
		
		
		
		public function get height():uint {
			return _height;
		}
	}
}
