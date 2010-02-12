package net.petosky.o2d.editor {

	import net.petosky.o2d.Tile;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.petosky.o2d.Game;
	import net.petosky.o2d.player.IPlayer;
	
	public class GameViewer extends RenderPanel {
		
		private var _game:Game;
		private var _newGame:Game;
		
		private var _player:IPlayer;
		private var _newPlayer:IPlayer;
		
		private var _trackingMouse:Boolean = false;
		private var _mouseDown:Boolean = false;
		
		public var tileToDraw:Tile;
		public var layerToDraw:int; // 0-based
		
		public function get game():Game {
			return _game;
		}
		public function set game(value:Game):void {
			_newGame = value;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		public function get player():IPlayer {
			return _player;
		}
		public function set player(value:IPlayer):void {
			_newPlayer = value;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			if (_newPlayer) {
				if (!_player && !_game)
					addListeners();
				
				_player = _newPlayer;
				view = _player.view;
				_newPlayer = null;
			}
			
			if (_newGame) {
				if (!_player && !_game)
					addListeners();
				
				_game = _newGame;
				_game.output = backingBitmap;
				_newGame = null;

			}
		}
		
		override protected function addListeners():void {
			super.addListeners();
			addEventListener(Event.ENTER_FRAME, enterFrameListener);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverListener);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutListener);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}
		
		override protected function measure():void {
			super.measure();
			
			if (_player) {
				measuredWidth += _player.map.pixelWidth;
				measuredHeight += _player.map.pixelHeight;
			} else {
				measuredWidth += 100;
				measuredHeight += 100;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			_game.output = backingBitmap;
			
			resizeScrollbars(_player.map.pixelWidth, _player.map.pixelHeight);
		}
				
		private function enterFrameListener(event:Event):void {
			_game.update();
			
			if (!scrolling && _trackingMouse) {
				selectTileUnderMouse(_player.map.width, _player.map.height);
				
				if (_mouseDown && selectedX > -1 && selectedY > -1) {
					_player.map.setTile(selectedX, selectedY, layerToDraw, tileToDraw);	
				}
			}			
		}
		
		private function mouseDownListener(event:MouseEvent):void {
			_mouseDown = true;
		}

		private function mouseUpListener(event:MouseEvent):void {
			_mouseDown = false;
		}
		
		
		private function mouseOverListener(event:MouseEvent):void {
			_trackingMouse = true;
		}

		private function mouseOutListener(event:MouseEvent):void {
			_trackingMouse = false;
		}
	}
}