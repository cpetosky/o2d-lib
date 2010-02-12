package net.petosky.spelling {

	/**
	 * @author Cory
	 */
	internal class SpellNode {
		private var _letter:String;
		private var _isWord:Boolean = false;
		private var _children:Object = {};
		
		
		public function SpellNode(letter:String) {
			_letter = letter;
		}
		
		public function addSubstring(word:String):void {
			if (word.length == 0) {
				_isWord = true;
				return;
			}
			
			var firstLetter:String = word.charAt();
			if (!_children[firstLetter])
				_children[firstLetter] = new SpellNode(firstLetter);
			
			SpellNode(_children[firstLetter]).addSubstring(word.substr(1));
		}
		
		public function containsSubstring(word:String):Boolean {
			if (word.length == 0) {
				return _isWord;
			}
			
			var firstLetter:String = word.charAt();
			if (!_children[firstLetter])
				return false;
			else
				return SpellNode(_children[firstLetter]).containsSubstring(word.substr(1));
		}
		
		public function get letter():String {
			return _letter;
		}
		
		public function dumpWords(target:Array, rootString:String = ""):void {
			if (_isWord)
				target.push(rootString + _letter);
			for each (var node:SpellNode in _children)
				node.dumpWords(target, rootString + _letter);
		}
		
		
		public function get isWord():Boolean {
			return _isWord;
		}
	}
}
