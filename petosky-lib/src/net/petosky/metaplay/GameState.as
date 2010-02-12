package net.petosky.metaplay {
	import net.petosky.input.Keys;	
	
	import flash.geom.Point;	
	import flash.events.MouseEvent;	
	import flash.display.InteractiveObject;

	/**
	 * <p>
	 * Tracks the state of the game in general. Built-in functionality includes
	 * keypress and mouse tracking. You can use the data property to set any
	 * custom attributes you might need on the GameState object.
	 * </p><p>
	 * You should not instantiate your own GameState objects -- instead, use
	 * the gameState property available on any renderable fully attached to
	 * the BaseGame.
	 * </p>
	 * 
	 * @author Cory Petosky
	 */
	public class GameState {
		internal static const $DEFAULT_COMMAND_GROUP:String = "default";
		internal static const $NO_COMMAND_GROUP_YET:String = "$noCommandGroup";
		
		private var _mouseLocation:Point;
		
		private var _keys:Keys;
		
		public var data:Object = {};
		internal var $commandGroup:String = $NO_COMMAND_GROUP_YET;

		/**
		 * @private
		 */
		public function GameState(interactiveObject:InteractiveObject) {
			_keys = Keys.instance;
			_keys.addEventSource(interactiveObject);
			
			interactiveObject.addEventListener(MouseEvent.CLICK, clickListener);
		}
		
		
		private function clickListener(event:MouseEvent):void {
			_mouseLocation = new Point(event.stageX, event.stageY);
		}

		
		
		public function isKeyDown(keyCode:Object):Boolean {
			return _keys.isDown(keyCode);
		}
		
		public function isKeyUp(keyCode:Object):Boolean {
			return !_keys.isUp(keyCode);
		}
		
		
		
		public function get mouseLocation():Point {
			if (_mouseLocation)
				return _mouseLocation.clone();
			else
				return null;
		}
		
		public function clearMouseClick():void {
			_mouseLocation = null;
		}
		
		internal function $canFireCommand(group:String):Boolean {
			return ($commandGroup == $NO_COMMAND_GROUP_YET || $commandGroup == group);
		}

	}
}
