package net.petosky.util {

	/**
	 * A static class with a number of static function relating to numeric
	 * operations.
	 * 
	 * @author Cory Petosky
	 */
	final public class NumberUtils {
		
		/**
		 * Adjusts value to fall within min and max. Specifically, if value
		 * is less than min, returns min. If value is greater than max, returns
		 * max. Otherwise, returns value unmodified.
		 * 
		 * @param min The minimum value to return
		 * @param value The input value
		 * @param max The maximum value to return
		 * 
		 * @return the closest number to value where min <= return <= max.
		 */
		public static function clamp(min:Number, value:Number, max:Number):Number {
			return min > value ? min : max < value ? max : value;
		}
		
		public static function isBetween(target:Number, a:Number, b:Number):Boolean {
			var min:Number = Math.min(a, b);
			var max:Number = Math.max(a, b);
			
			return (min <= target && target <= max);
		}
		
		
		
		/**
		 * Returns a random int. This function has a variety of headers.
		 * 
		 * * randomInt() -- returns a random int from all possible integral values
		 * * randomInt(negativeInt) -- returns a random int [input, 0).
		 * * randomInt(positiveInt) -- returns a random int [0, input).
		 * * randomInt(a, b) -- returns a random int [a, b) (and swaps args if b > a)
		 * * randomInt(a, b, true) -- returns a random int [a, b]
		 */
		public static function randomInt(...args):int {
			var min:int;
			var max:int;
			switch (args.length) {
				case 0:
					min = int.MIN_VALUE;
					max = int.MAX_VALUE;
				break;
				case 1:
					min = Math.min(args[0], 0);
					max = Math.max(args[0], 0);
				break;
				case 2:
					min = Math.min(args[0], args[1]);
					max = Math.max(args[0], args[1]);
				break;
				case 3:
					min = args[0];
					max = args[1] + args[2] ? 1 : 0;
				break;
			}
			return Math.floor(Math.random() * (max - min) + min);
			
		}
		
		/**
		 * Returns a random unsigned int. This function has a variety of headers.
		 * 
		 * * randomUint() -- returns a random uint from all possible integral values
		 * * randomUint(a) -- returns a random uint [0, a).
		 * * randomUint(a, b) -- returns a random uint [a, b) (and swaps args if b > a)
		 * * randomUint(a, b, true) -- returns a random uint [a, b]
		 */
		public static function randomUint(...args):uint {
			var min:uint;
			var max:uint;
			switch (args.length) {
				case 0:
					min = 0;
					max = uint.MAX_VALUE;
				break;
				case 1:
					min = 0;
					max = args[0];
				break;
				case 2:
					min = Math.min(args[0], args[1]);
					max = Math.max(args[0], args[1]);
				break;
				case 3:
					min = args[0];
					max = args[1] + args[2] ? 1 : 0;
				break;
			}
			return Math.floor(Math.random() * max + min);
		}
		
		private static var _extra:Number;
		private static var _useExtra:Boolean = false;
		
		/**
		 * Returns a random number between min and max, inclusive, where the
		 * generated numbers follow a normal distribution (aka a bell curve).
		 * 
		 * Normal distributions don't, by definition, have a min and max value,
		 * so this function sets min and max to be where the standard deviation
		 * would be -3 and 3. This function operates by generating standard
		 * deviations away from the mean and calculating the value which would
		 * have this deviation. Thus, any distances less than -3 or greater than
		 * 3 are rounded. Since 99.7% of all values drawn from the generated
		 * normal distribution are within 3 standard deviations from the mean,
		 * this results in "good enough" data, with minimal effect on the
		 * returned data. 
		 * 
		 * @param min The minimum value returned by this function
		 * @param max The maximum value returned by this function
		 * 
		 * @return a random number generated from the implied normal distribution
		 */
		public static function normalRandom(min:Number, max:Number):Number {
			if (_useExtra) {
				_useExtra = false;
				return convertRandom(min, max, _extra);
			} else {
				var x1:Number, x2:Number, w:Number;
				
				do {
					x1 = 2.0 * Math.random() - 1.0;
					x2 = 2.0 * Math.random() - 1.0;
					w = x1 * x1 + x2 * x2;
				} while (w >= 1.0);
				
				w = Math.sqrt(-2.0 * Math.log(w) / w);
				_extra = x1 * w;
				return convertRandom(min, max, x2 * w);
			}		
		}
		
		
		/**
		 * Same as normalRandom, but returns integral values. Because decimals
		 * are truncated in this version, a significantly large range (say, 10
		 * or more) is required for results that look normal.
		 */
		public static function normalRandomInt(min:int, max:int):int {
			return Math.round(normalRandom(min, max));
		}
		
		private static function convertRandom(min:Number, max:Number, factor:Number):Number {
			var midrange:Number = (max - min) / 2;
			var midpoint:Number = midrange + min;
			if (factor < -3)
				factor = -3;
			if (factor > 3)
				factor = 3;
			factor /= 3;
			
			return midpoint + (midrange * factor);
		}
	}
}
