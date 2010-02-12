package net.petosky.collections {

	/**
	 * @author Cory
	 */
	public interface IIterator {
		function get hasNext():Boolean;
		function get next():Object;
		function remove():void;
	}
}
