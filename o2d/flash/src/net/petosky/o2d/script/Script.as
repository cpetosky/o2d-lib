package net.petosky.o2d.script {

	import org.antlr.runtime.tree.CommonTreeNodeStream;
	import org.antlr.runtime.tree.CommonTree;
	import org.antlr.runtime.CommonTokenStream;
	import org.antlr.runtime.ANTLRStringStream;
	/**
	 * @author Cory
	 */
	public class Script {
		private var _name:String;
		private var _text:String;
		private var _handlers:Object = {};
		
		public function Script(name:String, text:String) {
			_name = name;
			_text = text;
		}
		
		
		public function addHandler(func:Function, triggerName:String, triggerArgs:Vector.<String>):void {
			var trigger:Trigger = new Trigger(func, triggerName, triggerArgs);
			
			trace("Adding trigger:", triggerName, triggerArgs);
			
			if (!_handlers[triggerName])
				_handlers[triggerName] = new Vector.<Trigger>();
				
			_handlers[triggerName].push(trigger);
		}
		
		
		public function handleTrigger(triggerName:String, args:Vector.<String>, context:ScriptContext):void {
			if (_handlers[triggerName]) {
				for each (var trigger:Trigger in _handlers[triggerName]) {
					if (trigger.args.length == args.length && trigger.args.join() == args.join()) {
						trigger.func(context);
						return;
					}
				}
			}
		}
		
		
		
		public function get name():String {
			return _name;
		}
		public function set name(value:String):void {
			_name = value;
		}
		
		public function toString():String {
			return name;
		}
		
		
		
		public function get text():String {
			return _text;
		}
		public function set text(value:String):void {
			_text = value;
		}
		
		public static function loadAndParse(name:String, text:String):Script {
			var lexer:ScriptLexer = new ScriptLexer(new ANTLRStringStream(text));
			var tokens:CommonTokenStream = new CommonTokenStream(lexer);
			var parser:ScriptParser = new ScriptParser(tokens);
			
			var tree:CommonTree = CommonTree(parser.program().tree);
			
			trace(tree.toStringTree());
			var nodes:CommonTreeNodeStream = new CommonTreeNodeStream(tree);
			nodes.tokenStream = tokens;
			var walker:ScriptWalker = new ScriptWalker(nodes);
			
			var script:Script = walker.program(name, text);
			
			return script;
		}
	}
}

class Trigger {
	public var name:String;
	public var args:Vector.<String>;
	public var func:Function;
	
	public function Trigger(func:Function, name:String, args:Vector.<String> = null) {
		this.func = func;
		this.name = name;
		this.args = args ? args : new Vector.<String>();
	}
}
