/*
 * Wye's lexer
 * Implemented in Ragel/C++
 */

#include "lexer.h"
#include "parser.h"
#include "parser.tab.h"

#include <iostream>

using namespace Wye;

%%machine wye_lexer;
// emit the constant static data for the state machine
%%write data;


%%{
	ident = alpha (alnum | '_')*;

	main := |*
	ident {fbreak;};

	space;
	*|;
}%%

namespace Wye {
	Lexer::Lexer(const char *input) {
		// emit the initialization code for the lexer
		%%write init;

		this->input = input;
		p = input ; // point Ragel to the input string
		pe = input + strlen(input) + 1; // point Ragel to the end of the input string
	}

	int Lexer::lex(YYSTYPE *val) {
		int ret = END; // the returned token; by default this is END=0
		// all tokens come from parser.yy

		%%write exec;

		if (cs == wye_lexer_error) {
			std::cerr << "Lexical error at (line:col): unknown symbol(s) `" << std::string(ts, te-ts) << "`.\n";
		}

		if (p == eof) {
			ret = END;
		}

		return ret;
	}
}

int yylex(YYSTYPE *val, ParserState *ps) {
	return ps->lexer->lex(val);
}

