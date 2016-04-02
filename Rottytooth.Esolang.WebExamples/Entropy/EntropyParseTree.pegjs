Start = 
		_? "Program" _ namespace:Identifier _ programName:Identifier _? "[" _? program:Command* _? "]" _?
        { 
        	var program = {
            	type: 'Program', 
                namespace: namespace, 
                program: programName,
                childcommands: program 
                };
        	return program;
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
        	var block = {
            	type: 'While', 
                expression: exp,
                childcommands:  commands 
                };
        	return block;
        }

If = "if" _ exp:Expression _? "[" commands:Command* _? "]"
		{
        	var block = {
            	type: 'If', 
                expression: exp,
                childcommands:  commands 
                };
        	return block;
        }
Declare = "declare" _ name:Identifier _ type:Type
		{ return {
            type: "Declare", 
            varName: name, 
            varType: type 
            }; 
        }

Assignment = "let" _ name:Identifier _? "=" _? exp:Expression
		{ return {
        	type: "Assignment", 
            varName:name,
            expression: exp 
        }; }

Input = "input" _ name:Identifier 
		{ return {
        	type: "Input", 
            varName:name
        }; }

Print = "print" _ exp:Expression
		{ return {
        	type: "Print", 
            expression: exp,
        }; }

Type = type:"real"/"int"/"char"/"string"

// Expressions

Expression = _? exp:(ExpressionBlock/Comparison)+ _?
		{ return exp; }
        
ExpressionBlock = '(' _? exp:Expression _? ')'
		{ return {
        	type: "ExpressionBlock",
            expression: exp};
        }

Comparison = left:(ExpressionBlock/AdditiveExpression) _? op:("="/"<="/">="/"<"/">") _? right:(ExpressionBlock/Expression)
		{ return {
        	type: "Comparison",
            operator: op,
            left: left,
            right: right};
        } / AdditiveExpression

AdditiveExpression
  = left:(ExpressionBlock/MultiplicativeExpression) _? op:AdditiveOperator _? right:(ExpressionBlock/AdditiveExpression)
    { return {
            type: "Additive", 
            operator: op,
            left: left,
            right: right};
    } / MultiplicativeExpression

AdditiveOperator
  = $("+" ![+=])
  / $("-" ![-=])
  
MultiplicativeExpression
  = left:(ExpressionBlock/UnaryExpression) _? op:MultiplicativeOperator _? right:(ExpressionBlock/MultiplicativeExpression)
    { return {
            type: "Multiplicative", 
            operator: op,
            left: left,
            right: right};
    } / UnaryExpression
    
MultiplicativeOperator
  = $("*" !"=")
  / $("/" !"=")
  / $("%" !"=")

UnaryExpression = Literal / VariableName

VariableName = id:Identifier
		{ return {
        	type: "VariableName",
            name: id };
        }

Literal = NumberLiteral / StringLiteral / CharLiteral

NumberLiteral
  = "-"? DecimalIntegerLiteral "." DecimalDigit* {
      return { type: "FloatLiteral", value: parseFloat(text()) };
    }
  / "." DecimalDigit+ {
      return { type: "FloatLiteral", value: parseFloat(text()) };
    }
  / "-"? DecimalIntegerLiteral { 
      return { type: "IntLiteral", value: parseInt(text()) };
    }

DecimalIntegerLiteral
  = "0"
  / NonZeroDigit DecimalDigit*

DecimalDigit
  = [0-9]

NonZeroDigit
  = [1-9]

StringLiteral = _? '"' val:[^"]* '"' _?
		{ return {
        	type: 'StringLiteral',
            value: val.join("") };
        }

CharLiteral = _? "'" val:[^'] "'" _?
		{ return {
        	type: 'CharLiteral',
            value: val };
        }
Identifier = d:[a-zA-Z0-9_]+
		{ return d.join(""); }

_ "whitespace" = [ \r\n\t]+ 



