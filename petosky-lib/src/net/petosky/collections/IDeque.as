package net.petosky.collections {

	/**
	 * @author Cory
	 */
	public interface IDeque extends IQueue {
		/**
		 * Adds a single item to the tail of the deque. This function runs in
		 * constant time.
		 * 
		 * This function is identical to <code>push</code>.
		 * 
		 * @param o object to add
		 * @return true
		 * @see push
		 */
		function pushBack(o:Object):Boolean;
		
		
		
		/**
		 * Adds a single item to the head of the deque. This function runs in
		 * constant time.
		 * 
		 * @param o object to add
		 * @return true
		 */	
		function pushFront(o:Object):Boolean;
		
		
		/**
		 * Removes and returns the tail of the deque.
		 * 
		 * @return the tail of the deque.
		 */
		function popBack():Object;
		
		/**
		 * Removes and returns the head of the deque.
		 * 
		 * This function is the same as <code>pop</code>.
		 * 
		 * @return the head of the deque.
		 * @see pop
		 */
		function popFront():Object;
		
		/**
		 * Returns, but does not remove, the head of the deque.
		 * 
		 * This function is the same as <code>peek</code>.
		 * 
		 * @return the head of the deque
		 */
		function head():Object;
		
		
		/**
		 * Returns, but does not remove, the tail of the deque.
		 * 
		 * @return the tail of the deque
		 */
		function tail():Object;
	}
}
