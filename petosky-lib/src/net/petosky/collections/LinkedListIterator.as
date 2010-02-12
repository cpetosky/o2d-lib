package net.petosky.collections {
	import flash.errors.IllegalOperationError;	
	
	/**
	 * @author Cory
	 */
	internal class LinkedListIterator implements IListIterator {
		private var _list:LinkedList;
		private var _nextNode:LinkedListNode;
		private var _lastNode:LinkedListNode;

		public function LinkedListIterator(list:LinkedList, node:LinkedListNode) {
			_list = list;
			_nextNode = node;
		}
		
		
		public function get hasNext():Boolean {
			return _nextNode != null;
		}
		
		
		
		public function get next():Object {
			if (!hasNext)
				return null;
			
			_lastNode = _nextNode;
			_nextNode = _nextNode.next;
			
			return _lastNode.data;
		}
		
		
		
		public function remove():void {
			if (!_lastNode)
				throw new IllegalOperationError("Cannot call remove before calling next or previous.");
			
			if (_lastNode == _list._head)
				_list._head = _lastNode.next;
			
			if (_lastNode == _list._tail)
				_list._tail = _lastNode.previous;
			
			if (_lastNode.previous)
				_lastNode.previous.next = _lastNode.next;
			
			if (_lastNode.next)
				_lastNode.next.previous = _lastNode.previous;
				
			--_list._length;
			
			_lastNode = null;
		}

		
		
		public function insert(data:Object):void {
			var temp:LinkedListNode = new LinkedListNode(data, _nextNode);
			
			if (!_nextNode) {
				temp.previous = _list._tail;
				_list._tail.next = temp;
				_list._tail = temp;
			} else if (_nextNode.previous) {
				temp.previous = _nextNode.previous;
				_nextNode.previous.next = temp;
				_nextNode.previous = temp;
			} else {
				_list._head = temp;
				_nextNode.previous = temp;
			}
			
			++_list._length;
			
			_lastNode = null;
		}
		
		
		public function set last(data:Object):void {
			if (!_lastNode)
				throw new IllegalOperationError("Cannot set last before calling next or previous.");
				
			_lastNode.data = data;
		}
	}
}
