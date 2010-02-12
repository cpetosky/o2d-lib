package net.petosky.o2d {

	/**
	 * @author Cory
	 */
	public final class TileAccess {
		public static const NONE:uint        = 0x00;
		public static const ENTER_WEST:uint  = 0x01;
		public static const ENTER_NORTH:uint = 0x02;
		public static const ENTER_EAST:uint  = 0x04;
		public static const ENTER_SOUTH:uint = 0x08;
		public static const LEAVE_WEST:uint  = 0x10;
		public static const LEAVE_NORTH:uint = 0x20;
		public static const LEAVE_EAST:uint  = 0x40;
		public static const LEAVE_SOUTH:uint = 0x80;
		public static const ALL:uint         = 0xff;
	}
}
