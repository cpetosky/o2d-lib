package net.petosky.o2d.player {
	
	import flash.display.BitmapData;	
	
	import net.petosky.o2d.Entity;	
	import net.petosky.o2d.Map;	
	
	/**
	 * @author Cory
	 */
	public interface IPlayer {
		
		function get view():View;	
		function get map():Map;
		function get avatar():Entity;

		
		
		function renderView(output:BitmapData):void;
		function scroll():void;
	}
}
