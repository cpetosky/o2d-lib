tree grammar ScriptWalker;

options {
	language=ActionScript;
	tokenVocab=Script;
	ASTLabelType=CommonTree;
}

@package { net.petosky.o2d.script }

@header {

}

@members {
	private var _script:Script;
	
	private function stripString(s:String):String {
		return s.substr(1, s.length - 2);
	}
}

program[String name, String text] returns [Script script]
@init {
	_script = new Script($name, $text);
}
@after {
	$script = _script;
}
	:	trigger+
	;

trigger
@init {
	var args:Vector.<String> = new Vector.<String>();
}
	:	^(TRIGGER ID (STRING { args.push(stripString($STRING.text)); })* block) {
		_script.addHandler($block.func, $ID.text, args);
	}
	;	


/*
variable
	:	^(VAR type ID)
		{ trace("define", $type.text, $ID.text); }
	;

type
	:	'int'
	|	'char'
	;

func
	:	^(FUNC type ID formalParameter* block)
		{ trace("define", $type.text, $ID.text, "()"); }
	;
	
formalParameter
	:	^(ARG type ID)
	;
*/
	
block returns [Function func]
@init {
	var statements:Vector.<Function> = new Vector.<Function>();
}
@after {
	$func = function(context:ScriptContext):void {
		for each (var f:Function in statements) {
			f(context);
		}
	};
}
	:	^(SLIST (stat { statements.push($stat.func); })*)
	;
	
stat returns [Function func]
	:	assignStat {
		$func = function(context:ScriptContext):void {
			$assignStat.func(context);
		};
	}
	;
/*
forStat
	:	^('for' assignStat expr assignStat block)
	;
*/	
assignStat returns [Function func]
	:	^('=' identifier expr) {
		$func = function(context:ScriptContext):void {
			$identifier.setFunc.call(null, context, $expr.func.call(null, context));
		};
	}
	;
	

identifier returns [Function getFunc, Function setFunc]
	:	^('.' i=identifier ID) {
		$getFunc = function(context:ScriptContext):Object {
			return $i.getFunc.call(null, context).getScriptProperty($ID.text);
		}
		
		$setFunc = function(context:ScriptContext, value:*):void {
			$i.getFunc.call(null, context).setScriptProperty($ID.text, value);
		};
	}
	|	ID {
		$getFunc = function(context:ScriptContext):Object {
			return context.targets[$ID.text];
		};
		
		$setFunc = function(context:ScriptContext, value:*):void {
			throw new Error("THIS ISN'T EVER SUPPOSED TO HAPPEN!");
			context.targets[$ID.text] = value;
		};
	}
	;
	
expr returns [Function func]
	:	^('+' e1=expr e2=expr) { 
		$func = function(context:ScriptContext):int {
			return $e1.func.call(null, context) + $e2.func.call(null, context);
		};
	}
	|	^('-' e1=expr e2=expr) { 
		$func = function(context:ScriptContext):int {
			return $e1.func.call(null, context) - $e2.func.call(null, context);
		};
	}
	|	^('*' e1=expr e2=expr) { 
		$func = function(context:ScriptContext):int {
			return $e1.func.call(null, context) * $e2.func.call(null, context);
		};
	}
	|	^('/' e1=expr e2=expr) { 
		$func = function(context:ScriptContext):int {
			return $e1.func.call(null, context) / $e2.func.call(null, context);
		};
	}
	|	^('%' e1=expr e2=expr) { 
		$func = function(context:ScriptContext):int {
			return $e1.func.call(null, context) \% $e2.func.call(null, context);
		};
	}
	|	identifier { 
		$func = function(context:ScriptContext):int {
			return parseInt($identifier.getFunc.call(null, context));
		};
	}
	|	INT { 
		$func = function(context:ScriptContext):int {
			return parseInt($INT.text);
		};
	}
	;

