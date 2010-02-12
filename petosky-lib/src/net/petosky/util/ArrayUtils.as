package net.petosky.util {

	/**
	 * @author cpetosky
	 */
	final public class ArrayUtils {
		
		/**
		 * Remove a value from an array. If multiple instances of the argument
		 * exist in the array, they are all removed.
		 * 
		 * @param a Array to modify
		 * @param o Value of element(s) to remove
		 */
		public static function remove(a:Array, o:*):void {
			
			var i:int = a.length;
			while(i--) if(a[i] == o) a.splice(i, 1);
		}
		
		/**
		 * Return true if the array contains the element specified. This uses
		 * the equality operator, so two object references will only be
		 * considered equal if they are references to the same object.
		 * 
		 * @param a Array to scan
		 * @param o Value to search for
		 * @return Whether the value was found
		 */
		public static function contains(a:Array, o:*):Boolean {
			return a.some(function(data:*, index:uint, array:Array):Boolean {
				return data == o;
			});
		}
		
		
		/**
		 * Get the index of the first element satisfying a custom condition.
		 * The condition function must have a signature compatible with 
		 * function(o:*):Boolean.
		 * 
		 * @param a the array to scan
		 * @param condition function to evaluate
		 * @param Index of found element in the array or -1 if not found
		 * 
		 * @throws ArgumentError if target array is null or empty
		 * @throws ArgumentError if condition function is null
		 * @throws ArgumentError if condition function does not conform to function(o:*):Boolean
		 * 
		 * @return index of first element satisfying condition function
		 */
		public static function first(a:Array, condition:Function):int {
			if (!a)
				throw new ArgumentError("[ArrayUtils.first] Target array is null.");
			else if (a.length == 0)
				throw new ArgumentError("[ArrayUtils.first] Target array is empty.");
			else if (condition == null)
				throw new ArgumentError("[ArrayUtils.first] Supplied closure is null.");
			
			var len:int = a.length;
			
			try {
				for (var i:uint = 0; i < len; ++i)
					if (condition(a[i]))
						return i;
			} catch (error:ArgumentError) {
				throw new ArgumentError("[ArrayUtils.first] Supplied condition function must conform to function(o:*):Boolean");
			}
			
			return -1;
		}

		/**
		 * Merge the properties of two objects into a single object. If
		 * identical property names exist, the merge will favor the second
		 * argument.
		 * 
		 * @param o1 Object 1
		 * @param o2 Object 2
		 * @return Object containing all dynamic properties from o1 and o2
		 */
		public static function mergeObjects(o1:Object, o2:Object):Object {

			var o3:Object = new Object();

			for (var key1:String in o1)
				o3[key1] = o1[key1];
			for (var key2:String in o2)
				o3[key2] = o2[key2];
			return o3;
		}
		
		
		
		/**
		 * Return a meaningful, debuggable string based on an array. This
		 * function delimits nested arrays so that the structure is 
		 * clearly visible.
		 * 
		 * @return string
		 */
		public static function debugArray(a:Array, t:uint = 0):String {
			var s:String = StringUtils.repeat("\t", t) + "[";
			
			for each (var o:* in a) {
				if (o is Array)
					s += "\n" + debugArray(o, t + 1) + ",\n";
				else
					s += o + ", ";
			}
			
			s = s.substr(0, s.length - 2) + "]";
			return s;
		}
		
		
		
		/**
		 * Just like array.splice, but takes an array of values to insert
		 * instead of a vararg list.
		 * 
		 * @param source the array to splice into
		 * @param startIndex where to begin insertion or deletion
		 * @param deleteCount number of elements to delete
		 * @param values array of values to insert at the startIndex
		 * 
		 * @return values deleted from the array
		 * 
		 * @see Array.splice
		 */
		public static function spliceArray(source:Array, startIndex:int, deleteCount:uint, values:Array):Array {
			return source.splice.apply(source, [startIndex, deleteCount].concat(values));
		}
		
		
		
		public static function create2DArray(width:int, height:int):Array {
			var array:Array = [];
			for (var i:uint = 0; i < width; ++i) {
				var column:Array = [];
				for (var j:uint = 0; j < height; ++j)
					column.push(null);
				array.push(column);
			}s
			
			return array;	
		}

	}
}
