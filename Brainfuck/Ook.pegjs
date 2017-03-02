start =
    Command*
    
Command = 
	_? cmd:(Print / Input / Loop / Increment / Decrement / MoveRight / MoveLeft) _?
    	{ return cmd; }

Print = 'Ook! Ook.' { return 'Print'; }

Input = 'Ook. Ook!' { return 'Input'; }

Loop = 'Ook! Ook?' _? exp:Command* _? 'Ook? Ook!'
	{ 
    	exp.unshift('BeginLoop');
        exp.push('EndLoop');
    	return exp; 
    }

Increment = 'Ook. Ook.' { return 'Increment'; }

Decrement = 'Ook! Ook!' { return 'Decrement'; }

MoveRight = 'Ook. Ook?' { return 'MoveRight'; }

MoveLeft = 'Ook? Ook.' { return 'MoveLeft'; }

_ = [ \t\r\n]+