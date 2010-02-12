package net.petosky.metaplay {
	import flash.geom.Matrix;	
	import flash.geom.Rectangle;	
	import flash.geom.Point;	
	import flash.display.BitmapData;	
	
	/**
	 * @author Cory Petosky
	 */
	public class RenderableBitmap extends Renderable {
		
		private var _pristineSource:BitmapData;
		private var _source:BitmapData;
		private var _sourceRect:Rectangle;
		
		private var _scaleX:Number = 1.0;
		private var _scaleY:Number = 1.0;
		
		public function RenderableBitmap(source:BitmapData) {
			super(source.width, source.height);
			_pristineSource = _source = source;
			_sourceRect = new Rectangle(0, 0, source.width, source.height);
		}
		
		override public function draw(target:BitmapData, destPoint:Point):void {
			if (_scaleX > 0 && _scaleY > 0)
				target.copyPixels(_source, _sourceRect, destPoint, null, null, true);
		}
		
		
		private function redrawSource():void {
			if (_scaleX > 0 && _scaleY > 0) {
				_source = new BitmapData(_pristineSource.width * _scaleX, _pristineSource.height * _scaleY, true, 0);
				_source.draw(_pristineSource, new Matrix(_scaleX, 0, 0, _scaleY));
				_sourceRect = new Rectangle(0, 0, _source.width, _source.height);
			}
		}
		
		
		
		override public function get width():int {
			return _source.width;
		}
		override public function set width(value:int):void {
			_scaleX = value / _pristineSource.width;
			redrawSource();
		}
		
		
		
		override public function get height():int {
			return _source.height;
		}
		override public function set height(value:int):void {
			_scaleY = value / _pristineSource.height;
			redrawSource();
		}

		
		
		public function get scaleX():Number {
			return _scaleX;
		}
		public function set scaleX(value:Number):void {
			_scaleX = value;
			redrawSource();
		}
		
		
		
		public function get scaleY():Number {
			return _scaleY;
		}
		public function set scaleY(value:Number):void {
			_scaleY = value;
			redrawSource();
		}
	}
}
