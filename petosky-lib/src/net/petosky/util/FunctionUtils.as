package net.petosky.util {	import flash.events.TimerEvent;		import flash.utils.Timer;
	import flash.events.Event;	
	/**	 * FunctionUtils provides a library of utility functions useful for	 * manipulating other functions.	 * 	 * @author cpetosky	 */	final public class FunctionUtils {				/**		 * Create wrapper function to run in alternate context (with arguments)		 * 		 * @param scope the context in which the closure should be run.		 * @param func the function to wrap.		 * @param args the arguments to the function.		 * @return a method that can take a variable number of additional arguments.		 */		public static function createClosure(scope:Object, func:Function, ...args):Function {				return function(...arglist):* {				return func.apply(scope, args.concat(arglist));			};		}				/**		 * Create wrapper function to run in alternate context (with arguments).		 * This differs from createEnclosure in that it takes a single array		 * full of arguments instead of a vararg list.		 * 		 * @param scope the context in which the closure should be run.		 * @param func the function to wrap.		 * @param args the arguments to the function.		 * @return a method that can take a variable number of additional arguments.		 * 		 */		public static function createClosureFromArray(scope:Object, func:Function, args:Array):Function {			return function(...arglist):* {				return func.apply(scope, args.concat(arglist));			};		}				/**		 * Create wrapper function to execute an event listener with arguments.		 * 		 * @param scope the context in which the closure should be run.		 * @param func the function to wrap, with signature function(event:Event, ...):void		 * @param args the arguments to the function.		 * @return a function that can act as an event listener.		 */		public static function createEventListener(scope:Object, func:Function, ...args):Function {			return function(event:Event):void {				func.apply(scope, [event].concat(args));			};		}				/**		 * Runs a function later. Any number of arguments to the function can		 * be specified.		 * 		 * @param delay Number of milliseconds to wait before invoking the function.		 * @param scope Context in which to run this function.		 * @param closure Function to run.		 * 		 * @return A Timer object so that the invokation may be cancelled or		 *         modified by the caller.		 */		public static function invokeLater(delay:Number, scope:Object, closure:Function, ...args):Timer {			var t:Timer = new Timer(delay, 1);			var c:Function = createClosureFromArray(scope, closure, args);			var f:Function = function(event:TimerEvent):void {				c();				t.removeEventListener(TimerEvent.TIMER, f);			};			t.addEventListener(TimerEvent.TIMER, f);			t.start();			return t;		}	}}