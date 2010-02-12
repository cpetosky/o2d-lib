// $ANTLR 3.1.2 C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g 2009-08-25 13:40:19
package  net.petosky.o2d.script  {



    import org.antlr.runtime.*;
        import org.antlr.runtime.tree.*;    

    public class ScriptWalker extends TreeParser {
        public static const tokenNames:Array = [
            "<invalid>", "<EOR>", "<DOWN>", "<UP>", "VAR", "FUNC", "TRIGGER", "LOOKUP", "ARG", "SLIST", "ID", "STRING", "INT", "WS", "NEWLINE", "SINGLE_COMMENT", "MULTI_COMMENT", "'trigger'", "'('", "','", "')'", "'{'", "'}'", "';'", "'='", "'.'", "'=='", "'!='", "'+'", "'-'", "'*'", "'/'", "'%'"
        ];
        public static const T__29:int=29;
        public static const T__28:int=28;
        public static const T__27:int=27;
        public static const T__26:int=26;
        public static const T__25:int=25;
        public static const T__24:int=24;
        public static const T__23:int=23;
        public static const T__22:int=22;
        public static const T__21:int=21;
        public static const T__20:int=20;
        public static const TRIGGER:int=6;
        public static const MULTI_COMMENT:int=16;
        public static const INT:int=12;
        public static const ID:int=10;
        public static const EOF:int=-1;
        public static const T__30:int=30;
        public static const LOOKUP:int=7;
        public static const T__19:int=19;
        public static const T__31:int=31;
        public static const T__32:int=32;
        public static const WS:int=13;
        public static const T__18:int=18;
        public static const ARG:int=8;
        public static const NEWLINE:int=14;
        public static const T__17:int=17;
        public static const FUNC:int=5;
        public static const SLIST:int=9;
        public static const VAR:int=4;
        public static const SINGLE_COMMENT:int=15;
        public static const STRING:int=11;

        // delegates
        // delegators


            public function ScriptWalker(input:TreeNodeStream, state:RecognizerSharedState = null) {
                super(input, state);
            }
            

        public override function get tokenNames():Array { return ScriptWalker.tokenNames; }
        public override function get grammarFileName():String { return "C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g"; }


        	private var _script:Script;
        	
        	private function stripString(s:String):String {
        		return s.substr(1, s.length - 2);
        	}


        // $ANTLR start program
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:23:1: program[String name, String text] returns [Script script] : ( trigger )+ ;
        public final function program(name:String, text:String):Script {
            var script:Script = null;


            	_script = new Script(name, text);

            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:30:2: ( ( trigger )+ )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:30:4: ( trigger )+
                {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:30:4: ( trigger )+
                var cnt1:int=0;
                loop1:
                do {
                    var alt1:int=2;
                    var LA1_0:int = input.LA(1);

                    if ( (LA1_0==6) ) {
                        alt1=1;
                    }


                    switch (alt1) {
                	case 1 :
                	    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:30:4: trigger
                	    {
                	    pushFollow(FOLLOW_trigger_in_program69);
                	    trigger();

                	    state._fsp = state._fsp - 1;


                	    }
                	    break;

                	default :
                	    if ( cnt1 >= 1 ) break loop1;
                            throw new EarlyExitException(1, input);

                    }
                    cnt1++;
                } while (true);


                }


                	script = _script;

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
            }
            finally {
            }
            return script;
        }
        // $ANTLR end program

        // $ANTLR start trigger
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:33:1: trigger : ^( TRIGGER ID ( STRING )* block ) ;
        public final function trigger():void {
            var STRING1:CommonTree=null;
            var ID3:CommonTree=null;
            var block2:Function = null;



            	var args:Vector.<String> = new Vector.<String>();

            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:37:2: ( ^( TRIGGER ID ( STRING )* block ) )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:37:4: ^( TRIGGER ID ( STRING )* block )
                {
                matchStream(input,TRIGGER,FOLLOW_TRIGGER_in_trigger87); 

                matchStream(input, TokenConstants.DOWN, null); 
                ID3=CommonTree(matchStream(input,ID,FOLLOW_ID_in_trigger89)); 
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:37:17: ( STRING )*
                loop2:
                do {
                    var alt2:int=2;
                    var LA2_0:int = input.LA(1);

                    if ( (LA2_0==11) ) {
                        alt2=1;
                    }


                    switch (alt2) {
                	case 1 :
                	    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:37:18: STRING
                	    {
                	    STRING1=CommonTree(matchStream(input,STRING,FOLLOW_STRING_in_trigger92)); 
                	     args.push(stripString((STRING1!=null?STRING1.text:null))); 

                	    }
                	    break;

                	default :
                	    break loop2;
                    }
                } while (true);

                pushFollow(FOLLOW_block_in_trigger98);
                block2=block();

                state._fsp = state._fsp - 1;


                matchStream(input, TokenConstants.UP, null); 

                		_script.addHandler(block2, (ID3!=null?ID3.text:null), args);
                	

                }

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
            }
            finally {
            }
            return ;
        }
        // $ANTLR end trigger

        // $ANTLR start block
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:64:1: block returns [Function func] : ^( SLIST ( stat )* ) ;
        public final function block():Function {
            var func:Function = null;

            var stat4:Function = null;



            	var statements:Vector.<Function> = new Vector.<Function>();

            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:75:2: ( ^( SLIST ( stat )* ) )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:75:4: ^( SLIST ( stat )* )
                {
                matchStream(input,SLIST,FOLLOW_SLIST_in_block133); 

                if ( input.LA(1)==TokenConstants.DOWN ) {
                    matchStream(input, TokenConstants.DOWN, null); 
                    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:75:12: ( stat )*
                    loop3:
                    do {
                        var alt3:int=2;
                        var LA3_0:int = input.LA(1);

                        if ( (LA3_0==24) ) {
                            alt3=1;
                        }


                        switch (alt3) {
                    	case 1 :
                    	    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:75:13: stat
                    	    {
                    	    pushFollow(FOLLOW_stat_in_block136);
                    	    stat4=stat();

                    	    state._fsp = state._fsp - 1;

                    	     statements.push(stat4); 

                    	    }
                    	    break;

                    	default :
                    	    break loop3;
                        }
                    } while (true);


                    matchStream(input, TokenConstants.UP, null); 
                }

                }


                	func = function(context:ScriptContext):void {
                		for each (var f:Function in statements) {
                			f(context);
                		}
                	};

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
            }
            finally {
            }
            return func;
        }
        // $ANTLR end block

        // $ANTLR start stat
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:78:1: stat returns [Function func] : assignStat ;
        public final function stat():Function {
            var func:Function = null;

            var assignStat5:Function = null;


            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:79:2: ( assignStat )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:79:4: assignStat
                {
                pushFollow(FOLLOW_assignStat_in_stat157);
                assignStat5=assignStat();

                state._fsp = state._fsp - 1;


                		func = function(context:ScriptContext):void {
                			assignStat5(context);
                		};
                	

                }

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
            }
            finally {
            }
            return func;
        }
        // $ANTLR end stat

        // $ANTLR start assignStat
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:90:1: assignStat returns [Function func] : ^( '=' identifier expr ) ;
        public final function assignStat():Function {
            var func:Function = null;

            var identifier6:TreeRuleReturnScope = null;

            var expr7:Function = null;


            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:91:2: ( ^( '=' identifier expr ) )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:91:4: ^( '=' identifier expr )
                {
                matchStream(input,24,FOLLOW_24_in_assignStat177); 

                matchStream(input, TokenConstants.DOWN, null); 
                pushFollow(FOLLOW_identifier_in_assignStat179);
                identifier6=identifier();

                state._fsp = state._fsp - 1;

                pushFollow(FOLLOW_expr_in_assignStat181);
                expr7=expr();

                state._fsp = state._fsp - 1;


                matchStream(input, TokenConstants.UP, null); 

                		func = function(context:ScriptContext):void {
                			(identifier6!=null?identifier6.values.setFunc:null).call(null, context, expr7.call(null, context));
                		};
                	

                }

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
            }
            finally {
            }
            return func;
        }
        // $ANTLR end assignStat

        // $ANTLR start identifier
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:99:1: identifier returns [Function getFunc, Function setFunc] : ( ^( '.' i= identifier ID ) | ID );
        public final function identifier():TreeRuleReturnScope {
            var retval:TreeRuleReturnScope = new TreeRuleReturnScope();
            retval.start = input.LT(1);

            var ID8:CommonTree=null;
            var ID9:CommonTree=null;
            var i:TreeRuleReturnScope = null;


            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:100:2: ( ^( '.' i= identifier ID ) | ID )
                var alt4:int=2;
                var LA4_0:int = input.LA(1);

                if ( (LA4_0==25) ) {
                    alt4=1;
                }
                else if ( (LA4_0==10) ) {
                    alt4=2;
                }
                else {
                    throw new NoViableAltException("", 4, 0, input);

                }
                switch (alt4) {
                    case 1 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:100:4: ^( '.' i= identifier ID )
                        {
                        matchStream(input,25,FOLLOW_25_in_identifier202); 

                        matchStream(input, TokenConstants.DOWN, null); 
                        pushFollow(FOLLOW_identifier_in_identifier206);
                        i=identifier();

                        state._fsp = state._fsp - 1;

                        ID8=CommonTree(matchStream(input,ID,FOLLOW_ID_in_identifier208)); 

                        matchStream(input, TokenConstants.UP, null); 

                        		retval.values.getFunc = function(context:ScriptContext):Object {
                        			return (i!=null?i.values.getFunc:null).call(null, context).getScriptProperty((ID8!=null?ID8.text:null));
                        		}
                        		
                        		retval.values.setFunc = function(context:ScriptContext, value:*):void {
                        			(i!=null?i.values.getFunc:null).call(null, context).setScriptProperty((ID8!=null?ID8.text:null), value);
                        		};
                        	

                        }
                        break;
                    case 2 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:109:4: ID
                        {
                        ID9=CommonTree(matchStream(input,ID,FOLLOW_ID_in_identifier216)); 

                        		retval.values.getFunc = function(context:ScriptContext):Object {
                        			return context.targets[(ID9!=null?ID9.text:null)];
                        		};
                        		
                        		retval.values.setFunc = function(context:ScriptContext, value:*):void {
                        			throw new Error("THIS ISN'T EVER SUPPOSED TO HAPPEN!");
                        			context.targets[(ID9!=null?ID9.text:null)] = value;
                        		};
                        	

                        }
                        break;

                }
            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
            }
            finally {
            }
            return retval;
        }
        // $ANTLR end identifier

        // $ANTLR start expr
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:121:1: expr returns [Function func] : ( ^( '+' e1= expr e2= expr ) | ^( '-' e1= expr e2= expr ) | ^( '*' e1= expr e2= expr ) | ^( '/' e1= expr e2= expr ) | ^( '%' e1= expr e2= expr ) | identifier | INT );
        public final function expr():Function {
            var func:Function = null;

            var INT11:CommonTree=null;
            var e1:Function = null;

            var e2:Function = null;

            var identifier10:TreeRuleReturnScope = null;


            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:122:2: ( ^( '+' e1= expr e2= expr ) | ^( '-' e1= expr e2= expr ) | ^( '*' e1= expr e2= expr ) | ^( '/' e1= expr e2= expr ) | ^( '%' e1= expr e2= expr ) | identifier | INT )
                var alt5:int=7;
                switch ( input.LA(1) ) {
                case 28:
                    {
                    alt5=1;
                    }
                    break;
                case 29:
                    {
                    alt5=2;
                    }
                    break;
                case 30:
                    {
                    alt5=3;
                    }
                    break;
                case 31:
                    {
                    alt5=4;
                    }
                    break;
                case 32:
                    {
                    alt5=5;
                    }
                    break;
                case ID:
                case 25:
                    {
                    alt5=6;
                    }
                    break;
                case INT:
                    {
                    alt5=7;
                    }
                    break;
                default:
                    throw new NoViableAltException("", 5, 0, input);

                }

                switch (alt5) {
                    case 1 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:122:4: ^( '+' e1= expr e2= expr )
                        {
                        matchStream(input,28,FOLLOW_28_in_expr235); 

                        matchStream(input, TokenConstants.DOWN, null); 
                        pushFollow(FOLLOW_expr_in_expr239);
                        e1=expr();

                        state._fsp = state._fsp - 1;

                        pushFollow(FOLLOW_expr_in_expr243);
                        e2=expr();

                        state._fsp = state._fsp - 1;


                        matchStream(input, TokenConstants.UP, null); 
                         
                        		func = function(context:ScriptContext):int {
                        			return e1.call(null, context) + e2.call(null, context);
                        		};
                        	

                        }
                        break;
                    case 2 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:127:4: ^( '-' e1= expr e2= expr )
                        {
                        matchStream(input,29,FOLLOW_29_in_expr252); 

                        matchStream(input, TokenConstants.DOWN, null); 
                        pushFollow(FOLLOW_expr_in_expr256);
                        e1=expr();

                        state._fsp = state._fsp - 1;

                        pushFollow(FOLLOW_expr_in_expr260);
                        e2=expr();

                        state._fsp = state._fsp - 1;


                        matchStream(input, TokenConstants.UP, null); 
                         
                        		func = function(context:ScriptContext):int {
                        			return e1.call(null, context) - e2.call(null, context);
                        		};
                        	

                        }
                        break;
                    case 3 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:132:4: ^( '*' e1= expr e2= expr )
                        {
                        matchStream(input,30,FOLLOW_30_in_expr269); 

                        matchStream(input, TokenConstants.DOWN, null); 
                        pushFollow(FOLLOW_expr_in_expr273);
                        e1=expr();

                        state._fsp = state._fsp - 1;

                        pushFollow(FOLLOW_expr_in_expr277);
                        e2=expr();

                        state._fsp = state._fsp - 1;


                        matchStream(input, TokenConstants.UP, null); 
                         
                        		func = function(context:ScriptContext):int {
                        			return e1.call(null, context) * e2.call(null, context);
                        		};
                        	

                        }
                        break;
                    case 4 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:137:4: ^( '/' e1= expr e2= expr )
                        {
                        matchStream(input,31,FOLLOW_31_in_expr286); 

                        matchStream(input, TokenConstants.DOWN, null); 
                        pushFollow(FOLLOW_expr_in_expr290);
                        e1=expr();

                        state._fsp = state._fsp - 1;

                        pushFollow(FOLLOW_expr_in_expr294);
                        e2=expr();

                        state._fsp = state._fsp - 1;


                        matchStream(input, TokenConstants.UP, null); 
                         
                        		func = function(context:ScriptContext):int {
                        			return e1.call(null, context) / e2.call(null, context);
                        		};
                        	

                        }
                        break;
                    case 5 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:142:4: ^( '%' e1= expr e2= expr )
                        {
                        matchStream(input,32,FOLLOW_32_in_expr303); 

                        matchStream(input, TokenConstants.DOWN, null); 
                        pushFollow(FOLLOW_expr_in_expr307);
                        e1=expr();

                        state._fsp = state._fsp - 1;

                        pushFollow(FOLLOW_expr_in_expr311);
                        e2=expr();

                        state._fsp = state._fsp - 1;


                        matchStream(input, TokenConstants.UP, null); 
                         
                        		func = function(context:ScriptContext):int {
                        			return e1.call(null, context) % e2.call(null, context);
                        		};
                        	

                        }
                        break;
                    case 6 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:147:4: identifier
                        {
                        pushFollow(FOLLOW_identifier_in_expr319);
                        identifier10=identifier();

                        state._fsp = state._fsp - 1;

                         
                        		func = function(context:ScriptContext):int {
                        			return parseInt((identifier10!=null?identifier10.values.getFunc:null).call(null, context));
                        		};
                        	

                        }
                        break;
                    case 7 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\ScriptWalker.g:152:4: INT
                        {
                        INT11=CommonTree(matchStream(input,INT,FOLLOW_INT_in_expr326)); 
                         
                        		func = function(context:ScriptContext):int {
                        			return parseInt((INT11!=null?INT11.text:null));
                        		};
                        	

                        }
                        break;

                }
            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
            }
            finally {
            }
            return func;
        }
        // $ANTLR end expr


           // Delegated rules


     

        public static const FOLLOW_trigger_in_program69:BitSet = new BitSet([0x00000042, 0x00000000]);
        public static const FOLLOW_TRIGGER_in_trigger87:BitSet = new BitSet([0x00000004, 0x00000000]);
        public static const FOLLOW_ID_in_trigger89:BitSet = new BitSet([0x00000A00, 0x00000000]);
        public static const FOLLOW_STRING_in_trigger92:BitSet = new BitSet([0x00000A00, 0x00000000]);
        public static const FOLLOW_block_in_trigger98:BitSet = new BitSet([0x00000008, 0x00000000]);
        public static const FOLLOW_SLIST_in_block133:BitSet = new BitSet([0x00000004, 0x00000000]);
        public static const FOLLOW_stat_in_block136:BitSet = new BitSet([0x01000008, 0x00000000]);
        public static const FOLLOW_assignStat_in_stat157:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_24_in_assignStat177:BitSet = new BitSet([0x00000004, 0x00000000]);
        public static const FOLLOW_identifier_in_assignStat179:BitSet = new BitSet([0xF2001400, 0x00000001]);
        public static const FOLLOW_expr_in_assignStat181:BitSet = new BitSet([0x00000008, 0x00000000]);
        public static const FOLLOW_25_in_identifier202:BitSet = new BitSet([0x00000004, 0x00000000]);
        public static const FOLLOW_identifier_in_identifier206:BitSet = new BitSet([0x00000400, 0x00000000]);
        public static const FOLLOW_ID_in_identifier208:BitSet = new BitSet([0x00000008, 0x00000000]);
        public static const FOLLOW_ID_in_identifier216:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_28_in_expr235:BitSet = new BitSet([0x00000004, 0x00000000]);
        public static const FOLLOW_expr_in_expr239:BitSet = new BitSet([0xF2001400, 0x00000001]);
        public static const FOLLOW_expr_in_expr243:BitSet = new BitSet([0x00000008, 0x00000000]);
        public static const FOLLOW_29_in_expr252:BitSet = new BitSet([0x00000004, 0x00000000]);
        public static const FOLLOW_expr_in_expr256:BitSet = new BitSet([0xF2001400, 0x00000001]);
        public static const FOLLOW_expr_in_expr260:BitSet = new BitSet([0x00000008, 0x00000000]);
        public static const FOLLOW_30_in_expr269:BitSet = new BitSet([0x00000004, 0x00000000]);
        public static const FOLLOW_expr_in_expr273:BitSet = new BitSet([0xF2001400, 0x00000001]);
        public static const FOLLOW_expr_in_expr277:BitSet = new BitSet([0x00000008, 0x00000000]);
        public static const FOLLOW_31_in_expr286:BitSet = new BitSet([0x00000004, 0x00000000]);
        public static const FOLLOW_expr_in_expr290:BitSet = new BitSet([0xF2001400, 0x00000001]);
        public static const FOLLOW_expr_in_expr294:BitSet = new BitSet([0x00000008, 0x00000000]);
        public static const FOLLOW_32_in_expr303:BitSet = new BitSet([0x00000004, 0x00000000]);
        public static const FOLLOW_expr_in_expr307:BitSet = new BitSet([0xF2001400, 0x00000001]);
        public static const FOLLOW_expr_in_expr311:BitSet = new BitSet([0x00000008, 0x00000000]);
        public static const FOLLOW_identifier_in_expr319:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_INT_in_expr326:BitSet = new BitSet([0x00000002, 0x00000000]);

    }
}