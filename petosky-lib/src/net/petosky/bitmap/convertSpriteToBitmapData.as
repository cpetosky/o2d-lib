package net.petosky.bitmap {
	import flash.geom.Rectangle;	
	import flash.display.BitmapData;	
	import flash.display.Sprite;
	
	/**
	 * This function takes a Sprite instance, draws it to a BitmapData,
	 * and returns that BitmapData instance.
	 * 
	 * This function preserves empty space within the Sprite. For example,
	 * if you have a 100x100 rectangle positioned at (200,200) within the
	 * sprite, the returned BitmapData object will be 300x300, 8/9ths of
	 * which will be transparent space.
	 * 
	 * If the parameter is a MovieClip, or has child MovieClips, the current
	 * frame will be cached. If you've issued a change frame request to the
	 * clip in the same root frame as this function is called, the request
	 * is likely (but not definitely) going to be ignored by this function.
	 * 
	 * @param sprite the sprite to convert
	 * @return the converted bitmap data object
	 * 
	 * @author Cory Petosky
	 */
	public function convertSpriteToBitmapData(sprite:Sprite):BitmapData {
		var bounds:Rectangle = sprite.getBounds(sprite);
		var width:uint = Math.ceil(bounds.x + bounds.width);
		var height:uint = Math.ceil(bounds.y + bounds.height);
		 
		var bitmapData:BitmapData = new BitmapData(width, height, true, 0);
		bitmapData.draw(sprite);
		return bitmapData; 
	}
}
