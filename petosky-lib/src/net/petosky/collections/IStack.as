package net.petosky.collections {	
	/**	 * @author cpetosky	 */	public interface IStack extends ICollection {		function push(o:*):Boolean;		function pop():*;		function peek():*;	}}