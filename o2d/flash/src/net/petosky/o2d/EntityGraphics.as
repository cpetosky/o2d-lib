package net.petosky.o2d {
	import flash.utils.ByteArray;
	import flash.display.BitmapData;	
	
	/**
	 * @author Cory
	 */
	public class EntityGraphics {
		private var _id:int;
		private var _name:String;
		private var _width:int;
		private var _height:int;
		private var _frames:int;
		private var _image:String;
		private var _modes:Vector.<String>;

		private var _texture:BitmapData;

		public function EntityGraphics(enforcer:FactoryEnforcer) { }
		
		public static function create(
			id:int,
			name:String,
			width:int,
			height:int,
			frames:int,
			image:String,
			modes:Vector.<String>,
			texture:BitmapData
		):EntityGraphics {
			var entity:EntityGraphics = new EntityGraphics(new FactoryEnforcer());
			
			entity.create(id, name, width, height, frames, image, modes, texture);
			
			return entity;
		}
		
		private function create(
			id:int,
			name:String,
			width:int,
			height:int,
			frames:int,
			image:String,
			modes:Vector.<String>,
			texture:BitmapData
		):void {
			_id = id;
			_name = name;
			_width = width;
			_height = height;
			_frames = frames;
			_image = image;
			_modes = modes;
			_texture = texture;
		}
		
		public function serialize():ByteArray {
			var out:ByteArray = new ByteArray();
			
			out.writeInt(0); // fileversion
			out.writeInt(_id); // id
			out.writeUTF(_name); // name
			out.writeInt(_width); // width
			out.writeInt(_height); // height
			out.writeInt(_frames); // frames
			out.writeInt(_modes.length); // num of modes
			
			for (var mode:String in _modes)
				out.writeUTF(mode); // mode
			
			out.writeInt(_texture.width); // texture width
			out.writeInt(_texture.height); // texture height
			out.writeBytes(_texture.getPixels(_texture.rect)); // texture data (width * height * 4 length);
			
			return out;
		}
		
		public static function deserialize(bytes:ByteArray):EntityGraphics {
			var entity:EntityGraphics = new EntityGraphics(new FactoryEnforcer());
			
			entity.deserialize(bytes);
			
			return entity;
		}
		
		private function deserialize(bytes:ByteArray):void {
			var version:int = bytes.readInt();
			
			if (version != 0)
				throw new Error("BAD ENTITYGRAPHICS VERSION!");
				
			_id = bytes.readInt();
			_name = bytes.readUTF();
			_width = bytes.readInt();
			_height = bytes.readInt();
			_frames = bytes.readInt();
			
			var n:int = bytes.readInt();
			
			_modes = new Vector.<String>(n);
			
			for (var i:int = 0; i < n; ++i) {
				_modes[i] = bytes.readUTF();
			}
			
			var texWidth:int = bytes.readInt();
			var texHeight:int = bytes.readInt();
			var texBytes:ByteArray = new ByteArray();
			bytes.readBytes(texBytes, 0, texWidth * texHeight * 4);
			
			_texture = new BitmapData(texWidth, texHeight, true);
			_texture.setPixels(_texture.rect, texBytes);
		}

		public function get id():int {
			return _id;
		}

		public function get frames():int {
			return _frames;
		}

		public function get width():int {
			return _width;
		}

		public function get height():int {
			return _height;
		}

		public function get texture():BitmapData {
			return _texture;
		}
		
		public function get name():String {
			return _name;
		}
	}
}

final class FactoryEnforcer { }