package net.petosky.dungeon {
	import net.petosky.dungeon.display.Menu;
	import net.petosky.dungeon.GameView;
	import net.petosky.metaplay.RenderableContainer;	
	
	import flash.events.Event;	
	
	import net.petosky.dungeon.party.Roster;	
	import net.petosky.dungeon.party.Party;	
	
	/**
	 * @author Cory Petosky
	 */
	public class CampView extends RenderableContainer {
		private var _party:Party;
		private var _roster:Roster;
		private var _menu:Menu;

		public function CampView(party:Party, roster:Roster) {
			super(615, 415);
			_party = party;
			_roster = roster;
			
			_menu = new Menu();
			_menu.addOption("Save game");
			_menu.addOption("Delete game");
			_menu.addOption("Exit camp");
			_menu.addEventListener(Menu.OPTION_SELECTED, menuListener);
			_menu.x = (width - _menu.width) >> 1;
			_menu.y = (height - _menu.height) >> 1;
			attach(_menu);
		}
		
		public function menuListener(event:Event):void {
			switch (_menu.selectedOption) {
				case "Save game":
					_menu.showPopupMessage("Game saved.", 3000);
					dispatchEvent(new Event(GameView.SAVE_GAME));					
					break;
				
				case "Delete game":
					_menu.showPopupMessage("Deleted game.", 3000);
					dispatchEvent(new Event(GameView.DELETE_GAME));
					break;
					
				case "Exit camp":
					dispatchEvent(new Event(Event.CLOSE));
					break;
			}
		}
	}
}
