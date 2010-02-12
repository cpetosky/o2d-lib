package net.petosky.dungeon {
	import net.petosky.dungeon.display.TextFactory;	
	import net.petosky.dungeon.display.Window;
	import net.petosky.dungeon.party.Party;
	import net.petosky.dungeon.CharacterMiniView;
	import flash.events.Event;	
	import flash.text.TextField;	
	
	/**
	 * @author Cory Petosky
	 */
	public class PartyMiniView extends Window {
		private var _party:Party;

		private var _nameField:TextField;
		private var _hpField:TextField;
		private var _powerField:TextField;
		
		private var _xpField:TextField;
		private var _levelField:TextField;
		
		public function PartyMiniView(party:Party) {
			super(805, 180);
			_party = party;
			_party.addEventListener(Party.CHARACTER_ADDED, initialize);
			
			_nameField = TextFactory.instance.createTextField("Name", 100);
			_nameField.x = 5;
			sprite.addChild(_nameField);
			
			_hpField = TextFactory.instance.createTextField("Health", 150);
			_hpField.x = 115;
			sprite.addChild(_hpField);
			
			_powerField = TextFactory.instance.createTextField("Power", 150);
			_powerField.x = 275;
			sprite.addChild(_powerField);
			
			_xpField = TextFactory.instance.createTextField("Experience", 250);
			_xpField.x = 435;
			sprite.addChild(_xpField);
			
			_levelField = TextFactory.instance.createTextField("Level", 100);
			_levelField.x = 695;
			sprite.addChild(_levelField);
			
			initialize();
		}
		
		private function initialize(event:Event = null):void {
			var i:uint;
			for (i = 0; i < sprite.numChildren; ++i)
				if (sprite.getChildAt(i) is CharacterMiniView)
					sprite.removeChildAt(i--);
					
			for (i = 0; i < _party.size; ++i) {
				var charView:CharacterMiniView = new CharacterMiniView( _party.getCharacter(i));
				charView.y = (sprite.numChildren - 4) * 25;
				sprite.addChild(charView);
			}			
		}
		
		override public function update(delta:uint):void {
			super.update(delta);
			
			redraw();
			for (var i:uint = 0; i < sprite.numChildren; ++i) {
				var view:CharacterMiniView = sprite.getChildAt(i) as CharacterMiniView;
				if (view)
					view.update(); 
			}
		}
	}
}
