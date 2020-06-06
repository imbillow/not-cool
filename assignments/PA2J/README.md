xxREADME file for Programming Assignment 2 (Java edition)
=======================================================

Your directory should now contain the following files:

 Makefile
 README
 cool.lex
 test.cl
 AbstractSymbol.java  -> [cool root]/src/PA2J/AbstractSymbol.java
 BoolConst.java       -> [cool root]/src/PA2J/BoolConst.java
 Flags.java           -> [cool root]/src/PA2J/Flags.java
 IdSymbol.java        -> [cool root]/src/PA2J/IdSymbol.java
 IdTable.java         -> [cool root]/src/PA2J/IdTable.java
 IntSymbol.java       -> [cool root]/src/PA2J/IntSymbol.java
 IntTable.java        -> [cool root]/src/PA2J/IntTable.java
 Lexer.java           -> [cool root]/src/PA2J/Lexer.java
 AbstractTable.java   -> [cool root]/src/PA2J/AbstractTable.java
 StringSymbol.java    -> [cool root]/src/PA2J/StringSymbol.java
 StringTable.java     -> [cool root]/src/PA2J/StringTable.java
 Utilities.java       -> [cool root]/src/PA2J/Utilities.java
 TokenConstants.java  -> [cool root]/src/PA2J/TokenConstants.java
 *.java		      other generated files

	The Makefile contains targets for compiling and running your
	program. DO NOT MODIFY.

	The README contains this info. Part of the assignment is to fill
	the README with the write-up for your project. You should
	explain design decisions, explain why your code is correct, and
	why your test cases are adequate. It is part of the assignment
	to clearly and concisely explain things in text as well as to
	comment your code. Just edit this file.

	cool.lex is a skeleton file for the specification of the
	lexical analyzer. You should complete it with your regular
	expressions, patterns and actions. 

	test.cl is a COOL program that you can test the lexical
	analyzer on. It contains some errors, so it won't compile with
	coolc. However, test.cl does not exercise all lexical
	constructs of COOL and part of your assignment is to rewrite
	test.cl with a complete set of tests for your lexical analyzer.

	TokenConstants.java contains constant definitions that are used by
	almost all parts of the compiler. DO NOT MODIFY.

	*Table.java and *Symbol.java contain string table data
	structures.  DO NOT MODIFY.

	Utilities.java contains various support functions used by the
	main lexer driver (Lexer.java).  DO NOT MODIFY.

	Lexer.java contains the main method which will call your lexer
	and print out the tokens that it returns.  DO NOT MODIFY.

        CoolLexer.java is the scanner generated by jlex from cool.lex.
        DO NOT MODIFY IT, as your changes will be overritten the next
        time you run jlex.

	mycoolc is a shell script that glues together the phases of the
	compiler using Unix pipes instead of statically linking code.  
	While inefficient, this architecture makes it easy to mix and match
	the components you write with those of the course compiler.
	DO NOT MODIFY.	

Instructions
------------

	To compile your lextest program type:

	% make lexer

	Run your lexer by putting your test input in a file 'foo.cl' and
	run the lextest program:

	% lexer foo.cl

	To run your lexer on the file test.cl type:

	% make dotest

	If you think your lexical analyzer is correct and behaves like
	the one we wrote, you can actually try 'mycoolc' and see whether
	it runs and produces correct code for any examples.
	If your lexical analyzer behaves in an
	unexpected manner, you may get errors anywhere, i.e. during
	parsing, during semantic analysis, during code generation or
	only when you run the produced code on spim. So beware.

	If you change architectures you must issue

	% make clean

	when you switch from one type of machine to the other.


	GOOD LUCK!

---8<------8<------8<------8<---cut here---8<------8<------8<------8<---

Write-up for PA2J
-----------------
