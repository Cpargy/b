# Lab 7: Induction Proofs

*CSci 2041: Advanced Programming Principles, Summer 2021*

**Due:** Friday, July 23 at 11:59pm (CDT)

**NOTE:** The questions on this lab will all be manually graded by the instructor and TAs.  Submission will be to Gradescope, where the autograder will just check that you have submitted files with the correct names.

Every question on this lab will be an induction proof.  For each of the four section, we will randomly choose one of the proofs to grade; the same proof will be graded for all submissions, regardless of whether you attempted that proof or not. The remaining proof in that section will be graded based on completion (that is, 0.5 point for a submission; 1 point if it appears that a serious attempt was made)

Each proof will be worth up to 3 points, one for each of the following categories:

1. Proof structure: are the property, base case, inductive case, inductive hypothesis, and inductive conclusion all clearly and correctly stated?  

2. Base case proof: are all steps of the proof correct, fully justified, and easy to follow?  

3. Inductive case proof: are all steps of the proof correct, fully justified and easy to follow?  Is it clear where the inductive hypothesis is applied to arrive at the inductive conclusion?

For each of the points your assessment will be one of:

* Meets expectations: 1.0 - most of the rubric questions are fully addressed.

* Revision needed: 0.67 - more than half of the rubric questions are consistently addressed.

* Not assessable: 0.33 - does not meet one of the above criteria.

Additionally, rather than grading each section out of 3 and dropping one section, we will simply take (the floor of) your score across all sections, up to 10 points.

# 1. Natural Induction Proofs

These proofs treat the type `int` like natural numbers.  For an example of a correctly formatted and justified proof, you can look at the file [tr_fact.md](tr_fact.md)

## `tr_sum` and `sumup`

Using the following definitions:

```ocaml
let sum n =
  let rec tr_sum m a =
    if m = 0 then a else tr_sum (m-1) (m+a)
  in tr_sum n 0

let rec sumup n =
  if n = 0 then 0 else n + (sumup (n-1))
```

We would like to be able to prove that `sum n ≡ sumup n`, but the structure of the definition for `sum` will make it difficult to directly prove things about `sum` by induction.  Instead, let's prove the more general goal: for all `n : ℕ`, for all `𝒶 : ℕ`,

> `tr_sum n 𝒶` ≡ `𝒶 + (sumup n)`

Put your proof in a file named `tr_sum.md`

## `sumbetween` and `sumup`

Let's use the following function definitions:

```ocaml
let rec sumbetween m n =
  if m >= n then 0 else n + (sumbetween m (n-1))
let rec sumup n =
  if n <= 0 then 0 else n + (sumup (n-1))
```

Prove that for all `n : ℕ`, for all `m : ℕ`,

> if `m ≤ n`, then `sumbetween m n` ≡ `(sumup n) - (sumup m)`

Note that there is one special case of `m` you will need to treat separately in the proof for the inductive case.  Put your proof in a file named `sumbetween.md`


# 2.  Structured nat proofs

The proofs in this section deal with the `nat` type defined in video 7.2. 

```ocaml
type nat = Zero | Succ of nat
let rec to_int (n:nat) = match n with
| Zero -> 0
| Succ m -> 1 + (to_int m)
```

## Structured Comparisons

```ocaml
let rec eq_nat n1 n2 = match (n1,n2) with
| (Zero,Zero) -> true
| (Zero,_) | (_, Zero) -> false
| (Succ n1', Succ n2') -> eq_nat n1' n2'
```

Use structured induction on the type `nat` to prove that for all `m : nat`, for all `n : nat`,

> `(to_int m) = (to_int n)` ≡ `eq_nat m n`

Your proof for this identity should appear in the file `eq_nat.md`

## Efficient conversions

```ocaml
let int_of m =
  let rec tr_nat n m = match m with
  | Zero -> n
  | Succ m1 -> tr_nat (n+1) m1
in tr_nat 0 m
```

Use induction to prove that for all `m : nat`, for all `n : ℕ`,

> `tr_nat n m` ≡ `n + (to_int m)`

your proof should appear in a file named `tr_nat.md`.


# 3.  Inductive list proofs

The proofs in this section will refer to the following list function definitions:

```ocaml
let rec length = function
| [] -> 0
| _::t -> 1+(length t)

let rec append l1 l2 = match l1 with
| [] -> l2
| h::t -> h::(append t l2)

let rec reverse ls = match ls with
| [] -> []
| h::t -> append (reverse t) [h]

let rec mem x = function
| [] -> false
| h::t -> (x=h) || (mem x t)
```

For examples of correctly formatted and justified proofs using list induction, you can look at the file [len_reverse.md](len_reverse.md).  (This file proves that for all `l : 'a list`, `length (reverse ls)` ≡ `length ls`.)

## `append` length

In a file named `len_append.md`, prove that for all `l_1 : 'a list`, for all `l_2 : 'a list`,

> `length (append l_1 l_2)` ≡ `(length l_1) + (length l_2)`

## `reverse` membership

In a file named `mem_reverse.md`, prove that for all `l : 'a list`, for all `a : 'a`

> `mem a (reverse l)` ≡ `mem a l`

You may use the identity relating `append` and `mem` from reading quiz 7.3.

# 2.  Induction on other types

## trees

Using the following definitions:

```ocaml
type 'a btree = Empty | Node of 'a * 'a btree * 'a btree

let rec mirror t = match t with
| Empty -> Empty
| Node(v,lt,rt) -> Node(v,mirror rt, mirror lt)

let rec size t = match t with
| Empty -> 0
| Node(_,lt,rt) -> 1 + (size lt) + (size rt)
```

Prove that for every tree, `size t ≡ size (mirror t)`.  Write your proof in the file `tree.md`

## nested lists

Using the following definitions:

```ocaml
type 'a nested = Nil | Cons of 'a * 'a nested | Nest of 'a nested * 'a nested

let rec mem x l = match l with [] -> false
| h::t -> (h=x) || (mem x t)

let rec nmem x nl = match nl with
| Nil -> false
| Cons (y,t) -> (y=x) || (nmem x t)
| Nest (nst,rst) -> (nmem x nst) || (nmem x rst)

let rec flatten nl = match nl with
| Nil -> []
| Cons(a, nl) -> a::(flatten nl)
| Nest(n1,nlrest) -> (flatten n1) @ (flatten nlrest)
```

Prove that for every `nl : 'a nested`, for every `x : 'a`, `nmem x nl ≡ mem x (flatten nl)`. Write your proof in the file `nested.md`


## Submission

You should submit the eight files:

+ `tr_sum.md`
+ `sumbetween.md`
+ `eq_nat.md`
+ `tr_nat.md`
+ `len_append.md`
+ `mem_reverse.md`
+ `tree.md`
+ `nested.md`

to [Lab 7 on Gradescope](https://www.gradescope.com/courses/261241/assignments/1349745) by 11:59pm on Friday, July 23.
