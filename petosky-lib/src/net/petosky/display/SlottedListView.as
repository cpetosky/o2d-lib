package net.petosky.display {
	
	import flash.utils.Dictionary;			import net.petosky.util.ArrayUtils;	
	
	import caurina.transitions.Tweener;	
	
	import net.petosky.util.DisplayUtils;	
	
	import flash.display.DisplayObject;		/**
	 * A SlottedListView places display objects in user-defined "slots". The
	 * view can only have as many elements as it has slots. If an element is
	 * removed from a slot, the elements tween back to fill in the newly-
	 * vacant position.
	 * 	 * @author cpetosky	 */	public class SlottedListView extends BaseListView {
		private var _snapPoints:Array;
		private var _tweenParameters:Object = {};
		
		private var _oldPositions:Dictionary = new Dictionary();

		private var _backgroundClass:Class;
		private var _betweenClass:Class;
		
		/**
		 * Creates an empty SlottedListView. Extra arguments are used to define
		 * the various "snap points" that objects should snap to, in order. You
		 * can pass in a single array of objects instead of using the varargs
		 * syntax.
		 * 
		 * A "snap point" is a generic Object with a collection of
		 * DisplayObject properties. Snap points are minimally required to
		 * provide x and y values, but can optionally provide rotation, scale,
		 * and other numeric properties.
		 */
		public function SlottedListView(...args) {
			if (args.length == 1 && args[0] is Array)
				_snapPoints = args[0];
			else
				_snapPoints = args;
			
			_tweenParameters.time = 1.0;
		}
		
		

		/**
		 * This class is instantiated to make the display objects behind
		 * list elements. This class must extend DisplayObject.
		 */		
		public function get backgroundClass():Class {
			return _backgroundClass;
		}
		public function set backgroundClass(value:Class):void {
			_backgroundClass = value;
			initialize();
			updateBackgrounds();
		}
		
		
		
		private function updateBackgrounds():void {
			if (_backgroundClass) {
				for each (var snapPoint:Object in _snapPoints) {
					var b:DisplayObject= new _backgroundClass();
					DisplayUtils.fixRegistrationPoint(b);
					b.x = (snapPoint.x || 0) - (b.width >> 1);
					b.y = (snapPoint.y || 0) - (b.height >> 1);
					$addChild(b);
				}
			}			
		}
		
		
		/**
		 * This class is instantiated to make the display objects between
		 * list elements. This class must extend DisplayObject.
		 */
		public function get betweenClass():Class {
			return _betweenClass;
		}
		public function set betweenClass(value:Class):void {
			_betweenClass = value;
			initialize();
		}
		
		
		
		public function setGlobalTweenParameter(name:String, value:*):void {
			if (value == null || value == undefined)
				delete _tweenParameters[name];
			else
				_tweenParameters[name] = value;
		}
		override protected function itemAdded(d:DisplayObject):void {
			var newPosition:uint = contents.length - 1;
			
			if (newPosition >= _snapPoints.length)
				throw new Error("[SlottedListView] This list is full and cannot support any additional items.");
			var snapPoint:Object = _snapPoints[newPosition];
			
			var tween:Object;
			
			if (d.parent != this) {
				_oldPositions[d] = new OldPosition(d);

				DisplayUtils.reparent(d, this);
				tween = ArrayUtils.mergeObjects(snapPoint, _tweenParameters);
			} else {
				tween = snapPoint;
			}
			preTween(d, tween);
			Tweener.addTween(d, tween);
		}
		
		
		
		protected function preTween(d:DisplayObject, tween:Object):void { }
		
		
		override protected function itemRemoved(d:DisplayObject):void {
			if (_oldPositions[d]) {
				var oldPosition:OldPosition = _oldPositions[d];
				DisplayUtils.reparent(d, oldPosition.parent);
				Tweener.addTween(d, ArrayUtils.mergeObjects(oldPosition.tweenParams, _tweenParameters));
				
				delete _oldPositions[d];
			}
			
			var start:uint = contents.indexOf(d);
			var end:uint = contents.length;
			
			trace("Item", start, "removed");
			for (var i:uint = start, j:uint = start + 1; j < end; ++i, ++j) {
				trace("Moving item", j, "to position", i);
				Tweener.addTween(contents.getItem(j), ArrayUtils.mergeObjects(_snapPoints[i], _tweenParameters));
			}
		}	}}
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

class OldPosition {
	private var _tweenParams:Object;
	private var _parent:DisplayObjectContainer;

	public function OldPosition(d:DisplayObject) {
		_tweenParams = {x: d.x, y: d.y, scaleX: d.scaleX, scaleY: d.scaleY, rotation: d.rotation};
		_parent = d.parent;
	}
	
	public function get tweenParams():Object {
		return _tweenParams;
	}
	
	public function get parent():DisplayObjectContainer {
		return _parent;
	}
}