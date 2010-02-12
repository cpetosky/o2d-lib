package net.petosky.dungeon.display {
	import flash.display.BitmapData;	
	
	/**
	 * @author Cory Petosky
	 */
	public final class Assets {
		
		
		private static var _stairsDown:BitmapData;
		
		{
			_stairsDown = new BitmapData(150, 150, false, 0xFF000000);
		}

		public static function get stairsDown():BitmapData {
			return _stairsDown;
		}
	}
}
