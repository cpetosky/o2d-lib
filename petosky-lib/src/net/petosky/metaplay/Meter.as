package net.petosky.metaplay {
	import flash.display.BitmapData;	
	
	/**
	 * <p>
	 * A Meter is used to draw a bar or line based upon a ratio, like progress
	 * or power meters.
	 * </p>
	 * 
	 * @author Cory Petosky
	 */
	public class Meter extends RenderableContainer {
		
		private var _background:Renderable;
		private var _foreground:Renderable;
		private var _filler:RenderableBitmap;
		
		private var _value:uint;
		private var _max:uint;
		private var _barWidth:int;
		private var _barHeight:int;
		
		public function Meter(background:Renderable, foreground:Renderable, filler:uint, max:uint) {
			super(foreground.width, foreground.height);
			
			_background = background;
			_foreground = foreground;
			_barWidth = _background.width;
			_barHeight = _background.height;
			
			_filler = new RenderableBitmap(new BitmapData(_background.width, _background.height, false, filler));
			_filler.width = 0;
			_max = max;
			
			attach(_background);
			attach(_filler);
			attach(_foreground);
		}
		
		public function get barX():int {
			return _filler.x;
		}
		public function set barX(value:int):void {
			_filler.x = value;
		}
		
		public function get barY():int {
			return _filler.y;
		}
		public function set barY(value:int):void {
			_filler.y = value;
		}
		
		public function get barWidth():int {
			return _barWidth;
		}
		public function set barWidth(value:int):void {
			_barWidth = value;
		}
		
		
		
		
		
		public function get barHeight():int {
			return _barHeight;
		}
		public function set barHeight(newValue:int):void {
			_barHeight = newValue;
			_filler.height = newValue;
		}



		public function get value():uint {
			return _value;
		}
		public function set value(newValue:uint):void {
			_value = newValue;
			_filler.width = _barWidth * (_value / _max);
		}
		
	}
}
