package net.petosky.puzzle.block {

	/**
	 * @author Cory
	 */
	public class BlockFactory {
		private var _blockSize:uint;
		private var _rowSize:uint;
		private var _blockCount:uint;
		
		private var _gfx:Array; // of BlockGraphics

		public function BlockFactory(blockSize:uint, rowSize:uint, blockCount:uint) {
			_blockSize = blockSize;
			_rowSize = rowSize;
			_blockCount = blockCount;
			_gfx = [
				new BlockGraphics(0, _blockSize),
				new BlockGraphics(1, _blockSize),
				new BlockGraphics(2, _blockSize),
				new BlockGraphics(3, _blockSize),
				new BlockGraphics(4, _blockSize),
				new BlockGraphics(5, _blockSize)
			];
		}
		
		public function get randomBlock():Block {
			return new Block(_gfx[Math.floor(Math.random() * _blockCount)]);
		}
		
		public function get randomRow():Array {
			var a:Array = [];
			for (var i:uint = 0; i < _rowSize; ++i)
				a.push(randomBlock);
			return a;
		}
		
		public function makeStartingArea(rows:uint):Array {
			var i:uint;
			var a:Array = [];
			var row:Array = [randomBlock];
			var block:Block;
						
			for (i = 1; i < _rowSize; ++i) {
				do
					block = randomBlock;
				while (block.matches(row[i - 1]));
				row.push(block);
			}
			a.push(row);
			
			for (var r:uint = 1; r < rows; ++r) {
				do
					block = randomBlock;
				while (block.matches(a[r - 1][0]));
				row = [block];
				
				for (i = 1; i < _rowSize; ++i) {
					do
						block = randomBlock;
					while (block.matches(a[r - 1][i]) || block.matches(row[i - 1]));
					row.push(block);
				}
				
				a.push(row);
			}
			return a;
		}
	}
}
