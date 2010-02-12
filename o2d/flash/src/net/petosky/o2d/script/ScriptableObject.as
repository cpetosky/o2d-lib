package net.petosky.o2d.script {

	/**
	 * @author Cory
	 */
	public class ScriptableObject implements IScriptableObject {
		private var _properties:Object = {};
		private var _type:String;
		
		public function ScriptableObject(type:String) {
			_type = type;
		}
		
		public function addScriptProperty(name:String):void {
			_properties[name] = name;
		}
		
		public function hasScriptProperty(name:String):Boolean {
			return _properties[name] != undefined;
				
		}
		
		public function getScriptProperty(name:String):Object {
			if (_properties[name])
				return this[_properties[name]];
			else
				throw new Error("'" + _type + "' objects don't have a '" + name + "' property.");
		}
		
		public function setScriptProperty(name:String, value:String):void {
			if (_properties[name]) {
				var currentValue:Object = this[_properties[name]];
				if (currentValue is String)
					this[_properties[name]] = value;
				else if (currentValue is int)
					this[_properties[name]] = parseInt(value);
				else if (currentValue is Number)
					this[_properties[name]] = parseFloat(value);
				else if (currentValue is Boolean)
					this[_properties[name]] = value == "true";
				else
					throw new Error(_type + "." + name + " is of an unsupported type, please file a bug.");
			} else {
				throw new Error("'" + _type + "' objects don't have a '" + name + "' property.");
			}
		}
	}
}
