package net.petosky.collections {

	/**
	 * @author Cory
	 */
	public class BaseListDecorator implements IList {
		protected var _list:IList;


		public function BaseListDecorator(list:IList) {
			_list = list;
		}		
				
		public function clear():void {
			_list.clear();
		}
		
		public function setItem(index:uint, value:Object):Object {
			return _list.setItem(index, value);
		}
		
		public function insert(index:uint, ...args):Boolean {
			return insertArray(index, args);
		}
		
		public function insertArray(index:uint, a:Array):Boolean {
			return _list.insertArray(index, a);
		}
		
		public function getItem(index:uint):Object {
			return _list.getItem(index);
		}
		
		public function getFirstByProperty(propName:String, propValue:Object):Object {
			return _list.getFirstByProperty(propName, propValue);
		}
		
		public function indexOf(o:Object):int {
			return _list.indexOf(o);
		}
		
		public function add(...args):Boolean {
			return addArray(args);
		}

		public function addArray(a:Array):Boolean {
			return _list.addArray(a);
		}
		
		public function remove(...args):Boolean {
			return removeArray(args);
		}
		
		public function removeArray(a:Array):Boolean {
			return _list.removeArray(a);
		}
		
		public function get length():uint {
			return _list.length;
		}
		
		public function get empty():Boolean {
			return _list.empty;
		}
		
		public function toString():String {
			return _list.toString();
		}
		
		public function toArray():Array {
			return _list.toArray();
		}
		
		public function getListIterator():IListIterator {
			return _list.getListIterator();
		}
		
		
		
		public function sort(sortProperty:String = "", ascending:Boolean = true):void {
			_list.sort(sortProperty, ascending);
		}
	}
}
