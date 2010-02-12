package net.petosky.puzzle.block {
	import caurina.transitions.Tweener;	
	
	import net.petosky.puzzle.display.Cursor;	
	
	import flash.events.EventDispatcher;	
	import flash.events.IEventDispatcher;	
	import flash.geom.Point;	
	import flash.geom.Rectangle;	
	import flash.display.BitmapData;
	import flash.events.Event;

	/**
	 * @author Cory
	 */
	public class BlockField extends BitmapData implements IEventDispatcher {
		private static const INITIAL_ROWS:uint = 5;
		private static const LEFT_BORDER:uint = 102;//10;
		private static const RIGHT_BORDER:uint = 7;
		private static const TOP_BORDER:uint = 12;//16;
		private static const BOTTOM_BORDER:uint = 20;//5;
		private static const MIN_MATCHES:uint = 3;
		
		private var _eventDispatcher:EventDispatcher = new EventDispatcher();
		
		private var _width:uint;
		private var _height:uint;
		private var _blockSize:uint;
		
		private var _top:int;
		
		[ArrayElementType("Array")]
		private var _rows:Array = [];

		private var _blockFactory:BlockFactory;
		private var _cursor:Cursor;
		
		private var _shade:BitmapData;
		
		private var _blocksRemoving:int = 0;
		private var _rowsRemoved:int = 0;
		
		[Embed(source="/../gfx/background.png")]
		private var Background:Class;
		
		private var _bg:BitmapData;
		
		public function BlockField(width:uint, height:uint, blockSize:uint, blockCount:uint) {
			_bg = new Background().bitmapData;
			
			super(
				Math.max(width * blockSize + LEFT_BORDER + RIGHT_BORDER, _bg.width),
				Math.max(height * blockSize + TOP_BORDER + BOTTOM_BORDER, _bg.height),
				true, 0
			);
						
			_cursor = new Cursor(blockSize);
			_top = (height - INITIAL_ROWS) * blockSize + TOP_BORDER;
			
			_width = width;
			_height = height;
			_blockSize = blockSize;

			_blockFactory = new BlockFactory(blockSize, width, blockCount);
			
			_shade = new BitmapData(width * blockSize, blockSize, true, 0xAA000000);
			
			_rows = _blockFactory.makeStartingArea(INITIAL_ROWS + 1);
		}
		
		
		
		/**
		 * Draws the blockfield onto the screen.
		 */
		public function render():void {
			lock();
			
			copyPixels(_bg, new Rectangle(0, 0, _bg.width, _bg.height), new Point(0, 0));

			var y:uint = _top;
			const longSrcRect:Rectangle = new Rectangle(0, 0, _blockSize, _blockSize);
			const shortSrcRect:Rectangle = new Rectangle(
				0, 0,
				_blockSize,
				_blockSize - ((_top - TOP_BORDER - 1) % _blockSize) - 1
			);
			
			var numRows:uint = _rows.length;
			var lastRow:uint = numRows - 1;
			
			for (var rowIndex:uint = 0; rowIndex < numRows; ++rowIndex) {
				var row:Array = _rows[rowIndex];
				var srcRect:Rectangle = rowIndex == lastRow ? shortSrcRect : longSrcRect;
				
				for (var i:uint = 0; i < _width; ++i) {
					var block:IBlock = row[i] as IBlock;
					
					if (!block.empty)
						copyPixels(
							block.bitmap,
							srcRect,
							new Point(i * _blockSize + LEFT_BORDER + block.xOffset, y + block.yOffset),
							null,
							null,
							true
						);
				}
				y += _blockSize;
			}
			
			// Draw shade on last row
			y -= _blockSize;
			copyPixels(
				_shade,
				new Rectangle(0, 0, _blockSize * _width, _blockSize - ((_top - TOP_BORDER - 1) % _blockSize) - 1),
				new Point(LEFT_BORDER, y),
				null, null, true
			);
			
			// Draw cursor
			copyPixels(
				_cursor.bitmap,
				new Rectangle(0, 0, _blockSize << 1, _blockSize),
				new Point(_cursor.column * _blockSize + LEFT_BORDER, _top + _cursor.row * _blockSize),
				null, null, true
			);
			
			unlock();
		}
		
		public function renderPauseNotice():void {
			lock();
			var y:int = _top;
			for (var i:uint = 0; i < _rows.length; ++i) {
				copyPixels(
					_shade,
					new Rectangle(0, 0, _blockSize * _width, _blockSize),
					new Point(LEFT_BORDER, y)
				);
				copyPixels(
					_shade,
					new Rectangle(0, 0, _blockSize * _width, _blockSize),
					new Point(LEFT_BORDER, y)
				);
				y += _blockSize;
			}
			unlock();
		}
	
		public function markMatches():uint {
			var delay:uint = 50;
			const delayIncrement:uint = 150;
			
			var group:BlockGroup = new BlockGroup();
			
			for (var i:uint = 0; i < _rows.length - 1; ++i) {
				for (var j:uint = 0; j < _width; ++j) {
					var block:IBlock = getBlock(i, j);
					if (block.empty)
						continue;
						
					var k:uint;
					var b:Boolean;

					// Mark horizontal					
					for (k = 1, b = true; k < MIN_MATCHES; ++k)
						b = b && block.matches(getBlock(i, j + k));
						
					if (b) {
						for (k = j; block.matches(getBlock(i, k)); ++k) {
							if (getBlock(i, k).markForRemoval(delay)) {
								group.addBlock(getBlock(i, k));
								delay += delayIncrement;
							}
						}
					}
					
					// Mark vertical
					for (k = 1, b = true; k < MIN_MATCHES; ++k)
						b = b && block.matches(getBlock(i + k, j));
						
					if (b) {
						for (k = i; block.matches(getBlock(k, j)); ++k) {
							if (getBlock(k, j).markForRemoval(delay)) {
								group.addBlock(getBlock(k, j));
								delay += delayIncrement;
							}
						}
					}
				}
			}
			_blocksRemoving += group.size;
			return group.size;
		}
		
		private function removeBlock(i:uint, j:uint, rowCount:int):void {
			var group:BlockGroup = _rows[i - (_rowsRemoved - rowCount)][j].group;
			var empty:IBlock = Block.EMPTY;
			 
			// Loop through all rows and remove all group members
			if (group.hit()) {
				for (var x:uint = 0; x < _rows.length - 1; ++x)
					for (var y:uint = 0; y < _width; ++y)
						if (group.contains(_rows[x][y]))
							_rows[x][y] = empty;
				
				group.dispose();
			}	
			
			--_blocksRemoving;
		}

		public function processMatches(delta:int):void {
			var empty:IBlock = Block.EMPTY;
			
			for (var i:int = rows - 1; i >= 0; --i) {
				for (var j:uint = 0; j < _width; ++j) {
					var block:IBlock = getBlock(i, j);
					if (block.empty)
						continue;
						
					if (block.markedForRemoval) {
						if (block.passTime(delta)) {
							Tweener.addTween(block, {
								size: 0,
								time: 0.250,
								transition: "easeOutCirc",
								onComplete: removeBlock,
								onCompleteParams: [i, j, _rowsRemoved]
							});
						}
					} else {
						block.moving = _rows[i + 1][j].empty || _rows[i + 1][j].moving;
						if (block.moving && block.fall(delta)) {
							_rows[i + 1][j] = block;
							_rows[i][j] = empty;
							block.moving = _rows[i + 2][j].empty || _rows[i + 1][j].moving;	
						}
					}	
				}
			}
			
			// Remove extra rows at top, if necessary
			var remove:Boolean = false;
			do {
				if (remove) {
					_rows.shift();
					_top += _blockSize;
					if (_cursor.row > 0)
						--_cursor.row;
					++_rowsRemoved;
				}
				remove = true;
				
				if (_rows[0] == undefined)
					break;
				for (i = 0; i < _rows[0].length && remove; ++i)
					if (!_rows[0][i].empty)
						remove = false;
			} while (remove);
			
			if (_cursor.row > rows - 1)
				_cursor.row = rows - 1;
			
		}
		
		public function get rows():uint {
			return _rows.length - 1;
		}
		
		public function rise():void {
			--top;
		}
		
		public function riseRow():void {
			Tweener.addTween(this, {top: top - _blockSize, time: 0.25 });
		}
		
		private function checkRows():void {
			if (_top < TOP_BORDER) {
				_top = 0;
				Tweener.removeTweens(this);
				dispatchEvent(new Event(Event.COMPLETE));
			} else {				
				// Add new row if necessary
				while ((height - BOTTOM_BORDER) - (_top) - (_rows.length * _blockSize) >= 0)
					_rows.push(_blockFactory.randomRow);
			}
		}
			
		private function getBlock(i:uint, j:uint):IBlock {
			if (i == _rows.length - 1 ||
				_rows[i] == undefined ||
				_rows[i][j] == undefined ||
				_rows[i][j] == null
			)
				return Block.EMPTY;
			return _rows[i][j];
		}
		
		public function get cursorRow():int {
			return _cursor.row;
		}
		public function set cursorRow(value:int):void {
			if (value < 0)
				value = 0;
			if (value > rows - 1)
				value = rows - 1;
			_cursor.row = value;
		}
		
		public function get cursorColumn():int {
			return _cursor.column;
		}
		public function set cursorColumn(value:int):void {
			if (value < 0)
				value = 0;
			if (value > _width - 2)
				value = _width - 2;
			_cursor.column = value;
		}
		
		public function swapBlocks():void {
			if (leftSelected.canMove && rightSelected.canMove) {
				leftSelected.moving = true;
				rightSelected.moving = true;
				
				Tweener.addTween(leftSelected, {
					xOffset: _blockSize, time: 0.0625, transition: "linear"
				});
				Tweener.addTween(rightSelected, {
					xOffset: -_blockSize, time: 0.0625, transition: "linear",
					onComplete: swap, onCompleteParams: [cursorRow, cursorColumn]}
				);
			}
		}
		
		private function swap(i:uint, j:uint):void {
			_rows[i][j].moving = _rows[i][j + 1].moving = false;
			_rows[i][j].xOffset = _rows[i][j + 1].xOffset = 0;
			var b:IBlock = _rows[i][j];
			_rows[i][j] = _rows[i][j + 1];
			_rows[i][j + 1] = b;
		}		
		
		public function get top():int {
			return _top;
		}
		public function set top(value:int):void {
			_top = value;
			checkRows();
		}
		
		private function get leftSelected():IBlock {
			return _rows[_cursor.row][_cursor.column];
		}
		
		private function get rightSelected():IBlock {
			return _rows[_cursor.row][_cursor.column + 1];
		}
		
		public function get removing():Boolean {
			return _blocksRemoving > 0;
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return _eventDispatcher.dispatchEvent(event);
		}

		public function hasEventListener(type:String):Boolean {
			return _eventDispatcher.hasEventListener(type);
		}

		public function willTrigger(type:String):Boolean {
			return _eventDispatcher.willTrigger(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}
}
