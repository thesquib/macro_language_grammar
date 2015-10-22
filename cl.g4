/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Grammar for the Clan Lord Macro Language                        *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

grammar cl;

/*
CR : [\r];
LF : [\n];
LINE_TERMINATOR : CR LF;
WS : [ \t];

fragment
NOT_CR_LF : ~[\n\r];
fragment
NOT_WS : ~[ \t];

NOT_STAR : ~[\*];
NOT_STAR_SLASH : ~[\*\\];
*/



//NOT_WS_CR_LF : ~[\n\r \t];
//NOT_CR_LF_DQUOTE : ~[\n\r"];

INCLUDE			  : 'include';

IF           : 'if';
ELSEIF			  : 'else if';
ELSE 			  : 'else';
ENDIF			    : 'end if';

SET_GLOBAL		: 'setglobal';
SET				    : 'set';

RANDOM			  : 'random';
NOREPEAT		  : 'no-repeat';
OR				    : 'or';
END_RANDOM		: 'end random';

LABEL			    : 'label';
GOTO			    : 'goto';

CALL			    : 'call';

PAUSE			    : 'pause';

MESSAGE			  : 'message';

MOVE			    : 'move';

L_PARENTHESE 	: '(';
R_PARENTHESE 	: ')';

L_BRACE 		  : '{';
R_BRACE 		  : '}';

L_BRACKET 		: '[';
R_BRACKET 		: ']';

comparator    : '<='|'<'|'>='|'>'|'=='|'!=';
operator      : '+'|'-'|'*'|'/'|'%';

//SingleQuote  : '\''|'`';
//DoubleQuote  : '"';

ATTRIBUTE     : '$ignore_case'|'$any_click'|'$no_override';

fragment
Digit
  : [0-9]
  ;

fragment
Letter
  : [a-zA-Z /@$\\]
  ;

Number
  : Digit+
  ;

NewLine
  : '\r'? '\n'
 // -> channel(HIDDEN)
  ;

//WS : (' ' | '\t')+ -> channel(HIDDEN);

// ----------
// Whitespace
//
// Characters and character constructs that are of no import
// to the parser and are used to make the grammar easier to read
// for humans.
//
WS
: [ \t\f]+
-> channel(HIDDEN)
;

//single quotes mean do replacement e.g
//'lol' 'laugh out loud'
//will replace 'lol' with 'laugh out loud'
SingleQuoted
  : '\'' Letter* '\''
  ;

//double quotes specify a rule, like:
//"lol" "/action laugh out loud"
// or
//"lol" {
//  /action laugh out loud
//  /pose celebrate  
// }
DoubleQuoted
  : '"' Letter* '"'
  ;

//valid identifiers:
// \abc /abc @abc $abc
// \abc- /abc_ @abc. $abc[ $abc] 
Identifier
  : ('\\'|'/'|'@'|'$')? Letter (Letter|Digit|'-'|'_'|'.'|'['|']')*
  ;

BlockComment
    :   '/*' .*? '*/'
        -> skip
    ;

LineComment
    :   '//' ~[\r\n]*
        -> skip
    ;


/* Rule Sets */

macros
  : macro*
  ;

macro
  : include_macro
  | set_macro
  | line_macro
  | block_macro
  | NewLine
  ;

include_macro
  : INCLUDE DoubleQuoted
  ;

set_macro
  : set_or_set_global Identifier set_expression
  ;

line_macro
  : trigger statement
  ;

block_macro
  : trigger NewLine statement_block
  ;

trigger
  : SingleQuoted
  | DoubleQuoted
  | Identifier
  ;

statement_block
  : L_BRACE NewLine statements NewLine
  ;

statements
  : statement*
  ;

statement
  : IF condition NewLine
      statements
      optional_else
    ENDIF NewLine
  | SET Identifier set_expression NewLine
  | SET_GLOBAL Identifier set_expression NewLine
  | RANDOM NOREPEAT? NewLine statements or_block* END_RANDOM NewLine
  | LABEL Identifier NewLine
  | GOTO Identifier NewLine
  | CALL Identifier NewLine
  | PAUSE Number NewLine
  | MOVE Identifier Identifier? NewLine
  | MESSAGE value+ NewLine
  | ATTRIBUTE NewLine
  | statement_block
  | text_command
  ;

optional_else
  : ELSEIF condition NewLine
      statements
      optional_else
  | ELSE NewLine
      statements
  ; // | {empty}

set_or_set_global
  : SET
  | SET_GLOBAL
  ;

or_block
  : OR NewLine statements
  ;

text_command
  : value* NewLine
  ;

condition
  : expression comparator expression
  ;

expression
  : value
  | value operator value
  ;

set_expression
  : value
  | operator value
  ;

value
  : DoubleQuoted
  | Number
  | Identifier
  ;