package net.petosky.dungeon {
	import net.petosky.metaplay.RenderableContainer;	
	import net.petosky.dungeon.party.Roster;
	import net.petosky.dungeon.display.Menu;
	import net.petosky.dungeon.party.Party;
	import flash.events.Event;	
	
	/**
	 * @author Cory Petosky
	 */
	public class TavernView extends RenderableContainer {
		private var _party:Party;
		private var _roster:Roster;
		private var _menu:Menu;

		public function TavernView(party:Party, roster:Roster) {
			super(615, 415);
			_party = party;
			_roster = roster;
			
			_menu = new Menu();
			_menu.addOption("Add character to party");
			_menu.addOption("Exit to maze");
			_menu.addEventListener(Menu.OPTION_SELECTED, menuListener);
			_menu.x = (width - _menu.width) >> 1;
			_menu.y = (height - _menu.height) >> 1;
			attach(_menu);
		}
		
		public function menuListener(event:Event):void {
			switch (_menu.selectedOption) {
				case "Add character to party":
					if (_party.size < _party.maxSize) {
						
						_party.addCharacter(_roster.createCharacter());
						
						_menu.showPopupMessage("Character added to party.");
					} else {
						_menu.showPopupMessage("Party full.");
					}
						
					break;
					
				case "Exit to maze":
					dispatchEvent(new Event(Event.CLOSE));
					break;
			}
		}
	}
}
