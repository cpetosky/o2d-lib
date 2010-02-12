package net.petosky.layer {
	import net.petosky.collections.IListIterator;			import flash.display.DisplayObject;
	
	import net.petosky.collections.ArrayList;
	import net.petosky.collections.IList;
	import net.petosky.collections.TypedList;		

	/**
	 * @author cpetosky
	 */
	public class LayerContainer extends AbstractLayer implements IList {
		private var _layers:IList;
		
		public function LayerContainer(name:String) {
			super(name);
			_layers = new TypedList(AbstractLayer, new ArrayList());
		}


		override public function clear():void {
			_layers.clear();
			while (numChildren > 0)
				removeChildAt(0);
		}
		
		public function addToLayer(layerName:String, d:DisplayObject):void {
			var layer:AbstractLayer = getLayer(layerName);
			if (layer)
				layer.add(d);
			else
				throw new ArgumentError("[LayerContainer.addToLayer] No such layer name '" + layerName + "'.");
		}
		
		
		
		public function removeFromLayer(layerName:String, d:DisplayObject):void {
			var layer:AbstractLayer = getLayer(layerName);
			if (layer)
				layer.remove(d);
			else
				throw new ArgumentError("[LayerContainer.removeFromLayer] No such layer name '" + layerName + "'.");
		}
		
		public function getLayer(layerName:String):AbstractLayer {
			return AbstractLayer(_layers.getFirstByProperty("layerName", layerName));
		}

		
		
		override public function addChild(d:DisplayObject):DisplayObject {
			var layer:AbstractLayer = d as AbstractLayer;
			if (layer)
				add(layer);
			else
				throw new ArgumentError("[LayerContainer.addChild] You can only add Layers to a LayerContainer!");
			return d;
		}


		
		override public function addChildAt(d:DisplayObject, index:int):DisplayObject {
			var layer:AbstractLayer = d as AbstractLayer;
			if (layer) {
				insert(index, layer);
			} else {
				throw new ArgumentError("[LayerContainer.addChildAt] You can only add Layers to a LayerContainer!");
			}
			return d;		
		} 

		// ====================================================================
		// IList functions
		// ====================================================================

		public function setItem(index:uint, value:Object):Object {
			var o:* = _layers.setItem(index, value);
			
			removeChildAt(index);
			addDisplayObjectAt(value as AbstractLayer, index);
			
			return o;
		}
		
		
		
		public function insert(index:uint, ...args):Boolean {
			return insertArray(index, args);
		}
		
		public function insertArray(index:uint, a:Array):Boolean {
			var b:Boolean = _layers.insertArray(index, a);
			
			for each (var layer:AbstractLayer in a)
				addDisplayObjectAt(layer, index++);
			
			return b;
		}
		
		

		public function getItem(index:uint):Object {
			return _layers.getItem(index);
		}


		
		public function getFirstByProperty(propName:String, propValue:Object):Object {
			return _layers.getFirstByProperty(propName, propValue);
		}
		
		
		
		public function indexOf(o:Object):int {
			return _layers.indexOf(o);
		}
		
		

		override public function remove(...args):Boolean {
			return removeArray(args);
		}
		
		public function removeArray(a:Array):Boolean {
			for each (var layer:AbstractLayer in a)
				removeChildAt(_layers.indexOf(layer));
				
			return _layers.removeArray(a);
		}
		
		

		override public function add(...args):Boolean {
			return addArray(args);
		}
		
		

		override public function addArray(a:Array):Boolean {
			var b:Boolean = _layers.addArray(a);
			
			for each (var layer:AbstractLayer in a)
				addDisplayObject(layer);
			
			return b;
		}
		
		

		override public function toArray():Array {
			return _layers.toArray();
		}
		
		
		
		override public function get length():uint {
			return _layers.length;
		}
		
		
		
		override public function get empty():Boolean {
			return _layers.empty;
		}
		
		public function getListIterator():IListIterator {
			return _layers.getListIterator();
		}								public function sort(sortProperty:String = "", ascending:Boolean = true):void {
			_layers.sort(sortProperty, ascending);
		}
	}
}
