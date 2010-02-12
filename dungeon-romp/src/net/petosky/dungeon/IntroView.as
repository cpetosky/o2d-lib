package net.petosky.dungeon {
	import net.petosky.metaplay.KeyCommand;	
	
	import flash.events.Event;	
	
	import net.petosky.dungeon.party.Character;	
	import net.petosky.dungeon.party.Party;	
	import net.petosky.dungeon.party.Roster;	
	
	import flash.ui.Keyboard;	
	
	import net.petosky.dungeon.display.Window;

	/**
	 * @author Cory Petosky
	 */
	public class IntroView extends Window {
		private var _messages:Vector.<String> = Vector.<String>([
			"As usual, you spent today in the tavern, unemployed and useless.",
			"However, today 'felt' different. Something in the air, maybe...",
			"A messenger enters the tavern.",
			"\"Today, we report 6 more casualties from the mysterious dungeon. No additional progress has been made in exploring its depths.\"",
			"\"As always, the king is looking for more able-bodied men and women to step up and volunteer to adventure into the dungeon...\"",
			"You begin ignoring the messenger and look down at your drink. You hear this request almost daily, but dungeoneering is suicide. No matter how things get, it's better to stay drunk, poor, and alive than brave and dead.",
			"\"You there!\"\nThe messenger is suddenly mere feet away from you. This has never happened before.",
			"\"What is your name?\"",
			"Enter your name.",
			"\"I thought so. You're the first name on the king's mandatory dungeon volunteer list.\"",
			"Before you can react, the messenger places his palm to your forehead. In the reflection of your beer, you see that an ominous mark has appeared. You try, in vain, to wipe it off.",
			"\"You have been branded a volunteer dungeon explorer. Successfully explore and learn something new about the dungeon and the mark will be removed.\"",
			"\"Fail to explore the dungeon, and you'll be beheaded as a traitor.\"",
			"\"Here is 100 gold pieces to equip yourself and hire allies. Thank you for volunteering your service to the kingdom.\""
		]);
		
		private var _messageIndex:int = -1;
		private var _nameRequest:int = 8;
		
		private var _party:Party;
		private var _roster:Roster;
		
		public function IntroView(party:Party, roster:Roster) {
			super(615, 415, false);
			
			_party = party;
			_roster = roster;
			
			var keyCommand:KeyCommand = new KeyCommand(advanceMessage, Keyboard.SPACE);
			keyCommand.requireUniquePress = true;
			attach(keyCommand);
			
			addEventListener(Window.INPUT_COMPLETE, nameInputListener);
			
			showMessage(_messages[++_messageIndex], 0);
		}
		
		private function advanceMessage():void {
			if (++_messageIndex < _messages.length) {
				if (_messageIndex == _nameRequest) {
					showInputPopupMessage(_messages[_messageIndex]);
					return;
				} else {
					showMessage(_messages[_messageIndex], 0);
					return;
				}
			} else {
				dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		private function nameInputListener(event:Event):void {
			var character:Character = _roster.createCharacter();
			character.name = input; 
			_party.addCharacter(character);
			showMessage(_messages[++_messageIndex], 0);
		}
	}
}
