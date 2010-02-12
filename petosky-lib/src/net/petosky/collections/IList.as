package net.petosky.collections {	/**	 * An IList provides functions to randomly access and manipulate data	 * within it.	 * 	 * A list is basically a densely-packed array. List elements are indexed	 * from 0 to (length - 1). There are no "holes" in a list -- every element	 * has a value (even if that value is null or undefined).	 * 	 * @author cpetosky	 */	public interface IList extends ICollection {		/**		 * Sets the element at the specified index.		 * 		 * @param index the index of the element to set		 * @param value the new list element		 * @return old list element at that location		 * 		 * @throws RangeError if requested index is not in [0, length)		 */		function setItem(index:uint, value:Object):Object;		/**		 * Returns the list element at the specified index.		 * 		 * @param index the index of the element to get		 * @return list element at provided index		 * 		 * @throws RangeError if requested index is not in [0, length)		 */				function getItem(index:uint):Object;				/**		 * Inserts the element(s) at the specified index. If an		 * array is passed to this function, the entire array is inserted as		 * a single list element -- if you want to insert each member of an		 * array as a separate element, use insertArray.		 * 		 * @param index where to begin insertion		 * @param args the new list element(s)		 * @return true		 * 		 * @throws RangeError if requested index is not in [0, length]		 * @see insertArray		 */				function insert(index:uint, ...args):Boolean;		/**		 * Inserts the elements of the array into the list at the specified		 * index. If you want to insert an array as a single element		 * of the list, use insert.		 * 		 * @param index where to begin insertion		 * @param a an array of new elements to insert		 * @return true		 * 		 * @throws RangeError if requested index is not in [0, length]		 * @see insert		 */		function insertArray(index:uint, a:Array):Boolean;				/**		 * Removes the first instance of each specified object from the list.		 * 		 * @param args The object(s) to be removed from the list.		 * @return true if an object was removed.		 */		function remove(...args):Boolean;		/**		 * Removes the first instance of each element of the array from the		 * list.		 *  		 * @param a an array of elements to remove from the list.		 * @return true if an object was removed.		 */		function removeArray(a:Array):Boolean;				/**		 * Return the first list element that has the specified property with		 * the specified value. If no such element exists, returns null.		 * 		 * @param propName the name of the property to compare on		 * @param propValue the required value of the named property		 * @return list element or null		 */		function getFirstByProperty(propName:String, propValue:Object):Object;				/**		 * Returns the first index of the specified element, or -1 if it		 * is not found.		 * 		 * @param o object to search for		 * @return Index of the object, or -1		 */		function indexOf(o:Object):int;				/**		 * An iterator to the first element in this list.		 */		function getListIterator():IListIterator;				function sort(sortProperty:String = "", ascending:Boolean = true):void;	}}