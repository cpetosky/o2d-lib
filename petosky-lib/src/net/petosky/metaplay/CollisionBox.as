package net.petosky.metaplay {
	import flash.geom.Rectangle;		

	/**
	 * <p>
	 * A CollisionBox can be used to quickly define a rectangular region
	 * for collision detection.
	 * </p>
	 * 
	 * @author Cory Petosky
	 */
	public class CollisionBox extends Renderable {
		
		public function CollisionBox(name:String, width:uint, height:uint) {
			super(width, height);
			this.name = name;
			collisionObject = new Rectangle(0, 0, width, height);
		}
	}
}
