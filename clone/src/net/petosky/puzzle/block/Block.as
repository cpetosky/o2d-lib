package net.petosky.puzzle.block {
	import flash.geom.Matrix;	
	import flash.display.BitmapData;
	
	import net.petosky.puzzle.block.IBlock;	

	/**
	 * @author Cory
	 */
	public class Block implements IBlock {
		public static const EMPTY:IBlock = new EmptyBlock();
		private var _data:BlockGraphics;
		
		private var _dead:Boolean = false;
		private var _moving:Boolean = false;
		private var _blowupTimer:int = 0;
		private var _beingRemoved:Boolean = false;
		
		private var _size:Number;
		private var _xOffset:int = 0;
		private var _yOffset:int = 0;
		
		private var _group:BlockGroup;
		
		public function Block(data:BlockGraphics) {
			_data = data;
			_size = 1;
		}
		
		public function get empty():Boolean {
			return false;
		}
		
		public function get bitmap():BitmapData {
			if (_dead) {
				var b:BitmapData = _data.marked;
				if (size != 1) {
					var m:Matrix = new Matrix(_size, 0, 0, _size, (1 - _size) * _data.width / 2, (1 - _size) * _data.width / 2);
					var q:BitmapData = new BitmapData(_data.width, _data.height, true, 0);
					q.draw(b, m);
					return q;
				}
				return b;
			} else
				return _data;
		}
		
		public function matches(block:IBlock):Boolean {
			var b:Block = block as Block;
			
			if (!b || _moving || b.moving || 
				(_dead && _beingRemoved) || (b._dead && b._beingRemoved)
			)
				return false;
			else
				return (_data === b._data);
		}
		
		public function get canMove():Boolean {
			return !(_moving || _dead || _beingRemoved);
		}
		
		public function markForRemoval(timer:uint):Boolean {
			if (_dead)
				return false;
			
			_dead = true;
			_blowupTimer = timer;
			
			return true;
		}
		
		public function get markedForRemoval():Boolean {
			return _dead;
		}
		
		
		/**
		 * Passes time in the internal blowup timer. If the timer fires this
		 * frame, return true.
		 */
		public function passTime(time:int):Boolean {
			if (_blowupTimer <= 0)
				return false;
			_blowupTimer -= time;
			_beingRemoved = true;
			return (_blowupTimer <= 0);
		}
		
		
		public function fall(time:int):Boolean {
			_yOffset += _data.height / 3;
			if (_yOffset >= _data.height) {
				_yOffset = 0;
				return true;
			} else {
				return false;
			}
		}

		public function get size():Number {
			return _size;
		}
		public function set size(value:Number):void {
			_size = value;
		}
		
		public function get xOffset():int {
			return _xOffset;
		}
		public function set xOffset(value:int):void {
			_xOffset = value;
		}
		
		public function get yOffset():int {
			return _yOffset;
		}
		public function set yOffset(value:int):void {
			_yOffset = value;
		}
		
		
		public function get group():BlockGroup {
			return _group;
		}
		public function set group(value:BlockGroup):void {
			_group = value;
		}
		
		public function get moving():Boolean {
			return _moving;
		}
		public function set moving(value:Boolean):void {
			_moving = value;
		}
	}
}
