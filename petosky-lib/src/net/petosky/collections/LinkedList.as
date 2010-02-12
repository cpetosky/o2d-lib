package net.petosky.collections {
	import net.petosky.util.ArrayUtils;import net.petosky.collections.compare.generateComparator;	
	
	/**
	 * @author Cory
	 */
	public class LinkedList implements IList {
		protected var head:LinkedListNode;
		protected var tail:LinkedListNode;
		
		internal function get _head():LinkedListNode {
			return head;
		}
		internal function set _head(value:LinkedListNode):void {
			head = value;
		}
		
		internal function get _tail():LinkedListNode {
			return tail;
		}
		internal function set _tail(value:LinkedListNode):void {
			tail = value;
		}

		internal var _length:uint;
		
		/**
		 * Creates a list by copying the provided list argument. If no argument
		 * is provided, this creates an empty list.
		 * 
		 * Note that elements are copied by reference, so changes to the
		 * elements in the new list will affect the old versions
		 * 
		 * @param list The source list to copy
		 */
		public function LinkedList(list:IList = null) {
			head = null;
			tail = null;
			_length = 0;
			
			if (list && !list.empty)
				addArray(list.toArray());
		}


		
		/**
		 * @inheritDoc
		 */
		public function add(...args):Boolean {
			return addArray(args);
		}
		
		
		
		public function addArray(a:Array):Boolean {
			for each (var data:Object in a) {
				if (_length == 0) {
					head = new LinkedListNode(data);
					tail = head;
				} else {
					tail.next = new LinkedListNode(data, null, tail);
					tail = tail.next;
				}
				++_length;
			}
			
			return true;
		}


		/**
		 * This runs in linear time, based on the length of the list.
		 * 
		 * @inheritDoc
		 */		
		public function remove(...args):Boolean {
			return removeArray(args);
		}
		
		
		/**
		 * This runs in linear time, based on the length of the list.
		 * 
		 * @inheritDoc
		 */		
		public function removeArray(a:Array):Boolean {
			var oldLength:uint = _length;
			var data:Object;
			var it:IIterator = getListIterator();
			
			while (data = it.next)
				if (ArrayUtils.contains(a, data))
					it.remove();
					
			return oldLength != _length;
		}


		/**
		 * This runs in linear time, based on the length of the list.
		 * 
		 * @inheritDoc
		 */		
		public function setItem(index:uint, value:Object):Object {
			if (index >= _length)
				throw new RangeError("[LinkedList.setItem] Requested index " + index + " in list of length " + length);
			
			var it:IListIterator = getListIterator();
			
			while (index--)
				it.next;
			
			var oldData:Object = it.next;
			it.last = value;
			
			return oldData;
		}
		
		
		
		public function getItem(index:uint):Object {
			if (index >= _length)
				throw new RangeError("[LinkedList.getItem] Requested index " + index + " in list of length " + length);
			
			var it:IIterator = getListIterator();
			
			while (index--)
				it.next;
			
			return it.next;
		}
		
		
		
		public function insert(index:uint, ...args):Boolean {
			return insertArray(index, args);
		}
		
		
		
		public function insertArray(index:uint, a:Array):Boolean {
			if (index >= _length)
				throw new RangeError("[LinkedList.getItem] Requested index " + index + " in list of length " + length);
			
			var it:IListIterator = getListIterator();
			
			while (index--)
				it.next;

			for each (var data:Object in a)
				it.insert(data);

			return true;
		}
		
		
		
		
		
		
		public function getFirstByProperty(propName:String, propValue:Object):Object {
			var data:Object;
			var it:IIterator = getListIterator();
			
			while (data = it.next)
				if (data[propName] == propValue)
					return data;
					
			return null;
		}
		
		
		
		public function indexOf(o:Object):int {
			var index:int = 0;
			var it:IIterator = getListIterator();
			var data:Object;
			
			while ((data = it.next) && data != o)
				++index;
				
			return data ? index : -1;
		}
		
		
		
		
		
		
		public function toString():String {
			var s:String = "";
			var data:Object;
			var it:IIterator = getListIterator();
			
			while (data = it.next)
				s += data + ", ";
				
			return s.substr(0, s.length - 2);
		}
		
		
		
		public function toArray():Array {
			var a:Array = [];
			var data:Object;
			var it:IIterator = getListIterator();
			
			while (data = it.next)
				a.push(data);

			return a;
		}
		
		
		
		public function clear():void {
			head = null;
			tail = null;
			_length = 0;
		}
		
		
		
		public function get length():uint {
			return _length;
		}
		
		
		
		public function get empty():Boolean {
			return _length != 0;
		}
		
		public function getListIterator():IListIterator {
			return new LinkedListIterator(this, head);
		}
		
		
		
		public function sort(sortProperty:String = "", ascending:Boolean = true):void {
			var p:LinkedListNode, q:LinkedListNode, e:LinkedListNode;
			var insize:int = 1;

			var compare:Function = generateComparator(sortProperty, ascending);
			
			if (!head)
				return;
		
			do {
				p = head;
				head = null;
				tail = null;
		
				var merges:int = 0;  /* count number of merges we do in this pass */
		
				while (p) {
					merges++;  /* there exists a merge to be done */
					/* step `insize' places along from p */
					q = p;
					var psize:int = 0;
					for (var i:int = 0; (i < insize) && q != null; i++) {
						psize++;
						q = q.next;
					}
		
					/* if q hasn't fallen off end, we have two lists to merge */
					var qsize:int = insize;
		
					/* now we have two lists; merge them */
					while (psize > 0 || ((qsize > 0) && q)) {
		
						/* decide whether next element of merge comes from p or q */
						if (psize == 0) {
							/* p is empty; e must come from q. */
							e = q; q = q.next; qsize--;
						} else if (qsize == 0 || !q) {
							/* q is empty; e must come from p. */
							e = p; p = p.next; psize--;
						} else if (compare(p.data, q.data)) {
							/* First element of p is lower (or same);
							 * e must come from p. */
							e = p; p = p.next; psize--;
						} else {
							/* First element of q is lower; e must come from q. */
							e = q; q = q.next; qsize--;
						}
				
						/* add the next element to the merged list */
						if (tail) {
							tail.next = e;
						} else {
							head = e;
						}
						e.previous = tail;
						tail = e;
					}
		
					/* now p has stepped `insize' places along, and q has too */
					p = q;
				}
				
				tail.next = null;
				
				insize <<= 1;
			} while (merges > 1);	
		}
	}
}
