# Lab Problem Set 2: Tail Recursion and Program-defined types in OCaml

*CSci 2041: Advanced Programming Principles, Summer 2021*

**Due:** Friday, June 18 at 11:59pm (CST)

In your local copy of the public 'labs2041' repository, do a `git pull` to grab the files for this week's lab exercises.  Then let's get started practicing with type declarations!

# 1. Tail Recursion and nested functions

The file `lab2/tailrec.ml` contains some syntax to get you started on this problem.  Copy it to the `lab2` directory in your personal repository (remember to `git add` the directory and the file before you commit!) and read on:

### `index_sum`

The function `index_sum : int list -> int` takes as input a list `[x1; x2; ...; xN]` and should return the integer `1*x1 + 2*x2 + ... + N * xN` (that is, the `i`th list element is multiplied by `i` in the sum).  Write a tail-recursive implementation of this function that uses a local helper function (which should have three inputs: the current index, the accumulated sum, and the rest of the list).  Some example evaluations:

+ `index_sum [17]` should evaluate to `17`
+ `index_sum [10; 9; 8]` should evaluate to `1*10 + 2*9 + 3*8` = `52`
+ `index_sum [3; 1; 4; 1; 5]` should evaluate to `3*1 + 1*2 + 4*3 + 1*4 + 5*5` = `46`

### `msort`

The `tailrec.ml` file contains an incomplete implementation of merge sort, a
sorting algorithm that works by splitting a list into two halves, recursively
sorting each half, and then merging the sorted results.  `msort` has a few
problems: first, the body is missing some base cases (it will recurse infinitely
as written), and second, the `merge` helper function is not tail recursive, so
the function will overflow the call stack when sorting a sufficiently large
list.  

Fix the helper function (it will need an accumulator parameter) so that it only
uses a fixed number of stack frames regardless of the size of the input list,
and complete the body of the definition.  You might find the functions
`List.rev` and `List.rev_append` useful here, since they are tail recursive.

Some example evaluations:
+ `msort []` evaluates to `[]`
+ `msort [0; 17; -32]` evaluates to `[-32; 0 ; 17]`
+ `msort ["not"; "me"; "string"; "list"]` evaluates to `["list"; "me"; "not"; "string"]`

### `range` again

Most likely your implementation of `range` from part 1 was not tail recursive.  Rework it here to use a tail-recursive helper function so that it uses at most a fixed number of stack frames regardless of the input parameters.

### `*@` operator
Another way to build lists in python is with the `*` operation: `n*lst` is `n` copies of the list `lst`, so for example `3*[1,2]` is the list `[1,2,1,2,1,2]`.  Let's implement the operator `( *@ ) : int -> 'a list -> 'a list` in OCaml to have the same behavior, and use tail recursion to use a fixed number of stack frames regardless of the input parameters.  Some example evaluations:

+ `3 *@ [1;2]` evaluates to `[1;2;1;2;1;2]`
+ `0 *@ [3.14159; 2.71828]` evaluates to `[]` (the same for any negative number of copies)
+ `17 *@ []` evaluates to `[]`


**Note**: The `@` operator is not tail-recursive; it is implemented exactly as we described the function `append` in class.

### Additional test cases
+ `range 1 1` evaluates to `[]`
+ `range 13 17` evaluates to `[13; 14; 15; 16]`
+ `msort (range 0 10000000)` does not fail with `Stack_overflow` (it might take noticeable time to evaluate in an interactive REPL like `utop`, though)
+ `range 0 10000000` does not fail with `Stack_overflow`
+ `10000000 *@ [1;2]` does not fail with `Stack_overflow`

_**Test Cases:**_ For full credit your solution should pass 10/14 of the example evaluations given above.


# 2. Records and enumerated unions: Card Games

The file `lab2/cards.ml` contains some syntax to help get started on this problem.  Copy it to an `lab2` directory in your personal repository to get started with them.

## Card Games

A "standard" card deck consists of 52 cards, each suit (Hearts, Clubs, Spades, Diamonds) having thirteen cards (2 through 10, Jack, Queen, King, Ace).  The file `cards.ml` contains incomplete definitions for three types: `card_suit`, `card_value`, and `card` (a record with suit and value fields.)  It also has incomplete definitions for functions to convert string representations of cards, like `"KD"` for Jack of Diamonds, into values of type `card`. (We're too lazy to look up how to represent a diamond, heart, club, or spade as a unicode character in OCaml.  If you want, you can add `unicode_string_of_card` and `card_of_unicode_string` functions to handle these fancier string representations.)

### `card_suit`, `card_value`, `string_of_card`, `card_of_string`

Complete the definitions of the `card_suit` and `card_value` types, along with the `card_of_string` and `string_of_card` functions.  Your definitions should allow comparisons between values of type `card_value` so that, for example, `Two < Five` and `Three < Queen` evaluate to true.  Some sample evaluations:

+ `let s : card_suit = Spades` should compile without errors

+ `let v : card_value = Jack` should compile without errors

+ `let c4c = { value = Four; suit = Clubs }` should compile without errors

+ `let cqd = { value = Queen; suit = Diamonds }` should compile without errors

+ `card_of_string "10D"` should evaluate to the record `{ value = Ten; suit = Diamonds }`

+ `string_of_card (card_of_string "9H")` should evaluate to `"9H"`


### `trick_winner`

Many card games involve play in "tricks" (eg. Spades, Hearts, Bridge, Whist), in which a player leads with a card, and other players also lay out cards, of the same suit if possible.  Once all players have played cards, the highest card of the same suit as the lead card "wins" or "takes" the "trick."  (and typically becomes the leader for the next trick.)  In `cards.ml` there is a prototype for the function `trick_winner : card list -> card` which should return the value of the winning `card` from a list of `card` values, assuming the cards were played in the order given.  (Assuming there are no "trump" cards, and Aces are "high".)  Fill in the definition for this function.  Some sample evaluations:

+ `trick_winner [ {value = Two; suit = Hearts}; {value = King; suit = Spades } ]` should evaluate to `{ value = Two; suit = Hearts }` because the lead suit was Hearts.

+ `trick_winner [ {value = Two; suit = Hearts}; {value = King; suit = Hearts } ]` should evaluate to `{ value = King; suit = Hearts }` because the King had the same suit as the lead card.

+ `trick_winner []` should raise an exception with `invalid_arg "empty trick"` because there can't be a winner in a trick with no cards.


_**Test cases:**_ Your solution must compile and agree on 8/9 example evaluations given above to get full credit for this question.

# 3. Disjoint unions

### TLD of hostinfo

In lecture, we defined a type `hostinfo` that is either a 4-byte "IP
address" (like `(134,84,159,182)`) or a string-valued "DNS name" (like
`"www.myu.umn.edu"`):

```
type hostinfo = IP of int * int * int * int | DNSName of string
```
We've conveniently placed this type definition in the file
`lab2/hostinfo.ml`.

An important property of a DNS name is the _top level domain_ - the
string after the last `'.'` character. For example the top-level
domain (or TLD) of "www.myu.umn.edu" is "edu", the TLD of
"www.google.com" is "com", and the TLD of "cs2041.org" is "org".
In `hostinfo.ml`, add the OCaml definition for the function `tld : hostinfo -> string
option`, which returns the TLD of a hostinfo value that is a DNS
name, and `None` if its argument is an IP address.   Some example
evaluations:

+ `tld (IP (8,8,8,8))` evaluates to `None` because its argument is an
IP value.
+ `tld (DNSName "cnn.com")` evaluates to `Some "com"`
+ `tld (DNSName "comcast.net")` evaluates to `Some "net"`

Hint: you might find the functions `String.sub` and `String.rindex` in the
[`String` module](http://caml.inria.fr/pub/docs/manual-ocaml/libref/String.html)
to be useful here.

### Card_option: Trump cards

The file `card_option.ml` contains the start of a similar set of types to represent playing cards as in the first problem: here we'll represent a card value as either `Simple of int`, or one of the "Face cards".  Here we'll extend the problem of determining the winner of a trick to consider the idea of "trump cards."  When a trick is played with a trump suit, the winner is the highest card of the lead suit, if no cards of the trump suit are played, or the highest card of the trump suit, if at least one such trump card is played.  

Fill in the definition of `trick_winner_trump : card list -> card_suit option -> card`, which can determine the winner of a trick when there is no trump suit (the second parameter is `None`) or when there is a trump suit (the second parameter is `Some s`).  Some sample evaluations:

+ `trick_winner_trump [{value = Simple 9; suit = Hearts}] (Some Diamonds)` should evaluate to `{value = Simple 9; suit = Hearts}` because no cards of the trump suit were played

+ `trick_winner_trump [{value = Simple 9; suit = Hearts}; {value = Simple 2; suit = Diamonds}] (Some Diamonds)` should evaluate to `{value = Simple 2; suit = Diamonds}` because the trump suit was Diamonds so the 2 of Diamonds "trumps" the 9 of Hearts.

+ `trick_winner_trump [{value = Simple 9; suit = Hearts}; {value = Simple 2; suit = Diamonds}] None` should evaluate to `{value = Simple 9; suit = Hearts}` because in this trick there is no trump suit and so the 9 of Hearts was the highest value card in the lead suit.

+ `trick_winner_trump [{value = Simple 9; suit = Hearts}; {value = Ace; suit = Hearts}] None` should evaluate to `{value = Ace; suit = Hearts}` because there is no trump suit and the Ace of Hearts has higher value than the 9 of Hearts.  (even if there was a trump suit, the Ace of Hearts would win this trick)

Hint: you might find it useful to first define a function that determines, given a current lead, a candidate card, and the trump suit (if any), determines what the new "leading card" should be.  Then think about how to process a list of cards using this logic.


_**Test Cases:**_ For full credit your solution should pass 5/7 of the example evaluations given above.

# 4. Recursive Types

### Binary Search trees

Binary trees are a fundamental data structure in computer science, which you
will have seen in CSci 1933 or its equivalent.  A _binary search tree_ is an
extension of a binary tree that allows for efficient search and insertion of
elements, by enforcing the requirement that the value stored at each internal
node is greater than or equal to all elements in its left subtree, and less than
or equal to all elements in its right subtree.  You'll find the type definition
and function definitions for `insert` and `search` in the file `lab2/btree.ml`,
and you should add your code for this problem to the same program.

+ Complete the function `tree_min : 'a btree -> 'a option` that finds the
smallest element in a binary tree (BST or not).  Example evaluations: `tree_min
Empty` should evaluate to `None`; `tree_min t3` should evaluate to `Some 3`

+ Complete the function `tree_max : 'a btree -> 'a option` which finds the
largest element in a binary tree (BST or not). Example evaluations: `tree_max
Empty` should evalute to `None`; `tree_max t5` should evaluate to `Some 12`.

+ Now fix the function `is_bstree : 'a bstree -> bool` that checks that its
argument satisfies the binary search tree condition.  Example evaluations:
`is_bstree Empty` should evaluate to `true`, `is_bstree (Node(0,Empty,Leaf 1))`
should evaluate to `true`, `is_bstree (Node(0,Leaf 1,Empty))` should evaluate to
`false`, and `is_bstree t3` should evaluate to `false`.

### An RPN Arithmetic calculator

The file that we are about to inspect relies on the `Str` module. When
using ocamlbuild, this dependency will be automatically detected
and this module will be loaded. However, `utop` will not do this and we must
instruct `utop` to load this library manually. We will do this by editing a file
**at the root of your home directory(e.g., /home/user1234/)** called
`.ocamlinit`. This file is automatically loaded by `utop` on startup. Open this
file in an editor and add a line containing `#load "str.cma";;`.
Compiled ocaml modules have the extension `cma` and there are some number
of default locations that ocaml will look for compiled ocaml modules. So,
adding `#load "str.cma";;` to `~/.ocamlinit` (`~` is a kind of macro that
means "my home directory") instructs `utop` to look for the `Str` module
and load it on start up.

Let's look more at using inductively defined types to represent expressions
The file `lab2/arithExp.ml` contains type declarations related to
representing airthmetic expressions over floating point numbers, and
parsing their representation from *Reverse Polish Notation* strings.

>_Aside: Reverse Polish what now?_
>
>An expression in RPN uses postfix operators, so "a b +" is the sum of
>"a" and "b", "a b *" is the product, and so on.  Values in the
>expression can be thought of as accumulating on a stack, and each
>arithmetic operation pops its argument(s) from the stack and pushes the result.
>Well-formed expressions result in exactly one value.  This has the
>interesting property that parentheses are never needed to express the
>order of operations.

The function `token_list` converts a string into a list of
`arithToken`s, and will result in a run-time error if the string
contains anything that is not `"+"`, `"*"`, `"-"` (for unary negation),
or a floating point number.  The function `rpnParse` interprets a list
of tokens as an RPN expression and attempts to build an arithExpr that
corresponds to this expression: notice that the nested `parser`
function uses an `arithExpr list` to keep track of the expression
stack and uses matching to "pop" values off the stack.  Finally, the
function `arithExpEval` evaluates an `arithExpr` and returns the
floating point value.  So to evaluate a string `s` as an RPN arithmetic
expression, we would call `arithExpEval (rpnParse (token_list s))`.

### Testing it out

At the bottom of the file, add declarations for two `arithExpr`
values, `e1` and `e2`.  The first should correspond to the (usual, infix) expression
`1.414 + (3.14 * 2)` and the second can correspond to an expression of
your choosing.  Then add two strings that represent these expressions
in RPN.  You can `#use` the file in `utop` and check whether the composition
`rpnParse` and `token_list` computes the same `arithExpr` values from
these strings.

### Extending the code

Now let's extend the code to add division to the calculator, so for
example the string `"1 2 /"` will evaluate to `0.5`.  We'll need to:

+ Add a new null-ary value constructor `DIV` to the type `arithToken` to
  represent the division operator.

+ Extend the `tokens` helper function in `token_list` to recognize the
  division operator in a string.

+ Extend the `arithExpr` type with a new value constructor, `DivExpr` that holds
  a pair of `arithExpr`s.

+ Extend the `parser` helper function in `rpnParse` to handle the
  division token.  (This will look a lot like the cases for `PLUS` and
  `TIMES`, but needs a little care because of the order of elements on
  the stack...)

+ Extend the `arithExpEval` function to handle values constructed
  using the new variant for division expressions.

The gitbot will check that:

+ `e1` is correct
+ `e2` has type ArithExpr
+ `DIV` is a valid constructor for `arithToken`
+ `token_list "/"` evaluates to `[DIV]`
+ `DivExpr` is a valid two-argument constructor for `arithExpr`
+ `rpnParse [CONST 1.; CONST 2.; DIV]` evaluates to `DivExpr (ConstExpr 1., ConstExpr 2.)`
+ `arithExpEval (DivExpr (ConstExpr 1., ConstExpr 2.))` evaluates to `0.5`
+ `arithExpEval (rpnParse (token_list "3 4 / 8 *"))` evaluates to `6.0`


_**Test Cases:**_  To get full credit for problem 3 your solution should pass at least 13/16 of the example evaluations.
