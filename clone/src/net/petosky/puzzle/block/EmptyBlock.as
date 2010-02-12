package net.petosky.puzzle.block {
	import net.petosky.puzzle.block.IBlock;
	
	import flash.display.BitmapData;	

	/**
	 * @author Try-Catch
	 */
	public class EmptyBlock implements IBlock {
		public function get empty():Boolean {
			return true;
		}
		
		public function matches(block:IBlock):Boolean {
			return (block is EmptyBlock);
		}
		
		public function markForRemoval(timer:uint):Boolean {
			return false;
		}
		
		public function passTime(time:int):Boolean {
			return false;
		}
		
		public function fall(time:int):Boolean {
			return false;
		}
		
		public function get bitmap():BitmapData {
			return null;
		}
		
		public function get markedForRemoval():Boolean {
			return false;
		}
		
		public function get size():Number {
			return 1;
		}
		
		public function get xOffset():int {
			return 0;
		}
		
		public function get yOffset():int {
			return 0;
		}
		
		public function get group():BlockGroup {
			return null;
		}
		
		public function get moving():Boolean {
			return false;
		}
		
		public function set size(value:Number):void {
		}
		
		public function set xOffset(value:int):void {
		}
		
		public function set yOffset(value:int):void {
		}
		
		public function set group(value:BlockGroup):void {
		}
		
		public function set moving(value:Boolean):void {
		}
		
		public function get canMove():Boolean {
			return true;
		}
	}
}
