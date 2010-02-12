package net.petosky.o2d.editor {

	import flash.events.MouseEvent;
	import flash.geom.Point;
	import mx.events.ScrollEventDetail;
	import mx.events.ScrollEvent;
	import flash.events.Event;
	import net.petosky.o2d.player.View;
	import mx.core.EdgeMetrics;
	import mx.core.ScrollPolicy;
	import flash.display.Bitmap;
	import net.petosky.o2d.Tile;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import mx.core.ScrollControlBase;
	/**
	 * A RenderPanel is used for any panel that draws tiled bitmaps to the
	 * screen.
	 * 
	 * @author Cory
	 */
	public class RenderPanel extends ScrollControlBase {
		private static const __highlightSprite:Sprite = new Sprite();
		private static const __highlight:BitmapData = new BitmapData(Tile.SIZE, Tile.SIZE, true, 0);

		{
			with (__highlightSprite.graphics) {
				lineStyle(1, 0xFF000000);
				drawRect(0, 0, Tile.SIZE, Tile.SIZE);
				lineStyle(1, 0xFFFFFFFF);
				drawRect(1, 1, Tile.SIZE - 2, Tile.SIZE - 2);
				drawRect(2, 2, Tile.SIZE - 4, Tile.SIZE - 4);
				lineStyle(1, 0xFF000000);
				drawRect(3, 3, Tile.SIZE - 6, Tile.SIZE - 6);
			}
			__highlight.draw(__highlightSprite);
		}
		
		private var _backingBitmap:BitmapData = new BitmapData(1, 1);
		private var _bitmapDisplay:Bitmap = new Bitmap(_backingBitmap);
		
		private var _view:View;
		
		private var _selectedX:int = -1;
		private var _selectedY:int = -1;
		
		private var _scrolling:Boolean = false;
		
		/**
		 * Creates and initializes a new RenderPanel.
		 */
		public function RenderPanel() {
			super();
			
			horizontalScrollPolicy = ScrollPolicy.ON;
			verticalScrollPolicy = ScrollPolicy.ON;

			addChild(_bitmapDisplay);
			
		}
		
		public function selectTileUnderMouse(contentWidth:int, contentHeight:int):void {
			if (mouseX > -1 &&
				mouseY > -1 &&
				mouseX < unscaledWidth - viewMetrics.right &&
				mouseY < unscaledHeight - viewMetrics.bottom
			) {
				_selectedX = (mouseX - viewMetrics.left + _view.x) / Tile.SIZE;
				_selectedY = (mouseY - viewMetrics.top + _view.y) / Tile.SIZE;
				
				if (_selectedX < 0 || _selectedX >= contentWidth)
					_selectedX = -1;
				if (_selectedY < 0 || _selectedY >= contentHeight)
					_selectedY = -1;
				
				drawHighlight();
			}
			
		}
		
		public function selectTile(tileX:int, tileY:int):void {
			_selectedX = tileX;
			_selectedY = tileY;
			
			drawHighlight();
		}
		
		public function drawHighlight():void {
			if (_selectedX > -1 && _selectedY > -1) {
				backingBitmap.copyPixels(
					highlightBitmap,
					highlightBitmap.rect,
					new Point(_selectedX * Tile.SIZE - _view.x, _selectedY * Tile.SIZE - _view.y),
					null,
					null,
					true
				);
			}
		}
		
		protected function addListeners():void {
			addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var metrics:EdgeMetrics = viewMetrics;

			_bitmapDisplay.x = metrics.left;
			_bitmapDisplay.y = metrics.top;
			
			unscaledWidth -= metrics.left + metrics.right;
			unscaledHeight -= metrics.top + metrics.bottom;
			
			if (unscaledWidth > 0 && unscaledHeight > 0)
				_backingBitmap = new BitmapData(unscaledWidth, unscaledHeight, true, 0);
			
			_bitmapDisplay.bitmapData = _backingBitmap;
			
			_view.width = _backingBitmap.width;
			_view.height = _backingBitmap.height;
		}
		
		override protected function measure():void {
			super.measure();
			
//			var metrics:EdgeMetrics = viewMetrics;
//			
//			measuredWidth = metrics.left + metrics.right;
//			measuredHeight = metrics.top + metrics.bottom;
		}
		
		
		/**
		 * Creates scrollbars of the correct size. Subclasses should call this
		 * method in their overridden updateDisplayList method.
		 * 
		 * @param contentWidth The width of the underlying content (pixels)
		 * @param contentHeight The height of the underlying content (pixels)
		 */
		protected function resizeScrollbars(contentWidth:int, contentHeight:int):void {
			setScrollBarProperties(contentWidth + 18, unscaledWidth, contentHeight + 18, unscaledHeight);
			
			var maxScrollPosition:int;
			
			maxScrollPosition = Math.max(0, contentWidth - unscaledWidth);
			_view.x = Math.min(horizontalScrollPosition, maxScrollPosition);
			maxScrollPosition = Math.max(0, contentHeight - unscaledHeight);
			_view.y = Math.min(verticalScrollPosition, maxScrollPosition);
			
		}
		
		
		/**
		 * Modifies the view so that a subclass can render according to where
		 * the panel is scrolled.
		 */
		override protected function scrollHandler(event:Event):void {
			if (!_view)
				return;
				
			if (!liveScrolling && ScrollEvent(event).detail == ScrollEventDetail.THUMB_TRACK)
				return;
				
			super.scrollHandler(event);
			
			_view.x = horizontalScrollPosition;
			_view.y = verticalScrollPosition;
		}
		
		
		/**
		 * The bitmap used to show a tile is currently selected.
		 */
		protected function get highlightBitmap():BitmapData {
			return __highlight;
		}
		
		/**
		 * The bitmap that gets drawn to the screen every frame.
		 */
		protected function get backingBitmap():BitmapData {
			return _backingBitmap;
		}
		
		
		/**
		 * The view controls what section of the underlying content is rendered.
		 * The RenderPanel manipulates the view when the scrollbars are used.
		 */
		protected function get view():View {
			return _view;
		}
		protected function set view(value:View):void {
			_view = value;
		}
		
		
		
		public function get selectedX():int {
			return _selectedX;
		}
		
		
		
		public function get selectedY():int {
			return _selectedY;
		}
		
		private function mouseDownListener(event:MouseEvent):void {
			// Check if clicking on scrollbars, and, if so, stop processing
			if (
				mouseX > unscaledWidth - viewMetrics.right ||
				mouseY > unscaledHeight - viewMetrics.bottom
			) {
				_scrolling = true;
				return;
			}
		}
		
		private function mouseUpListener(event:MouseEvent):void {
			_scrolling = false;
		}
		
		
		
		public function get scrolling():Boolean {
			return _scrolling;
		}
	}
}
