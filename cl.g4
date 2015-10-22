/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Grammar for the Clan Lord Macro Language                        *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

grammar cl;

/************* LEXER ************/
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

Comparator    : '<='|'<'|'>='|'>'|'=='|'!=';
Operator      : '+'|'-'|'*'|'/'|'%';

ATTRIBUTE     : '$ignore_case'|'$any_click'|'$no_override';

fragment
Digit
  : [0-9]
  ;

fragment
Letter
  : ~[\n"]
  //[a-zA-Z0-9 \r!/@$\\]
  ;

fragment
IdentifierLetter
  : [a-zA-Z]
  ;

Number
  : Digit+
  ;

fragment NL : '\r''\n' | '\n' | '\r';

NEWLINE
  : NL+
//  -> channel(HIDDEN)
// -> skip
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
  : ('\\'|'/'|'@'|'$')? IdentifierLetter (IdentifierLetter|Digit|'-'|'_'|'.'|'['|']')*
  ;

BlockComment
    :   '/*' .*? '*/'  NEWLINE?
        -> skip
    ;

LineComment
    :   '//' ~[\r\n]* NEWLINE?
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
  | NEWLINE
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
  : trigger NEWLINE statement_block 
  ;

trigger
  : SingleQuoted
  | DoubleQuoted
  | Identifier
  ;

statement_block
  : L_BRACE NEWLINE statements R_BRACE NEWLINE
  ;

statements
  : statement*
  ;

statement
  : conditional_statement
  | SET Identifier set_expression NEWLINE
  | SET_GLOBAL Identifier set_expression NEWLINE
  | RANDOM NOREPEAT? NEWLINE statements or_block* END_RANDOM NEWLINE
  | LABEL Identifier NEWLINE
  | GOTO Identifier NEWLINE
  | CALL Identifier NEWLINE?
  | PAUSE pause_statement NEWLINE
  | MOVE Identifier Identifier? NEWLINE
  | MESSAGE value+ NEWLINE
  | ATTRIBUTE NEWLINE
  | statement_block
  | text_command NEWLINE
  ;

pause_statement
  : Number
  | Identifier
  ;

conditional_statement
  : IF condition NEWLINE
      statements
      optional_else
    ENDIF NEWLINE
  ;

optional_else
  : ELSEIF condition NEWLINE
      statements
      optional_else
  | ELSE  NEWLINE
      statements
  |
  ;

set_or_set_global
  : SET
  | SET_GLOBAL
  ;

or_block
  : OR statements
  ;

text_command
  : value+
  ;

condition
  : expression Comparator expression
  ;

expression
  : value
  | value Operator value
  ;

set_expression
  : value
  | Operator value
  ;

value
  : DoubleQuoted
  | Number
  | Identifier
  ;