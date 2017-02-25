palindrome =
    'a' _? palindrome _?  'a' /
    'b' _? palindrome _?  'b' /
    'c' _? palindrome _?  'c' /
    'd' _? palindrome _?  'd' /
    'e' _? palindrome _?  'e' /
    'f' _? palindrome _?  'f' /
    'g' _? palindrome _?  'g' /
    'h' _? palindrome _?  'h' /
    'i' _? palindrome _?  'i' /
    'j' _? palindrome _?  'j' /
    'k' _? palindrome _?  'k' /
    'l' _? palindrome _?  'l' /
    'm' _? palindrome _?  'm' /
    'n' _? palindrome _?  'n' /
    'o' _? palindrome _?  'o' /
    'p' _? palindrome _?  'p' /
    'q' _? palindrome _?  'q' /
    'r' _? palindrome _?  'r' /
    's' _? palindrome _?  's' /
    't' _? palindrome _?  't' /
    'u' _? palindrome _?  'u' /
    'v' _? palindrome _?  'v' /
    'w' _? palindrome _?  'w' /
    'x' _? palindrome _?  'x' /
    'y' _? palindrome _?  'y' /
    'z' _? palindrome _?  'z' /
	'a' _? 'a' / 'b' _? 'b' / 'c' _? 'c' / 'd' _? 'd' / 'e' _? 'e' / 'f' _? 'f' / 'g' _? 'g' / 'h' _? 'h' / 'i' _? 'i' / 'j' _? 'j' /
	'k' _? 'k' / 'l' _? 'l' / 'm' _? 'm' / 'n' _? 'n' / 'o' _? 'o' / 'p' _? 'p' / 'q' _? 'q' / 'r' _? 'r' / 's' _? 's' / 't' _? 't' /
	'u' _? 'u' / 'v' _? 'v' / 'w' _? 'w' / 'x' _? 'x' / 'y' _? 'y' / 'z' _? 'z' /
    letter

letter = [a-z]

_ "whitespace" = [ \t\r\n]+