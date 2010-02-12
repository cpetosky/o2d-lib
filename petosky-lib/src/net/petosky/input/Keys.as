package net.petosky.input {
	import flash.events.EventDispatcher;	
	import flash.events.KeyboardEvent;	
	import flash.display.InteractiveObject;	
	
	/**
	 * @author Cory
	 */
	public class Keys extends EventDispatcher {
		private static var _instance:Keys;
		public static function get instance():Keys {
			if (!_instance)
				_instance = new Keys();
			return _instance;
		}
		
		private var _keyDown:Object = {};
		
		public function addEventSource(interactiveObject:InteractiveObject):void {
			interactiveObject.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			interactiveObject.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		
		
		private function keyDownListener(event:KeyboardEvent):void {
			if (!_keyDown[event.keyCode])
				dispatchEvent(event);
				
			_keyDown[event.keyCode] = true;
		}
		
		private function keyUpListener(event:KeyboardEvent):void {
			if (_keyDown[event.keyCode])
				dispatchEvent(event);
				
			_keyDown[event.keyCode] = false;
		}

		public function isDown(keyCode:Object):Boolean {
			return _keyDown[convertToKeyCode(keyCode)];
		}
		
		public function isUp(keyCode:Object):Boolean {
			return !_keyDown[convertToKeyCode(keyCode)];
		}
		
		
		private function convertToKeyCode(keyCode:Object):uint {
			if (keyCode is uint)
				return uint(keyCode);
			if (keyCode is String)
				return String(keyCode).charCodeAt();
			return 0;		
		}
	}
}
