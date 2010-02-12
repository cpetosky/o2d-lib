package net.petosky.metaplay {
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;		

	/**
	 * @author Cory Petosky
	 */
	public class Renderable extends EventDispatcher {
		
		private var _x:int;
		private var _y:int;
		
		private var _width:int;
		private var _height:int;
		
		private var _name:String;
		
		private var _collisionObject:Object;
		
		private var _gameState:GameState;

		public function Renderable(width:int, height:int) {
			_width = width;
			_height = height;
		}
		
		public function update(delta:uint):void {
		}
		
		
		
		public function draw(target:BitmapData, destPoint:Point):void {
		}
		
		
		
		public function get x():int {
			return _x;
		}
		public function set x(value:int):void {
			_x = value;
		}		
		
		
		public function get y():int {
			return _y;
		}
		public function set y(value:int):void {
			_y = value;
		}
		
		
		
		public function get collisionObject():Object {
			return _collisionObject;
		}
		public function set collisionObject(value:Object):void {
			_collisionObject = value;
		}
		
		
		
		public function get name():String {
			return _name;
		}
		public function set name(value:String):void {
			_name = value;
		}
		
		public function destroy():void {
			dispatchEvent(new RenderableEvent(RenderableEvent.DESTROY, this));
		}
		
		
		
		public function get width():int {
			return _width;
		}
		public function set width(value:int):void {
			_width = value;
		}
		
		
		
		public function get height():int {
			return _height;
		}
		public function set height(value:int):void {
			_height = value;
		}
		
		
		
		public function get gameState():GameState {
			return _gameState;
		}
		
		internal function setGameState(value:GameState):void {
			_gameState = value;
		}
	}
}
