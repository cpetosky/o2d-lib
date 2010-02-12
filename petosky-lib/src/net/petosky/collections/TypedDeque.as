package net.petosky.collections {

import flash.utils.describeType;	/**
	 * @author Cory
	 */
	public class TypedDeque extends TypedQueue implements IDeque {
		private var _deque:IDeque;

		public function TypedDeque(klass:Class, deque:IDeque) {
			super(klass, deque);
			
			_deque = deque;
		}
		
		
		
		public function pushBack(o:Object):Boolean {
			return push(o);
		}
		
		
		
		public function pushFront(o:Object):Boolean {
			if (!(o is _klass))
				throw new TypeError("[TypedDeque<" + _className + ">.push] Tried to push element of type " + describeType(o).@name + ".");
			else
				return _deque.pushFront(o);			
		}
		
		
		
		public function popBack():Object {
			return _deque.popBack();
		}
		
		
		
		public function popFront():Object {
			return pop();
		}
		
		
		
		public function head():Object {
			return peek();
		}
		
		
		
		public function tail():Object {
			return _deque.tail();
		} 
	}
}
