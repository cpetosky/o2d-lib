package net.petosky.dungeon.party {
	import net.petosky.util.ByteArrayUtils;	
	
	import flash.utils.ByteArray;	
	
	import net.petosky.dungeon.party.Character;
	import flash.events.EventDispatcher;	
	
	/**
	 * @author Cory Petosky
	 */
	public class Roster extends EventDispatcher {
		private static const FILE_VERSION:uint = 2;
		private static const SAVE_VERSION:uint = 2;
		
		private var _characters:Vector.<Character> = new Vector.<Character>();
		
		public function serialize():ByteArray {
			var bytes:ByteArray = new ByteArray();
			
			bytes.writeUnsignedInt(SAVE_VERSION);
			bytes.writeUnsignedInt(_characters.length);
			
			for each (var character:Character in _characters)
				ByteArrayUtils.writeByteArray(character.serialize(), bytes);
			
			return bytes;
		}
		
		public static function deserialize(bytes:ByteArray):Roster {
			if (bytes.readUnsignedInt() != FILE_VERSION)
				return null;
				
			var numChars:uint = bytes.readUnsignedInt();
			
			var roster:Roster = new Roster();
			
			for (var i:uint = 0; i < numChars; ++i) {
				roster._characters[i] = Character.deserialize(ByteArrayUtils.readByteArray(bytes));
			}
			
			return roster;
		}

		
			
		public function createCharacter(job:Job = null):Character {
			if (!job)
				job = JobManager.instance.defaultJob;
				
			var character:Character = job.generateRandomCharacter(_characters.length);
			_characters.push(character);
			
			return character;
		}
		
		public function get size():int {
			return _characters.length;
		}

		public function removeCharacterByIndex(index:int):void {
			_characters.splice(index, 1);
		}
		
		public function getCharacter(index:int):Character {
			return _characters[index];
		}
	}
}
