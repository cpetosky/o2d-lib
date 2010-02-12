package net.petosky.metaplay {

	/**
	 * @author Cory Petosky
	 */
	internal class State {
		public var start:uint;
		public var length:uint;
		public var name:String;
		public var repeat:int;
		public var next:String;
		
		public function State(start:uint, name:String) {
			this.start = start;
			this.name = name;
		}
	}
}
