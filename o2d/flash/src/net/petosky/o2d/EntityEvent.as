package net.petosky.o2d {
	import flash.events.Event;	
	
	/**
	 * @author Cory
	 */
	public class EntityEvent extends Event {
		public static const VELOCITY_CHANGED:String = "velocityChanged";
		
		private var _entity:Entity;
		
		public function EntityEvent(type:String, entity:Entity) {
			super(type);
			_entity = entity;
		}
		
		public override function clone():Event {
			return new EntityEvent(type, _entity);
		}
		
		public function get entity():Entity {
			return _entity;
		}
	}
}
