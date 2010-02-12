package net.petosky.dungeon.party {
	import flash.utils.ByteArray;	
	
	/**
	 * @author Cory Petosky
	 */
	public class Character {
		private var _x:int;
		private var _y:int;
		
		// character
		private var _id:uint;
		private var _name:String = "Hero";
		
		private var _health:int;
		private var _maxHealth:int;
		
		private var _power:int;
		private var _maxPower:int;
		
		private var _strength:int;
		private var _defense:int;
		private var _fervor:int;
		private var _inspiration:int;
		private var _cunning:int;
		private var _luck:int;
		
		private var _xp:uint = 0;
		private var _xpForNext:int = 100;
		private var _level:int = 1;
		
		private var _jobs:Vector.<Job> = new Vector.<Job>();
		private var _currentJobIndex:int = -1;
		
		public function Character(id:uint, job:Job) {
			_id = id;
			_jobs.push(job);
			_currentJobIndex = 0;
		}
		
		public function serialize():ByteArray {
			var bytes:ByteArray = new ByteArray();
			
			bytes.writeUnsignedInt(_id);
			
			bytes.writeUTF(_name);
			bytes.writeInt(_health);
			bytes.writeInt(_maxHealth);
		
			bytes.writeInt(_power);
			bytes.writeInt(_maxPower);
		
			bytes.writeInt(_strength);
			bytes.writeInt(_defense);
			bytes.writeInt(_fervor);
			bytes.writeInt(_inspiration);
			bytes.writeInt(_cunning);
			bytes.writeInt(_luck);

			bytes.writeUnsignedInt(_xp);
			bytes.writeInt(_xpForNext);
			bytes.writeInt(_level);


			bytes.writeInt(_currentJobIndex);
			bytes.writeInt(_jobs.length);
			
			for each (var job:Job in _jobs) {
				bytes.writeInt(job.id);
			}
			
			
			return bytes;
		}
		
		public static function deserialize(bytes:ByteArray):Character {
			var id:uint = bytes.readUnsignedInt();
			
			var character:Character = new Character(id, null);
			
			character._name = bytes.readUTF();

			character._health = bytes.readInt();
			character._maxHealth = bytes.readInt();
		
			character._power = bytes.readInt();
			character._maxPower = bytes.readInt();
		
			character._strength = bytes.readInt();
			character._defense = bytes.readInt();
			character._fervor = bytes.readInt();
			character._inspiration = bytes.readInt();
			character._cunning = bytes.readInt();
			character._luck = bytes.readInt();

			character._xp = bytes.readUnsignedInt();
			character._xpForNext = bytes.readInt();
			character._level = bytes.readInt();

			character._currentJobIndex = bytes.readInt();
			var numJobs:int = bytes.readInt();
			
			for (var i:uint = 0; i < numJobs; ++i) {
				character._jobs[i] = JobManager.instance.getJobByID(bytes.readInt());
			}
			
			return character;
		}

		
		
		public function gainLevel():void {
			xp = _xpForNext;
		}

		private function checkForLevelUp():void {
			while (_xp >= _xpForNext) {
				_level++;
				var gain:int = 1 + Math.random() * 5;
				_maxHealth += gain;
				_health += gain;
				
				gain = 1 + Math.random() * 5;
				_maxPower += gain;
				_power += gain;
				
				gain = 1 + Math.random() * 4;
				_strength += gain;
				
				gain = 1 + Math.random() * 4;
				_defense += gain;
				
				gain = 1 + Math.random() * 4;
				_fervor += gain;
				
				gain = 1 + Math.random() * 4;
				_inspiration += gain;
				
				gain = 1 + Math.random() * 4;
				_cunning += gain;
				
				gain = 1 + Math.random() * 4;
				_luck += gain;
				
				
				_xp -= _xpForNext;
				if (_xp < 0)
					_xp = 0;
				var lastXpReq:int = _xpForNext;
				_xpForNext = Math.floor(_xpForNext * 1.5);
				if (_xpForNext < lastXpReq)
					_xpForNext = int.MAX_VALUE;
			}
		}

		public function get x():int {
			return _x;
		}
		public function set x(value:int):void {
			_x = value;
		}
		
		
		
		public function get y():int {
			return _y;
		}
		public function set y(value:int):void {
			_y = value;
		}
		
		
		
		public function get health():int {
			return _health;
		}
		public function set health(value:int):void {
			_health = value;
		}
		
		
		
		public function get maxHealth():int {
			return _maxHealth;
		}
		public function set maxHealth(value:int):void {
			_maxHealth = value;
		}
		
		
		
		public function get strength():int {
			return _strength;
		}
		public function set strength(value:int):void {
			_strength = value;
		}
		
		
		
		public function get defense():int {
			return _defense;
		}
		public function set defense(value:int):void {
			_defense = value;
		}
		
		
		
		public function get xp():uint {
			return _xp;
		}
		public function set xp(value:uint):void {
			_xp = value;
			checkForLevelUp();
		}
		
		
		
		public function get xpForNext():int {
			return _xpForNext;
		}
		
		
		
		public function get level():int {
			return _level;
		}
		
		
		
		public function get name():String {
			return _name;
		}
		public function set name(value:String):void {
			_name = value;
		}
		
		
		
		public function get power():int {
			return _power;
		}
		public function set power(value:int):void {
			_power = value;
		}
		
		
		
		public function get maxPower():int {
			return _maxPower;
		}
		public function set maxPower(value:int):void {
			_maxPower = value;
		}
		
		
		
		public function get fervor():int {
			return _fervor;
		}
		public function set fervor(value:int):void {
			_fervor = value;
		}
		
		
		
		public function get inspiration():int {
			return _inspiration;
		}
		public function set inspiration(value:int):void {
			_inspiration = value;
		}
		
		
		
		public function get cunning():int {
			return _cunning;
		}
		public function set cunning(value:int):void {
			_cunning = value;
		}
		
		
		
		public function get luck():int {
			return _luck;
		}
		public function set luck(value:int):void {
			_luck = value;
		}
		
		
		public function get currentJob():Job {
			return _jobs[_currentJobIndex];
		}
		
		
		
		public function get id():uint {
			return _id;
		}
	}
}
