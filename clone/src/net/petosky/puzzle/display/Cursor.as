package net.petosky.puzzle.display {
	import flash.filters.GlowFilter;	
	import flash.display.Sprite;	
	import flash.display.BitmapData;	
	/**
	 * @author Cory
	 */
	public class Cursor {
		private var _data:BitmapData;
		private var _row:uint = 0;
		private var _column:uint = 0;
		
		public function Cursor(blockSize:uint) {
			_data = new BitmapData(blockSize << 1, blockSize, true, 0);
			
			var width:uint = blockSize >> 2;
			var s:Sprite = new Sprite();
			with (s.graphics) {
				lineStyle(width,0xFFFFFF);
				moveTo(0, width);
				lineTo(0, 0);
				lineTo(width, 0);
				
				moveTo(0, blockSize - width - 1);
				lineTo(0, blockSize - 1);
				lineTo(width, blockSize - 1);
				
				var rightEnd:uint = blockSize << 1;
				moveTo(rightEnd - width - 1, 0);
				lineTo(rightEnd - 1, 0);
				lineTo(rightEnd - 1, width);
				
				moveTo(rightEnd - width - 1, blockSize - 1);
				lineTo(rightEnd - 1, blockSize - 1);
				lineTo(rightEnd - 1, blockSize - width - 1);
			}
			var f:Array = s.filters;
			f.push(new GlowFilter(0x666666));
			s.filters = f;
			
			_data.draw(s);
		}
		
		public function get bitmap():BitmapData {
			return _data;
		}
		
		public function get row():uint {
			return _row;
		}
		public function set row(value:uint):void {
			_row = value;
		}
		
		public function get column():uint {
			return _column;
		}
		public function set column(value:uint):void {
			_column = value;
		}
	}
}
