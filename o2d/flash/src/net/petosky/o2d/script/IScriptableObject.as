package net.petosky.o2d.script {

	/**
	 * @author Cory
	 */
	public interface IScriptableObject {
		function addScriptProperty(name:String):void;
		function getScriptProperty(name:String):Object;
		function setScriptProperty(name:String, value:String):void;
		function hasScriptProperty(name:String):Boolean;
	}
}
