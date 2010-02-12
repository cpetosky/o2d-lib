package net.petosky.collections {
	/**
	 * @author Cory
	 */
	internal class LinkedListNode {
		public var next:LinkedListNode;
		public var previous:LinkedListNode;
		public var data:Object;
		
		public function LinkedListNode(data:Object = null, next:LinkedListNode = null, previous:LinkedListNode = null) {
			this.data = data;
			this.next = next;
			this.previous = previous;
		}
	}
}
