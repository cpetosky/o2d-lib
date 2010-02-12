package net.petosky.game {
	import flash.filters.BevelFilter;	
	import flash.display.Sprite;	
	
	/**
	 * @author Cory
	 */
	public class Dialogue extends Sprite {
		public function Dialogue(
			width:uint,
			height:uint,
			backgroundColor:uint = 0xFFFFFF,
			borderThickness:uint = 5,
			borderColor:uint = 0
		) {
			with (graphics) {
				lineStyle(borderThickness, borderColor);
				beginFill(backgroundColor);
				drawRoundRect(0, 0, width, height, 25, 25);
				endFill();
			}
			
			var f:Array = filters;
			f.push(new BevelFilter());
			filters = f;
		}
	}
}
