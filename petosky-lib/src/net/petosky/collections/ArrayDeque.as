package net.petosky.collections {

	/**
	 * @author Cory
	 */
	public class ArrayDeque extends ArrayQueue implements IDeque {

		/**
		 * @inheritDoc
		 */
		public function pushBack(o:Object):Boolean {
			return push(o);
		}
		
		
		
		/**
		 * @inheritDoc
		 */
		public function pushFront(o:Object):Boolean {
			_array.unshift(o);
			return true;
		}
		
		
		
		/**
		 * @inheritDoc
		 */
		public function popBack():Object {
			return _array.pop();
		}
		
		
		/**
		 * @inheritDoc
		 */		
		public function popFront():Object {
			return pop();
		}

		/**
		 * @inheritDoc
		 */
		public function head():Object {
			return peek();
		}

		/**
		 * @inheritDoc
		 */
		public function tail():Object {
			return _array[_array.length - 1];
		}

	}
}
