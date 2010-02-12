package net.petosky.metaplay {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;	

	/**
	 * <p>
	 * An InfiniteScroller can be used to seamlessly tile a single bitmap over
	 * and over again based upon a Counter object. Attach a Counter, set up
	 * an InfiniteScroller to use that Counter, and attach the scroller --
	 * the background will scroll in relation to the Counter's value.
	 * </p><p>
	 * You can set up multiple InfiniteScrollers using the same Counter for
	 * layered effects. You can set up multiple InfiniteScrollers with different
	 * Counters for parallax effects.
	 * </p>
	 * 
	 * @author Cory Petosky
	 */
	public class InfiniteScroller extends Renderable {
		private var _source:BitmapData;
		private var _offset:Counter;
		private var _overlap:uint;
		
		public function InfiniteScroller(source:BitmapData, offset:Counter, overlap:uint = 0) {
			super(source.width, source.height);
			
			_source = source;
			_offset = offset;
			_overlap = overlap;
		}
		
		override public function draw(target:BitmapData, destPoint:Point):void {
			var srcRect:Rectangle;
			var point:Point = destPoint.clone();
			var actingOffset:uint = _offset.value % _source.height;
			if (actingOffset != 0) {
				// Draw top bit of background
				srcRect = new Rectangle(0, _source.height - actingOffset, _source.width, actingOffset);
				target.copyPixels(_source, srcRect, point, null, null, true);
			}
			
			// Handle overlapping of background tiles except when only one is needed
			actingOffset = Math.max(actingOffset - _overlap, 0);
			
			// Draw rest of background
			point = destPoint.clone();
			point.y += actingOffset;
			srcRect = new Rectangle(0, 0, _source.width, _source.height - actingOffset);
			target.copyPixels(_source, srcRect, point, null, null, true);			
		}
	}
}
