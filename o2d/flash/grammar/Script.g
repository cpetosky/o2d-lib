grammar Script;

options {
	language=ActionScript;
	output=AST;
}

tokens {
	VAR;
	FUNC;
	TRIGGER;
	LOOKUP;
	ARG;
	SLIST;
}

@lexer::package { net.petosky.o2d.script }
@parser::package { net.petosky.o2d.script }

program
	:	trigger+
	;

trigger
	:	'trigger' ID '(' ( STRING (',' STRING)* )? ')'
		block
		-> ^(TRIGGER ID STRING* block)
	;	
/*
variable
	:	type ID ';' -> ^(VAR type ID)
	;

type
	:	'int'
	|	'char'
	;

func
	:	type ID
		'(' ( formalParameter (',' formalParameter)* )? ')'
		block
		-> ^(FUNC type ID formalParameter* block)
	;
	
formalParameter
	:	type ID -> ^(ARG type ID)
	;
*/

block
	:	lc='{' stat* '}'
		-> ^(SLIST[$lc, "SLIST"] stat*)
	;
	
stat
	:	assignStat ';'!
	|	';'!
	;

/*
forStat
	:	'for' '(' first=assignStat ';' expr ';' inc=assignStat ')' block
		-> ^('for' $first expr $inc block)
	;
*/	
assignStat
	:	identifier '=' expr -> ^('=' identifier expr)
	;

identifier
	:	ID ( '.'^ ID )*
	;
	
expr
	:	aExpr
	;

condExpr
	:	aExpr ( ('=='^ | '!='^) aExpr )?
	;

aExpr
	:	mExpr ( ('+'^ | '-'^) mExpr )*
	;

mExpr
	:	atom ( ('*'^ | '/'^ | '%'^) atom )*
	;
	
atom
	:	INT
	|	identifier
	|	'(' expr ')' -> expr
	;


INT:	('+' | '-')? ('0'..'9')+ ;

ID	:	('a'..'z' | 'A'..'Z' | '_') ('a'..'z' | 'A'..'Z' | '0'..'9' | '_')* ;

STRING
	:	'"' .* '"'
	;

WS	:	(' ' | '\t' | '\r' | '\n' )+ { $channel = HIDDEN; } ;

SINGLE_COMMENT
	:	'//' ~('\r' | '\n')* NEWLINE { skip(); }
	;
	
MULTI_COMMENT
	: '/*' .* '*/' NEWLINE? { skip(); }
	;

fragment NEWLINE
	:	('\r'? '\n')+
	;
