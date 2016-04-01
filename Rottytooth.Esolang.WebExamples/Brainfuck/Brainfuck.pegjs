start =
    Command*
    
Command = 
	_? cmd:(Print / Input / Loop / Increment / Decrement / MoveRight / MoveLeft) _?
    	{ return cmd; }

Print = '.' { return 'Print'; }

Input = ',' { return 'Input'; }

Loop = '[' _? exp:Command* _? ']'
	{ 
    	exp.unshift('BeginLoop');
        exp.push('EndLoop');
    	return exp; 
    }

Increment = '+' { return 'Increment'; }

Decrement = '-' { return 'Decrement'; }

MoveRight = '>' { return 'MoveRight'; }

MoveLeft = '<' { return 'MoveLeft'; }

_ = [^.,+-<>\[\]]+

