Start = 
		_? "Program" _ namespace:Identifier _ programName:Identifier _? "[" _? program:Command* _? "]" _?
        { 
        	return 	"function " + namespace + "_" + programName + "() {" +
            		"\n" + program.join("") +
                    "\n}";
        }

// Commands

Command = _? command:(Block / Statement) _?
		{ return command; }
        
Statement = (command:(Declare/Assignment/Input/Print) _? ";")        
		{ return command; }

Block = command:(While/If) 
		{ return command; }

While = "while" _ exp:Expression _? "[" _? commands:Command* _? "]"
        { 
        	return 	"while(" + exp + ") {" +
            		"\n" + commands.join("") +
                    "\n}";
        }

If = "if" _ exp:Expression _? "[" commands:Command* _? "]"
		{
        	return 	"if(" + exp + ") {" +
            		"\n" + commands.join("") +
                    "\n}";
        }
Declare = "declare" _ name:Identifier _ type:Type
		{
        	return "var " + name + "; // this variable should be a(n) " + type + "\n"
        }

Assignment = "let" _ name:Identifier _? "=" _? exp:Expression
		{
        	return name + " = " + exp + ";\n";
        }

Input = "input" _ name:Identifier 
		{
        	return name + " = prompt(\"Please enter a value for " + name +"\", \"\");\n";
        }

Print = "print" _ exp:Expression
        {
            return "$('#output').append(" + exp + ");\n";
        }
        
Type = type:"real"/"int"/"char"/"string"

// Expressions

Expression = _? exp:ExpressionBlockOrLower _? // _? exp:(ExpressionBlock/Comparison/AdditiveExpression/MultiplicativeExpression/UnaryExpression)+ _?
		{ return exp; }
        
ExpressionBlock = '(' _? exp:ExpressionBlockOrLower _? ')'
		{ return "(" + exp + ")"; }

Comparison = left:(ExpressionBlock/AdditiveOrLower) _? op:("="/"<="/">="/"<"/">") _? right:(ExpressionBlock/AdditiveOrLower)
		{ return "(" + left + " " + op + " " + right + ")" }


AdditiveExpression
  = left:(ExpressionBlock/MultiplicativeOrLower) _? op:AdditiveOperator _? right:(ExpressionBlock/AdditiveOrLower)
		{ return "(" + left + " " + op + " " + right + ")" }

AdditiveOperator
  = $("+" ![+=])
  / $("-" ![-=])
  
MultiplicativeExpression
  = left:(ExpressionBlock/UnaryExpression) _? op:MultiplicativeOperator _? right:(ExpressionBlock/MultiplicativeOrLower)
		{ return "(" + left + " " + op + " " + right + ")" }
    
MultiplicativeOperator
  = $("*" !"=")
  / $("/" !"=")
  / $("%" !"=")

// Precedence
ExpressionBlockOrLower = (ExpressionBlock / ComparisonOrLower)
ComparisonOrLower = (Comparison / AdditiveOrLower)
AdditiveOrLower = (AdditiveExpression / MultiplicativeOrLower)
MultiplicativeOrLower = (MultiplicativeExpression / UnaryExpression)

UnaryExpression = VariableName / Literal

VariableName = id:Identifier
		{ return id; }

Literal = NumberLiteral / StringLiteral / CharLiteral

NumberLiteral
  = "-"? DecimalIntegerLiteral "." DecimalDigit* 
   { return parseFloat(text()); }
  / "." DecimalDigit+ 
   { return parseFloat(text()); }
  / "-"? DecimalIntegerLiteral 
   { return parseInt(text()); }

DecimalIntegerLiteral
  = "0"
  / NonZeroDigit DecimalDigit*

DecimalDigit
  = [0-9]

NonZeroDigit
  = [1-9]

StringLiteral = _? '"' val:[^"]* '"' _?
		{ return '"' + val.join("") + '"' ; }

CharLiteral = _? "'" val:[^'] "'" _?
		{ return "'" + val + "'" ; }

Identifier = d:[a-zA-Z0-9_]+
		{ return d.join(""); }

_ "whitespace" = [ \r\n\t]+ 



