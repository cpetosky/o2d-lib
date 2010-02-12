package net.petosky.metaplay {
	import flash.geom.Point;	
	
	/**
	 * <p>
	 * A ClickableRegion is used to define a simple rectangular region attached
	 * to a function callback that is triggered when that region is clicked.
	 * </p>
	 * 
	 * @author Cory Petosky
	 */
	public class ClickableRegion extends RenderableContainer {
		
		public var handleClick:Function;
		
		public function ClickableRegion(width:int, height:int) {
			super(width, height);
		}
		
		override public function update(delta:uint):void {
			super.update(delta);
			
			var mouse:Point = gameState.mouseLocation;
			if (mouse) {
				mouse.x -= x;
				mouse.y -= y;
				
				if (mouse && mouse.x >= 0 && mouse.x < width &&
					mouse.y >= 0 && mouse.y < height
				) {
					if (handleClick != null)
						handleClick(mouse);
						
					gameState.clearMouseClick();
				}
			}
		}
	}
}
