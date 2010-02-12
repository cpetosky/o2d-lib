package net.petosky.dungeon.party {

	/**
	 * @author Cory Petosky
	 */
	public class Job {
		
		private var _id:int = 0;
		private var _name:String = "Jobless";
		
		public function Job(id:int, name:String) {
			_id = id;
			_name = name;
		}
		
		public function generateRandomCharacter(id:uint):Character {
			var character:Character = new Character(id, this);
			character.maxHealth = character.health = 10 + int(Math.random() * 10);
			character.maxPower = character.power = 10 + int(Math.random() * 10);
			
			character.strength = 6 + int(Math.random() * 8);
			character.defense = 6 + int(Math.random() * 8);
			character.fervor = 6 + int(Math.random() * 8);
			character.inspiration = 6 + int(Math.random() * 8);
			character.cunning = 6 + int(Math.random() * 8);
			character.luck = 6 + int(Math.random() * 8);
			
			return character;
		}
		
		
		
		public function get id():int {
			return _id;
		}
		
		
		
		public function get name():String {
			return _name;
		}
	}
}
