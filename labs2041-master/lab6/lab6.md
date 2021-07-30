# Lab Problem Set 6: Lazy Evaluation

*CSci 2041: Advanced Programming Principles, Summer 2021*

**Due:** Friday, July 16 at 11:59pm (CST)

In your local copy of the public 'labs2041' repository, do a `git pull` to grab the files for this week's lab exercises.  Then let's get started!

# 1. Evaluations in _`lazyCaml`_

Copy the file `lab6/lazy_eval.md` into your personal `lab6` directory, where you will record your answers for this question.

Consider the following _`lazyCaml`_ definitions:

```ocaml
let rec squares n = (n*n)::(squares (n+1))

let factorials () =
  let rec fac_acc n a = n*a :: (fac_acc (n+1) (n*a)) in
  fac_acc 1 1

let rec fold_right f lst init = match lst with
   | [] -> init
   | (h::t) -> f h (fold_right f t init)

let rec map f lst = match lst with
  | [] -> []
  | (h::t) -> (f h)::(map f t)

let rec sum_list lst = match lst with
  | [] -> 0
  | (h::t) -> h + (sum_list t)
```

Using these definitions, consider the following expressions.  For each
expression, state whether the expression evaluates to a normal form in
a finite number of steps (Normal Form), or the expression will never reach a normal
form (Never) under lazy evaluation.  For those expressions that will reach a
normal form, give the resulting value on the following line.  You should attempt to
explain your reasoning on the following line.

1. `take 2 (squares 3)`

2. `fold_right (&&) (map ((<) 0) (squares 2)) true`

3. `fold_right (||)  (map (fun n -> n mod 3 = 0) (factorials ())) false`

4. `take (sum_list (squares 1)) (factorials ())`

5. `take 1 (reverse (squares 2))`

6. `fold_right (+) (take 1 (factorials ())) 0`

7. `(fun x -> if false then x else ()) (flip 0 0)`

Your solution should match the following format:

```
1. `take 2 (squares 3)`
Normal Form
[9; 16]

```

#### _Test Cases:_

In order to receive full credit for this problem, your solution should have the correct "Normal Form / Never" result and the corresponding Normal Form value for at least 4/7 cases.

# 2. MOAR Lazy Evaluation

Consider the following function definitions, in _`lazyCaml`_ (same
syntax as OCaml, but using lazy evaluation):

```ocaml
type 'a tree = Leaf of 'a | EmptyT | Node of 'a tree * 'a tree

let rec crazytree n v = if n = 0 then (Leaf v) else
        Node(crazytree (n-1) ("a"^v), crazytree n ("buffalo"^v))

let rec treefind t v = match t with
| EmptyT -> false
| Leaf v' -> v'=v
| Node(l,r) -> (treefind l v) || (treefind r v)

let rec eqtree t1 t2 = match (t1,t2) with
| (EmptyT,EmptyT) -> true
| (Leaf v1, Leaf v2) -> v1=v2
| (Node (l1,r1), Node (l2,r2)) -> (eqtree r1 r2) && (eqtree l1 l2)
| _ -> false
```

The file `lazytreeval.md` contains four _`lazyCaml`_ expressions using these
definitions.  For each expression, state whether the expression evaluates to a
normal form in a finite number of steps (Normal Form), or the expression will
never reach a normal form (Never) under lazy evaluation.  For those expressions
that will reach a normal form, give the resulting value on the following line.
You should attempt to explain your reasoning on the following line.

#### _Test Cases_  

To get full credit for problem 2 your solution should earn at least 3/4 points.

# 3. Streams

The file `lab6/streams.ml` contains definitions for the `'a stream` data type we discussed in class, which allows us to simulate the infinite objects supported by _`lazyCaml`_ with eager evaluation.  Fill in the definitions for the following functions:

### `map_s`

The function `map_s` takes a function `f : 'a -> 'b` and a `'a stream` as input and returns the `'b stream` that results from applying `f` to every element of its input stream.  Some examples evaluations:

+ `take_s 5 (map_s (fun n -> 2*n+1) (nats 0))` should evaluate to `[1; 3; 5; 7; 9]`

+ `take_s 2 (map_s String.uppercase_ascii (repeating "wow"))` should evaluate to `["WOW"; "WOW"]`

### `odds_s`

The function `odds_s` takes a `'a stream` and returns the elements at odd indices in the string,
so if `take_s 6 s = [a0; a1; a2; a3; a4; a5]` then `take_s 3 (odds_s s) = [a1; a3; a5]`.  Some example evaluations:

+ `take_s 3 (odds_s factorials)` should evaluate to `[2; 24; 720]`  (note that the element at index `i` of `factorials` is in fact (`i+1`)!).

+ `take_s 4 (odds_s fibs)` should evaluate to `[1; 2; 5; 13]`.

### `natpairs_s`
The stream generator `natpairs : int*int -> (int * int) stream` should output
all possible pairs of positive integers when initialized with `(0,0)`.  Your
function should generate the pairs in "diagonal" order, by listing in order of
increasing first component all the pairs that sum to 1, then all the pairs that
sum to 2, then 3, then 4, and so on.  Some example evaluations:

+ `take_s 10 (natpairs (0,0))` evaluates to `[(0, 0); (0, 1); (1, 0); (0, 2); (1, 1); (2, 0);
(0, 3); (1, 2); (2, 1); (3, 0)]`;

+ `take_s 4 (natpairs (4,5))` should evaluate to `[(4, 5); (5, 4); (6, 3); (7, 2)]`.

### Palindrome stream

A _palindrome_ is a string that reads the same backwards and forwards, such as
"tacocat" or "madamimadam" or "amanaplanacanalpanama".  (Or more boringly, "b",
"bb", "aba", "dad")  In this problem, we'll write a `string stream` generator
that lists all of the palindromes that can be created by appending together 0 or
more strings from a pair of words

+ Start by adding a definition for the function `pal_check : string -> bool`
  that checks whether its argument is a palindrome to `streams.ml`.  Your
  implementation should be case-insensitive. Some example evaluations:

  + `(pal_check "Abba") && (pal_check "dAD") && (pal_check "") && (pal_check "raceCar")`  should
  evaluate to `true`; and

  + `(pal_check "abc") || (pal_check "aB") || (pal_check "nomnomcookies")` should evaluate to `false`.

+ Next add the OCaml definition for the function `bstrings_s : string -> string -> string stream` which generates a stream of all strings that can be generated by repeated concatenation of the first or second argument, in ascending order of length.  Some example evaluations:

    + `take_s 3 (bstrings_s "a" "b")` should evaluate to `[""; "a"; "b"]`

    + `take_s 7 (bstrings_s "foo" "bar")` should evaluate to `[""; "foo"; "bar"; "foofoo"; "foobar"; "barfoo"; "barbar"]`

+ Finally, use an appropriate higher-order stream function to create
  the stream generator `palindromes : string -> string -> string stream`
  that takes two strings and returns a stream with all of the palindromes that can be created by concatenating 0 or more copies of the input strings together. Some example evaluations:

      + `take_s 3 (palindromes "Race" "Car")` should evaluate to `[""; "RaceCar"; "RaceCarRaceCar"]`

      + `take_s 4 (palindromes "Mad" "Dame")` should evalute to `[""; "DameMad"; "DameMadDameMad"; "DameMadDameMadDameMad"]`

#### _Test Cases:_

One for each example evaluation above. In order to receive full credit, your solution should pass 6/12 cases.

# 4.  Lazy lists

The file `lazylist.ml` contains the  definition of a "lazy list" data structure and functions using OCaml's `Lazy` module.  Let's repeat all of the stream functions we defined above using lazy lists instead:

+ `lzmap : ('a -> 'b) -> 'a lzlist -> 'b lzlist` applies its first argument to every element in its second argument (lazily).  Some additional test cases:

    + `lztake 4 (lzmap (fun n -> 3*n) (lznats 0))` should evaluate to `[0;3;6;9]`

    + `lztake 3 (lzmap (fun s -> s^"!") (lzrepeat "yass"))` should evaluate to `["yass!"; "yass!"; "yass!"]`

+ The function `lz_odds : 'a lzlist -> 'a lzlist` that returns the elements in odd-numbered positions of a lazy list, so if `(lztake 6 ll) = [ a0; a1; a2; a3; a4; a5 ]` then `(lztake 3 (lz_odds ll)) = [ a1; a3; a5 ]`  Additional examples:

    + `lztake 4 (lz_odds (lzmerge lzfibs lzfact))` should evaluate to `[1; 2; 6; 24]`

    + `lztake 3 (lz_odds (lznats 0))` should evaluate to `[1; 3; 5]`

+ In `lazylist.ml`, the function `lz_natpairs` should have type `(int*int) -> (int*int) lzlist` and some example evaluations should include:

    + `lztake 3 (lz_natpairs (12,1))` should evaluate to `[(12, 1); (13, 0); (0, 14)]`.

    + `lztake 4 (lz_natpairs (100,99))` should evaluate to `[(100,99); (101, 98); (102, 97); (103, 96)]`

+ Copy `pal_check` from `streams.ml`.

+ Give a definition for the function `lz_bstrings: string -> string ->
  string lzlist`, which generates a lazy list of all strings that can be
  created by repeated concatenation of `a` or `b`.  Example evaluations:

    + `(lztake 7 (lz_bstrings "0" "1"))` should evaluate to `[""; "0"; "1"; "00"; "01"; "10"; "11"]`

    + `(lztake 6 (lz_bstrings "aa" "b"))` should evaluate to `["";"aa";"b";"aaaa";"aab";"baa"]`.

+ Give a definition of `lz_palindromes : string -> string -> string lzlist` as above.  Example evaluations:

    + `lztake 5 (lz_palindromes "dad" "dad")` should evaluate to `[""; "dad"; "dad"; "daddad"; "daddad"]`

    + `lztake 4 (lz_palindromes "o" "so")` should evaluate `[""; "o"; "oo"; "oso"]`


#### _Test Cases:_

One for each example evaluation given above.  Your solution must pass 6/10 test cases to get full credit for this problem.
