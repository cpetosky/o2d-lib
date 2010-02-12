package net.petosky.bitmap {
	import flash.display.Sprite;
	
	/**
	 * Same as convertSpriteToBitmapData, but takes a variable number of
	 * Sprite arguments and returns an array of converted bitmap data objects.
	 * 
	 * @param args sprites to convert.
	 * @return an array of BitmapData objects.
	 * @see convertSpriteToBitmapData
	 * 
	 * @author Cory Petosky
	 */
	public function convertSpritesToBitmapData(...args):Array {
		var array:Array = [];
		
		for each (var sprite:Sprite in args)
			array.push(convertSpriteToBitmapData(sprite));
			
		return array;
	}
}
