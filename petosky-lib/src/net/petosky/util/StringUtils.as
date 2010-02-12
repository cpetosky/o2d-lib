package net.petosky.util {
	/**
	 * @author Cory Petosky
	 */
	final public class StringUtils {
		public static function isWhitespace(c:String):Boolean {
			return c == " " || c == "\n" || c == "\r" || c == "\t" || c == "\f";
		}
		
		/**
		 * Strip whitespace from both ends of a string
		 *
		 * @param str String to strip
		 * @return Stripped string
		 */
		public static function trim(s:String):String {
			var left:int = 0;
			var right:int = s.length - 1;
			var char:String = s.charAt(0);
		
			while (isWhitespace(char))
				char = s.charAt(++left);
			
			char = s.charAt(right);
			
			while (isWhitespace(char))
				char = s.charAt(--right);
			
			return s.substr(left, right - left + 1);
		}
		
		/**
		 * Generate a string by repeating a string.
		 * 
		 * @param s String to repeat
		 * @param count number of times to repeat the string
		 * @return s repeated count times
		 */
		public static function repeat(s:String, count:uint):String {
			var s2:String = "";
			for (var i:uint = 0; i < count; ++i)
				s += s;
			return s2;
		}
		
		/**
		 * Captialize the first letter of every word.
		 * @param s String to convert
		 * @return s in title case
		 */
		public static function toTitleCase(s:String):String {
			s = trim(s);
			var a:Array = s.split(" ");
			for (var key:String in a)
				a[key] = a[key].charAt().toUpperCase() + a[key].substr(1).toLowerCase();
			return a.join(" ");
		}
	}
}
