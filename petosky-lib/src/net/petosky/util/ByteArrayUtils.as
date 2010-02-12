package net.petosky.util {
	import flash.utils.ByteArray;	
	
	/**
	 * @author Cory Petosky
	 */
	public final class ByteArrayUtils {
		public static function writeByteArray(source:ByteArray, target:ByteArray):void {
			target.writeUnsignedInt(source.length);
			target.writeBytes(source);
		}
		
		public static function readByteArray(source:ByteArray):ByteArray {
			var length:uint = source.readUnsignedInt();
			var bytes:ByteArray = new ByteArray();
			source.readBytes(bytes, 0, length);
			return bytes;
		}
	}
}
