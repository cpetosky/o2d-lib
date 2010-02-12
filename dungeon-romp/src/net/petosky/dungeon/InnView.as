package net.petosky.dungeon {
	import net.petosky.dungeon.display.Menu;
	import net.petosky.metaplay.RenderableContainer;	
	import net.petosky.dungeon.party.Character;	
	
	import flash.events.Event;	
	
	import net.petosky.dungeon.party.Roster;	
	import net.petosky.dungeon.party.Party;	
	
	/**
	 * @author Cory Petosky
	 */
	public class InnView extends RenderableContainer {
		private var _party:Party;
		private var _roster:Roster;
		private var _menu:Menu;

		public function InnView(party:Party, roster:Roster) {
			super(615, 415);
			_party = party;
			_roster = roster;
			
			_menu = new Menu();
			_menu.addOption("Rest and heal");
			_menu.addOption("Exit inn");
			_menu.addEventListener(Menu.OPTION_SELECTED, menuListener);
			_menu.x = (width - _menu.width) >> 1;
			_menu.y = (height - _menu.height) >> 1;
			attach(_menu);
		}
		
		public function menuListener(event:Event):void {
			switch (_menu.selectedOption) {
				case "Rest and heal":
					for (var i:uint = 0; i < _party.size; ++i) {
						var character:Character = _party.getCharacter(i);
						character.health = character.maxHealth;
					}
					
					_menu.showPopupMessage("Party healed.");
						
					break;
					
				case "Exit inn":
					dispatchEvent(new Event(Event.CLOSE));
					break;
			}
		}
	}
}
