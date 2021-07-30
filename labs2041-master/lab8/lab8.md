# Lab 8: Mutable Data Structures in OCaml

*CSci 2041: Advanced Programming Principles, Summer 2021*

**Due:** ***THURSDAY***, July 29 at 11:59pm (CDT)

In your local copy of the public `labs2041` repository, do a `git pull` to grab the files for this week's lab exercises.  Then let's get started!

# 1. References x2

### Memoization

In the file `memo.ml`, two functions based on linear recurrences similar to the fibonacci sequence are defined, `pell` and `alt4`.  Using the same technique as discussed in Video 8.1 for `memofib`, use a reference to an associative list to produce "fully" memoized functions `memopell` and `memoalt4`.  We will test the memoization with the following evaluations with a 1-second timeout:

+ `memopell 40` should evaluate to `723573111879672`
+ `memopell 45` should evaluate to `59341817924539925`
+ `memoalt4 43` should evaluate to `33046005485`
+ `memoalt4 53` should evaluate to `4414256426351`
+ `(memopell 40) + 2*(memopell 41)` should evaluate to `(memopell 42)`

### Cycles

In chapter 7.2, Hickey discusses the use of references to create cyclical data structures, such as doubly-linked lists.  We can also make cyclic singly-linked lists using references; the file `clist.ml` defines the type `'a clist`, and the function `clist_of_list : 'a list -> 'a clist`.  Let's define two functions that manipulate clists:

+ `make_cyclic : 'a clist -> unit` should take as input a `clist` `ls` and induce a cycle by assigning the tail of the last `CCons` to be `ls` instead.  Some example evaluations:

    * `let cl1 = CCons("oroboros", ref Nil) in make_cyclic cl1; (ctl cl1) == cl1` should evaluate to `true`
    * `let cl2 = CCons(8, ref (CCons(17, ref Nil))) in make_cyclic cl2; (ctl cl2) == cl2` should evaluate to `false`
    * `let cl2 = CCons(8, ref (CCons(17, ref Nil))) in make_cyclic cl2; (ctl (ctl cl2)) == cl2` should evaluate to `true`


+ `findcycle : 'a clist -> bool` should return true if its argument contains a cycle, and false otherwise.  This can be implemented by what is called the "tortoise and hare" algorithm: We keep track of two list elements, the "tortoise" and the "hare."  At each step, we check (1) if the tortoise is the *same* (`==`) list element as the hare, in which case we have found a cycle, or (2) if the hare is Nil (then there's no cycle) OR the hare's tail dereferences to Nil.  (then there's also no cycle).  If neither condition is true, the tortoise steps one link forward in the list, and the hare steps two links forward, and we repeat the algorihtm.  This algorithm is guaranteed to discover a cycle in linear time in the length of the cycle, or terminate after the hare has traversed the entire list.  Some example evaluations:

    * `findcycle (clist_of_list [1;2;3;4;5])` should evaluate to `false`
    * `let cl = (clist_of_list [1;2;3;4;5]) in make_cyclic cl; findcycle cl` should evaluate to `true`

#### _Test cases_

In order to receive full credit for this problem, your solution should agree with the example evaluations on at least 6/10 cases.

# 2. Mutable list functions

Here's a definition using records for the type `'a mlist`, an OCaml version of the standard mutable linked list data type, which is also in the file `mlist.ml`:
```
type 'a ll = { mutable hd : 'a ; mutable tl : 'a mlist}
 and 'a mlist = List of 'a ll | Nil
```
Let's write some functions in `mlist.ml` to handle mutable linked lists:

+ `mlist_of_list : 'a list -> 'a mlist` takes an immutable list as an argument and returns a mutable list with the same contents, so
    * `mlist_of_list []` should evaluate to `Nil`

    * `mlist_of_list [1;2;3]` should evaluate to
      `List {hd = 1; tl = List {hd = 2; tl = List {hd = 3; tl = Nil}}}`

+ `rev_mlst : 'a mlist -> 'a mlist` should destructively reverse its argument, so that the returned list uses the same cells as the input list, and:

    * `rev_mlist Nil` should evaluate to `Nil`

    * `rev_mlist (List {hd = 1; tl = List {hd = 2; tl = Nil}})` should evaluate to `List {hd = 2; tl = List {hd = 1; tl = Nil}}`

+ `append_m : 'a mlist -> 'a mlist -> 'a mlist` should destructively append its second argument to the end of its first argument and return the result, so

    * `append_m (List {hd = "grilled"; tl = List {hd = "corn"; tl = Nil}})
      (List {hd = "onthecob"; tl = Nil})` should evaluate to
      `List {hd = "grilled"; tl = List {hd = "corn"; tl = List {hd = "onthecob"; tl= Nil}}}`

    * ```ocaml
      let l1 = List {hd = 1; tl = Nil} in
      let l2 = append_m l1 (List {hd = 2; tl = Nil}) in l1 = l2
      ```
      should evaluate to `true`

+ `insert_after_m : 'a -> 'a -> 'a mlist -> unit`: this function
performs a destructive update to its `mlist` argument: `insert_after_m
a b ml` should modify ml so that the value `b` appears after the
first instance of `a` in `ml`.  For example:

  ```ocaml
  # let m1 = mlist_of_list [2;3;5;11] ;;
  val m1 : int mlist = List {hd = 2; tl = List {hd = 3; tl = List {hd = 5; tl = List {hd = 11; tl = Nil}}}}
  # insert_after_m 5 7 m1;;
  - : unit = ()
  # list_of_mlist m1 ;;
  - : int list = [2; 3; 5; 7; 11]
  ```

`insert_after_m` should raise `Not_found` if no instance of `b` is
encountered.

+ `exclude_m : ('a -> bool) -> 'a mlist -> 'a mlist`: this function
destructively updates an mlist; `exclude_m p ml` should return a list that
excludes all elements of `ml` that satisfy the predicate `p`.  For example:

```ocaml
# let m2 = mlist_of_list [1;2;3;4;5;6;7;8;9;10] ;;
# exclude_m (fun x -> x mod 2 = 0) m2 ;;
- : int mlist = List {hd = 1; tl = List {hd = 3; tl = List {hd = 5; tl = List {hd = 7; tl = List {hd = 9; tl = Nil}}}}}
# list_of_mlist m2 ;;
- : int list = [1; 3; 5; 7; 9]
# exclude_m (fun x -> x mod 3 = 1) m2 ;;
- : int mlist = List {hd = 3; tl = List {hd = 5; tl = List {hd = 9; tl = Nil}}}                                                                                            
# list_of_mlist m2 ;;
- : int list = [1; 3; 5; 9]
```

(Notice that only elements after the first element that does not satisfy `p`
are permanently removed from the list.  Why?  How could we change the
interface to `exclude_m` to prevent this problem?)

#### _Test Cases:_

In order to receive full credit, your solutions to this problem should agree on at least 7/12 of the feedback cases.

# 3. Array functions

### List functions

Let's write some of our favorite `List` functions for `Array`s in the file `list_arr.ml`:

+ `rev_array : 'a array -> unit` should reverse an array in place, so the result of

    * `let a = [|1; 2; 3 |] in rev_array a; a` should be `[|3; 2; 1|]`, and

    * `let b = [||] in rev_array b; b` should be `[||]` and

    * `let c = [|"pronto"; "pups"|] in rev_array c; c` should be `[|"pups"; "pronto"|]`

+ `zip_array : 'a array -> 'b array -> ('a*'b) array` should take two arrays of equal length, and zip them into
pairs, e.g.

    * `zip_array [|1;2|] [|"a";"b"|]` should evaluate to `[|(1, "a"); (2, "b")|]`

    * `zip_array [|true; false; true|] [|0;1;1|]` should evaluate to `[|(true, 0); (false, 1); (true, 1)|]`

### Array sets

At the end of Video 8.3, we discussed an implementation of sets of integers (in a bounded range) as arrays of bools.  We showed how to implement the `mem`, `add`, `fold_left`, `union`, and `inter` operations; These are all included in the file `aset.ml`, along with a few example sets. Let's define two additional operations for this representation:

+ `subset : bool array -> bool array -> bool` should return true if its first argument represents a subset of the second argument.  If the lengths of the arrays are not equal, subset should call `invalid_arg "subset"`. Some example evaluations:

    * `subset s1 s2` should evaluate to `true`
    * `subset s3 s2` should evaluate to `false`

+ `of_list : int -> int list -> bool array` should take a maximum int, a list of ints and return an array of bools representing all elements of the list (strictly) less than the maximum as a set.  Some example evaluations:

    * `of_list 4 [1;3;5]` should evaluate to `[|false;true;false;true|]`
    * `of_list 6 []` should evaluate to `[|false;false;false;false;false;false|]`


#### _Test Cases_  

To get full credit for problem 3 your solution should earn at least 7/9 points.

# 4. (ALMOST) FREE POINTS!

In your `lab8` directory, edit the file named `answers.md` to record your answers to the following three questions as a markdown list:

1. What was your favorite topic we covered this semester?
2. What was your least favorite lab problem, and how do you think it could be improved?
3. What did you think about the midterm?  Was it interesting?  Would you rather have more, slightly shorter projects?

Then do a happy dance, you're done with CSci 2041 labs!
