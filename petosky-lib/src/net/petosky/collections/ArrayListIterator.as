package net.petosky.collections {

	/**
	 * @author Cory
	 */
	internal class ArrayListIterator implements IListIterator {
		private var _list:ArrayList;
		private var _array:Array;
		private var _index:uint = 0;
		
		public function ArrayListIterator(list:ArrayList, array:Array) {
			_list = list;
			_array = array;
		}
		
		
		
		public function get hasNext():Boolean {
			return _index + 1 < _array.length;
		}
		


		public function get next():Object {
			return hasNext ? _array[_index++] : null;
		}



		public function remove():void {
			_array.splice(_index, 1);
			if (_index > 0)
				--_index;
		}



		public function insert(data:Object):void {
			_array.splice(_index, 0, data);
			++_index;
		}
		
		public function set last(data:Object):void {
			
		}
	}
}
