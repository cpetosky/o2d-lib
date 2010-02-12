package net.petosky.dungeon {
	import net.petosky.input.Keys;	
	
	import flash.events.EventDispatcher;	
	
	import net.petosky.metaplay.BaseGame;	
	
	import flash.net.URLRequest;	
	import flash.net.URLLoaderDataFormat;	
	import flash.net.URLLoader;	
	import flash.ui.Keyboard;	
	import flash.events.KeyboardEvent;	
	import flash.net.FileReference;	
	import flash.system.Capabilities;	
	import flash.utils.ByteArray;	
	import flash.net.SharedObject;	
	
	import net.petosky.dungeon.party.Roster;
	import net.petosky.dungeon.PartySkillsMiniView;
	import net.petosky.dungeon.party.Party;
	import net.petosky.dungeon.MapView;
	import net.petosky.dungeon.maze.Maze;
	import net.petosky.dungeon.PartyMiniView;
	import flash.events.Event;	
	import flash.geom.Point;
	/**
	 * @author Cory Petosky
	 */
	[SWF(width="800", height="600", backgroundColor="#000000", frameRate="30")]
	public class Main extends BaseGame {
		
		private var _roster:Roster;
		private var _party:Party;
		private var _maze:Maze;
		
		private var _stats:PartyMiniView;
		private var _skills:PartySkillsMiniView;
		private var _map:MapView;
		
		private var _mazeView:GameView;
		
		private var _sharedObject:SharedObject = SharedObject.getLocal("dungeon");
		
		private var _preload:EventDispatcher = new EventDispatcher();

		public function Main() {
			super(800, 600, 0xFF000000);

			preload(_preload);
						
			if (_sharedObject.data.maze is ByteArray) {
				_maze = Maze.deserialize(ByteArray(_sharedObject.data.maze));
				if (_maze)
					loadCharacters();
			}
			
			if (!_maze) {
				trace("Loading maze...");
				var loader:URLLoader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.addEventListener(Event.COMPLETE, mazeLoadComplete);
				
				var request:URLRequest;
				if (loaderInfo.loaderURL.indexOf("http://") > -1)
					request = new URLRequest("http://files.petosky.net/romp/maze.rompMaze");
				else
					request = new URLRequest("maze.rompMaze");
				loader.load(request);
			}
		}
		
		private function mazeLoadComplete(event:Event):void {
			trace("Maze load done.");
			var loader:URLLoader = URLLoader(event.target);
			var bytes:ByteArray = loader.data;
			
			_maze = Maze.deserialize(bytes);
			
			if (!_maze) {
				_maze = new Maze();
				_maze.generateBlankFloor();
			}
			loadCharacters();
		}
		
		private function loadCharacters():void {
			trace("Loading characters...");
			if (_sharedObject.data.roster is ByteArray) {
				_roster = Roster.deserialize(_sharedObject.data.roster);
				if (_roster)
					_party = Party.deserialize(_sharedObject.data.party, _roster, _maze);
			}
			
			if (!_roster) {
				trace("Making new party/roster.");
				_roster = new Roster();
			
				_party = new Party(_maze.getFloor(0));
				_party.warp(_party.currentFloor.start.x, _party.currentFloor.start.y);
			}
			
			trace("Ending preload!");
			_preload.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		override public function init():void {
			super.init();
			
			Keys.instance.addEventListener(KeyboardEvent.KEY_DOWN, keyListener);
			
			_stats = new PartyMiniView(_party);
			attach(_stats, new Point(-4, 420));
			
			_skills = new PartySkillsMiniView(_party);
			attach(_skills, new Point(623, 185));

			_map = new MapView(180, 180, _maze, _party, 9, 2);
			attach(_map, new Point(620, 0));

			_mazeView = new GameView(_party, _roster, _maze);
			_mazeView.addEventListener(GameView.SAVE_GAME, saveListener);
			_mazeView.addEventListener(GameView.DELETE_GAME, deleteListener);
			
			attach(_mazeView);
		}
		
		private function saveListener(event:Event):void {
			_sharedObject.data.maze = _maze.serialize();
			_sharedObject.data.roster = _roster.serialize();
			_sharedObject.data.party = _party.serialize();
			_sharedObject.flush();
		}
		
		private function deleteListener(event:Event):void {
			delete _sharedObject.data.maze;
			delete _sharedObject.data.roster;
			delete _sharedObject.data.party;
			_sharedObject.flush();
		}
		
		private function keyListener(event:KeyboardEvent):void {
			// Running locally, spawn save dialog
			if (event.keyCode == Keyboard.F12 && Capabilities.isDebugger && loaderInfo.loaderURL.indexOf("http://") == -1) {
				var file:FileReference = new FileReference();
				file.save(_maze.serialize(), "maze.rompMaze");
			}			
		}

		
		
		override public function update(delta:uint):void {
			trace("UPDATE");
			super.update(delta);
		}
	}
}
