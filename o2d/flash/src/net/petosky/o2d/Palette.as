package net.petosky.o2d {
	import flash.utils.ByteArray;
	import flash.display.BitmapData;	
	import flash.geom.Rectangle;	
	import flash.geom.Point;	
	
	import net.petosky.geom.GridPoint;	
	
	/**
	 * @author Cory
	 */
	public class Palette {
		private var _name:String;
		private var _id:int;
		private var _tiles:Vector.<Tile>;
		private var _atlas:BitmapData;

		public function Palette(enforcer:FactoryEnforcer) { }
		
		public function serialize():ByteArray {
			var out:ByteArray = new ByteArray();
			
			out.writeInt(0); // fileversion
			out.writeInt(_id); // id
			out.writeUTF(_name); // name;
			
			out.writeInt(_tiles.length); // numTiles
			
			for each (var tile:Tile in _tiles) {
				out.writeBoolean(tile != null); // if tile exists
				if (!tile)
					continue;
				
				out.writeUTF(tile.name); // tile name
				out.writeInt(tile.priority); // tile priority
				out.writeUnsignedInt(tile.access); // tile access
				out.writeInt(tile.texture.width); // tile texture width
				out.writeInt(tile.texture.height); // tile texture height
				out.writeBytes(tile.texture.getPixels(tile.texture.rect)); // tile texture data (width * height * 4 length)
			}
			
			return out;
		}
		
		public static function deserialize(bytes:ByteArray):Palette {
			var palette:Palette = new Palette(new FactoryEnforcer());
			
			palette.deserialize(bytes);
			
			return palette;
		}
		
		private function deserialize(bytes:ByteArray):void {
			var version:int = bytes.readInt();
			
			if (version != 0)
				throw new Error("INCORRECT PALETTE VERSION!");
				
			_id = bytes.readInt();
			_name = bytes.readUTF();
			
			var n:int = bytes.readInt();
			var tileInfos:Vector.<TileInfo> = new Vector.<TileInfo>(n);
			
			for (var i:int = 0; i < n; ++i) {
				var tileInfo:TileInfo;
				
				if (bytes.readBoolean()) {
					var name:String = bytes.readUTF();
					var priority:int = bytes.readInt();
					var access:uint = bytes.readUnsignedInt();
					var width:int = bytes.readInt();
					var height:int = bytes.readInt();
					var textureData:ByteArray = new ByteArray();
					bytes.readBytes(textureData, 0, width * height * 4);
					
					var texture:BitmapData = new BitmapData(width, height, true);
					texture.setPixels(texture.rect, textureData);
					
					tileInfo = new TileInfo(
						i,
						name,
						priority,
						access,
						texture
					);
				}
				
				tileInfos[i] = tileInfo;
			}
			
			initializeAtlas(tileInfos);
		}
		
		public static function create(id:int, name:String, tileInfos:Vector.<TileInfo>):Palette {
			var palette:Palette = new Palette(new FactoryEnforcer());
			
			palette.create(id, name, tileInfos);
			
			return palette;
		}
		
		private function create(id:int, name:String, tileInfos:Vector.<TileInfo>):void {
			_id = id;
			_name = name;

			initializeAtlas(tileInfos);
		}
		
		private function initializeAtlas(tileInfos:Vector.<TileInfo>):void {
			var info:TileInfo;
			var p:GridPoint;
			var srcRect:Rectangle;
			var destPoint:Point;
			
		
			var dynamicTiles:Vector.<TileInfo> = new Vector.<TileInfo>();
			var staticTiles:Vector.<TileInfo> = new Vector.<TileInfo>();
			var staticAnimatedTiles:Vector.<TileInfo> = new Vector.<TileInfo>();
			
			var highestID:uint = 0;
			
			for each (info in tileInfos) {
				if (info.blank)
					continue;

				switch (info.type) {
					case TileType.DYNAMIC:
					case TileType.DYNAMIC_ANIMATED:
						dynamicTiles.push(info);
						break;
					case TileType.STATIC:
						staticTiles.push(info);
						break;
					case TileType.STATIC_ANIMATED:
						staticAnimatedTiles.push(info);
						break;
				}
				
				if (info._id > highestID)
					highestID = info._id;
			}

			_tiles = new Vector.<Tile>(highestID + 1);


			// Create ubertexture.
			var width:int = 64;
			var leftHeight:int = 0;
			for each (info in dynamicTiles)
				leftHeight += info.frames;
			var rightHeight:int = (staticAnimatedTiles.length >> 2) + (staticAnimatedTiles.length % 4 > 0 ? 1 : 0);
			rightHeight += (staticTiles.length >> 4) + (staticTiles.length % 16 > 0 ? 1 : 0);

			var height:int = Math.max(Math.max(leftHeight, rightHeight), 1);

			trace(width, height);
			_atlas = new BitmapData(
				width * Tile.SIZE,
				height * Tile.SIZE,
				true,
				0
			);

			var x:int = 0;
			var y:int = 0;

			for each (info in dynamicTiles) {
				p = new GridPoint(x, y);
				y += info.frames;
				
				_tiles[info._id] = new Tile(this, info, p);

				for (var f:int = 0; f < info.frames; ++f) {
					for (var i:int = 0; i < 47; ++i) {
						var flags:Vector.<Boolean> = new Vector.<Boolean>(20);
						var j:int;
						
						if (i == 0)
							flags[DynamicPart.BaseEmpty] = true;
						else if (i == 1)
							flags[DynamicPart.BaseNE] = flags[DynamicPart.SideS] = flags[DynamicPart.BendSE] = true;
						else if (i == 2)
							flags[DynamicPart.BaseSW] = flags[DynamicPart.SideN] = flags[DynamicPart.BendNW] = true;
						else if (i == 3)
							flags[DynamicPart.BaseSW] = flags[DynamicPart.SideE] = flags[DynamicPart.BendSE] = true;
						else if (i == 4)
							flags[DynamicPart.BaseNE] = flags[DynamicPart.SideW] = flags[DynamicPart.BendNW] = true;
						else if (i == 5)
							flags[DynamicPart.BaseSE] = true;
						else if (i == 6)
							flags[DynamicPart.BaseSE] = flags[DynamicPart.CornerNW] = true;
						else if (i == 7)
							flags[DynamicPart.BaseSW] = true;
						else if (i == 8)
							flags[DynamicPart.BaseSW] = flags[DynamicPart.CornerNE] = true;
						else if (i == 9)
							flags[DynamicPart.BaseNW] = true;
						else if (i == 10)
							flags[DynamicPart.BaseNW] = flags[DynamicPart.CornerSE] = true;
						else if (i == 11)
							flags[DynamicPart.BaseNE] = true;
						else if (i == 12)
							flags[DynamicPart.BaseNE] = flags[DynamicPart.CornerSW] = true;
						else if (i == 13)
							flags[DynamicPart.BaseW] = flags[DynamicPart.SideE] = true;
						else if (i == 14)
							flags[DynamicPart.BaseN] = flags[DynamicPart.SideS] = true;
						else if (i >= 31) {
							j = i - 31;
							flags[DynamicPart.BaseCenter] = true;
							if ((j & 1) > 0)
								flags[DynamicPart.CornerNW] = true;
							if ((j & 2) > 0)
								flags[DynamicPart.CornerNE] = true;
							if ((j & 4) > 0)
								flags[DynamicPart.CornerSW] = true;
							if ((j & 8) > 0)
								flags[DynamicPart.CornerSE] = true;
						} else if (i >= 27) {
							j = i - 27;
							flags[DynamicPart.BaseE] = true;
							if ((j & 1) > 0)
								flags[DynamicPart.CornerNW] = true;
							if ((j & 2) > 0)
								flags[DynamicPart.CornerSW] = true;
						} else if (i >= 23) {
							j = i - 23;
							flags[DynamicPart.BaseN] = true;
							if ((j & 1) > 0)
								flags[DynamicPart.CornerSW] = true;
							if ((j & 2) > 0)
								flags[DynamicPart.CornerSE] = true;
						} else if (i >= 19) {
							j = i - 19;
							flags[DynamicPart.BaseW] = true;
							if ((j & 1) > 0)
								flags[DynamicPart.CornerNE] = true;
							if ((j & 2) > 0)
								flags[DynamicPart.CornerSE] = true;
						} else if (i >= 15) {
							j = i - 15;
							flags[DynamicPart.BaseS] = true;
							if ((j & 1) > 0)
								flags[DynamicPart.CornerNW] = true;
							if ((j & 2) > 0)
								flags[DynamicPart.CornerNE] = true;
						}

						// Flags set, deal with 'em

						destPoint = new Point(
							(p.x + i) * Tile.SIZE,
							(p.y + f) * Tile.SIZE
						);
						
						var offset:int = f * Tile.SIZE * 3;

						if (flags[DynamicPart.BaseEmpty]) {
							addBase(info._texture, destPoint.clone(), offset, 0);
						}

						if (flags[DynamicPart.BaseCenter]) {
							addBase(info._texture, destPoint.clone(), offset + Tile.SIZE, 2 * Tile.SIZE);
						}

						if (flags[DynamicPart.BaseNW]) {
							addBase(info._texture, destPoint.clone(), offset, Tile.SIZE);
						}

						if (flags[DynamicPart.BaseN]) {
							addBase(info._texture, destPoint.clone(), offset + Tile.SIZE, Tile.SIZE);
						}

						if (flags[DynamicPart.BaseNE]) {
							addBase(info._texture, destPoint.clone(), offset + Tile.SIZE + Tile.SIZE, Tile.SIZE);
						}

						if (flags[DynamicPart.BaseW]) {
							addBase(info._texture, destPoint.clone(), offset, 2 * Tile.SIZE);
						}

						if (flags[DynamicPart.BaseE]) {
							addBase(info._texture, destPoint.clone(), offset + Tile.SIZE + Tile.SIZE, Tile.SIZE + Tile.SIZE);
						}

						if (flags[DynamicPart.BaseSW]) {
							addBase(info._texture, destPoint.clone(), offset, Tile.SIZE + Tile.SIZE + Tile.SIZE);
						}

						if (flags[DynamicPart.BaseS]) {
							addBase(info._texture, destPoint.clone(), offset + Tile.SIZE, Tile.SIZE + Tile.SIZE + Tile.SIZE);
						}

						if (flags[DynamicPart.BaseSE]) {
							addBase(info._texture, destPoint.clone(), offset + Tile.SIZE + Tile.SIZE, Tile.SIZE + Tile.SIZE + Tile.SIZE);
						}

						if (flags[DynamicPart.SideW]) {
							addSide(info._texture, destPoint.clone(), 0, 0, offset, (Tile.SIZE << 1), SliceType.Vertical);
						}

						if (flags[DynamicPart.SideN]) {
							addSide(info._texture, destPoint.clone(), 0, 0, offset + Tile.SIZE, Tile.SIZE, SliceType.Horizontal);
						}

						if (flags[DynamicPart.SideE]) {
							addSide(info._texture, destPoint.clone(), (Tile.SIZE >> 1), 0,
								offset + 2 * Tile.SIZE + (Tile.SIZE >> 1), 2 * Tile.SIZE, SliceType.Vertical);
						}

						if (flags[DynamicPart.SideS]) {
							addSide(info._texture, destPoint.clone(), 0, Tile.SIZE >> 1,
									offset + Tile.SIZE, 3 * Tile.SIZE + (Tile.SIZE >> 1), SliceType.Horizontal);
						}

						if (flags[DynamicPart.BendNW]) {
							addBend(info._texture, destPoint.clone(), offset, Tile.SIZE);
						}

						if (flags[DynamicPart.BendSE]) {
							destPoint.x += (Tile.SIZE >> 1);
							destPoint.y += (Tile.SIZE >> 1);
							addBend(info._texture, destPoint.clone(), offset + (Tile.SIZE << 1) + (Tile.SIZE >> 1), (Tile.SIZE << 1) + Tile.SIZE + (Tile.SIZE >> 1));
							destPoint.x -= (Tile.SIZE >> 1);
							destPoint.y -= (Tile.SIZE >> 1);
						}

						if (flags[DynamicPart.CornerNW]) {
							addCorner(info._texture, destPoint.clone(), 0, 0, offset + (Tile.SIZE << 1), 0);
						}

						if (flags[DynamicPart.CornerNE]) {
							addCorner(info._texture, destPoint.clone(), (Tile.SIZE >> 1), 0, offset + (Tile.SIZE << 1) + (Tile.SIZE >> 1), 0);
						}

						if (flags[DynamicPart.CornerSW]) {
							addCorner(info._texture, destPoint.clone(), 0, (Tile.SIZE >> 1), offset + (Tile.SIZE << 1), (Tile.SIZE >> 1));
						}

						if (flags[DynamicPart.CornerSE]) {
							addCorner(info._texture, destPoint.clone(), (Tile.SIZE >> 1), (Tile.SIZE >> 1), offset + (Tile.SIZE << 1) + (Tile.SIZE >> 1), (Tile.SIZE >> 1));
						}
					}
				}
			}

			const StaticOffset:int = 48;
			const StaticWidth:int = 16;

			x = 0;
			y = 0;

			for each (info in staticAnimatedTiles) {
				p = new GridPoint(x + StaticOffset, y);
				x += 4;
				if (x >= StaticWidth) {
					x = 0;
					++y;
				}

				srcRect = new Rectangle(0, 0, Tile.SIZE << 2, Tile.SIZE);
				destPoint = new Point(p.x * Tile.SIZE, p.y * Tile.SIZE);

				_atlas.copyPixels(info._texture, srcRect, destPoint);

				_tiles[info._id] = new Tile(this, info, p);
			}

			if (x != 0) {
				x = 0;
				++y;
			}

			for each (info in staticTiles) {
				p = new GridPoint(x + StaticOffset, y);
				++x;
				if (x >= StaticWidth) {
					x = 0;
					++y;
				}
				srcRect = new Rectangle(0, 0, Tile.SIZE, Tile.SIZE);
				destPoint = new Point(p.x * Tile.SIZE, p.y * Tile.SIZE);
				
				_atlas.copyPixels(info._texture, srcRect, destPoint);
				_tiles[info._id] = new Tile(this, info, p);
			}
		}
		
		
		
		private function addSide(src:BitmapData, destPoint:Point, dx:int, dy:int, sx:int, sy:int, st:uint):void {
			var srcRect:Rectangle = new Rectangle();
			srcRect.x = sx;
			srcRect.y = sy;
			destPoint.x += dx;
			destPoint.y += dy;
		
			switch (st) {
				case SliceType.Horizontal:
					srcRect.width = Tile.SIZE;
					srcRect.height = (Tile.SIZE >> 1);
					break;
				case SliceType.Vertical:
					srcRect.width = (Tile.SIZE >> 1);
					srcRect.height = Tile.SIZE;
					break;
			}
			
			_atlas.copyPixels(src, srcRect, destPoint);
		}


	
		private function addCorner(src:BitmapData, destPoint:Point, dx:int, dy:int, sx:int, sy:int):void {
			var srcRect:Rectangle = new Rectangle();
			srcRect.x = sx;
			srcRect.y = sy;
			srcRect.width = srcRect.height = (Tile.SIZE >> 1);
			destPoint.x += dx;
			destPoint.y += dy;
			_atlas.copyPixels(src, srcRect, destPoint);
		}
		
		

		private function addBase(src:BitmapData, destPoint:Point, sx:int, sy:int):void {
			var srcRect:Rectangle = new Rectangle();
			srcRect.x = sx;
			srcRect.y = sy;
			srcRect.width = srcRect.height = Tile.SIZE;
			_atlas.copyPixels(src, srcRect, destPoint);
		}
		
		

		private function addBend(src:BitmapData, destPoint:Point, sx:int, sy:int):void {
			var srcRect:Rectangle = new Rectangle();
			srcRect.x = sx;
			srcRect.y = sy;
			srcRect.width = srcRect.height = (Tile.SIZE >> 1);
			_atlas.copyPixels(src, srcRect, destPoint);
		}



		public function getTile(index:int):Tile {
			if (index >= 0 && index < _tiles.length)
				return _tiles[index];
			else
				return null;
		}
		
		public function setTile(index:int, value:Tile):void {
			_tiles[index] = value;
		}


		public function get id():int {
			return _id;
		}

		public function get name():String {
			return _name;
		}

		public function get defaultTile():Tile {
			return _tiles.length > 0 ? _tiles[0] : null;
		}

		public function get atlas():BitmapData {
			return _atlas;
		}
		
		public function get tiles():Vector.<Tile> {
			return _tiles;
		}
	}
}

final class DynamicPart {
	public static const BaseEmpty:int  = 0;
	public static const BaseCenter:int = 1;
	public static const BaseNW:int     = 2;
	public static const BaseN:int      = 3;
	public static const BaseNE:int     = 4;
	public static const BaseW:int      = 5;
	public static const BaseE:int      = 6;
	public static const BaseSW:int     = 7;
	public static const BaseS:int      = 8;
	public static const BaseSE:int     = 9;
	public static const SideN:int      = 10;
	public static const SideW:int      = 11;
	public static const SideS:int      = 12;
	public static const SideE:int      = 13;
	public static const BendNW:int     = 14;
	public static const BendSE:int     = 15;
	public static const CornerNW:int   = 16;
	public static const CornerNE:int   = 17;
	public static const CornerSW:int   = 18;
	public static const CornerSE:int   = 19;
	
	public static const TOTAL:int      = 20;
}

final class SliceType {
	public static const Horizontal:uint = 0;
	public static const Vertical:uint = 1;
}

final class FactoryEnforcer { }
