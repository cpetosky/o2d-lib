package net.petosky.puzzle.block {
	import flash.display.BitmapData;	
	
	/**
	 * @author Try-Catch
	 */
	public interface IBlock {
		function get bitmap():BitmapData;
		function matches(block:IBlock):Boolean;
		function markForRemoval(timer:uint):Boolean;
		function get markedForRemoval():Boolean;
		function passTime(time:int):Boolean;
		function fall(time:int):Boolean;
		
		function get empty():Boolean;
		function get canMove():Boolean;
		
		function get size():Number;
		function set size(value:Number):void;
		
		function get xOffset():int;
		function set xOffset(value:int):void;
		
		function get yOffset():int;
		function set yOffset(value:int):void;
		
		function get group():BlockGroup;
		function set group(value:BlockGroup):void;
		
		function get moving():Boolean;
		function set moving(value:Boolean):void;
	}
}
