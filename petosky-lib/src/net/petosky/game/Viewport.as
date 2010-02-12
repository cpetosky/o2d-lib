package net.petosky.game {
	import net.petosky.util.NumberUtils;	
	
	/**
	 * A Viewport defines a rectangular region within a larger space. It
	 * provides functionality to scroll itself as part of a larger game update
	 * cycle, in both frame-based and time-based games.
	 * 
	 * Most usages of Viewport interpret its properties as direct pixel values,
	 * to be used directly within a custom renderer. However, this is not
	 * required -- the units used within a Viewport are purposely undefined,
	 * and can be any integral value, like cells, tiles, or regions, instead of
	 * literal pixels.
	 * 
	 * This class should _not_ be used with a "tweener" class. It has its own
	 * in-betweening functionality that uses the existing game loop to
	 * function.
	 * 
	 * @author Cory Petosky
	 */
	public class Viewport {
		private var _width:int;
		private var _height:int;
		private var _x:int;
		private var _y:int;
		
		private var _xScrollRate:Number;
		private var _xScrollCounter:int;
		private var _xGoal:int;
		private var _xMin:int = int.MIN_VALUE;
		private var _xMax:int = int.MAX_VALUE;
		
		private var _yScrollRate:Number;
		private var _yScrollCounter:int;
		private var _yGoal:int;
		private var _yMin:int = int.MIN_VALUE;
		private var _yMax:int = int.MAX_VALUE;

		/**
		 * Constructs a new Viewport with the specified parameters.
		 * 
		 * @param width The width of the viewport.
		 * @param height The height of the viewport.
		 * @param x The x-position of the viewport within the larger gamespace.
		 * @param y The y-position of the viewport within the larger gamespace.
		 */
		public function Viewport(width:int, height:int, x:int = 0, y:int = 0) {
			_width = width;
			_height = height;
			_x = _xGoal = x;
			_y = _yGoal = y;
		}
		
		/**
		 * The width of the viewport.
		 */
		public function get width():int {
			return _width;
		}
		public function set width(value:int):void {
			_width = value;
		}
		
		
		
		/**
		 * The height of the viewport.
		 */
		public function get height():int {
			return _height;
		}
		public function set height(value:int):void {
			_height = value;
		}
		
		
		
		/**
		 * The x-position of the viewport, within the larger gamespace.
		 * 
		 * If xScrollRate is non-zero, setting this property does not cause it
		 * to immediately change. Instead, it will gradually shift to the value
		 * set over repeated update calls.
		 * 
		 * @see update
		 */
		public function get x():int {
			return _x;
		}
		public function set x(value:int):void {
			if (_xScrollRate)
				_xGoal = NumberUtils.clamp(_xMin, value, _xMax);
			else
				_x = NumberUtils.clamp(_xMin, value, _xMax);
		}
		
		

		/**
		 * The minimum value that x can take. Attempts to set x to a lower
		 * value will instead set x to the value of this property.
		 * 
		 * Default is int.MIN_VALUE.
		 */		
		public function get xMin():int {
			return _xMin;
		}
		public function set xMin(value:int):void {
			_xMin = value;
			if (_x < _xMin)
				_x = _xMin;
		}
		


		/**
		 * The maximum value that x can take. Attempts to set x to a higher
		 * value will instead set x to the value of this property.
		 * 
		 * Default is int.MAX_VALUE.
		 */		
		public function get xMax():int {
			return _xMax;
		}
		public function set xMax(value:int):void {
			_xMax = value;
			if (_x > _xMax)
				_x = _xMax;
		}



		/**
		 * The y-position of the viewport, within the larger gamespace.
		 * 
		 * If yScrollRate is non-zero, setting this property does not cause it
		 * to immediately change. Instead, it will gradually shift to the value
		 * set over repeated update calls.
		 * 
		 * @see update
		 */
		public function get y():int {
			return _y;
		}
		public function set y(value:int):void {
			if (_yScrollRate)
				_yGoal = NumberUtils.clamp(_yMin, value, _yMax);
			else
				_y = NumberUtils.clamp(_yMin, value, _yMax);
		}
		
		
		
		/**
		 * The minimum value that y can take. Attempts to set y to a lower
		 * value will instead set y to the value of this property.
		 * 
		 * Default is int.MIN_VALUE.
		 */		
		public function get yMin():int {
			return _yMin;
		}
		public function set yMin(value:int):void {
			_yMin = value;
			if (_y < _yMin)
				_y = _yMin;
		}


		
		/**
		 * The maximum value that y can take. Attempts to set y to a higher
		 * value will instead set y to the value of this property.
		 * 
		 * Default is int.MAX_VALUE.
		 */		
		public function get yMax():int {
			return _yMax;
		}
		public function set yMax(value:int):void {
			_yMax = value;
			if (_y > _yMax)
				_y = _yMax;
		}
		
		
		/**
		 * The scroll rate along the x-axis. A value of 0 disables scrolling
		 * and causes updates to the x property to immediately propagate.
		 * 
		 * @see scrollRate
		 */
		public function get xScrollRate():Number {
			return _xScrollRate;
		}
		public function set xScrollRate(value:Number):void {
			_xScrollRate = value;
			if (_xScrollRate == 0 && _x != _xGoal)
				_x = _xGoal;
		}
		
		
		
		/**
		 * The scroll rate along the y-axis. A value of 0 disables scrolling
		 * and causes updates to the y property to immediately propagate.
		 * 
		 * @see scrollRate
		 */
		public function get yScrollRate():Number {
			return _yScrollRate;
		}
		public function set yScrollRate(value:Number):void {
			_yScrollRate = value;
			if (_yScrollRate == 0 && _y != _yGoal)
				_y = _yGoal;
		}

		/**
		 * The scroll rate for both axes. This is a write-only property, as
		 * the scroll rates for each axis can be different.
		 * 
		 * Non-zero values are interpreted differently depending on how the
		 * update method is used. A frame-based game treats scroll rate as
		 * units per frame. A time-based game treats scroll rate as units per
		 * second. In other words, with a scroll rate of 7, a frame-based game 
		 * will scroll 7 pixels every frame, whereas a time-based game will
		 * scroll 7 pixels every second. In general, this means that scroll
		 * rates for frame-based games will usually be an order of magnitude
		 * smaller than for time-based games.
		 * 
		 * @see update
		 */
		public function set scrollRate(value:Number):void {
			xScrollRate = yScrollRate = value;
		}
		
		
		
		/**
		 * Processes scrolling based on a frame update or time interval.
		 * 
		 * A call to this function should be placed in the main game loop.
		 * It can work in two modes -- frame-based and time-based. For a
		 * frame-based game, call this function with no parameters. For a
		 * time-based game, pass in the number of milliseconds since the last
		 * game loop iteration.
		 * 
		 * @param delta number of milliseconds since last loop
		 */
		public function update(delta:uint = 1000):void {
			_xScrollCounter += _xScrollRate * delta;
			if (_xScrollCounter > 1000) {
				var xScroll:int = int(_xScrollCounter / 1000);
				_x = scroll(_x, _xGoal, xScroll);
				_xScrollCounter -= xScroll;
			}
				
			_yScrollCounter += _yScrollRate * delta;
			if (_yScrollCounter > 1000) {
				var yScroll:int = int(_yScrollCounter / 1000);
				_y = scroll(_y, _yGoal, yScroll);
				_yScrollCounter -= yScroll;
			}
		}
		
		private function scroll(loc:int, locGoal:int, locScrollRate:int):int {
			if (loc == locGoal) {
				return loc;
			} else {
				if (loc < locGoal)
					return Math.min(loc + locScrollRate, locGoal);
				else
					return Math.max(loc - locScrollRate, locGoal);
			}
		}
	}
}
