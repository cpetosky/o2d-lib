package net.petosky.metaplay {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;		

	/**
	 * @author Cory Petosky
	 */
	public class RenderableMovieClip extends RenderableContainer {
		
		private var _frame:Counter;
		private var _frameToSwitch:int = -1;
		
		private var _source:CachedMovieClip;
		
		private var _state:State;
		
		private var _collisionCache:Array;

		private var _leftBoundary:int; 
		private var _rightBoundary:int;
		private var _topBoundary:int;
		private var _bottomBoundary:int;
		
		/**
		 * @private
		 */
		public function RenderableMovieClip(source:CachedMovieClip, frameRate:uint) {
			super(source.width, source.height);
			
			_frame = new Counter(frameRate);
			attach(_frame);
			
			_source = source;
			_state = source.defaultState;
			_collisionCache = _source.collisionCache;
			collisionObject = currentCachedCollision;
		}

		override public function update(delta:uint):void {
			super.update(delta);
			
			if (_frame.value == _frameToSwitch)
				state = _state.next;
			
			
			collisionObject = currentCachedCollision;
		}
		
		override public function draw(target:BitmapData, destPoint:Point):void {
			if (currentCachedFrame != null) {
				target.copyPixels(currentCachedFrame, currentCachedRectangle, destPoint, null, null, true);
			}
		}
		
		public function get state():String {
			return _state.name;
		}
		public function set state(value:String):void {
			_state = _source.states[value] || _source.defaultState;
			_frame.value = 0;
			if (_state.repeat > 0)
				_frameToSwitch = _state.length * _state.repeat;
			else
				_frameToSwitch = -1;
		}

		
		
		private function get cacheIndex():uint {
			return _state.start + (_frame.value % _state.length);
		}
		
		private function get currentCachedFrame():BitmapData {
			return _source.bitmapCache[cacheIndex];
		}
		
		private function get currentCachedRectangle():Rectangle {
			return _source.renderCache[cacheIndex];
		}
		
		private function get currentCachedCollision():Rectangle {
			return _collisionCache[cacheIndex];
		}

		
		public function get frameRate():uint {
			return _frame.rate;
		}
		public function set frameRate(value:uint):void {
			_frame.rate = value;
		}

		
		public function get leftBoundary():int {
			return _leftBoundary;
		}
		public function set leftBoundary(value:int):void {
			var change:int = value - _leftBoundary;
			fixCollisionCache("x", -change);
			fixCollisionCache("width", change);
			_leftBoundary = value;
		}


		
		public function get rightBoundary():int {
			return _rightBoundary;
		}
		public function set rightBoundary(value:int):void {
			fixCollisionCache("width", value - _rightBoundary);
			_rightBoundary = value;
		}


		
		public function get topBoundary():int {
			return _topBoundary;
		}
		public function set topBoundary(value:int):void {
			var change:int = value - _topBoundary;
			fixCollisionCache("y", -change);
			fixCollisionCache("height", change);
			_topBoundary = value;
		}


		
		public function get bottomBoundary():int {
			return _bottomBoundary;
		}
		public function set bottomBoundary(value:int):void {
			fixCollisionCache("height", value - _bottomBoundary);
			_bottomBoundary = value;
		}

		
		
		private function fixCollisionCache(property:String, value:int):void {
			for each (var rect:Rectangle in _collisionCache)
				if (rect)
					rect[property] += value;
		}		
	}
}