package net.petosky.dungeon {
	import flash.geom.Point;	
	
	import net.petosky.metaplay.Renderable;	
	import net.petosky.metaplay.KeyCommand;	
	import net.petosky.metaplay.RenderableContainer;	
	import net.petosky.dungeon.party.Roster;	
	import net.petosky.geom.GridPoint;	
	import net.petosky.dungeon.maze.Maze;
	import net.petosky.dungeon.maze.CellType;
	import net.petosky.dungeon.FirstPersonView;
	import net.petosky.dungeon.maze.Cell;
	import net.petosky.dungeon.party.Party;
	import net.petosky.dungeon.BattleView;
	import flash.events.Event;	
	
	/**
	 * @author Cory Petosky
	 */
	public class GameView extends RenderableContainer {
		public static const SAVE_GAME:String = "saveGame";
		public static const DELETE_GAME:String = "deleteGame";
		
		private var _party:Party;
		private var _roster:Roster;
		private var _maze:Maze;

		private var _view:Renderable;
		private var _lastCell:Cell;

		public function GameView(party:Party, roster:Roster, maze:Maze) {
			super(620, 415);
			_party = party;
			_roster = roster;
			_maze = maze;
			
			_lastCell = _party.currentFloor.getCell(_party.cellX, _party.cellY);
			
			_party.addEventListener(Party.DOOMED, partyDoomedListener);
			
			var keyCommand:KeyCommand = new KeyCommand(showCampScreen, "C");
			keyCommand.requireUniquePress = true;
			attach(keyCommand);
			
			if (_party.size > 0) {
				showFPV();
			} else {
				addIntro();
			}
		}

		
		
		private function clearView():void {
			if (_view) {
				_view.destroy();
				_view= null;
			}
		}

		
		
		private function addIntro():void {
			_view = new IntroView(_party, _roster);
			_view.addEventListener(Event.CLOSE, exitViewListener);
			attach(_view);
		}
		
		
		private function warpToTavern():void {
			_party.currentFloor = _maze.getFloor(0);
			var tavern:GridPoint = _party.currentFloor.findCellLocation(CellType.TAVERN);
			if (tavern) {
				_party.warp(tavern.x, tavern.y);
			} else {
				throw Error("Cannot find tavern!");
			}
		}
		
		private function addTavern():void {
			_view = new TavernView(_party, _roster);
			_view.addEventListener(Event.CLOSE, exitViewListener);
			attach(_view);
		}
		
		private function addInn():void {
			_view = new InnView(_party, _roster);
			_view.addEventListener(Event.CLOSE, exitViewListener);
			attach(_view);
			
		}
		
		private function showCampScreen():void {
			clearView();
			
			_view = new CampView(_party, _roster);
			_view.addEventListener(SAVE_GAME, redispatcher);
			_view.addEventListener(DELETE_GAME, redispatcher);
			_view.addEventListener(Event.CLOSE, exitViewListener);
			
			attach(_view);
		}
		
		private function redispatcher(event:Event):void {
			dispatchEvent(event);
		}
		
		private function exitViewListener(event:Event):void {
			clearView();
			
			showFPV();
		}

		
		
		private function partyDoomedListener(event:Event):void {
			clearView();
			
			warpToTavern();
			addTavern();
		}
		
		private function showFPV():void {
			_view = new FirstPersonView(620, 415, _maze, _party);
			attach(_view);
		}

			
		
		private function checkBattle():void {
			if (Math.random() < _party.currentFloor.encounterRate) {
				clearView();
				
				// battle start
				_view = new BattleView(_party.currentFloor.id + 1, _party);
				_view.addEventListener(BattleView.BATTLE_ESCAPE, exitViewListener);
				_view.addEventListener(BattleView.BATTLE_WON, exitViewListener);
				attach(_view, new Point(10, 10));
			}
		}
		
		override public function update(delta:uint):void {
			super.update(delta);
			
			var cell:Cell = _party.currentFloor.getCell(_party.cellX, _party.cellY);
			if (cell != _lastCell) {
				cell.visited = true;
				
				if (cell.object) {
					if (cell.object.type == CellType.TAVERN) {
						clearView();
						addTavern();
					} else if (cell.object.type == CellType.INN) {
						clearView();
						addInn();
					}
				} else {
					checkBattle();
				}
				
				_lastCell = cell;			
			}
		}
	}
}
