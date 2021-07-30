# Types and Values
For each of the following expressions, either indicate its type, or that it will cause a type error when compiled in OCaml. If the expression is well-typed, give the result of its evaluation – if the result is a functional value, give a brief explanation of what it does – and if the expression has a type error, explain the nature of the error.

1. `let rec swapper x y = not (swapper y x) in swapper 1.0`

    Type: `float -> bool` \
    Value: a function that takes a floating point number as input and then loops forever.  
    (The type of y must be the same as the type of x;
     the return type must be `bool` because the result is passed to `not`)

2. ```ocaml
   let rec fail_rev acc = function
   | [] -> fail_rev [] acc
   | h::t -> fail_rev (h::acc) t
   ```

    Type: `'a list -> 'a list -> 'b` \
    Value: a function that "reverses" its second argument onto its first until empty,
    then reverses the result, and starts all over again.
    (The `acc` argument must be a list because the second match case conses something onto it;
    the unnamed argument must be a list because it is matched against a list pattern,
    and the return type is not constrained by the definition.)

3. ```ocaml
    let rec irev = function
    | [] -> []
    | h::t -> (irev t)::h
    ```

    **Type Error**.  The second match case conses a `'a list` to an element of type `'a`.

4. ```ocaml
    let p = ref true in
    let notr q = p := p || q in (notr false)
    ```

    **Type Error**. `p` has type `bool ref` so `p || q` is a type error.  
    (If we replace it with `!p || q`, the type is `unit`.)


4. ```ocaml
    let rec ts ft = function
    | [] -> ft
    | h::t -> ts (h +. ft) t
    ```

    Type: `float -> float list -> float` \
    Value: a function that adds all of the elements of a `float list` to an initial value `ft`.


4. ```ocaml
    type 'a dlist = Nil | Link of 'a link
    and 'a link = { mutable prev : 'a dlist ; mutable next : 'a dlist; hd : 'a}
    let rec to_list_rev = function
    | Nil -> []
    | Link { hd ; next ; prev } -> (to_list_rev next) @ [hd]
    ```

    Type: `'a dlist -> 'a list` \
    Value: a function that reverses a doubly-linked list.

4. `let a = ref [] in let z = a in z := [1;2] ; !a`

    Type: `int list` \
    Value: `[1;2]`

4. ```ocaml
    type 'a mpair = { fst : 'a; mutable snd : 'a}
    let o = { fst = 0; snd = '0'} in o.snd <- '3'
    ```

    **Type error**. The fields of `'a mpair` must belong to the same type.

4. ```ocaml
    type ipair = { mutable fst : int ; mutable snd : int}
    let p = {fst = 1; snd = 2} in p.snd <- 3
    ```

    Type: `unit` \
    Value: `()`

4. ```ocaml
    type 'a stream = End | Cons of 'a * (unit -> 'a stream)
    let rec drop_s s n = match (s,n) with
    | (End,_) -> End
    | (_,0) -> s
    | (Cons(h,t),_) -> (drop_s (t ()) (n-1))
    ```

    Type: `'a stream -> int -> 'a stream`  \
    Value: a function that drops the first n elements of a stream.


4. ```ocaml
    type 'a lzlist = Nil | Lz of 'a * 'a lzlist lazy_t
    let print_lz l = match l with
    | Nil -> ()
    | Lz(h,t) -> print_endline h ; print_lz t
    ```

    **Type Error**. In the second match case, `t` has type `string lzlist lazy_t`, not `string lzlist`.  
    (If we force `t` with the pattern `Lz(h,lazy(t))` or with the recursive call `print_lz (Lazy.force t)`
    then the type would be `string lzlist -> unit`.)

4. `let f x = raise x; 4`

    Type: `exn -> int` \
    Value: a function that takes a value of type `exn` (an exception) and raises it.

4. `try 1+2 with _ -> 3.0`

    **Type Error**.  The body of the `try...with` has type `int` but the `with` clause has type `float`.

4. `let fc s = try Some(s.[0]) with _ -> None`

    Type: `string -> char option` \
    Value: a function that returns the first character in a string, wrapped in a `Some` constructor,
    or `None` if the string is empty.

4. `[(Invalid_argument ""); (Failure ""); Stack_overflow]`

    Type: `exn list` \
    Value: What it says.

4. `List.fold_left (fun acc x -> (acc^x)) 3`

    **Type error**. The fold function expects the accumulator to be a string
    (because it is passed to the `^` string concatenation operator)
    but the initial accumulator has type `int`

4. `List.exists (fun x -> x)`

    Type: `bool list -> bool`  \
    Value: A function that returns `true` if any element of its input list is `true`.

4. `List.map string_of_float`

    Type: `float list -> string list` \
    Value: A function that converts a list of floating point numbers into their string representations.

4. `let rec g p f b n = if (p n) then b else (f n (g p f b (n-1)))`

    Type: `(int -> bool) -> (int -> 'a -> 'a) -> 'a -> int -> 'a`  \
    Value: a function that loops over decreasing values of `n`,
    until some "base case" `n0` satisfies `p`.  
    The result is `f n (f (n-1) (... b ...)`

4. `let rec h k = if !k = 0 then 1 else (k := (!k/2) ; !k + (h k)) in h (ref 4)`

    Type: `int` \
    Value: `1`  (Each recursive call is made before `!k` is evaluated,
    so when the stack unwinds, `k` already refers to `0`)

4. `32 || false`

    **Type error**. `||` has type `bool -> bool -> bool` and `32` has type `int`, not `bool`.

4. `let k = ref [| |] in Array.length !k`

    Type: `int` \
    Value: `0`.  (`k` refers to an empty array)

4. ```ocaml
    type pm = { name : string;  hp : int ; mutable lvl : int}
    let rec lvl_up npc = npc.lvl <- npc.lvl + 1
    ```

    Type: `pm -> unit` \
    Value: a function that increments the `lvl` field of a `pm` record.

# Modules and Functors

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

    The signature `At` gives the type of `f` as `int->int` but `Af.f` treats its argument as a bool.  Fixing the problem requires either fixing the definition of `Af.f` (did it mean to test `z=0` like in C/C++?) or changing the signature of `Af`.

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

    In the signature `Bt`, the type `t` is abstract, so `BB.f` has type `BB.t -> BB.t`, which is not the same as `int list` outside the scope of `BB`.  The problem can be fixed by opening the signature, e.g. `module BB : Bt with type t = int list = struct ...`

1. ```ocaml
    module type Ct = sig
      val c : float
    end

    module Cf(C : Ct) = struct
      let e m = m *. C.c *. C.c
    end

    module CC = Cf(struct let cc = 2.998e8 end)
    ```

    The argument `struct` in the declaration of `CC` does not implement `Ct`.  The problem can be fixed by changing the name `cc` to `c` as in the signature.

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

    The type `IFunSet.elt` is abstract since the type `Set.elt` is abstract in the `Set` signature.  So there is no way to instantiate a value of the correct type to add an `IFunSet.t`.  The problem can be fixed by modifying the signature in the `FunSet` declaration: `module FunSet(E : Elt) : Set with type elt=E.elt = struct...`

2. Extend the `Elt` signature to include a function `eq : elt -> elt -> bool` that checks for equality of elements, the `Set` signature to include `union : t -> t -> t` and `intersect : t -> t -> t`, and the `FunSet` functor to correctly implement these functions with the new `Elt` signature.

  ```ocaml
    module type Elt = sig
      type elt
      val eq : elt -> elt -> bool
    end

    module type Set = sig
      (* stuff from before *)
      val union : t -> t -> t
      val intersect : t -> t -> t
    end

    module FunSet(E: Elt) : Set with type elt = E.elt = struct
      type elt = E.elt
      type t = elt -> bool
      let empty = fun _ -> false
      let mem x s = (s x)
      let add x s = fun e -> (E.eq x y) || (s e)
      let union s1 s2 = fun e -> (s1 e) || (s2 e)
      let intersect s1 s2 = fun e -> (s1 e) && (s2 e)
    end
  ```

3. Give a line of code that instantiates a `FunSet` module with element type `int`, and equality up to absolute value (so `eq 7 (-7)` would evaluate to `true`.)

  ```ocaml
    module IAFunSet = FunSet(struct type elt = int let eq x y = (x=y) || ((-x)=y) end)
  ```

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

    We would need to replace the value `d` with an appropriate "default" value for the type `E.elt`.

5. Let's fix this problem by extending the `Elt` signature to include a value `d : elt`.  Give the complete definition of the functor.

  ```ocaml
    module type Elt = sig type elt val d : elt end

    module MutableStack(E: Elt) = struct
      type elt = E.elt
      let d = E.d
      let n = 100
      type t = { a : elt array ; mutable i : int }
      let create () = { a = Array.make d n ; i = 0 }
      let is_empty s = (s.i = 0)
      let peek s = if s.i = 0 then raise Empty_stack else s.a.(s.i)
      let push x s = if s.i = n then raise Stack_overflow else s.a.(s.i) <- x ; s.i <- s.i+1
      let pop s = if s.i = 0 then raise Empty_stack else s.a.(s.i) <- d; s.i <- s.i - 1
    end
  ```

6. Suppose we also want to allow stacks with different maximum sizes.  Extend the functor to act on a second struct that specifies the maximum stack size.

  ```ocaml
    module type Size = sig val maxsize : int end

    module MutableStack(E: Elt)(S: Size) = struct
      type elt = E.elt
      let d = E.d
      let n = S.maxsize
      (* the rest is unchanged *)
    end
  ```

# Induction

1. For each of the following types, what is its principle of structural induction?

    ```ocaml
    type bexp = True | False | Not of bexp | And of bexp*bexp | Or of bexp*bexp

    type 'a rlist =  Lin | Snoc of 'a rlist * 'a

    type mvar = Var of string | Int of int | Mul of mvar*mvar | Plus of mvar*mvar

    type 'a mtree = Leaf of 'a | Node of 'a mtree * 'a mtree

    type regexp = C of char | Concat of regexp * regexp | U of regexp * regexp | Star of regexp
    ```


    **`bexp`**:
    For all `b : bexp`, P(`b`) if:
    - P(`True`), and
    - P(`False`), and
    - ∀ `b: bexp`, [ P(`b`) ⇒ P(`Not b`) ], and
    - ∀ `b1, b2 : bexp`, [ P(`b1`) and P(`b2`) ⇒ P(`And(b1,b2)`) ], and
    - ∀ `b1, b2 : bexp`, [ P(`b1`) and P(`b2`) ⇒ P(`Or(b1,b2)`) ]

    **`rlist`**:
    For all `l : 'a rlist`, P(`l`) if:
    - P(`Lin`), and
    - ∀ `x : 'a`, `l : 'a rlist`, [ P(`l`) ⇒ P(`Snoc(l,x)`) ]

    **`mvar`**:
    For all `p : mvar`, P(`p`) if:
    - ∀ `s : string`, P(`Var s`), and
    - ∀ `n : int`, P(`Int n`), and
    - ∀ `p,q : mvar`, [ P(`p`) and P(`q`) ⇒ P(`Mul(p,q)`) ], and
    - ∀ `p,q : mvar`, [ P(`p`) and P(`q`) ⇒ P(`Add(p,q)`) ]


    **`mtree`**:
    For all `t : 'a mtree`, P(`t`) if:
    - ∀ `v : 'a`, P(`Leaf v`) and
    - ∀ `rt, lt : 'a mtree`, [ P(`rt`) and P(`lt`) ⇒ P(`Node(lt,rt)`) ]

    **`regexp`**:
    For all `r : regexp`, P(`r`) if:
    - ∀ `c: char`, P(`C c`), and
    - ∀ `r : regexp`, [ P(`r`) ⇒ P(`Star r`) ], and
    - ∀ `r1, r2 : regexp`, [ P(`r1`) and P(`r1`) ⇒ P(`Concat (r1,r2)`) ], and
    - ∀ `r1, r2 : regexp`, [ P(`r1`) and P(`r1`) ⇒ P(`Union (r1,r2)`) ]


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

    Prove the following identities:
    (i) ∀ `b : bexp`, `feval b` ≡ `false`
    (ii) ∀ `b : bexp`, `eval (demorg b)` ≡ `eval b`


    (i) We will prove that for all `b : bexp`, P(`b`): `feval b` ≡ `false`.

      **Base Cases:**
      * P(`True`) : `feval True` ≡ `false`. \
        This is true by evaluation of `feval`.

      * P(`False`) : `feval False` ≡ `false`. \
        This is also true by evaluation of `feval`.

      **Inductive Cases:**

      * For all `b: bexp`, P(`b`) ⇒ P(`Not b`):\
        We can actually prove this unconditionally since:
        `feval (Not b)` ≡ `false` **[ eval. of `feval` ]**.

      * For all `b1, b2 : bexp`, [ P(`b1`) and P(`b2`) ⇒ P(`And(b1,b2)`)]:\
        We make the following\
        **IH**: `feval b1 ≡ false` and `feval b2 ≡ false`.\
        Then:\
        `feval (And(b1,b2))`\
        ≡ `(feval b1) && (feval b2)` **[ eval of `feval` ]**\
        ≡ `false && (feval b2)` **[ IH: `feval b1` ≡ `false` ]**\
        ≡ `false` **[ evaluation of `&&` ]** ✓

      * For all `b1, b2 : bexp`, [ P(`b1`) and P(`b2`) ⇒ P(`Or(b1,b2)`)]:\
        We make the following\
        **IH**: `feval b1 ≡ false` and `feval b2 ≡ false`.\
        Then:\
        `feval (Or(b1,b2))`\
        ≡ `(feval b1) || (feval b2)` **[ eval of `feval` ]**\
        ≡ `false || (feval b2)` **[ IH: `feval b1` ≡ `false` ]**\
        ≡ `false || false` **[ IH: `feval b2` ≡ `false` ]**\
        ≡ `false` **[ evaluation of `||` ]** ✓

    (ii) We will prove that for all `b : bexp`, P(`b`): `eval (demorg b)` ≡ `eval b`.\
      **Base Cases:**

      * P(`True`) : `eval (demorg True)` ≡ `eval True`. \
        `eval (demorg True)` ≡ `eval True` **[ eval of `demorg True` ]**, ✓

      * P(`False`) : `eval (demorg False)` ≡ `eval False`. \
        `eval (demorg False)` ≡ `eval False` **[ eval of `demorg False` ]**, ✓


      **Inductive Cases:**

      * For all `b: bexp`, P(`b`) ⇒ P(`Not b`):\
        We make the following\
        **IH**: `eval (demorg b)` ≡ `eval b`.\
        Then:\
        `eval (demorg (Not b))`\
        ≡ `eval (Not (demorg b))` **[ eval `demorg` ]**\
        ≡ `not (eval (demorg b))` **[ eval `eval` ]**\
        ≡ `not (eval b)` **[ IH ]**\
        ≡ `eval (Not b)` **[ rev. eval `eval` ]**, ✓

      * For all `b1, b2 : bexp`, [ P(`b1`) and P(`b2`) ⇒ P(`And(b1,b2)`)]:\
      We make the following\
      **IH**: `eval (demorg b1) ≡ eval b1` and `eval (demorg b2) ≡ eval b2`.\
      Then:\
      `eval (demorg (And(b1,b2)))`\
      ≡ `eval Not(Or(Not (demorg b1), Not (demorg b2)))` **[ eval of `demorg` ]**\
      ≡ `not (eval Or(Not (demorg b1), Not (demorg b2)))` **[ eval of `eval` ]**\
      ≡ `not ((eval (Not (demorg b1))) || (eval (Not (demorg b2))))` **[ eval of `eval` ]**\
      ≡ `not (not (eval (demorg b1))) || (not (eval (demorg b2))))` **[ eval of `eval` ]**\
      ≡ `not ((not (eval b1)) || (not (eval b2)))` **[ IH ]**\
      ≡ `(eval b1) && (eval b2)` **[ boolean algebra ]**\
      ≡ `eval (And(b1,b2))` **[ reverse eval `eval` ]** ✓

      * For all `b1, b2 : bexp`, [ P(`b1`) and P(`b2`) ⇒ P(`Or(b1,b2)`)]:\
      We make the following\
      **IH**: `eval (demorg b1) ≡ eval b1` and `eval (demorg b2) ≡ eval b2`.\
      Then:\
      `eval (demorg (Or(b1,b2)))`\
      ≡ `eval Not(And(Not (demorg b1), Not (demorg b2)))` **[ eval of `demorg` ]**\
      ≡ `not (eval And(Not (demorg b1), Not (demorg b2)))` **[ eval of `eval` ]**\
      ≡ `not ((eval (Not (demorg b1))) && (eval (Not (demorg b2))))` **[ eval of `eval` ]**\
      ≡ `not (not (eval (demorg b1))) && (not (eval (demorg b2))))` **[ eval of `eval` ]**\
      ≡ `not ((not (eval b1)) && (not (eval b2)))` **[ IH ]**\
      ≡ `(eval b1) || (eval b2)` **[ boolean algebra ]**\
      ≡ `eval (Or(b1,b2))` **[ reverse eval `eval` ]** ✓

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

    Prove the following identities:
    (i) ∀ `t : 'a mtree`, ∀ `x : 'a`,  `texists ((=) x) t` ≡ `tmem x t`
    (ii) ∀ `t : 'a mtree`, ∀ `p : 'a -> bool`, `tcount p t >= 0` ≡ `true`


    (i) We will prove that for all `t : 'a mtree`, P(`t`): ∀ `x : 'a`, `texists ((=) x) t` ≡ `tmem x t`.

      **Base Case**:\
      ∀ `v : 'a`, P(`Leaf v`):\
      `texists ((=) x) (Leaf v)` \
      ≡ `((=) x v)` **[ eval `texists` ]** \
      ≡ `v=x` **[ eval of `(=)` operator ]** \
      ≡ `tmem x (Leaf v)` **[ reverse eval of `tmem` ]**, ✓

      **Step Case:**\
      ∀ `t1, t2 : 'a mtree`, [ P(`t1`) and P(`t2`) ⇒ P(`Node(t1,t2)`) ]:\
      We make the following\
      **IH**: ∀x, `texists ((=) x) t1` ≡ `tmem x t1` and ∀x, `texists ((=) x) t2` ≡ `tmem x t2`\
      Then,\
      `texists ((=) x) (Node(t1,t2))`\
      ≡ `(texists ((=) x) t1) || (texists ((=) x) t2)` **[ eval `texists` ]** \
      ≡ `(tmem x t1) || (tmem x t2)` **[ IH ]**\
      ≡ `tmem x (Node(t1,t2))` **[ reverse eval `tmem` ]**, ✓

    (ii) We will prove that for all `t : 'a mtree`, P(`t`): ∀`p : 'a -> bool`, `tcount p t >= 0` ≡ `true`.

      **Base Case**:\
      ∀ `v : 'a`, P(`Leaf v`):\
      `tcount p (Leaf v) >= 0`\
      ≡ `(if (p v) then 1 else 0) >= 0` **[ eval `tcount` ]** \
      There are two sub-cases: if `(p v)` ≡ `true`, then
      ≡ `1 >= 0` **[ eval of `if` ]** \
      ≡ `true` **[ eval of `>=` ]**, and otherwise `(if ...)` \
      ≡ `0 >= 0` **[ eval of `if` ]** \
      ≡ `true` **[ eval of `>=` ]**, ✓

      **Step Case:**\
      ∀ `t1, t2 : 'a mtree`, [ P(`t1`) and P(`t2`) ⇒ P(`Node(t1,t2)`) ]:\
      We make the following\
      **IH**: ∀p, `tcount p t1 >= 0` ≡ `true` and ∀p, `tcount p t2 >= 0` ≡ `true`\
      Then,\
      `tcount p (Node(t1,t2)) >= 0`\
      ≡ `(tcount p t1) + (tcount p t2) >= 0` **[ eval `tcount` ]** \
      ≡ `(tcount p t2) >= 0` **[ IH: `tcount p t1 >= 0` ]**\
      ≡ `true` **[ IH: `tcount p t2 >= 0` ]**, ✓


# Functions

1. Give a definition of the function `take : int -> 'a list -> 'a list`, so that `(take n ls)` returns the first `n` elements of `ls`, or if `ls` has less than `n` elements, the entire list.

  ```ocaml
    let rec take n lst = match (n,lst) with
    | (0,_) | (_,[]) -> []
    | (_,h::t) -> h::(take (n-1) t)

    (* for fun, the tail-recursive version: *)
    let take n lst =
      let rec trtake i l acc = match (i,l) with
      | (0,_) | (_,[]) -> acc
      | (_,h::t) -> trtake (i-1) t (h::acc)
      in List.rev (trtake n lst [])

    (* and the continuation-passing version: *)
    let take n lst =
      let rec ktake i l k = match (i,l) with
      | (0,_) | (_,[]) -> k []
      | (_,h::t) -> ktake (i-1) t (fun r -> k (h::r))
    in ktake n lst (fun x->x)
  ```

2. Give a definition for the function `powerset : 'a list -> 'a list list` that returns the list of all sub-lists of `ls`, so `powerset [1;2]` should evaluate to `[[]; [1]; [2]; [1;2]]` and `powerset []` should evaluate to `[[]]`.  (Your sublists can appear in any order)

  ```ocaml
    let powerset lst =
      let rec pp = function
      | [] -> [[]]
      | h::t -> let pt = pp t in (map (List.cons h) pt) @ pt
    (* to get the nice sorted result: *)
    in List.sort List.compare_lengths (pp lst)
  ```

3. Give a definition for the function `last_of : 'a list -> 'a option` that returns the last element of a non-empty list (wrapped in a `Some` constructor) or `None` on an empty list, so `last_of ["tasty"; "fresh"; "cookies"]` should evaluate to `Some "cookies"` and `last_of []` should evaluate to `None`.

  ```ocaml
    let rec last_of = function
    | [] -> None
    | [h] -> Some h
    | h::t -> last_of t
  ```

4. Use a list higher-order function to define the function `countp : ('a -> bool) -> 'a list -> int`, so that `countp p ls` returns the number of elements in `ls` that make `p` evaluate to `true`, so for example `countp ((=) 1) [3;1;4;1;5;9;2]` should evaluate to `2` and `countp (fun s -> String.length s > 2) ["its";"off";"to";"work"]` should evaluate to `3`.

  ```ocaml
    (* with filter: *)
    let countp p lst = List.length (List.filter p lst)

    (* with fold: *)
    let countp p lst = List.fold_left (fun c n -> if (p n) then c+1 else c) 0 lst
  ```

5. Use a higher-order list function to define the function `scale : float -> float list -> float list` such that `scale s ls` multiplies each element of `ls` by `s`.

  ```ocaml
    let scale s = List.map ((*.) s)
  ```

6. Use a higher-order list function to define the function `positives : int list -> int list` that returns only the positive elements of its argument list. (`0` is not positive)

  ```ocaml
    let positives = List.filter ((<) 0)
  ```

7. Use continuations to give a tail-recursive definition of `take`.

  ```ocaml
    let take n lst =
      let rec ktake i ls k = match (i,ls) with
      | (0,_) | (_,[]) -> k []
      | (_,h::t) -> ktake (i-1) t (fun r -> k (h::r))
    in ktake n lst (fun r -> r)
  ```

8. Use continuations to give a tail-recursive definition of the function `replace_all : 'a -> 'a -> 'a list -> 'a list`.  `replace_all a b ls` replaces all instances of the value `a` in `ls` with `b`, so e.g. `replace_all 1 0 [1;2;1;3]` should evaluate to `[0;2;0;3]` and `replace_all 'a' 'o' ['b';'a';'n';'a';'n';'a']` should evaluate to `['b';'o';'n';'o';'n';'o']`.

  ```ocaml
    let replace_all f r lst =
      let rec repk ls k = match ls with
      | [] -> k []
      | h::t -> repk t (fun rt -> k (if h=f then r else h)::rt)
    in repk lst (fun l -> l)
  ```

9. Using the definition `type 'a btree = Empty | Node of 'a * 'a btree * 'a btree`, write the code for a function `tmax : 'a btree -> 'a option` that returns the largest element in a btree (in a `Some` constructor) or `None` if the tree is empty, so e.g. `tmax Node(7,Node(1,Empty,Empty),Empty)` should evaluate to `Some 7` and `tmax Empty` should evaluate to `None`.

  ```ocaml
    let rec tmax = function
    | Empty -> None
    | Node(a,l,r) -> max (Some a) (max (tmax l) (tmax r))
  ```

10. Using the same type, write a definition for the function `max_path : 'a btree -> 'a list` that returns the list of values encountered along the longest path from the root to a leaf.  So `max_path Empty` should evaluate to `[]`, and `max_path (Node("a",Node("b",Empty,Node("d",Empty,Empty)),Node("c",Empty,Empty)))` should evaluate to `["a";"b";"d"]`.

  ```ocaml
    let rec max_path = function
    | Empty -> []
    | Node(v,l,r) ->
      let (lp,rp) = (max_path l, max_path r) in
      v::(if List.length lp > List.length rp then lp else rp)
  ```

11. Using the type `type 'a lazylist = End | Lz of 'a * 'a lazylist lazy_t`, give the definition of a function `lz_until : ('a -> bool) -> 'a list -> 'a lzlist` so that `lz_until p ls` lazily returns elements of `ls` until one makes `p` evaluate to true.

  ```ocaml
    let rec lz_until p ls = match ls with
    | [] -> End
    | h::t -> if (p h) then End else Lz(h,lazy(lz_until p t))
  ```

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

    We will need to modify the `result` type to have a string-valued result, e.g. `StringR of string`, and the `expType` type to have a constructor for the string type, `StringT`.

2. Recall that a type judgment is a rule telling us how to type an expression, for example:
  + e1 : IntT, e2: IntT ⇒ Add(e1,e2): IntT
  + e1 : t, e2 : t ⇒ Eq(e1,e2) : BoolT
  + Const : IntT

  Give the type judgments for each of the new expression constructors:

  * `StrConst`

    ⇒ `StrConst(s) : StringT`

  * `Concat`

    `e1 : StringT`, `e2 : StringT` ⇒ `Concat(e1,e2) : StringT`

  * `Len`

    `e : StringT` ⇒ `Len(e) : IntT`

  * `Substr`

    `s : StringT`, `i : IntT`, `j : IntT` ⇒ `Substr(s,i,j) : StringT`

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

  ```ocaml
    | StrConst s -> (StringR s, st)
    | Concat (e1,e2) -> let (StringR s1, st1) = eval e1 st in
                        let (StringR s2, st2) = eval e2 st1 in (StringR (s1^s2), st2)
  ```
