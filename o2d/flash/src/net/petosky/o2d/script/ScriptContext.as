package net.petosky.o2d.script {

	/**
	 * @author Cory
	 */
	public class ScriptContext {
		private var _script:Script;

		public var targets:Object = {};
		
		public function ScriptContext(script:Script) {
			_script = script;
		}
		
		public function handleTrigger(trigger:String, ...args):void {
			_script.handleTrigger(trigger, Vector.<String>(args), this);
		}
		
		public function get scriptName():String {
			return _script.name;
		}
	}
}
