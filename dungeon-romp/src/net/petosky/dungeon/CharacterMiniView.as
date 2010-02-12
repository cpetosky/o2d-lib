package net.petosky.dungeon {
	import net.petosky.dungeon.display.TextFactory;
	import net.petosky.dungeon.display.StatField;
	import net.petosky.dungeon.party.Character;
	import flash.text.TextField;	
	import flash.display.Sprite;	
	
	/**
	 * @author Cory Petosky
	 */
	public class CharacterMiniView extends Sprite {
		private var _character:Character;
		
		private var _nameField:TextField;
		private var _hpField:StatField;
		private var _powerField:StatField;
		
		private var _xpField:StatField;
		private var _levelField:StatField;

		public function CharacterMiniView(character:Character) {
			_character = character;
			
			_nameField = TextFactory.instance.createTextField("", 100);
			_nameField.x = 5;
			addChild(_nameField);
			
			_hpField = TextFactory.instance.createStatField(150);
			_hpField.x = 115;
			addChild(_hpField);
			
			_powerField = TextFactory.instance.createStatField(150);
			_powerField.x = 275;
			addChild(_powerField);
						
			_xpField = TextFactory.instance.createStatField(250);
			_xpField.x = 435;
			addChild(_xpField);
			
			_levelField = TextFactory.instance.createStatField(100);
			_levelField.x = 695;
			addChild(_levelField);
			
			update();
		}
		
		
		public function update():void {
			_nameField.text = _character.name;
			_hpField.maxValue = _character.maxHealth;
			_hpField.value = _character.health;
			_powerField.maxValue = _character.maxPower;
			_powerField.value = _character.power;
			
			_xpField.maxValue = _character.xpForNext;
			_xpField.value = _character.xp;
			_levelField.value = _character.level;
		}

		
		
		public function get character():Character {
			return _character;
		}
		public function set character(value:Character):void {
			_character = value;
		}
	}
}
