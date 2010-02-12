package net.petosky.collections {	import flash.utils.Dictionary;		/**	 * @author cpetosky	 */	public class HashSet implements ISet {		private var _hash:Dictionary = new Dictionary();		private var _length:uint = 0;				public function HashSet() {					}						public function clear():void {			_length = 0;			_hash = new Dictionary();		}
		
		public function add(...args):Boolean {			return addArray(args);		}				public function addArray(a:Array):Boolean {			for each (var d:* in a) {				_hash[d] = d;				++_length;			}			return true;		}				public function contains(d:*):Boolean {			return (_hash[d] != undefined);		}				public function remove(d:*):Boolean {			if (_hash[d]) {				_hash[d] = undefined;				--_length;				return true;			}						return false;		}				public function get length():uint {			return _length;		}				public function get empty():Boolean {			return (length == 0);		}				public function toString():String {			return "Set: length: " + length;		}				public function toArray():Array {			var a:Array = [];			for each (var o:* in _hash) {				a.push(o);			}						return a;		}	}}