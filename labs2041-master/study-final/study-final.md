# Study Final - CSci 2041

The questions listed here are similar in form, content and difficulty to those that will appear on the actual final.  If you feel confident in your solutions to these problems, you should be well-prepared for the course final exam.  (Note: there are around 3 times as many questions here as on the real exam.)

## Types and Values
For each of the following expressions, either indicate its type, or that it will cause a type error when compiled in OCaml. If the expression is well-typed, give the result of its evaluation – if the result is a functional value, give a brief explanation of what it does – and if the expression has a type error, explain the nature of the error.

1. `let rec swapper x y = not (swapper y x) in swapper 1.0`


2. ```ocaml
   let rec fail_rev acc = function
   | [] -> fail_rev [] acc
   | h::t -> fail_rev (h::acc) t
   ```

3. ```ocaml
    let rec irev = function
    | [] -> []
    | h::t -> (irev t)::h
    ```
    
4. ```ocaml
    let p = ref true in
    let notr q = p := p || q in (notr false)
    ```

4. ```ocaml
    let rec ts ft = function
    | [] -> ft
    | h::t -> ts (h +. ft) t
    ```

4. ```ocaml
    type 'a dlist = Nil | Link of 'a link
    and 'a link = { mutable prev : 'a dlist ; mutable next : 'a dlist; hd : 'a}
    let rec to_list_rev = function
    | Nil -> []
    | Link { hd ; next ; prev } -> (to_list_rev next) @ [hd]
    ```

4. `let a = ref [] in let z = a in z := [1;2] ; !a`

4. ```ocaml
    type 'a mpair = { fst : 'a; mutable snd : 'a}
    let o = { fst = 0; snd = '0'} in o.snd <- '3'
    ```

4. ```ocaml
    type ipair = { mutable fst : int ; mutable snd : int}
    let p = {fst = 1; snd = 2} in p.snd <- 3
    ```

4. ```ocaml
    type 'a stream = End | Cons of 'a * (unit -> 'a stream)
    let rec drop_s s n = match (s,n) with
    | (End,_) -> End
    | (_,0) -> s
    | (Cons(h,t),_) -> (drop_s (t ()) (n-1))
    ```

4. ```ocaml
    type 'a lzlist = Nil | Lz of 'a * 'a lzlist lazy_t
    let print_lz l = match l with
    | Nil -> ()
    | Lz(h,t) -> print_endline h ; print_lz t
    ```

4. `let f x = raise x; 4`

4. `try 1+2 with _ -> 3.0`

4. `let fc s = try Some(s.[0]) with _ -> None`

4. `[(Invalid_argument ""); (Failure ""); Stack_overflow]`

4. `List.fold_left (fun acc x -> (acc^x)) 3`

4. `List.exists (fun x -> x)`

4. `List.map string_of_float`

4. `let rec g p f b n = if (p n) then b else (f n (g p f b (n-1)))`

4. `let rec h k = if !k = 0 then 1 else (k := (!k/2) ; !k + (h k)) in h (ref 4)`

4. `32 || false`

4. `let k = ref [| |] in Array.length !k`

4. ```ocaml
    type pm = { name : string;  hp : int ; mutable lvl : int}
    let rec lvl_up npc = npc.lvl <- npc.lvl + 1
    ```

## Modules and Functors

Each of the following programs will fail to compile.  Explain why, and if possible, how to fix the problem:

1. ```ocaml
    module type At = sig
      val x : int
      val f : int -> int
    end

    module Af(X : At) : At = struct
      let x = X.x
      let f z = if z then (X.f x) else x
    end
    ```

1. ```ocaml
    module type Bt = sig
      type t
      val f : t -> t
    end

    module BB : Bt = struct
      type t = int list
      let f = List.rev t
    end

    let b = BB.f [1; 2; 3]
    ```

1. ```ocaml
    module type Ct = sig
      val c : float
    end

    module Cf(C : Ct) = struct
      let e m = m *. C.c *. C.c
    end

    module CC = Cf(struct let cc = 2.998e8 end)
    ```


The following questions are based on this code:

```ocaml
module type Set = sig
  type t
  type elt
  val empty : t
  val mem : elt -> t -> bool
  val add : elt -> t -> t
end

module type Elt = sig
  type elt
end

module FunSet(E : Elt) : Set = struct
  type elt = E.elt
  type t = elt -> bool
  let empty = fun _ -> false
  let mem x s = (s x)
  let add x s = fun e -> (e=x) || (s e)
end
```

1. The module declaration `module IFunSet = FunSet(struct type elt = int end)` will compile but programmers will not be able to build any values of type `IFunSet.t` other than the empty set.  Why?  How can it be fixed?


2. Extend the `Elt` signature to include a function `eq : elt -> elt -> bool` that checks for equality of elements, the `Set` signature to include `union : t -> t -> t` and `intersect : t -> t -> t`, and the `FunSet` functor to correctly implement these functions with the new `Elt` signature.


3. Give a line of code that instantiates a `FunSet` module with element type `int`, and equality up to absolute value (so `eq 7 (-7)` would evaluate to `true`.)


The next three questions are based on this code:

```ocaml
exception Empty_stack

module MutableIntStack = struct
  let d = -1
  let n = 100 (* who would ever push more than 100 ints on a stack? *)
  type t = { a : int array ; mutable i : int }
  let create () = { a = Array.make n d ; i = 0}
  let is_empty s = s.i = 0
  let peek s = if s.i = 0 then raise Empty_stack else s.a.(s.i)
  let push x s = if s.i = n then raise Stack_overflow else s.a.(s.i) <- x ; s.i <- s.i+1
  let pop s = if s.i = 0 then raise Empty_stack else s.a.(s.i) <- d; s.i <- s.i - 1
end
```

4. We could try to make a `MutableStack` functor that operates on an `Elt` struct as in the previous example.  What problem would we run into?  


5. Let's fix this problem by extending the `Elt` signature to include a value `d : elt`.  Give the complete definition of the functor.


6. Suppose we also want to allow stacks with different maximum sizes.  Extend the functor to act on a second struct that specifies the maximum stack size.


## Induction

1. For each of the following types, what is its principle of structural induction?

    ```ocaml
    type bexp = True | False | Not of bexp | And of bexp*bexp | Or of bexp*bexp

    type 'a rlist =  Lin | Snoc of 'a rlist * 'a

    type mvar = Var of string | Int of int | Mul of mvar*mvar | Plus of mvar*mvar

    type 'a mtree = Leaf of 'a | Node of 'a mtree * 'a mtree

    type regexp = C of char | Concat of regexp * regexp | U of regexp * regexp | Star of regexp
    ```

2. Consider the following code:
    ```ocaml
    let rec demorg bx = match bx with
    | And(b1,b2) -> Not(Or(Not (demorg b1),Not (demorg b2)))
    | Or(b1,b2) -> Not(And(Not (demorg b1), Not (demorg b2)))
    | Not b -> Not (demorg b)
    | _ -> bx

    let rec feval bx = match bx with
    | False | True | Not _ -> false
    | And(b1,b2) -> (feval b1) && (feval b2)
    | Or(b1,b2) -> (febal b1) || (feval b2)

    let rec eval bx = match bx with
    | False -> false
    | True -> true
    | Not b -> not (eval b)
    | And (b1,b2) -> (eval b1) && (eval b2)
    | Or (b1,b2) -> (eval b1) || (eval b2)
    ```

    Prove the following identities: \
    (i) ∀ `b : bexp`, `feval b` ≡ `false` \
    (ii) ∀ `b : bexp`, `eval (demorg b)` ≡ `eval b`


3. Here's some more code to read:
    ```ocaml
    let rec tmem x t = match t with
    | Leaf v -> v=x
    | Node(l,r) -> (tmem x l) || (tmem x r)

    let rec texists p t = match t with
    | Leaf v -> (p v)
    | Node(l,r) -> (texists p l) || (texists p r)

    let rec tcount p t = match t with
    | Leaf v -> if p v then 1 else 0
    | Node(l,r) -> (tcount p l) + (tcount p r)
    ```

    Prove the following identities: \
    (i) ∀ `t : 'a mtree`, ∀ `x : 'a`,  `texists ((=) x) t` ≡ `tmem x t` \
    (ii) ∀ `t : 'a mtree`, ∀ `p : 'a -> bool`, `tcount p t >= 0` ≡ `true`


## Functions

1. Give a definition of the function `take : int -> 'a list -> 'a list`, so that `(take n ls)` returns the first `n` elements of `ls`, or if `ls` has less than `n` elements, the entire list.


2. Give a definition for the function `powerset : 'a list -> 'a list list` that returns the list of all sub-lists of `ls`, so `powerset [1;2]` should evaluate to `[[]; [1]; [2]; [1;2]]` and `powerset []` should evaluate to `[[]]`.  (Your sublists can appear in any order)


3. Give a definition for the function `last_of : 'a list -> 'a option` that returns the last element of a non-empty list (wrapped in a `Some` constructor) or `None` on an empty list, so `last_of ["tasty"; "fresh"; "cookies"]` should evaluate to `Some "cookies"` and `last_of []` should evaluate to `None`.


4. Use a list higher-order function to define the function `countp : ('a -> bool) -> 'a list -> int`, so that `countp p ls` returns the number of elements in `ls` that make `p` evaluate to `true`, so for example `countp ((=) 1) [3;1;4;1;5;9;2]` should evaluate to `2` and `countp (fun s -> String.length s > 2) ["its";"off";"to";"work"]` should evaluate to `3`.


5. Use a higher-order list function to define the function `scale : float -> float list -> float list` such that `scale s ls` multiplies each element of `ls` by `s`.


6. Use a higher-order list function to define the function `positives : int list -> int list` that returns only the positive elements of its argument list. (`0` is not positive)


7. Use continuations to give a tail-recursive definition of `take`.


8. Use continuations to give a tail-recursive definition of the function `replace_all : 'a -> 'a -> 'a list -> 'a list`.  `replace_all a b ls` replaces all instances of the value `a` in `ls` with `b`, so e.g. `replace_all 1 0 [1;2;1;3]` should evaluate to `[0;2;0;3]` and `replace_all 'a' 'o' ['b';'a';'n';'a';'n';'a']` should evaluate to `['b';'o';'n';'o';'n';'o']`.


9. Using the definition `type 'a btree = Empty | Node of 'a * 'a btree * 'a btree`, write the code for a function `tmax : 'a btree -> 'a option` that returns the largest element in a btree (in a `Some` constructor) or `None` if the tree is empty, so e.g. `tmax Node(7,Node(1,Empty,Empty),Empty)` should evaluate to `Some 7` and `tmax Empty` should evaluate to `None`.


10. Using the same type, write a definition for the function `max_path : 'a btree -> 'a list` that returns the list of values encountered along the longest path from the root to a leaf.  So `max_path Empty` should evaluate to `[]`, and `max_path (Node("a",Node("b",Empty,Node("d",Empty,Empty)),Node("c",Empty,Empty)))` should evaluate to `["a";"b";"d"]`.


11. Using the type `type 'a lazylist = End | Lz of 'a * 'a lazylist lazy_t`, give the definition of a function `lz_until : ('a -> bool) -> 'a list -> 'a lzlist` so that `lz_until p ls` lazily returns elements of `ls` until one makes `p` evaluate to true.


## Program representation and analysis

Recall our types and functions for representing, analyzing, and evaluating programs:

```ocaml
type expr = Boolean of bool
| Const of int
| Add of expr * expr
| Mul of expr * expr
| Gt of expr * expr
| Eq of expr * expr
| If of expr * expr * expr
| Not of expr
| Name of string
| Set of string * expr
| While of expr * expr
| Seq of expr list
| Print of expr
| ReadInt

type result = IntR of int | BoolR of bool | UnitR

type expType = IntT | BoolT | UnitT
type state = (string * result) list

val eval : expr -> state -> (result*state)
val typeOf : expr -> (string*expType) list -> expType
```

1. Suppose we add the following constructors to the expr type:
  ```ocaml
    | StrConst of string (* a string constant *)
    | Len of expr (* Len(s) is the length of string s *)
    | Concat of expr * expr (* Concat(s1,s2) is the concatenation of s1 and s2 *)
    | Substr of expr * expr * expr (* Substr(s,i,j) = substring from index i to j of s *)
  ```

  What other data types in our representation will need to be modified to accomodate strings, and how?


2. Recall that a type judgment is a rule telling us how to type an expression, for example:
  + e1 : IntT, e2: IntT ⇒ Add(e1,e2): IntT
  + e1 : t, e2 : t ⇒ Eq(e1,e2) : BoolT
  + Const : IntT

  Give the type judgments for each of the new expression constructors:

  * `StrConst`

  * `Concat`

  * `Len`

  * `Substr`


3. Complete the match cases for `StrConst` and `Concat` in the `eval` function:
  ```ocaml
    let rec eval e st = match e with    
    | Const i -> (IntR i, st)
    | Boolean b -> (BoolR b, st)
    ...
    |  Len e1 -> let (StringR s, st1) = eval e1 st in (IntR (String.length s),st1)
    | Substr (sx,e1,e2) -> let (StringR s, st1) = eval sx st in
        let (IntR l, st2) = eval e1 st1 in
        let (IntR r, st3) = eval e2 st2 in (StringR (String.sub s l (r-l+1)), st3)
  ```

# Other study resources:

* Lab Exercises: You can see all of the lab exercises and their solutions on [github](https://github.umn.edu/csci2041-sum21/sol2041-sum21/)

* Quizzes: You can see the questions and scoring rubric for all quizzes you took on [Gradescope](https://www.gradescope.com/courses/261241) 

