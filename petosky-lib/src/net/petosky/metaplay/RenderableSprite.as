package net.petosky.metaplay {
	
	import net.petosky.bitmap.convertSpriteToBitmapData;	
	
	import flash.geom.Point;	
	import flash.display.BitmapData;	
	import flash.display.Sprite;
	
	/**
	 * @author cory
	 */
	public class RenderableSprite extends RenderableContainer {
		private var _sprite:Sprite = new Sprite();

		public function RenderableSprite() {
			super(0, 0);
		}
		
		override public function get width():int {
			return _sprite.width;
		}
		override public function set width(value:int):void {
			_sprite.width = value;
		}
		
		
		
		override public function get height():int {
			return _sprite.height;
		}
		override public function set height(value:int):void {
			_sprite.height = value;
		}
		
		public function get sprite():Sprite {
			return _sprite;
		}

		override public function draw(target:BitmapData, destPoint:Point):void {
			super.draw(target, destPoint);
			var temp:BitmapData = convertSpriteToBitmapData(_sprite);
			target.copyPixels(temp, temp.rect, destPoint, null, null, true);
		}
	}
}
