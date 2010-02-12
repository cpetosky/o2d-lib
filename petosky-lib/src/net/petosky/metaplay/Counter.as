package net.petosky.metaplay {
	
	/**
	 * <p>
	 * A Counter is used to track updates based on time to a numerical
	 * value. By creating and attaching a Counter, you can have a simple,
	 * referencable integral timer that acts like any other Renderable --
	 * just attach it and it works.
	 * </p>
	 * 
	 * @author Cory Petosky
	 */
	public class Counter extends Renderable {
		
		public static const PER_SECOND:int = 1000;
		public static const PER_MINUTE:int = 60 * PER_SECOND;
		public static const PER_HOUR:int = 60 * PER_MINUTE;
		public static const PER_DAY:int = 24 * PER_HOUR;
		
		private var _rate:int; // units ...
		private var _per:int; // ...per (this many) milliseconds
		private var _counter:int = 0;
		private var _value:int = 0;
		
		private var _limited:Boolean = false;
		private var _to:int;
		
		public function Counter(rate:int, per:int = PER_SECOND) {
			super(0, 0);
			_rate = rate;
			_per = per;
			_value = value;
		}
		
		override public function update(delta:uint):void {
			_counter += int(_rate * delta);
			_value += int(_counter / _per);
			
			_counter %= _per;
			
			if (_limited && _value > _to)
				_value = _to;
		}

		
		
		public function get value():int {
			return _value;
		}
		public function set value(value:int):void {
			_value = value;
			_counter = 0;
		}
		
		
		
		public function get rate():int {
			return _rate;
		}
		public function set rate(value:int):void {
			_rate = value;
		}
		
		
		
		public function get to():int {
			return _to;
		}
		public function set to(value:int):void {
			_limited = true;
			_to = value;
		}
	}
}
