package net.petosky.o2d {
	import flash.events.KeyboardEvent;	
	import flash.ui.Keyboard;	
	
	import net.petosky.o2d.script.ScriptContext;	
	import net.petosky.o2d.player.IPlayer;	
	
	import flash.display.InteractiveObject;	
	
	import net.petosky.input.Keys;	
	
	import flash.events.EventDispatcher;	
	import flash.display.BitmapData;	
	
	import flash.utils.getTimer;	
	
	/**
	 * @author Cory
	 */
	public class Game extends EventDispatcher {
//		private static const MoveRate:int = 120;
//		private static const AnimateRate:int = 175;
		
		private var _players:Vector.<IPlayer> = new Vector.<IPlayer>();
		
		private var _output:BitmapData;
		
		private var _paused:Boolean = false;
		
		private var _project:Project;
		
		private var _lastLoopTime:int;
		
		private var _globalScript:ScriptContext;

//		private ToggleState showDebugInfo;
//		private ToggleState showGrid;
//		private ToggleState pause;

		public function Game(project:Project, output:BitmapData, keyboardEventSource:InteractiveObject) {
			_project = project;
			_output = output;
			
			Keys.instance.addEventSource(keyboardEventSource);
			Keys.instance.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			Keys.instance.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		

		
		public function addPlayer(player:IPlayer):void {
			_players.push(player);
			
			if (_players.length == 1) {
				_globalScript = new ScriptContext(_project.getScript(0));
				_globalScript.targets.player = player;
			}
				
		}




		/// <summary>
		/// Allows the game to run logic such as updating the world,
		/// checking for collisions, gathering input and playing audio.
		/// </summary>
		/// <param name="gameTime">Provides a snapshot of timing values.</param>
		public function update():void {
			if (_lastLoopTime == 0) {
				_lastLoopTime = getTimer();
				return;
			}
			
			var time:int = getTimer();
			var delta:int = time - _lastLoopTime;
			_lastLoopTime = time;
			
			var player:IPlayer;
			
			// Get all unique maps currently being rendered
			var maps:Object = {};
			for each (player in _players) {
				maps[player.map.name] = player.map;
			}
			
			for each (var map:Map in maps)
				map.passTime(delta);

			for each (player in _players) {
				player.scroll();
			}

			if (!_paused) {
				_output.lock();

				for each (player in _players)
					player.renderView(_output);
					//_output.copyPixels(_resources.palettes.getPalette("Grasslands").Atlas, new Rectangle(768, 0, 2000, 2000), new Point());
//				if (showDebugInfo.On)
//					spriteBatch.DrawString(debugFont, debugText(gameTime), new Vector2(0, 0), Color.Black);
//
//				switch (players.Count) {
//					case 2:
//						drawer.drawRectangle(graphics.PreferredBackBufferWidth / 2 - 2,
//							0, 4,
//							graphics.PreferredBackBufferHeight,
//							Color.Black
//						);
//					break;
//				}

				_output.unlock();
			}
		}
		
		
		
		private function keyDownListener(event:KeyboardEvent):void {
			if (_globalScript) {
				var key:String;
				if (event.charCode)
					key = String.fromCharCode(event.charCode);
				else
					key = keyNameFromCode(event.keyCode);
					
				if (key)
					_globalScript.handleTrigger("keypress", key);
			}			
		}
		
		private function keyUpListener(event:KeyboardEvent):void {
			if (_globalScript) {
				var key:String;
				if (event.charCode)
					key = String.fromCharCode(event.charCode);
				else
					key = keyNameFromCode(event.keyCode);
				
				if (key)
					_globalScript.handleTrigger("keyrelease", key);
			}						
		}

		private function keyNameFromCode(code:uint):String {
			switch (code) {
				case Keyboard.UP: return "up";
				case Keyboard.DOWN: return "down";
				case Keyboard.LEFT: return "left";
				case Keyboard.RIGHT: return "right";
				default: return null;
			}			
		}
		
		public function get output():BitmapData {
			return _output;
		}
		public function set output(value:BitmapData):void {
			_output = value;
		}
		
		
		public function getPlayer(playerIndex:uint):IPlayer {
			return _players[playerIndex];
		}
		
		
		
		public function get project():Project {
			return _project;
		}


//		private function debugText(GameTime gameTime):String {
//			return
//				"Run Time  : " + gameTime.TotalRealTime + "\n" +
//				"FPS	   : " + 1 / gameTime.ElapsedGameTime.TotalSeconds + "\n" +
//				"Resolution: " + GraphicsAdapter.DefaultAdapter.CurrentDisplayMode.Width + " x " + GraphicsAdapter.DefaultAdapter.CurrentDisplayMode.Height;
//		}

	}
}
