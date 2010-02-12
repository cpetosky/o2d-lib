package net.petosky.o2d.editor {

	import mx.events.PropertyChangeEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/**
	 * @author Cory
	 */
	public class PaletteViewer extends RenderPanel {
		import net.petosky.o2d.Palette;
		import net.petosky.o2d.Tile;
		import net.petosky.o2d.player.View;
		
		private var _palette:Palette;
		private var _newPalette:Palette;
		
		public function get palette():Palette {
			return _palette;
		}
		public function set palette(value:Palette):void {
			_newPalette = value;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		override protected function addListeners():void {
			super.addListeners();
			addEventListener(Event.ENTER_FRAME, enterFrameListener);
			addEventListener(MouseEvent.CLICK, mouseClickListener);
//			addEventListener(MouseEvent.MOUSE_OVER, mouseOverListener);
//			addEventListener(MouseEvent.MOUSE_OUT, mouseOutListener);
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			if (_newPalette) {
				if (!_palette)
					addListeners();
				
				_palette = _newPalette;
				view = new View(0, 0, 0, 0, 0, 0);
				_newPalette = null;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			resizeScrollbars(contentWidth, contentHeight);
		}
		
		private function enterFrameListener(event:Event):void {
			drawPalette();
			drawHighlight();
		}
		
		public function drawPalette():void {
			if (!_palette)
				return;
			
			backingBitmap.lock();
			backingBitmap.fillRect(backingBitmap.rect, 0xFFFF00FF);
			
			for each (var tile:Tile in _palette.tiles) {
				if (tile) {
					tile.blitSimple(
						backingBitmap,
						int(tile.id % 8) * Tile.SIZE - view.x,
						int(tile.id / 8) * Tile.SIZE - view.y,
						view
					);
				}
			}
			
			backingBitmap.unlock();
		}
		
		[Bindable]
		public function get selectedTile():Tile {
			return _palette.getTile(selectedX + selectedY * 8);
		}
		
		
		private function get contentWidth():int {
			return Tile.SIZE * 8;
		}
		
		private function get contentHeight():int {
			return (_palette.tiles.length / 8 + 1) * Tile.SIZE;
		}
		
		private function mouseClickListener(event:MouseEvent):void {
			var oldTile:Tile = selectedTile;
			
			selectTileUnderMouse(contentWidth, contentHeight);
			
			if (oldTile != selectedTile)
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedTile", oldTile, selectedTile));
		}
	}
}
