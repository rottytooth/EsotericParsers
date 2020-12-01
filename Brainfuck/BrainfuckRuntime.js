brainfuckRuntime = (function () {
    "use strict";
    /*
        Valid commands: Print / Input / BeginLoop / EndLoop / Increment / Decrement / MoveRight / MoveLeft
    */

    var maxValue = 255; // max value of memory block -- bf standard is 255 (8 bits: 0 to 255)
    var memorySize = 256; // # of memory blocks allowed in program

    var _memory; // memory storage for brainfuck program
    var _idx; // current index -- where we are in that memory storage

    /**
     * Given a parse tree, it executes the brainfuck commands
     * @param {Parse Tree} parseTree: from brainfuckParser.parse() 
     * @param {string} output: div to write output to
     */
    function run(parseTree, output) {

        // setup
        _memory = new Array(memorySize); // data storage
        _idx = 0; // index of current position of pointer (within _memory)

        for (var i = 0; i <= memorySize; i++) {
            _memory[i] = 0;
        }

        _executeCommands(parseTree, output);
    }

   /**
    * Loops through program or a loop within the program, executing commands as it goes
    * @param {Parse Tree} parseTree: from brainfuckParser.parse() 
    * @param {string} output: div to write output to
    * @return {bool} testForReturn: is this a loop in the program, meaning we return on zero value
    */
    function _executeCommands(parseTree, output) {
        for (var i = 0; i < parseTree.length; i++) {
            if (typeof (parseTree[i]) == "string") { // If it's a string, we know it's one of the bf commands
                switch(parseTree[i])
                {
                    case "Print":
                        document.getElementById(output).innerText += String.fromCharCode(_memory[_idx]);
                        break;
                    case "Input":
                        var input = prompt("Please input a value", "");
                        _memory[_idx] = input;
                        break;
                    case "Increment":
                        _memory[_idx]++;
                        if (_memory[_idx] > maxValue) _memory[_idx] = 0;
                        break;
                    case "Decrement":
                        _memory[_idx]--;
                        if (_memory[_idx] < 0) _memory[_idx] = maxValue;
                        break;
                    case 'MoveRight':
                        _idx++;
                        if (_idx >= maxValue) _idx = 0;
                        break;
                    case 'MoveLeft':
                        _idx--;
                        if (_idx < 0) _idx = MaxValue - 1;
                        break;
                    case "EndLoop":
                        if (_memory[_idx] != 0) {
                            i = 0; // go back to beginning of current loop
                        } else {
                            return; // exit current loop
                        }
                        break;
                }

                // Uncomment line below to see the parse tree printed to output
//                output.text += parseTree[i] + "<BR>";
            }
            else { // If it's not a string, it's an object holding the sub-tree; this corresponds to a loop
                _executeCommands(parseTree[i], output);
            }
        }
    }

    return {
        run: run,
        maxValue: maxValue,
        memorySize: memorySize
    }

})();
