package net.petosky.o2d {
	import net.petosky.o2d.player.View;	
	
	import flash.geom.Rectangle;	
	import flash.geom.Point;	
	import flash.display.BitmapData;	
	
	import net.petosky.geom.GridPoint;	
	
	/**
	 * @author Cory
	 */
	public class Tile {
		public static const SIZE:int = 32;

		private var _palette:Palette;
		private var _info:TileInfo;
		private var _tileLoc:GridPoint;

		public function Tile(palette:Palette, info:TileInfo, tileLoc:GridPoint) {
			_palette = palette;
			_info = info;
			_tileLoc = tileLoc;
		}

		public function get id():int {
			return _info._id;
		}
		
		public function get name():String {
			return _info._name;
		}

		public function get frames():int {
			return _info.frames;
		}

		public function get animated():Boolean {
			return _info.frames > 1;
		}

		public function get access():uint {
			return _info._access;
		}

		public function get priority():int {
			return _info._priority;
		}
		
		public function get texture():BitmapData {
			return _info._texture;
		}
		
		public function getZIndex(layer:int):Number {
			return Math.abs(1.0 - ((priority * Map.LAYERS + layer) / (Map.PRIORITIES * Map.LAYERS)));
		}

		public function blitSimple(output:BitmapData, dX:int, dY:int, view:View):void {
			blit(output, 0, 0, 0, dX, dY, view);
		}

		public function blit(output:BitmapData, neighbors:int, frame:int, layer:int, dX:int, dY:int, view:View):void {
			var src:Rectangle = new Rectangle();
			var xOffset:int = 0;
			var yOffset:int = 0;

			if (dX < 0)
				xOffset = -dX;
			else if ((dX + SIZE) > view.width)
				xOffset = view.width - (dX + SIZE);

			if (dY < 0)
				yOffset = -dY;
			else if (dY + SIZE > view.height)
				yOffset = view.height - (dY + SIZE);

			var dest:Point = new Point(
				dX + view.screenX,
				dY + view.screenY
			);
			
			if (xOffset < 0)
				xOffset = 0;
			if (yOffset < 0)
				yOffset = 0;

			dest.x += xOffset;
			dest.y += yOffset;
			src.width = SIZE - Math.abs(xOffset);
			src.height = SIZE - Math.abs(yOffset);

			

			switch (_info.type) {
				case TileType.STATIC:
					src.x = _tileLoc.x * SIZE + xOffset;
					src.y = _tileLoc.y * SIZE + yOffset;
					break;
				case TileType.STATIC_ANIMATED:
					src.x = (_tileLoc.x + frame % frames) * SIZE + xOffset;
					src.y = _tileLoc.y * SIZE + yOffset;
					break;
				case TileType.DYNAMIC:
					src.x = (_tileLoc.x + neighbors) * SIZE + xOffset;
					src.y = _tileLoc.y * SIZE + yOffset;
					break;
				case TileType.DYNAMIC_ANIMATED:
					src.x = (_tileLoc.x + neighbors) * SIZE + xOffset;
					src.y = (_tileLoc.y + frame % frames) * SIZE + yOffset;
					break;
			}
			
			output.copyPixels(_palette.atlas, src, dest, null, null, true);
		}
	}
}
