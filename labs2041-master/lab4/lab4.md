# Lab Problem Set 4: Exceptions, IO, Modules and Functors

*CSci 2041: Advanced Programming Principles, Summer 2021*

**Due:** Friday, July 2 at 11:59pm (CST)

In your local copy of the public 'labs2041' repository, do a `git pull` to grab the files for this week's lab exercises.  Then let's get started practicing with higher-order functions!

# 1.  Exceptions

In the public repo for this exercise you will find a file named `exn.ml` where your solutions can be recorded.

### Raising and handling exceptions

First let's start by writing some code to declare, raise, and handle exceptions. At the top of `exn.ml`, add a declaration for a new `exn` constructor called `Reflect` that can be applied to a value of type `int`.  Then complete the definition of the function `reflector : int -> 'a`, which always raises a `Reflect` applied to its argument.  Finally, complete the definition of the function `catcher : ('a -> int) -> 'a -> int`, so that `catcher r x` applies `r` to `x`, and handles the exception `Reflect y` by returning `y`.  Here are the tests we will apply:

+ `(Reflect 1)` should have type `exn`
+ `try (reflector 0) with Reflect 0 -> true` should evaluate to `true`
+ `catcher reflector 17` should evaluate to `17`

### Converting to options

Several functions in the OCaml standard library have two versions: a standard version that can raise an exception when called with certain inputs, and an `_opt` version that instead returns a `Some` constructor on is results, or `None` for inputs that can result in the exception.  So for instance, `List.assoc k l` raises `Not_found` when no input associated with `k` is found, whereas `List.assoc_opt` returns `None`; and `List.hd l` returns the head of list `l` when it is not empty and raises `Failure "hd"` otherwise, whereas `List.hd_opt l` returns `None` if its argument is `[]`.  Complete the definition of a generic "option converter" `make_opt : ('a -> 'b) -> exn -> 'a -> 'b option` so that `make_opt f e` returns a function that evaluates to `Some (f y)` unless the expection `e` is raised, in which case it evaluates to `None`.  Some example evaluations:

+ `(make_opt List.hd (Failure "hd")) []` should evaluate to `None`
+ `(make_opt List.hd (Failure "hd")) [1]` should evaluate to `Some 1`
+ `let assoc_opt k = make_opt (List.assoc k) Not_found in assoc_opt 3 [(2,"a")]` should evaluate to `None`
+ `let assoc_opt k = make_opt (List.assoc k) Not_found in assoc_opt 3 [(3,"a")]` should evaluate to `Some "a"`

### Guarding substring cases

The `String.sub` function for extracting substrings can be tricky, because it expects a beginning index and a substring _length_ rather than an ending index.  So programmers can either forget and pass an index *or* make an off-by-one error, in either case potentially asking for a substring that runs past the end of the string, and causing an `Invalid_argument` exception to be raised.  Let's write a "safe" version `safe_substr : string -> int -> int -> string` that optimistically calls `String.sub` with its arguments, but then handles a potential `Invalid_argument` exception by reducing the substring length so that it doesn't run past the end of the string.  Some example evaluations:

+ `safe_substr "abc" 1 1` should evaluate to `"b"`.
+ `safe_substr "abc" 1 15` should evaluate to `"bc"`.
+ `safe_substr "ab" (-1) 1` should still raise an `Invalid_argument` exception.

### Shortcut evaluation

Another potential use of exceptions is in case a "normal" return from a function would require a large amount of unnecessary work.  For instance, consider the following function:

```ocaml
let rec sorted_insert lst e = match lst with
| [] -> [e]
| h::t when h=e -> lst
| h::t -> if h > e then e::lst else h::(sorted_insert t e)
```

If the element `e` is already in the list but near the end, then this procedure builds another copy of the list for no good reason.  We could check whether `e` was in the list before building the list, but that would require twice as much work when `e` was not in the list.  An alternative is to raise the built-in but unused `Exit` exception to signal that the original list should be returned:

```ocaml
let sorted_insert lst e =
  let rec worker = function [] -> [e]
  | h::t when h=e -> raise Exit
  | h::t as ls -> if h > e then e::ls else h::(worker t)
  in try (worker lst) with Exit -> lst
```

The function `List.remove_assoc : 'a -> ('a*'b) list -> ('a * 'b) list` removes the value (if any) associated with its first argument in the associative list that is its second argument.  It has a similar problem (reaching the end of the list means copying the entire original list).  In `exn.ml`, fill in the function `rm_assoc_exit` so that the `rm_assoc` function behaves the same as `remove_assoc`.  Some example evaluations:

+ `rm_assoc_exit 3 [(2,"v1"); (3,"v2")]` should evaluate to `[(2,"v1")]`
+ `rm_assoc_exit 3 [(3,"v")]` should evaluate to `[]`
+ `rm_assoc_exit 2 [(3,"v")]` should raise `Exit`
+ `rm_assoc 2 [(3,"v")]` should evaluate to `[(3,"v")]`  

#### _Test cases_

In order to receive full credit for this problem, your solution should agree with the example evaluations on at least 9/14 cases.

# 2. Writing and reading files

Your answers for this exercise should be recorded in a file named `io.ml` in the `lab4` folder.

## uncomment

In a python program, any thing after the first `#` character on a line is in a comment, so it doesn't affect the behavior of the program.  Write a function `uncomment : string -> string list` such that `uncomment f1` opens the file named `f1` and evaluates to a list of all of the lines of `f1` with any commented portions removed.  There are three example files `short1.py`, `short2.py`, and `short3.py` in the `lab4` directory of the public repo.  If you copy them to the directory in which you are running `utop`, then:

+ `uncomment "short1.py"` should evaluate to `[""; "print(\"hello world!\") "; "x = 4*3"]`
+ `uncomment "short2.py"` should evaluate to `[""; ""; "x = 4*3"]`
+ `uncomment "short3.py"` should evaluate to `["print(\"hello world!\") "; "x = 4*3\\"; "  * 7"]`

## tabulate

Write a function `tabulate : (float*float) list -> string -> unit` that takes as input a list of `float`s, and a file name, and writes the elements of the list to a file.  Each pair should be in scientific notation, with two digits of precision, separated by a comma and one space, and followed by a newline, except for the last pair.  So for example:

+ `tabulate [] "out1.txt"` should produce an empty file
+ `tabulate [(1.2313,12324.2)] "out2.txt"` should produce a file like :
    ```
    1.23e+00,1.23e+04
    ```
+ `tabulate [(234.5, 678901.2); (0.00125,0.00000101)] "out3.txt"` should produce a file like:
    ```
    2.34e+02,6.79e+05
    1.25e-03,1.01e-06
    ```

#### _Test Cases:_

In order to receive full credit, your solutions to this problem should agree on at least 4/6 of the example cases.

# 3.  Module code

In this section, we'll develop some simple modules and functors, working in the file `modules.ml`  

### Stack module

In `modules.ml`, add a module `Stack` that defines a type `'a t = 'a list`; the functions `push : 'a -> 'a t -> 'a t`, `pop : 'a t -> 'a t`, and `top : 'a t -> 'a`; and the value `empty : 'a t`.   (`push` conses a new top onto the stack, `pop` returns the rest or `invalid_arg "pop"` on an empty stack; `top` returns the head or `invalid_arg "top"` on an empty stack; `empty` is `[]`).  There will be one test case for each item in the signature, and test evaluations for `Stack.pop (Stack.push "a" Stack.empty) = Stack.empty`, which should evaluate to `true`) and `Stack.top (Stack.push 17 Stack.empty)`, which should evaluate to `17`.

### `Nat`ural arithmetic

#### `Nat` module

Define a module `Nat` that defines the type `t = Zero | Next of t`, and provides

+ functions `to_int : Nat.t -> int`, `of_int : int -> Nat.t`,  defined by:

```ocaml
let rec to_int = function Zero -> 0 | Next n -> 1 + (to_int n)
let rec of_int = function 0 -> Zero | n -> Next (of_int (n-1))
```

+ The value `zero : Nat.t`, and
+ functions `incr : Nat.t -> Nat.t`, and `decr : Nat.t -> Nat.t` (Calling `Nat.decr Zero` should raise `Invalid_argument "decr"`, but this won't be a test case).  

Test cases:

+ `let x = Nat.zero in ((Nat.decr (Nat.incr x)) = x)` evaluates to `true`
+ `Nat.to_int (Nat.incr Nat.zero)` evaluates to `1`
+ `Nat.to_int (Nat.of_int 3)` evaluates to `3`.  

#### `NatSig` signature

Define a module signature `NatSig` that requires a type `t`, a value `zero : t` and the functions `incr : t -> t` and `decr : t -> t`.  Test cases will check for each of these belonging to the signature.


#### _Test cases_

In order to receive full credit for this problem, your solution should agree with the example evaluations on at least 9/14 cases.

# 4. Writing Functors

### DefaultDict

In this section, we'll look at dictionaries, data structures that map from keys of type `k` to values of type `v`.  The file `ddict.ml` give an associative list implementation of dictionaries, though they can also be implemented by hash tables or a binary search tree-based structure, as in the OCaml standard library's `Map.Make` functor.   In this exercise, we'll consider dictionaries that are parameterized in two additional aspects:

* the equality function that determines whether two keys are the same or not,

* the "default value" to return if a key is not present in the dictionary

The file `ddict.ml` contains some starting pieces: a signature `Elt` that will provide the key type, value type, and equality function, and a signature `Dict` that our functors will satisfy.

### EqListDict

Let's start by filling in the `EqListDict` functor, which has "kind" `functor(Elt) -> Dict`, that is, the functor should take a module satisfying `Elt` and create a module satisfying `Dict`:

+ The empty value is just `[] : k*v list`
+ The add function just conses its key and value arguments onto the front of the list
+ The lookup function should walk through the list, using the Elt module's `eq` function to compare keys, and return the value associated to the first key matching its key argument.  If no matching key is found, EqListDict should raise `Not_found`.

In order to use the resulting `dict` module, you will need to expose the types `k` and `v` in the functor signature.

+ Some example evaluations:

    * `let module DII = EqListDict(struct type k = int type v = int let eq = (=) end) in let d1 = DII.empty in let d2 = DII.add 2 17 d1 in DII.lookup 2 d2` should evaluate to `17`

    * `let module DSLI = EqListDict(struct type k = string type v = int let eq s1 s2 = String.length s1 = String.length s2 end) in let d = DSLI.add "aa" 42 DSLI.empty in DSLI.lookup "bb" d` should evaluate to `42`.

    * `let module NeverDict = EqListDict(struct type k = int type v = int let eq k1 k2 = false end) in let d = NeverDict.add 1 1 NeverDict.empty in NeverDict.lookup 1 d` should raise `Not_found`

### DefaultDict

Now make the `DefaultElt` signature, which just includes the `Elt` signature plus requires a `default` value of type `v`.  Write a functor, `DefaultDict` that acts on a module of type `DefaultEt`, and implements the `Dict` signature with appropriate sharing.  `DefaultDict` will look nearly identical to `EqListDict` except that where `EqListDict` raises `NotFound`, the new functor should return the default value in the DefaultElt module it received as input. Some example evaluations:

  * `let module M = DefaultDict(struct type k = int type v = int let default = -1 let eq = (=) end) in M.lookup 1 M.empty` should evaluate to `-1`.

  * `let module M = DefaultDict(struct type k = int type v = string let default = "" let eq = (=) end) in M.lookup 2 (M.add 2 "a" M.empty)` should evaluate to `"a"`.

  * `let module M = DefaultDict(struct type k = int type v = string let default = "" let eq = (=) end) in M.lookup 3 (M.add 2 "a" M.empty)` should evaluate to `""`.

### DefaultDictFunctor
Finally, let's make a functor that converts an arbitrary `Dict` into a `DefaultDict`: `DefaultDictFunctor` should act on a `DefaultElt` module and a `Dict` module.  `DefaultDictFunctor(E)(D)` should include `D`, and overwrite the `lookup` function by calling `D.lookup` in a `try...catch` wrapper that returns `E.default` with `Not_found` is raised.  Example evaluations:

  * `let module E = struct type k = int type v = int let default = (-1) let eq = (=) end in
     let module D = EqListDict(E) in let module DD = DefaultDictFunctor(E)(D) in
     DD.lookup 1 DD.empty` should evaluate to `-1`.

  * `let module E = struct type k = int type v = int let default = (-1) let eq _ _ = false end in
    let module D = EqListDict(E) in let module DD = DefaultDictFunctor(E)(D) in
    DD.lookup 1 (DD.add 1 3 DD.empty)` should evaluate to `-1`.

  * `let module E = struct type k = string type v = string let default = "" let eq s1 s2 = String.lowercase_ascii s1 = String.lowercase_ascii s2 end in
      let module D = EqListDict(E) in let module DD = DefaultDictFunctor(E)(D) in
      DD.lookup "A" (DD.add "a" "yo" DD.empty)` should evaluate to `"yo"`.


#### _Test Cases:_

In order to receive full credit, your solutions to this problem should agree on at least 6/9 of the example cases.
