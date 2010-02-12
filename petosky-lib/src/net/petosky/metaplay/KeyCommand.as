package net.petosky.metaplay {
	
	/**
	 * <p>
	 * A KeyCommand is an attachable callback that fires whenever a specified
	 * key command is entered by the user. KeyCommands can be set up in
	 * different command groups -- one a command from one group fires, only
	 * other commands in the same group can fire in the same frame. This is
	 * handy for making sure your movement code doesn't interfere with, say,
	 * your menu code.
	 * </p><p>
	 * KeyCommand supports binding multiple keys to the same command by default.
	 * Alternatively, set requireUniquePress to true, and all keyCodes added to
	 * the command are required before the command will fire. This is especially
	 * useful for commands that involve Shift or Ctrl/Cmd.
	 * </p><p>
	 * KeyCommand supports timeouts to prevent a specific command from firing
	 * too often. It also supports requiring a discrete keypress for each
	 * command (vs firing every frame while the key combo is held down).
	 * </p>
	 * 
	 * @author Cory Petosky
	 */
	public class KeyCommand extends Renderable {
		
		private var _keyCodes:Array = [];
		private var _timeout:int;
		private var _command:Function;
		
		private var _requireUniquePress:Boolean = false;
		private var _requireAllKeys:Boolean = false;
		
		private var _wasDown:Boolean = false;
		
		private var _counter:int;
		
		private var _commandGroup:String = GameState.$DEFAULT_COMMAND_GROUP;

		public function KeyCommand(command:Function, ...args) {
			super(0, 0);
			_command = command;
			
			addKeyCodesFromArray(args);
		}
		
		public function addKeyCodes(...args):void {
			addKeyCodesFromArray(args);
		}
		
		public function addKeyCodesFromArray(codes:Array):void {
			for each (var code:Object in codes)
				_keyCodes.push(code);
		}
		
		public function get timeout():int {
			return _timeout;
		}
		public function set timeout(timeout:int):void {
			_timeout = timeout;
			_counter = timeout;
		}
		
		public function get command():Function {
			return _command;
		}
		public function set command(command:Function):void {
			_command = command;
		}
		
		override public function update(delta:uint):void {
			var isDown:Boolean = isOneDown();
			
			_counter += delta;
			
			if ((_counter > _timeout) &&
				isDown &&
				!(_requireUniquePress && _wasDown) &&
				gameState.$canFireCommand(_commandGroup)
			) {
				trace(isDown, _wasDown, _keyCodes);
				_counter = 0;
				_command();
				gameState.$commandGroup = _commandGroup;
			}
			
			_wasDown = isDown;
		}
		
		private function isOneDown():Boolean {
			var fire:Boolean = _requireAllKeys;
			
			for each (var keyCode:Object in _keyCodes)
				if (_requireAllKeys)
					fire &&= gameState.isKeyDown(keyCode);
				else
					fire ||= gameState.isKeyDown(keyCode);
				
			return fire;
		}
		
		
		public function get requireUniquePress():Boolean {
			return _requireUniquePress;
		}
		public function set requireUniquePress(value:Boolean):void {
			_requireUniquePress = value;
		}
		
		
		
		public function get commandGroup():String {
			return _commandGroup;
		}
		public function set commandGroup(value:String):void {
			_commandGroup = value;
		}
		
		
		
		public function get requireAllKeys():Boolean {
			return _requireAllKeys;
		}
		public function set requireAllKeys(value:Boolean):void {
			_requireAllKeys = value;
		}
	}
}
