package net.petosky.metaplay {
	import flash.events.Event;		

	/**
	 * @author Cory Petosky
	 */
	public class RenderableEvent extends Event {
		
		public static const ATTACHED:String = "attached";
		public static const ATTACHED_TO_BASE:String = "attachedToBase";
		public static const COLLISION:String = "collision";
		public static const DESTROY:String = "destroy";
		
		private var _object:Renderable;

		public function RenderableEvent(type:String, object:Renderable = null) {
			super(type);
			_object = object;
		}
		
		override public function clone():Event {
			return new RenderableEvent(type, _object);
		}
		
		
		
		public function get object():Renderable {
			return _object;
		}
	}
}
