package net.petosky.dungeon {
	import net.petosky.util.NumberUtils;	
	
	/**
	 * @author Cory
	 */
	public class Directions {
		public static const NONE:uint = 0x00;
		public static const NORTH:uint = 0x01;
		public static const EAST:uint = 0x02;
		public static const SOUTH:uint = 0x04;
		public static const WEST:uint = 0x08;
		public static const ALL:uint = 0x0F;
		
		public static function get random():uint {
			return 1 << NumberUtils.randomUint(4);
		}
		
		public static function isSingular(direction:uint):Boolean {
			return (direction == Directions.NORTH ||
				direction == Directions.EAST ||
				direction == Directions.SOUTH ||
				direction == Directions.WEST
			);	
		}
		
		public static function opposite(direction:uint):uint {
			if (direction == NORTH)
				return SOUTH;
			if (direction == SOUTH)
				return NORTH;
			if (direction == WEST)
				return EAST;
			if (direction == EAST)
				return WEST;
			return NONE;
		}

		private static const directions:Vector.<uint> = Vector.<uint>([NORTH, EAST, SOUTH, WEST]);
		
		public static function getActualDirection(facing:uint, relDirection:uint):uint {
			var mod:int = 0;
			if (facing == EAST)
				mod = 1;
			else if (facing == SOUTH)
				mod = 2;
			else if (facing == WEST)
				mod = 3;
				
			if (relDirection == EAST)
				mod += 1;
			else if (relDirection == SOUTH)
				mod += 2;
			else if (relDirection == WEST)
				mod += 3;
				
			return directions[mod % 4];
		}
	}
}
