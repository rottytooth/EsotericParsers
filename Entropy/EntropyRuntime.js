entropyRuntime = (function () {

    var mutationRate = 0.005; // this can be changed before calling run

    var _varStore; // where we're putting everything

    /**
     * Given a parse tree, it executes the entropy commands
     * @param {Parse Tree} parseTree: from entropyParser.parse() 
     * @param {string} output: div to write output to
     */
    function run(parseTree, output) {

        _varStore = new Object(); // reset our store

        _executeCommand(parseTree, output);

    }

    //function _helloWorldTest() {
    //    _declareVar('testString', 'string');
    //    _setVar('testString', 'This is my String!!!')

    //    for (var i = 0; i < 100; i++) {
    //        var test = _getVar('testString');
    //    }
    //}

    function _mutate(oldValue) {
        // slightly alter the number (assumes a float, returns a float)

        if (typeof oldValue === 'string') { // we don't send strings, so this is a char
            oldValue = oldValue.charCodeAt(0);
        }

        var changeAmount = entropyRuntime.mutationRate * Math.random() * oldValue;
        if (Math.round(Math.random())) changeAmount = -changeAmount;
        oldValue += changeAmount;
        return oldValue;
    }

    function _mutateString(oldValue) {
        // convert string to a list of floats that can then each be mutated, and returned in an array
        var retString = "";
        var toStore = new Array();

        for (var j = 0; j < oldValue.length; j++) {
            var currentChar = _mutate(oldValue[j]);
            toStore[j] = currentChar;
        }

        return toStore;
    }

    function _declareVar(varName, type) {
        if (_varStore[varName]) {
            // Already exists!! Fail
            throw "There's already a variable with the name " + varName;
        }
        _varStore[varName] = { name: varName, type: type };
    }

    function _setVar(varName, value) {

        if (_varStore[varName] === undefined)
            throw "Could not find variable called " + varName;

        // type checking -- don't pass a string into something else, otherwise everything's good
        if (typeof value === 'string' && _varStore[varName].type !== 'string' && 
            !(_varStore[varName].type === 'char' && value.length === 1)) // if it's a string of length 1, it's a char (for us)
        {
            throw "Tried to put a " + (typeof value) + " in a variable of type " + _varStore[varName].type;
        }

        if (typeof value === "string") {
            value = _mutateString(value);
        } else {
            value = _mutate(value);
        }
        _varStore[varName].value = value;
    }

    function _getVar(varName) {

        if (_varStore[varName] === undefined)
            throw "Could not find variable called " + varName;

        if (_varStore[varName].value === undefined)
            throw "No value set for variable " + varName;

        switch(_varStore[varName].type)
        {
            case "real":
            case "int":
                _varStore[varName].value = _mutate(_varStore[varName].value);
                return _varStore[varName].value;
            case "char":
                _varStore[varName].value = _mutate(_varStore[varName].value);
                return '"' + String.fromCharCode(Math.round(_varStore[varName].value)) + '"';
            case "string":
                        
                var retString = "";
                for (var j = 0; j < _varStore[varName].value.length; j++) {
                    _varStore[varName].value[j] = _mutate(_varStore[varName].value[j]);
                    retString += String.fromCharCode(Math.round(_varStore[varName].value[j]));
                }
                return '"' + retString + '"';
        }
    }

    function _executeCommand(node, output) {
        retString = "";
        switch (node.type) {
            case "Program":
                // Okay, we're at the beginning! We loop through each child command
                for (var i = 0; i < node.childcommands.length; i++) {
                    _executeCommand(node.childcommands[i], output);
                }
                return;
            case "While":
                // If the expression is true, we keep executing child commands. If not, we return
                while (eval(_buildExpression(node.expression))) {
                    for (var i = 0; i < node.childcommands.length; i++) {
                        _executeCommand(node.childcommands[i], output);
                    }
                }
                return;
            case "If":
                // Similar to while, but we only do it once
                if (eval(_buildExpression(node.expression))) {
                    for (var i = 0; i < node.childcommands.length; i++) {
                        _executeCommand(node.childcommands[i], output);
                    }
                }
                return;
            case "Print":
                var exp = eval(_buildExpression(node.expression));
                output.innerText += exp.toString().replace(/(?:\r\n|\r|\n)/g, '<br />'); // output to a div, htmlify the line breaks
                return;
            case "Declare":
                _declareVar(node.varName, node.varType);
                return;
            case "Assignment":
                var exp = eval(_buildExpression(node.expression));
                _setVar(node.varName, exp);
                return;
            case "Input":
                var exp = prompt("Please enter a value for " + node.varName + "\"");
                _setVar(node.varName, exp);
                break;
        }
    }

    function _buildExpression(node) {
        // this is probably unnecessary bc we basically know when we're dealing with an expression or array of expressions, but this double-checks for us
        var retString = "";
        if (node !== undefined && node.type === undefined) { // if the node doesn't have a type, we're assuming it's an array of nodes
            for (var i = 0; i < node.length; i++) {
                retString += _loopExpression(node[i], output);
            }
            return retString;
        }
        else
            retString = _loopExpression(node, output);

        if (retString === undefined) {
            throw "Could not determine expression";
        }
        return retString;
    }

    function _loopExpression(node) {
        // if we're given an array, append each piece and send back (happens with comparisons sometimes)
        if (node.type === undefined && node[0].type !== undefined) {
            var retString = "";
            for (var k = 0; k < node.length; k++) {
                retString += _loopExpression(node[k]);
            }
            return retString;
        }

        if (retString === undefined) retString = "";

        // build a string of the expression and send it back
        switch (node.type) {
            case "ExpressionBlock":
                retString += "("
                for (var i = 0; i < node.expression.length; i++) {
                    retString += _loopExpression(node.expression[i]);
                }
                retString += ") ";
                return retString;
                break;
            case "Comparison":
            case "Additive":
            case "Multiplicative":
                return "(" + _loopExpression(node.left) + " " + node.operator + " " + _loopExpression(node.right) + ") ";
                break;
            case "VariableName":
                var variableValue = _getVar(node.name).toString();
                variableValue += " ";
                return variableValue;
                break;
            case "IntLiteral":
            case "FloatLiteral":
                return node.value.toString() + " ";
                break;
            case "StringLiteral":
                var str = node.value;
                str = _mutateString(str);
                var strBuilder = "";
                for (var j = 0; j < str.length; j++) {
                    strBuilder += String.fromCharCode(Math.round(str[j]));
                }
                return '"' + strBuilder + '" ';
                break;
            case "CharLiteral":
                var char = node.value;
                char = _mutate(char);
                return '"' + char + '" '
                break;
        }
    }

    return {
        run: run,
        mutationRate: mutationRate
    }

})();
