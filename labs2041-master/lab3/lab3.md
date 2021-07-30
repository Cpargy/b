# Lab Problem Set 3: Higher-Order Functions in OCaml

*CSci 2041: Advanced Programming Principles, Summer 2021*

**Due:** Friday, June 25 at 11:59pm (CST)

In your local copy of the public 'labs2041' repository, do a `git pull` to grab the files for this week's lab exercises.  Then let's get started practicing with higher-order functions!

# 1. Functions and arguments

Create a file name `hof.ml` in the `lab3` directory to hold your solutions to this problem.

### `drop_until`

Provide a definition for the function `drop_until : ('a -> bool) -> ('a list) -> ('a list)` which drops elements from the beginning of a list that do not make its first argument true.  Some example evaluations:

+ `drop_until (fun _ -> true) []` should evaluate to `[]`.

+ `drop_until (fun _ -> true) [1]` should evaluate to `[1]`

+ `drop_until (fun s -> s.[0]='a') ["boring"; "as"; "always"]` should evaluate to `["as"; "always"]`

### `take_while`

Provide a definition for the function `take_while : ('a -> bool) -> 'a list -> 'a list` that returns the prefix list of its second argument such that all elements satisfy its first argument.  Some example evaluations:

+ `take_while (fun _ -> true) [1; 2; 3]` should evaluate to `[1; 2; 3]`.

+ `take_while ((=) "a") ["a"; "a"; "b"; "a"]` should evaluate to `["a"; "a"]`.

+ `take_while (fun _ -> false) ["say"; "anything"]` should evaluate to `[]`

### `take_until`

Provide a definition for the function `take_until : ('a -> bool) -> 'a list -> 'a list` that returns the prefix list of its second argument such that all elements do not satisfy its first argument.  Some example evaluations:

+ `take_until (fun _ -> false) [1; 2; 3]` should evaluate to `[1; 2; 3]`.

+ `take_until ((<>) "a") ["a"; "a"; "b"; "a"]` should evaluate to `["a"; "a"]`.

+ `take_until (fun _ -> true) ["say"; "anything"]` should evaluate to `[]`

#### Test cases

Your solution must compile and agree on 6/9 example evaluations given above to get full credit for this question.

# 2. Continuations

In Video 3.2, we saw that continuations can be used to make non-tail-recursive functions tail recursive (although a chain of continuations is still constructed in continuation-passing style, this chain doesn't reside on the system call stack).  Let's apply this technique to some familiar functions that aren't tail-recursive in the standard formulation. Copy the file `lab3/cps_functions.ml` from the public repository to your personal repository and fill in these
functions:

### `length_k`

`length_k : 'a list -> (int -> 'b) -> 'b` should compute the length of a list in continuation-passing style.  Some example evaluations:

+ `length_k [] (fun n -> n)` should evaluate to `0`

+ `length_k ["1"; "2"; "3"] (fun n -> [n])` should evaluate to `[3]`

+ `length_k [0; 0; 0; 0] string_of_int` should evaluate to `"4"`

### `find_all_k`

Recall that `find_all p ls` returns the list of all elements `e` of `ls` such `p e` evaluates to `true`.  Write the CPS version `find_all_k : ('a -> bool) -> 'a list -> ('a list -> 'b) -> 'b`.  Some example evaluations:

+ `find_all_k (fun _ -> true) [] (fun x -> x)` should evaluate to `[]`

+ `find_all_k ((=) 0) [0; 2; 0] List.length` should evaluate to `2`

+ `find_all_k ((<) 5) [6; 8; 2; 1] (fun x-> x)` should evaluate to `[6; 8]`

### `postorder_k`

The post-order enumeration of a binary tree lists the post-order enumeration of the left subtree, followed by the post-order enumeration of the right subtree, followed by the element at the root.  Write the CPS version `postorder_k : 'a btree -> ('a list -> 'b) -> 'b`.  Some example evaluations:

+ `postorder_k (Node (3, Node(1,Empty,Empty), Node(42, Empty, Empty))) (fun x -> x)` should evaluate to `[1;42;3]`.

+ `postorder_k (Node (3, Empty, Empty)) (fun x -> x)` should evaluate to `[3]`.

+ `postorder_k Empty (fun _ -> "nyet")` should evaluate to `"nyet"`.

### `flip_tree_k`

The *flip* of a binary tree recursive swaps the left branch and the right branch of the tree at all levels, so the flip of `Node (10, Node (2, Node (5,Empty, Empty), Empty), Empty)` is the tree `Node (10, Empty, Node (2, Empty, Node (5, Empty, Empty)))`.  Write the CPS version `flip_tree_k : 'a btree -> ('a btree -> 'b) -> 'b`.  Some example evaluations:

+ `flip_tree_k Empty (fun x->x)` should evaluate to `Empty`

+ `flip_tree_k (Node ("root", Node("left", Empty, Empty), Node ("right", Empty, Node ("rr", Empty, Empty)))) (fun x -> x)` should evaluate to `Node ("root", Node ("right", Node ("rr", Empty, Empty), Empty), Node ("left", Empty, Empty))`

+ `flip_tree_k (Node ("root", Empty, Empty)) (fun _ -> "treebeard")` should evaluate to `"treebeard"`.

#### _Test Cases:_  

To get full credit for problem 3 your solution should pass at least 9/12 of the example evaluations.

# 3.  Filters and maps

Create a file name `maps_and_filters.ml` in the `lab3` directory within your personal repo to hold your solutions to this problem.  Each problem can be solved by a single call to `List.map` or `List.filter`.

### `fixduck`

Find all instances of `"goose"` in a `string list` and replace them with the right-thinking `"grey duck"`; for any other string but `"duck"`, append `" duck"`. Example evaluations: `fixduck ["duck"; "duck"; "goose"]` should evaluate to `["duck"; "duck"; "grey duck"]` and `fixduck ["purple"; "blue"; "duck"]` should evaluate to `["purple duck"; "blue duck"; "duck"]`. (`fixduck ["gooseduck"]` should evaluate to `["gooseduck duck"]`.)

### `hex_list`

Convert a list of integers into their hexadecimal string representations.  (Note: the most concise way to do this for a single string is with `(Printf.sprintf "%X")`.)  Examples: `hex_list [10]`  should evaluate to `["A"]` and `hex_list [19; 10; 31137]` should evaluate to `["13"; "A"; "79A1"]`.

### `de_parenthesize`

Remove all `'('` and `')'` chars from a char list. Examples: `de_parenthesize ['('; 'c'; 'a'; 'r'; ' '; '('; 'c'; 'd'; 'r'; ' '; 'l'; ')'; ')']` should evaluate to `['c'; 'a'; 'r'; ' '; 'c'; 'd'; 'r'; ' '; 'l']` and `de_parenthesize [':';'-'; ')']` should evaluate to `[':'; '-']`.

### `p_hack`

Given a list of `float*string` pairs, keep only pairs where the first element is less than `0.05`.  Example evaluations: `p_hack [(0.04, "Red meat vs cancer"); (0.1, "Internet vs cancer")]` should evaluate to `[(0.04, "Red meat vs cancer")]`, and `p_hack [(0.2, "random study"); (0.3, "random study 2"); (0.25, "random study 3"); (0.049, "random study 4")]` should evaluate to `[(0.049, "random study 4")]`.


#### _Test cases_

In order to receive full credit for this problem, your solution should agree with the example evaluations on at least 7/9 cases, and the file must not include a single `let rec` declaration.

# 4. Folds, Reductions, and beyond

Each of the following functions can be implemented by a single call to List.fold_left or List.fold_right.  In a file named `folds.ml`, give implementations of:

### `rank`

`rank : 'a -> 'a list -> int` counts the number of items less than its first argument in its second argument, e.g. `rank 2 [1;3]` should evaluate to `1`, `rank "a" []` should evaluate to `0`, and `rank 3.14 [0.; 1.; 2.71828; 6.022e23]` should evaluate to `3`.

### `prefixes`

`prefixes : 'a list -> 'a list list` should return a list of all prefixes of the input list, e.g. `prefixes [1; 2]` should evaluate to `[[1;2]; [1]; []]`, and `prefixes ["a";"b";"c"]` should evaluate to `[["a"; "b"; "c"]; ["a";"b"]; ["a"]; []]`.

### `suffixes`

`suffixes : 'a list  -> 'a list list` should return a list of all suffixes of the input list, e.g. `suffixes [1; 2]` should evaluate to `[[1;2]; [2]; []]`, and `suffixes ["a"]` should evaluate to `[["a"]; []]`.


##  Using and choosing List HOFs

Create a file named 'hoflist.ml' in your `lab3` folder to record your solutions to the problems in this section.

### Single-call implementations

Each of the following functions can be implemented via a single
call to one of our known higher-order list functions.  Give the
single-call implementation of each:

+ `implode : char list -> string` takes a list of characters and
  squashes them into a string.  (Note: `String.make 1 c` makes a
  single-character string out of character `c`)  Example evaluations: `implode ['a'; ' '; 'f'; 'i'; 'n'; 'e'; ' '; 'm'; 'e'; 's'; 's']` should evaluate to `"a fine mess"`.

+ `onlySomes : 'a option list -> 'a option list` removes all of the
  `None` variants from a list of `'a option` values.  `onlySomes [Some 1; None]` should evaluate to `[Some 1]` and `onlySomes []` should evaluate to `[]`.

### Double trouble

The following functions can be implemented by calling a list HOF on the output of another list HOF.  Give such implementations for each of them:

+ `isPrime : int -> bool` the integer `n` is prime if for every `i` between `2` and `n/2`, `n mod i <> 0`.  Some example evaluations: `isPrime 7` should evaluate to `true` and `isPrime 8` should evaluate to `false`.  (You might find `List.init` useful for this problem)

+ `deOption : 'a option list -> 'a list` removes all of the `None` constructors from a list of `'a option` values, and returns the arguments of the `Some` constructors, so `deOption [Some 1; None; Some 3]` should evaluate to `[1;3]` and `deOption [None; None]` should evaluate to `[]`.


#### _Test Cases_  

To get full credit for problem 4 your solution should pass at least 8/13 of the example evaluations, and must not contain a single `let rec` binding.
