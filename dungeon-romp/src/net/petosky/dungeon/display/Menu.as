package net.petosky.dungeon.display {
	import net.petosky.metaplay.KeyCommand;	
	import net.petosky.dungeon.display.Window;
	import net.petosky.dungeon.display.TextFactory;
	
	import flash.text.TextField;	
	import flash.events.Event;	

	/**
	 * @author Cory Petosky
	 */
	public class Menu extends Window {
		public static const OPTION_SELECTED:String = "optionSelected";
		
		private var _options:Vector.<String> = new Vector.<String>();
		private var _pointerLocation:int = 0;
		
		private var _keyCommand:KeyCommand;

		public function addOption(label:String):void {
			_options.push(label);
			initialize();
		}
		
		private function initialize():void {
			while (sprite.numChildren > 0)
				sprite.removeChildAt(0);
			
			if (_keyCommand)
				_keyCommand.destroy();
			
			_keyCommand = new KeyCommand(optionSelected);
			_keyCommand.requireUniquePress = true;
			
			for each (var option:String in _options) {
				_keyCommand.addKeyCodes((sprite.numChildren + 1).toString());
				
				var tf:TextField = TextFactory.instance.createTextField(
					"" + (sprite.numChildren + 1) + ") " + option
				);
				tf.x = 5;
				tf.y = sprite.numChildren * 25 + 5;
				sprite.addChild(tf);
			}
			
			attach(_keyCommand);
			redraw();
		}

		
		
		public function get selectedOption():String {
			return _options[_pointerLocation];
		}
		
		private function optionSelected():void {
			for (var index:int = "1".charCodeAt(); index <= "9".charCodeAt(); ++index) {
				if (gameState.isKeyDown(index)) {
					_pointerLocation = index - "1".charCodeAt();
					dispatchEvent(new Event(OPTION_SELECTED));
					return;
				}
			}
		}
	}
}
