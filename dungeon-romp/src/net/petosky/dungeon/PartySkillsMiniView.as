package net.petosky.dungeon {
	import net.petosky.dungeon.party.Party;	
	import net.petosky.dungeon.display.Window;
	import net.petosky.dungeon.display.TextFactory;
	import flash.text.TextField;	
	
	/**
	 * @author Cory Petosky
	 */
	public class PartySkillsMiniView extends Window {
		
		private var _title:TextField;
		private var _party:Party;

		public function PartySkillsMiniView(party:Party) {
			_party = party;
			_title = TextFactory.instance.createTextField("Skills", 178, 225);
			_title.x = _title.y = 2;
			sprite.addChild(_title);
			redraw();
		}
		
		override public function update(delta:uint):void {
			super.update(delta);
			
			_title.text =
				"X: " + _party.x +
				"\nZ: " + _party.z +
				"\nFPS: " + int(1000 / delta);
		}
	}
}
