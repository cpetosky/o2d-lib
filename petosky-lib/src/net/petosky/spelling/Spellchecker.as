package net.petosky.spelling {

	/**
	 * @author Cory
	 */
	public class Spellchecker {
		private var _rootNode:SpellNode = new SpellNode("");
		
		public function checkWord(word:String):Boolean {
			return _rootNode.containsSubstring(word);
		}
		
		public function addWord(word:String):void {
			_rootNode.addSubstring(word);
		}
		
		public function addWords(...args):void {
			var words:Array = args[0] is Array ? args[0] : args;
			for each (var word:String in words)
				_rootNode.addSubstring(word);
		}
		
		public function getAllWords():Array {
			var array:Array = [];
			_rootNode.dumpWords(array);
			return array;
		}
	}
}
