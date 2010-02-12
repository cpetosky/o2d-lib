package net.petosky.collections {

	/**
	 * @author Cory
	 */
	public interface IListIterator extends IIterator {
		function insert(data:Object):void;
		function set last(data:Object):void;
	}
}
