package net.petosky.dungeon.display {
	import net.petosky.dungeon.display.StatField;
	import flash.text.TextFormat;	
	import flash.text.TextField;	
	
	/**
	 * @author Cory Petosky
	 */
	public class TextFactory {
		private static var __instance:TextFactory;
		
		public static function get instance():TextFactory {
			if (!__instance)
				__instance = new TextFactory();
			
			return __instance;
		}
		
		public function createTextField(text:String = "", width:int = 0, height:int = 0):TextField {
			return manipulateTextField(new TextField(), text, width, height);
		}
		
		public function createStatField(width:int = 0, height:int = 0):StatField {
			return StatField(manipulateTextField(new StatField(), "", width, height));
		}
		
		public function createMessageWindow(text:String):Window {
			var window:Window = new Window();
			
			return window;
		}

		
		
		private function manipulateTextField(tf:TextField, text:String, width:int, height:int):TextField {
			tf.defaultTextFormat = new TextFormat("Courier New", 20, 0xFFFFFFFF);
			tf.text = text;
			
			if (width)
				tf.width = width;
			else if (text != "")
				tf.width = tf.textWidth + 5;
				
			if (height)
				tf.height = height;
			else if (text != "")
				tf.height = tf.textHeight + 5;
			else
				tf.height = 25;
				
			tf.selectable = false;
			
			return tf;
		}
	}
}
