/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Grammar for the Clan Lord Macro Language                        *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

grammar cl;

Letter
	: [A-Za-z]
	;

Digit
	: [0-9]
	;

Cr : 
  [\r];


Lf : 
  [\n];
  
line_terminator_char : Cr Lf;

Blank_char : 
  [ \t];
  
Not_cr_lf : [^\n\r];
Not_blank : [^ \t];
Not_cr_lf_blank : [^\n\r \t];
Not_star : [^\*];
Not_star_slash : [^\*\\];

include			: 'include';

if_				: 'if';
elseif			: 'else if';
else_ 			: 'else';
endif			: 'end if';

set_global		: 'setglobal';
set				: 'set';

random			: 'random';
norepeat		: 'no-repeat';
or				: 'or';
end_random		: 'end random';

label			: 'label';
goto_			: 'goto';

call			: 'call';

pause			: 'pause';

message			: 'message';

move			: 'move';

l_parenthese 	: '(';
r_parenthese 	: ')';

l_brace 		: '{';
r_brace 		: '}';

l_bracket 		: '[';
r_bracket 		: ']';

comparator    : '<='|'<'|'>='|'>'|'=='|'!=';
operator      : '+'|'-'|'*'|'/'|'%';


//Not sure about these yet,
//but I think they have to take a longer form
//
//attribute		: '$ignore_case'|'$any_click'|'$no_override';

BlockComment
    :   '/*' .*? '*/'
        -> skip
    ;

LineComment
    :   '//' ~[\r\n]*
        -> skip
    ;






/*

Helpers
  letter = ['A'..'Z']|['a'..'z'];
  digit = ['0'..'9'];
  cr = 13;
  lf = 10;
  
  all = [0..0xFFFF];
 
  line_terminator_char = [cr + lf];
  
  blank_char = [' '+ '	'];
  
  not_cr_lf = [all - line_terminator_char];
  not_blank = [all - blank_char];
  not_cr_lf_blank = [not_cr_lf - blank_char];
  not_star = [ all - '*' ];
  not_star_slash = [ not_star - '/' ];
  
  single_quote=0x0027;
Tokens
  include			= 'include';

  if				= 'if';
  elseif			= 'else if';
  else				= 'else';
  endif				= 'end if';

  set_global		= 'setglobal';
  set				= 'set';

  random			= 'random';
  norepeat			= 'no-repeat';
  or				= 'or';
  end_random		= 'end random';

  label				= 'label';
  goto				= 'goto';

  call				= 'call';
  
  pause				= 'pause';

  message			= 'message';

  move				= 'move';

  attribute			= '$ignore_case'|'$any_click'|'$no_override';

  comparator 		= '<='|'<'|'>='|'>'|'=='|'!=';

  operator			= '+'|'-'|'*'|'/'|'%';

  l_parenthese = '(';
  r_parenthese = ')';

  l_brace = '{';
  r_brace = '}';
  
  l_bracket = '[';
  r_bracket = ']';
  
  number = digit+;
  single_quoted = single_quote not_cr_lf_blank* single_quote;
  quoted = '"' [not_cr_lf - '"']* '"';

  new_line = line_terminator_char*;

  blank = blank_char*;

  comment = '/*' not_star * '*' + ( not_star_slash not_star * '*' + ) * '/';
  line_comment = '//' not_cr_lf *;
  
  identifier		= ('\'|'/'|'@'|'$')? letter (letter|digit|'-'|'_'|'.'|'['|']')*;

Ignored Tokens
  blank, comment, line_comment;

Productions
  macros	=	macro*;

  macro		=	{include_macro}	include_macro|
  				{set_macro}		set_macro|
  				{line_macro}	line_macro|
  				{block_macro}	block_macro|
  				{new_line}		new_line;

  include_macro=				include quoted;

  set_macro=	set_or_set_global identifier set_expression;

  line_macro=					trigger statement;

  block_macro=					trigger new_line statement_block;

  trigger	=	{single_quoted}	single_quoted|
  				{quoted}		quoted|
  				{identifier}	identifier;
  
  statement_block	=	l_brace [nl1]:new_line statements r_brace [nl2]:new_line;

  statements		=	statement*;

  statement = 
    {if}         		if condition [nl1]:new_line
                   			statements
                   			optional_else
                 		endif [nl2]:new_line|
    {set}		 		set identifier set_expression new_line|
    {set_global}	 	set_global identifier set_expression new_line|
    {random}	 		random norepeat? [nl1]:new_line statements or_block* end_random [nl2]:new_line|
	{label}				label identifier new_line|
	{goto}				goto identifier new_line|
	{call}				call identifier new_line|
	{pause}				pause number new_line|
	{move}				move [speed]:identifier [direction]:identifier? new_line|
	{message}			message value+ new_line|
	{attribute}			attribute new_line|
	{statement_block}	statement_block|
	{text_command}	 	text_command;
	
  optional_else = 
    {elseif}  elseif condition [nl1]:new_line
              	statements
              	optional_else|
    {else}  else new_line
              statements |
    {empty} ;
  
  set_or_set_global=	{set}			set|
  						{set_global}	set_global;
  
  or_block	=	or new_line statements;
  
  text_command	=	value* new_line;
  
  condition =	[left]:expression comparator    [right]:expression;

  expression =
    {value} value |
    {operator}  [left]:value operator [right]:value;

  set_expression =
    {value} value |
    {operator}  operator  value;

  value =
    {quoted}     quoted |
    {constant}   number |
    {identifier} identifier;


    */

