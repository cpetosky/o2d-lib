package net.petosky.puzzle.block {
	
	/**
	 * @author cory
	 */
	public class BlockGroup {
		private var blocks:Array = [];
		public var hitCount:uint = 0;
		
		public function addBlock(b:IBlock):void {
			blocks.push(b);
			b.group = this;
		}
		
		public function get size():uint {
			return blocks.length;
		}
		
		public function hit():Boolean {
			return ++hitCount >= blocks.length;
		}
		
		public function contains(b:IBlock):Boolean {
			for (var i:uint = 0; i < blocks.length; ++i)
				if (blocks[i] === b)
					return true;
			return false;
		}
		
		
		public function dispose():void {
			for (var i:uint = 0; i < blocks.length; ++i)
				blocks[i].group = null;
			blocks = null;
		}
	}
}
