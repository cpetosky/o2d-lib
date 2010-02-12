// $ANTLR 3.1.2 C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g 2009-08-25 13:40:25
package  net.petosky.o2d.script  {
    import org.antlr.runtime.*;
        

    import org.antlr.runtime.tree.*;


    public class ScriptParser extends Parser {
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
        public static const LOOKUP:int=7;
        public static const T__19:int=19;
        public static const T__30:int=30;
        public static const T__31:int=31;
        public static const T__32:int=32;
        public static const WS:int=13;
        public static const NEWLINE:int=14;
        public static const ARG:int=8;
        public static const T__18:int=18;
        public static const T__17:int=17;
        public static const FUNC:int=5;
        public static const SLIST:int=9;
        public static const SINGLE_COMMENT:int=15;
        public static const VAR:int=4;
        public static const STRING:int=11;

        // delegates
        // delegators


            public function ScriptParser(input:TokenStream, state:RecognizerSharedState = null) {
                super(input, state);
            }
            
        protected var adaptor:TreeAdaptor = new CommonTreeAdaptor();

        override public function set treeAdaptor(adaptor:TreeAdaptor):void {
            this.adaptor = adaptor;
        }
        override public function get treeAdaptor():TreeAdaptor {
            return adaptor;
        }

        public override function get tokenNames():Array { return ScriptParser.tokenNames; }
        public override function get grammarFileName():String { return "C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g"; }


        // $ANTLR start program
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:20:1: program : ( trigger )+ ;
        public final function program():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var trigger1:ParserRuleReturnScope = null;



            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:21:2: ( ( trigger )+ )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:21:4: ( trigger )+
                {
                root_0 = Object(adaptor.nil());

                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:21:4: ( trigger )+
                var cnt1:int=0;
                loop1:
                do {
                    var alt1:int=2;
                    var LA1_0:int = input.LA(1);

                    if ( (LA1_0==17) ) {
                        alt1=1;
                    }


                    switch (alt1) {
                	case 1 :
                	    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:21:4: trigger
                	    {
                	    pushFollow(FOLLOW_trigger_in_program74);
                	    trigger1=trigger();

                	    state._fsp = state._fsp - 1;

                	    adaptor.addChild(root_0, trigger1.tree);

                	    }
                	    break;

                	default :
                	    if ( cnt1 >= 1 ) break loop1;
                            throw new EarlyExitException(1, input);

                    }
                    cnt1++;
                } while (true);


                }

                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end program

        // $ANTLR start trigger
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:24:1: trigger : 'trigger' ID '(' ( STRING ( ',' STRING )* )? ')' block -> ^( TRIGGER ID ( STRING )* block ) ;
        public final function trigger():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var string_literal2:Token=null;
            var ID3:Token=null;
            var char_literal4:Token=null;
            var STRING5:Token=null;
            var char_literal6:Token=null;
            var STRING7:Token=null;
            var char_literal8:Token=null;
            var block9:ParserRuleReturnScope = null;


            var string_literal2_tree:Object=null;
            var ID3_tree:Object=null;
            var char_literal4_tree:Object=null;
            var STRING5_tree:Object=null;
            var char_literal6_tree:Object=null;
            var STRING7_tree:Object=null;
            var char_literal8_tree:Object=null;
            var stream_20:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 20");
            var stream_19:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 19");
            var stream_ID:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token ID");
            var stream_17:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 17");
            var stream_18:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 18");
            var stream_STRING:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token STRING");
            var stream_block:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule block");
            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:25:2: ( 'trigger' ID '(' ( STRING ( ',' STRING )* )? ')' block -> ^( TRIGGER ID ( STRING )* block ) )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:25:4: 'trigger' ID '(' ( STRING ( ',' STRING )* )? ')' block
                {
                string_literal2=Token(matchStream(input,17,FOLLOW_17_in_trigger86));  
                stream_17.add(string_literal2);

                ID3=Token(matchStream(input,ID,FOLLOW_ID_in_trigger88));  
                stream_ID.add(ID3);

                char_literal4=Token(matchStream(input,18,FOLLOW_18_in_trigger90));  
                stream_18.add(char_literal4);

                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:25:21: ( STRING ( ',' STRING )* )?
                var alt3:int=2;
                var LA3_0:int = input.LA(1);

                if ( (LA3_0==11) ) {
                    alt3=1;
                }
                switch (alt3) {
                    case 1 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:25:23: STRING ( ',' STRING )*
                        {
                        STRING5=Token(matchStream(input,STRING,FOLLOW_STRING_in_trigger94));  
                        stream_STRING.add(STRING5);

                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:25:30: ( ',' STRING )*
                        loop2:
                        do {
                            var alt2:int=2;
                            var LA2_0:int = input.LA(1);

                            if ( (LA2_0==19) ) {
                                alt2=1;
                            }


                            switch (alt2) {
                        	case 1 :
                        	    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:25:31: ',' STRING
                        	    {
                        	    char_literal6=Token(matchStream(input,19,FOLLOW_19_in_trigger97));  
                        	    stream_19.add(char_literal6);

                        	    STRING7=Token(matchStream(input,STRING,FOLLOW_STRING_in_trigger99));  
                        	    stream_STRING.add(STRING7);


                        	    }
                        	    break;

                        	default :
                        	    break loop2;
                            }
                        } while (true);


                        }
                        break;

                }

                char_literal8=Token(matchStream(input,20,FOLLOW_20_in_trigger106));  
                stream_20.add(char_literal8);

                pushFollow(FOLLOW_block_in_trigger110);
                block9=block();

                state._fsp = state._fsp - 1;

                stream_block.add(block9.tree);


                // AST REWRITE
                // elements: ID, block, STRING
                // token labels: 
                // rule labels: retval
                // token list labels: 
                // rule list labels: 
                retval.tree = root_0;
                var stream_retval:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule retval",retval!=null?retval.tree:null);

                root_0 = Object(adaptor.nil());
                // 27:3: -> ^( TRIGGER ID ( STRING )* block )
                {
                    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:27:6: ^( TRIGGER ID ( STRING )* block )
                    {
                    var root_1:Object = Object(adaptor.nil());
                    root_1 = Object(adaptor.becomeRoot(Object(adaptor.create(TRIGGER, "TRIGGER")), root_1));

                    adaptor.addChild(root_1, stream_ID.nextNode());
                    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:27:19: ( STRING )*
                    while ( stream_STRING.hasNext ) {
                        adaptor.addChild(root_1, stream_STRING.nextNode());

                    }
                    stream_STRING.reset();
                    adaptor.addChild(root_1, stream_block.nextTree());

                    adaptor.addChild(root_0, root_1);
                    }

                }

                retval.tree = root_0;
                }

                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end trigger

        // $ANTLR start block
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:51:1: block : lc= '{' ( stat )* '}' -> ^( SLIST[$lc, \"SLIST\"] ( stat )* ) ;
        public final function block():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var lc:Token=null;
            var char_literal11:Token=null;
            var stat10:ParserRuleReturnScope = null;


            var lc_tree:Object=null;
            var char_literal11_tree:Object=null;
            var stream_21:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 21");
            var stream_22:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 22");
            var stream_stat:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule stat");
            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:52:2: (lc= '{' ( stat )* '}' -> ^( SLIST[$lc, \"SLIST\"] ( stat )* ) )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:52:4: lc= '{' ( stat )* '}'
                {
                lc=Token(matchStream(input,21,FOLLOW_21_in_block141));  
                stream_21.add(lc);

                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:52:11: ( stat )*
                loop4:
                do {
                    var alt4:int=2;
                    var LA4_0:int = input.LA(1);

                    if ( (LA4_0==10||LA4_0==23) ) {
                        alt4=1;
                    }


                    switch (alt4) {
                	case 1 :
                	    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:52:11: stat
                	    {
                	    pushFollow(FOLLOW_stat_in_block143);
                	    stat10=stat();

                	    state._fsp = state._fsp - 1;

                	    stream_stat.add(stat10.tree);

                	    }
                	    break;

                	default :
                	    break loop4;
                    }
                } while (true);

                char_literal11=Token(matchStream(input,22,FOLLOW_22_in_block146));  
                stream_22.add(char_literal11);



                // AST REWRITE
                // elements: stat
                // token labels: 
                // rule labels: retval
                // token list labels: 
                // rule list labels: 
                retval.tree = root_0;
                var stream_retval:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule retval",retval!=null?retval.tree:null);

                root_0 = Object(adaptor.nil());
                // 53:3: -> ^( SLIST[$lc, \"SLIST\"] ( stat )* )
                {
                    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:53:6: ^( SLIST[$lc, \"SLIST\"] ( stat )* )
                    {
                    var root_1:Object = Object(adaptor.nil());
                    root_1 = Object(adaptor.becomeRoot(Object(adaptor.create(SLIST, lc, "SLIST")), root_1));

                    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:53:28: ( stat )*
                    while ( stream_stat.hasNext ) {
                        adaptor.addChild(root_1, stream_stat.nextTree());

                    }
                    stream_stat.reset();

                    adaptor.addChild(root_0, root_1);
                    }

                }

                retval.tree = root_0;
                }

                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end block

        // $ANTLR start stat
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:56:1: stat : ( assignStat ';' | ';' );
        public final function stat():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var char_literal13:Token=null;
            var char_literal14:Token=null;
            var assignStat12:ParserRuleReturnScope = null;


            var char_literal13_tree:Object=null;
            var char_literal14_tree:Object=null;

            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:57:2: ( assignStat ';' | ';' )
                var alt5:int=2;
                var LA5_0:int = input.LA(1);

                if ( (LA5_0==10) ) {
                    alt5=1;
                }
                else if ( (LA5_0==23) ) {
                    alt5=2;
                }
                else {
                    throw new NoViableAltException("", 5, 0, input);

                }
                switch (alt5) {
                    case 1 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:57:4: assignStat ';'
                        {
                        root_0 = Object(adaptor.nil());

                        pushFollow(FOLLOW_assignStat_in_stat170);
                        assignStat12=assignStat();

                        state._fsp = state._fsp - 1;

                        adaptor.addChild(root_0, assignStat12.tree);
                        char_literal13=Token(matchStream(input,23,FOLLOW_23_in_stat172)); 

                        }
                        break;
                    case 2 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:58:4: ';'
                        {
                        root_0 = Object(adaptor.nil());

                        char_literal14=Token(matchStream(input,23,FOLLOW_23_in_stat178)); 

                        }
                        break;

                }
                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end stat

        // $ANTLR start assignStat
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:67:1: assignStat : identifier '=' expr -> ^( '=' identifier expr ) ;
        public final function assignStat():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var char_literal16:Token=null;
            var identifier15:ParserRuleReturnScope = null;

            var expr17:ParserRuleReturnScope = null;


            var char_literal16_tree:Object=null;
            var stream_24:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 24");
            var stream_expr:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule expr");
            var stream_identifier:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule identifier");
            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:68:2: ( identifier '=' expr -> ^( '=' identifier expr ) )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:68:4: identifier '=' expr
                {
                pushFollow(FOLLOW_identifier_in_assignStat193);
                identifier15=identifier();

                state._fsp = state._fsp - 1;

                stream_identifier.add(identifier15.tree);
                char_literal16=Token(matchStream(input,24,FOLLOW_24_in_assignStat195));  
                stream_24.add(char_literal16);

                pushFollow(FOLLOW_expr_in_assignStat197);
                expr17=expr();

                state._fsp = state._fsp - 1;

                stream_expr.add(expr17.tree);


                // AST REWRITE
                // elements: 24, identifier, expr
                // token labels: 
                // rule labels: retval
                // token list labels: 
                // rule list labels: 
                retval.tree = root_0;
                var stream_retval:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule retval",retval!=null?retval.tree:null);

                root_0 = Object(adaptor.nil());
                // 68:24: -> ^( '=' identifier expr )
                {
                    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:68:27: ^( '=' identifier expr )
                    {
                    var root_1:Object = Object(adaptor.nil());
                    root_1 = Object(adaptor.becomeRoot(stream_24.nextNode(), root_1));

                    adaptor.addChild(root_1, stream_identifier.nextTree());
                    adaptor.addChild(root_1, stream_expr.nextTree());

                    adaptor.addChild(root_0, root_1);
                    }

                }

                retval.tree = root_0;
                }

                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end assignStat

        // $ANTLR start identifier
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:71:1: identifier : ID ( '.' ID )* ;
        public final function identifier():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var ID18:Token=null;
            var char_literal19:Token=null;
            var ID20:Token=null;

            var ID18_tree:Object=null;
            var char_literal19_tree:Object=null;
            var ID20_tree:Object=null;

            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:72:2: ( ID ( '.' ID )* )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:72:4: ID ( '.' ID )*
                {
                root_0 = Object(adaptor.nil());

                ID18=Token(matchStream(input,ID,FOLLOW_ID_in_identifier218)); 
                ID18_tree = Object(adaptor.create(ID18));
                adaptor.addChild(root_0, ID18_tree);

                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:72:7: ( '.' ID )*
                loop6:
                do {
                    var alt6:int=2;
                    var LA6_0:int = input.LA(1);

                    if ( (LA6_0==25) ) {
                        alt6=1;
                    }


                    switch (alt6) {
                	case 1 :
                	    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:72:9: '.' ID
                	    {
                	    char_literal19=Token(matchStream(input,25,FOLLOW_25_in_identifier222)); 
                	    char_literal19_tree = Object(adaptor.create(char_literal19));
                	    root_0 = Object(adaptor.becomeRoot(char_literal19_tree, root_0));

                	    ID20=Token(matchStream(input,ID,FOLLOW_ID_in_identifier225)); 
                	    ID20_tree = Object(adaptor.create(ID20));
                	    adaptor.addChild(root_0, ID20_tree);


                	    }
                	    break;

                	default :
                	    break loop6;
                    }
                } while (true);


                }

                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end identifier

        // $ANTLR start expr
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:75:1: expr : aExpr ;
        public final function expr():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var aExpr21:ParserRuleReturnScope = null;



            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:76:2: ( aExpr )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:76:4: aExpr
                {
                root_0 = Object(adaptor.nil());

                pushFollow(FOLLOW_aExpr_in_expr240);
                aExpr21=aExpr();

                state._fsp = state._fsp - 1;

                adaptor.addChild(root_0, aExpr21.tree);

                }

                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end expr

        // $ANTLR start condExpr
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:79:1: condExpr : aExpr ( ( '==' | '!=' ) aExpr )? ;
        public final function condExpr():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var string_literal23:Token=null;
            var string_literal24:Token=null;
            var aExpr22:ParserRuleReturnScope = null;

            var aExpr25:ParserRuleReturnScope = null;


            var string_literal23_tree:Object=null;
            var string_literal24_tree:Object=null;

            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:80:2: ( aExpr ( ( '==' | '!=' ) aExpr )? )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:80:4: aExpr ( ( '==' | '!=' ) aExpr )?
                {
                root_0 = Object(adaptor.nil());

                pushFollow(FOLLOW_aExpr_in_condExpr251);
                aExpr22=aExpr();

                state._fsp = state._fsp - 1;

                adaptor.addChild(root_0, aExpr22.tree);
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:80:10: ( ( '==' | '!=' ) aExpr )?
                var alt8:int=2;
                var LA8_0:int = input.LA(1);

                if ( ((LA8_0>=26 && LA8_0<=27)) ) {
                    alt8=1;
                }
                switch (alt8) {
                    case 1 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:80:12: ( '==' | '!=' ) aExpr
                        {
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:80:12: ( '==' | '!=' )
                        var alt7:int=2;
                        var LA7_0:int = input.LA(1);

                        if ( (LA7_0==26) ) {
                            alt7=1;
                        }
                        else if ( (LA7_0==27) ) {
                            alt7=2;
                        }
                        else {
                            throw new NoViableAltException("", 7, 0, input);

                        }
                        switch (alt7) {
                            case 1 :
                                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:80:13: '=='
                                {
                                string_literal23=Token(matchStream(input,26,FOLLOW_26_in_condExpr256)); 
                                string_literal23_tree = Object(adaptor.create(string_literal23));
                                root_0 = Object(adaptor.becomeRoot(string_literal23_tree, root_0));


                                }
                                break;
                            case 2 :
                                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:80:21: '!='
                                {
                                string_literal24=Token(matchStream(input,27,FOLLOW_27_in_condExpr261)); 
                                string_literal24_tree = Object(adaptor.create(string_literal24));
                                root_0 = Object(adaptor.becomeRoot(string_literal24_tree, root_0));


                                }
                                break;

                        }

                        pushFollow(FOLLOW_aExpr_in_condExpr265);
                        aExpr25=aExpr();

                        state._fsp = state._fsp - 1;

                        adaptor.addChild(root_0, aExpr25.tree);

                        }
                        break;

                }


                }

                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end condExpr

        // $ANTLR start aExpr
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:83:1: aExpr : mExpr ( ( '+' | '-' ) mExpr )* ;
        public final function aExpr():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var char_literal27:Token=null;
            var char_literal28:Token=null;
            var mExpr26:ParserRuleReturnScope = null;

            var mExpr29:ParserRuleReturnScope = null;


            var char_literal27_tree:Object=null;
            var char_literal28_tree:Object=null;

            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:84:2: ( mExpr ( ( '+' | '-' ) mExpr )* )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:84:4: mExpr ( ( '+' | '-' ) mExpr )*
                {
                root_0 = Object(adaptor.nil());

                pushFollow(FOLLOW_mExpr_in_aExpr279);
                mExpr26=mExpr();

                state._fsp = state._fsp - 1;

                adaptor.addChild(root_0, mExpr26.tree);
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:84:10: ( ( '+' | '-' ) mExpr )*
                loop10:
                do {
                    var alt10:int=2;
                    var LA10_0:int = input.LA(1);

                    if ( ((LA10_0>=28 && LA10_0<=29)) ) {
                        alt10=1;
                    }


                    switch (alt10) {
                	case 1 :
                	    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:84:12: ( '+' | '-' ) mExpr
                	    {
                	    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:84:12: ( '+' | '-' )
                	    var alt9:int=2;
                	    var LA9_0:int = input.LA(1);

                	    if ( (LA9_0==28) ) {
                	        alt9=1;
                	    }
                	    else if ( (LA9_0==29) ) {
                	        alt9=2;
                	    }
                	    else {
                	        throw new NoViableAltException("", 9, 0, input);

                	    }
                	    switch (alt9) {
                	        case 1 :
                	            // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:84:13: '+'
                	            {
                	            char_literal27=Token(matchStream(input,28,FOLLOW_28_in_aExpr284)); 
                	            char_literal27_tree = Object(adaptor.create(char_literal27));
                	            root_0 = Object(adaptor.becomeRoot(char_literal27_tree, root_0));


                	            }
                	            break;
                	        case 2 :
                	            // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:84:20: '-'
                	            {
                	            char_literal28=Token(matchStream(input,29,FOLLOW_29_in_aExpr289)); 
                	            char_literal28_tree = Object(adaptor.create(char_literal28));
                	            root_0 = Object(adaptor.becomeRoot(char_literal28_tree, root_0));


                	            }
                	            break;

                	    }

                	    pushFollow(FOLLOW_mExpr_in_aExpr293);
                	    mExpr29=mExpr();

                	    state._fsp = state._fsp - 1;

                	    adaptor.addChild(root_0, mExpr29.tree);

                	    }
                	    break;

                	default :
                	    break loop10;
                    }
                } while (true);


                }

                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end aExpr

        // $ANTLR start mExpr
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:87:1: mExpr : atom ( ( '*' | '/' | '%' ) atom )* ;
        public final function mExpr():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var char_literal31:Token=null;
            var char_literal32:Token=null;
            var char_literal33:Token=null;
            var atom30:ParserRuleReturnScope = null;

            var atom34:ParserRuleReturnScope = null;


            var char_literal31_tree:Object=null;
            var char_literal32_tree:Object=null;
            var char_literal33_tree:Object=null;

            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:88:2: ( atom ( ( '*' | '/' | '%' ) atom )* )
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:88:4: atom ( ( '*' | '/' | '%' ) atom )*
                {
                root_0 = Object(adaptor.nil());

                pushFollow(FOLLOW_atom_in_mExpr307);
                atom30=atom();

                state._fsp = state._fsp - 1;

                adaptor.addChild(root_0, atom30.tree);
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:88:9: ( ( '*' | '/' | '%' ) atom )*
                loop12:
                do {
                    var alt12:int=2;
                    var LA12_0:int = input.LA(1);

                    if ( ((LA12_0>=30 && LA12_0<=32)) ) {
                        alt12=1;
                    }


                    switch (alt12) {
                	case 1 :
                	    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:88:11: ( '*' | '/' | '%' ) atom
                	    {
                	    // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:88:11: ( '*' | '/' | '%' )
                	    var alt11:int=3;
                	    switch ( input.LA(1) ) {
                	    case 30:
                	        {
                	        alt11=1;
                	        }
                	        break;
                	    case 31:
                	        {
                	        alt11=2;
                	        }
                	        break;
                	    case 32:
                	        {
                	        alt11=3;
                	        }
                	        break;
                	    default:
                	        throw new NoViableAltException("", 11, 0, input);

                	    }

                	    switch (alt11) {
                	        case 1 :
                	            // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:88:12: '*'
                	            {
                	            char_literal31=Token(matchStream(input,30,FOLLOW_30_in_mExpr312)); 
                	            char_literal31_tree = Object(adaptor.create(char_literal31));
                	            root_0 = Object(adaptor.becomeRoot(char_literal31_tree, root_0));


                	            }
                	            break;
                	        case 2 :
                	            // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:88:19: '/'
                	            {
                	            char_literal32=Token(matchStream(input,31,FOLLOW_31_in_mExpr317)); 
                	            char_literal32_tree = Object(adaptor.create(char_literal32));
                	            root_0 = Object(adaptor.becomeRoot(char_literal32_tree, root_0));


                	            }
                	            break;
                	        case 3 :
                	            // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:88:26: '%'
                	            {
                	            char_literal33=Token(matchStream(input,32,FOLLOW_32_in_mExpr322)); 
                	            char_literal33_tree = Object(adaptor.create(char_literal33));
                	            root_0 = Object(adaptor.becomeRoot(char_literal33_tree, root_0));


                	            }
                	            break;

                	    }

                	    pushFollow(FOLLOW_atom_in_mExpr326);
                	    atom34=atom();

                	    state._fsp = state._fsp - 1;

                	    adaptor.addChild(root_0, atom34.tree);

                	    }
                	    break;

                	default :
                	    break loop12;
                    }
                } while (true);


                }

                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end mExpr

        // $ANTLR start atom
        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:91:1: atom : ( INT | identifier | '(' expr ')' -> expr );
        public final function atom():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var INT35:Token=null;
            var char_literal37:Token=null;
            var char_literal39:Token=null;
            var identifier36:ParserRuleReturnScope = null;

            var expr38:ParserRuleReturnScope = null;


            var INT35_tree:Object=null;
            var char_literal37_tree:Object=null;
            var char_literal39_tree:Object=null;
            var stream_20:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 20");
            var stream_18:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 18");
            var stream_expr:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule expr");
            try {
                // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:92:2: ( INT | identifier | '(' expr ')' -> expr )
                var alt13:int=3;
                switch ( input.LA(1) ) {
                case INT:
                    {
                    alt13=1;
                    }
                    break;
                case ID:
                    {
                    alt13=2;
                    }
                    break;
                case 18:
                    {
                    alt13=3;
                    }
                    break;
                default:
                    throw new NoViableAltException("", 13, 0, input);

                }

                switch (alt13) {
                    case 1 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:92:4: INT
                        {
                        root_0 = Object(adaptor.nil());

                        INT35=Token(matchStream(input,INT,FOLLOW_INT_in_atom341)); 
                        INT35_tree = Object(adaptor.create(INT35));
                        adaptor.addChild(root_0, INT35_tree);


                        }
                        break;
                    case 2 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:93:4: identifier
                        {
                        root_0 = Object(adaptor.nil());

                        pushFollow(FOLLOW_identifier_in_atom346);
                        identifier36=identifier();

                        state._fsp = state._fsp - 1;

                        adaptor.addChild(root_0, identifier36.tree);

                        }
                        break;
                    case 3 :
                        // C:\\Users\\Cory\\workspace\\o2d\\grammar\\Script.g:94:4: '(' expr ')'
                        {
                        char_literal37=Token(matchStream(input,18,FOLLOW_18_in_atom351));  
                        stream_18.add(char_literal37);

                        pushFollow(FOLLOW_expr_in_atom353);
                        expr38=expr();

                        state._fsp = state._fsp - 1;

                        stream_expr.add(expr38.tree);
                        char_literal39=Token(matchStream(input,20,FOLLOW_20_in_atom355));  
                        stream_20.add(char_literal39);



                        // AST REWRITE
                        // elements: expr
                        // token labels: 
                        // rule labels: retval
                        // token list labels: 
                        // rule list labels: 
                        retval.tree = root_0;
                        var stream_retval:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule retval",retval!=null?retval.tree:null);

                        root_0 = Object(adaptor.nil());
                        // 94:17: -> expr
                        {
                            adaptor.addChild(root_0, stream_expr.nextTree());

                        }

                        retval.tree = root_0;
                        }
                        break;

                }
                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end atom


           // Delegated rules


     

        public static const FOLLOW_trigger_in_program74:BitSet = new BitSet([0x00020002, 0x00000000]);
        public static const FOLLOW_17_in_trigger86:BitSet = new BitSet([0x00000400, 0x00000000]);
        public static const FOLLOW_ID_in_trigger88:BitSet = new BitSet([0x00040000, 0x00000000]);
        public static const FOLLOW_18_in_trigger90:BitSet = new BitSet([0x00100800, 0x00000000]);
        public static const FOLLOW_STRING_in_trigger94:BitSet = new BitSet([0x00180000, 0x00000000]);
        public static const FOLLOW_19_in_trigger97:BitSet = new BitSet([0x00000800, 0x00000000]);
        public static const FOLLOW_STRING_in_trigger99:BitSet = new BitSet([0x00180000, 0x00000000]);
        public static const FOLLOW_20_in_trigger106:BitSet = new BitSet([0x00200000, 0x00000000]);
        public static const FOLLOW_block_in_trigger110:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_21_in_block141:BitSet = new BitSet([0x00C00400, 0x00000000]);
        public static const FOLLOW_stat_in_block143:BitSet = new BitSet([0x00C00400, 0x00000000]);
        public static const FOLLOW_22_in_block146:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_assignStat_in_stat170:BitSet = new BitSet([0x00800000, 0x00000000]);
        public static const FOLLOW_23_in_stat172:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_23_in_stat178:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_identifier_in_assignStat193:BitSet = new BitSet([0x01000000, 0x00000000]);
        public static const FOLLOW_24_in_assignStat195:BitSet = new BitSet([0x00041400, 0x00000000]);
        public static const FOLLOW_expr_in_assignStat197:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_ID_in_identifier218:BitSet = new BitSet([0x02000002, 0x00000000]);
        public static const FOLLOW_25_in_identifier222:BitSet = new BitSet([0x00000400, 0x00000000]);
        public static const FOLLOW_ID_in_identifier225:BitSet = new BitSet([0x02000002, 0x00000000]);
        public static const FOLLOW_aExpr_in_expr240:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_aExpr_in_condExpr251:BitSet = new BitSet([0x0C000002, 0x00000000]);
        public static const FOLLOW_26_in_condExpr256:BitSet = new BitSet([0x00041400, 0x00000000]);
        public static const FOLLOW_27_in_condExpr261:BitSet = new BitSet([0x00041400, 0x00000000]);
        public static const FOLLOW_aExpr_in_condExpr265:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_mExpr_in_aExpr279:BitSet = new BitSet([0x30000002, 0x00000000]);
        public static const FOLLOW_28_in_aExpr284:BitSet = new BitSet([0x00041400, 0x00000000]);
        public static const FOLLOW_29_in_aExpr289:BitSet = new BitSet([0x00041400, 0x00000000]);
        public static const FOLLOW_mExpr_in_aExpr293:BitSet = new BitSet([0x30000002, 0x00000000]);
        public static const FOLLOW_atom_in_mExpr307:BitSet = new BitSet([0xC0000002, 0x00000001]);
        public static const FOLLOW_30_in_mExpr312:BitSet = new BitSet([0x00041400, 0x00000000]);
        public static const FOLLOW_31_in_mExpr317:BitSet = new BitSet([0x00041400, 0x00000000]);
        public static const FOLLOW_32_in_mExpr322:BitSet = new BitSet([0x00041400, 0x00000000]);
        public static const FOLLOW_atom_in_mExpr326:BitSet = new BitSet([0xC0000002, 0x00000001]);
        public static const FOLLOW_INT_in_atom341:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_identifier_in_atom346:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_18_in_atom351:BitSet = new BitSet([0x00041400, 0x00000000]);
        public static const FOLLOW_expr_in_atom353:BitSet = new BitSet([0x00100000, 0x00000000]);
        public static const FOLLOW_20_in_atom355:BitSet = new BitSet([0x00000002, 0x00000000]);

    }
}