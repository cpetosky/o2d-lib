package net.petosky.dungeon.display {
	import flash.utils.Timer;	
	import flash.events.TimerEvent;	
	import flash.filters.GlowFilter;	
	
	import flash.text.TextField;	
	
	/**
	 * @author Cory Petosky
	 */
	public class StatField extends TextField {
		
		private var _value:int;
		private var _maxValue:int;
		
		private var _first:Boolean = true;
		private var _glowTimer:Timer;

		public function StatField() {
			_glowTimer = new Timer(3000);
			_glowTimer.addEventListener(TimerEvent.TIMER, glowCompleteListener);
		}

		public function get value():int {
			return _value;
		}
		public function set value(newValue:int):void {
			if (_first) {
				_value = newValue;
				update();
				_first = false;		
			} else {
				var diff:int = newValue - _value;
				if (diff) {
					_value = newValue;
					update();
					appendText(" (");

					if (diff > 0) {
						appendText("+");
						filters = [new GlowFilter(0xFF00FF00)];
					} else {
						filters = [new GlowFilter(0xFFFF0000)];
					}

					appendText(diff + ")");
					
					_glowTimer.reset();
					_glowTimer.start();
				}
			}
		}
		
		private function update():void {
			text = "" + _value;
			if (_maxValue)
				appendText("/" + _maxValue);
		}
		
		private function glowCompleteListener(event:TimerEvent):void {
			update();
			_glowTimer.stop();
			filters = [];
		}
		
		
		
		public function get maxValue():int {
			return _maxValue;
		}
		public function set maxValue(newValue:int):void {
			if (_maxValue != newValue) {
				_maxValue = newValue;
				update();
			}
		}
	}
}
