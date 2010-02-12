package net.petosky.metaplay {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;		

	/**
	 * @author Cory Petosky
	 */
	public class RenderableContainer extends Renderable {
		
		private var _attachedRenderables:Array = [];
		private var _collidableRenderables:Array = [];
		
		public function RenderableContainer(width:int, height:int) {
			super(width, height);
		}

		public function attach(renderable:Renderable, point:Point = null):void {
			if (point) {
				renderable.x = point.x;
				renderable.y = point.y;
			}
			
			attachAtPosition(renderable, _attachedRenderables.length);
		}
		
		public function attachBelow(attachee:Renderable, target:Renderable):void {
			var i:uint;
			for (i = 0; i < _attachedRenderables.length; ++i) {
				if (_attachedRenderables[i] == target)
					break;
			}
			
			attachAtPosition(attachee, i);
		}
		
		public function attachAtPosition(renderable:Renderable, position:uint):void {
			renderable.setGameState(gameState);
			_attachedRenderables.splice(position, 0, renderable);
			
			if (renderable.collisionObject)
				_collidableRenderables.push(renderable);
			
			renderable.addEventListener(RenderableEvent.DESTROY, destroyListener);
			renderable.dispatchEvent(new RenderableEvent(RenderableEvent.ATTACHED));
			if (gameState)
				renderable.dispatchEvent(new RenderableEvent(RenderableEvent.ATTACHED_TO_BASE));
		}

		
		
		override public function update(delta:uint):void {
			for each (var renderable:Renderable in _attachedRenderables)
				renderable.update(delta);
			
			
			for (var i:int = 0, n:int = _collidableRenderables.length - 1; i < n; ++i) {
				var collidable:Renderable = _collidableRenderables[i];
				
				for (var j:int = i + 1, m:int = _collidableRenderables.length; j < m; ++j) {
					var otherCollidable:Renderable = _collidableRenderables[j];
					
					if (handleCollision(collidable, otherCollidable)) {
						collidable.dispatchEvent(new RenderableEvent(RenderableEvent.COLLISION, otherCollidable));
						otherCollidable.dispatchEvent(new RenderableEvent(RenderableEvent.COLLISION, collidable));
					}
				}
			}
		}
		
		private function destroyListener(event:RenderableEvent):void {
			var i:uint;
			for (i = 0; i < _attachedRenderables.length; ++i)
				if (_attachedRenderables[i] == event.object)
					_attachedRenderables.splice(i--, 1);
			
			for (i = 0;i < _collidableRenderables.length; ++i)
				if (_collidableRenderables[i] == event.object)
					_collidableRenderables.splice(i--, 1);
			
			//Renderable(event.object).setGameState(null);
			
			event.object.removeEventListener(RenderableEvent.DESTROY, destroyListener);
		}

		
		
		private function handleCollision(o1:Renderable, o2:Renderable):Boolean {
			if (o1 == o2 || !o1 || !o2)
				return false;
			
			var o1offsetX:int = o1.x;
			var o1offsetY:int = o1.y;
			var o2offsetX:int = o2.x;
			var o2offsetY:int = o2.y;
			 
			while (o1.collisionObject is Renderable) {
				o1 = Renderable(o1.collisionObject);
				o1offsetX += o1.x;
				o1offsetY += o1.y;
			}
			
			while (o2.collisionObject is Renderable) {
				o2 = Renderable(o2.collisionObject);
				o2offsetX += o2.x;
				o2offsetY += o2.y;
			}
				
			if (o1.collisionObject is Rectangle && o2.collisionObject is Rectangle) {
				var r1:Rectangle = Rectangle(o1.collisionObject).clone();
				var r2:Rectangle = Rectangle(o2.collisionObject).clone();
				
				r1.x += o1offsetX;
				r1.y += o1offsetY;
				r2.x += o2offsetX;
				r2.y += o2offsetY;

				return r1.intersects(r2);
			}
			
			return false;
		}

		
		
		override public function draw(target:BitmapData, destPoint:Point):void {
			for each (var renderable:Renderable in _attachedRenderables)
				renderable.draw(target, new Point(renderable.x, renderable.y).add(destPoint));
		}
		
		
		override internal function setGameState(value:GameState):void {
			super.setGameState(value);
			
			for each (var renderable:Renderable in _attachedRenderables)
				renderable.setGameState(value);
		}
	}
}