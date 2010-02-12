package net.petosky.puzzle.block {
	import flash.display.Sprite;	
	import flash.display.BitmapData;
	
	/**
	 * @author Cory
	 */
	public class BlockGraphics extends BitmapData {
		private var _markedVersion:BitmapData;

		[Embed(source="/../gfx/blue_anim.png")]
		public static var Block0:Class;
		[Embed(source="/../gfx/orange_anim.png")]
		public static var Block1:Class;
		[Embed(source="/../gfx/purple_anim.png")]
		public static var Block2:Class;
		[Embed(source="/../gfx/red_anim.png")]
		public static var Block3:Class;
		[Embed(source="/../gfx/yellow_anim.png")]
		public static var Block4:Class;
		[Embed(source="/../gfx/green_anim.png")]
		public static var Block5:Class;
		
		private static var __blocks:Array = [
			new Block0(),
			new Block1(),
			new Block2(),
			new Block3(),
			new Block4(),
			new Block5()
		];

		public function BlockGraphics(index:uint, size:uint) {
			super(size, size, true, 0x00000000);
			
			var border:uint = size >> 4;
			draw(__blocks[index].bitmapData);
			
			_markedVersion = new BitmapData(size, size, true, 0x00000000);
			
			var s:Sprite = new Sprite();
			
			with (s.graphics) {
				beginBitmapFill(__blocks[index].bitmapData);
				drawRect(0, 0, size, size);
				endFill();
				lineStyle(border, 0xFFFF00);
				moveTo(0, 0);
				lineTo(size, size);
				moveTo(size, 0);
				lineTo(0, size);
			}
			_markedVersion.draw(s);
		}

		public function get marked():BitmapData {
			return _markedVersion;
		}
	}
}
