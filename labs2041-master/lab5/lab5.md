# Lab Problem Set 5: Representing, Checking, and Evaluating Programs

*CSci 2041: Advanced Programming Principles, Summer 2021*

**Due:** Friday, July 9 at 11:59pm (CST)

In your local copy of the public 'labs2041' repository, do a `git pull` to grab the files for this week's lab exercises.  Then let's get started!

# 1. Syntax Trees

In the file `lab5/syntax.ml` in the public `labs2041` repo, you will find the data structure for representing programs we worked on in Video and Reading 8.1.  Copy the file to the `lab5` directory in your personal repo, and use it to answer these questions.

### Encoding expressions as syntax trees

The following two OCaml programs can be represented by values of type `expr`.  Complete the let declarations in `syntax.ml` binding each OCaml name to the correct `expr` value:  (Note that we are looking for an expression that encodes the computation, not the result.  But a fair check would be to call eval on each and see if you get the same result as for evaluating the OCaml expression.)


#### `e_collatz`

```ocaml
let n = 31 in
let n2 = n/2 in
if n2*2 = n then n2 else 3*n+1
```

#### `e_ifchain`

```ocaml
let x = 42 - 17 in
if (x > 17) && true then (if (x < 31) || false then 1 else 0) else (-1)
```

#### `e_uclid`
```ocaml
let p1 = 2*3+1 in
let p2 = 5*(p1 - 1)+1 in 7*(p2-1)+1
```

Test cases: 1 for each `expr` value.

### Extending Syntax trees with new expression types: `BLet`

A boolean let, or `BLet`, holds a string, a boolean subexpression, and a
subexpression, and when evaluated, it evaluates the boolean subexpression, and
binds the string name to the resulting boolean value and then evaluates the
regular subexpression with this binding.  Since regular environments map names
to integer values, adding `BLet` to `expr` will require extending both `eval`
and `beval` to take a third parameter, which is the "boolean environment" that
maps names (strings) to boolean values (`bool`). We'll also need a new
constructor for `boolExpr` values that reference names bound in `BLet`, `BName`.
Add a `BLet` constructor to `expr`, a `BName` constructor to `boolExpr`, and
modify `eval` and `beval` to evaluate expressions with boolean lets in them.
Some test cases: `BLet ("cnd", BoolC true, If(BName "cnd", IntC 1, IntC (-1)))` 
should have type `expr` and compile without an error, 
`And (BName "bvar", BoolC true)` should have type `boolExpr` and compile without an error;
`beval (BName "v") [] [("v", true)]` should evaluate to `true`, and 
`eval (BLet ("c", BoolC false, If (BName "c", IntC 1, IntC 17))) [] []` should evaluate to `17`.


#### _Test cases_

In order to receive full credit for this problem, your solution should agree with the example evaluations on at least 5/7 cases.  

# 2. Type Checking and other analysis

In the file `lab5/static.ml` in the public `labs2041` repo, you will find the data structure, evaluation, name-checking and type-checking functions for representing programs with primitive types we worked on in Video and Reading 5.2.  Copy the file to the `lab5` directory in your personal repo, and use it to answer these questions.

The expressions we worked on in lecture could have type either `IntT` or `BoolT`, but in typical programs we would want several other data types and operations.  In this exercise, we'll add a new type and four new operations related to this type to the program:

* We'll also add strings to our language, represented by the `expType` constructor `StringT`.  Strings in our language can be introduced as constants, `StringC s`; as the result of a `SFirst` expression, which holds a subexpression `e`, and when evaluated, evaluates `e` and returns the single character string from the start of `e` (or `""` if `e` evaluates to the empty string); as the result of a `SRest` expression, which holds a subexpression `e`, and when evaluated, evaluates `e` and returns the string after the first letter in `e` (or `""` if there are less than 2 letters in `e`); and as the result of a `Concat` expression, which holds two subexpressions, `e1` and `e2`, and when evaluated, evaluates `e1` and `e2` and concatenates the resulting strings.

Before you move on, spend some time to work out what the typing rules should be for each of these expressions.

### Implementations

Now that you've worked out the typing rules, add the expression constructors `StringC`, `SFirst`, `SRest`, and `Concat` to the `expr` type declaration, add a `StringR` constructor to the `result` type declaration, and a `StringT` constructor to the `expType` declaration.  Modify `eval`, `unbound`, and `typeof` to handle these new expressions. Some example evaluations:

+ `Eq (StringC "a", SFirst (StringC "ab"))` should compile without errors and have type `expr`

+ `Concat (StringC "a", SRest (StringC "b"))` should compile without errors and have type `expr`

+ `typeof (Concat (StringC "a", SRest (StringC "b"))) []` should evaluate to `StringT`

+ `unbound (StringC "a") []` should evaluate to `[]`

+ `eval (Let("n", StringC "In", SFirst (Name "n"))) []` should evaluate to `StringR "I"`.

+ `eval (Concat (SFirst (StringC "ab"), SRest (StringC "ab"))) []` should evaluate to `StringR "ab"`.

#### _Test Cases:_

In order to receive full credit, your solutions to this problem should agree on at least 4/6 of the example cases.

# 3. Imperative constructs

The file `lab5/imperative.ml` contains the type definitions for `expr`, `eval`, and `typeof` implementing assignment, sequences, and while loops.  Copy it to your local repo and continue to add definitions there for this exercise.

## Encoding loops as syntax trees

The following "java-like" sequences can be represented by our constructs now.  Add let declarations in `imperative.ml` binding each OCaml name to the correct `expr` value:  (As in part 1, we are looking only for the expression, not the result

#### `e_gcd`

```java
int m = 65537;
int n = 262144;
while (m != n) {
  if (m > n) {
    m = m - n;
  } else {
    n = n - m;
  }
}
return m;
```

#### `e_rsqr`

```java
int p = 3;
int x = 15;
while (x > 0) {
  x = x-1;
  p = p*p;
  while (p > 65521) {
    p = p - 65521;
  }
}
return p;
```

## `unbound`

In Video 5.3 we did not extend the `unbound` procedure for name analysis on imperative constructs.  Add a definition for the function `unbound : expr -> string list -> string list` to `imperative.ml` that extends the `unbound` procedure from Video 5.2 to cover these cases.  Some example evaluations:

+ `unbound (Set ("x",IntC 7)) []` should evaluate to `["x"]`
+ `unbound (Set ("x",Name "y")) ["x"]` should evaluate to `["y"]`
+ `unbound (Seq ([Name "x"; Let("y", IntC 7, BoolC true); Set ("y",BoolC false)])) []`
 should evaluate to `["x";"y"]` (because the second occurence of `"y"` is unbound)
+ `unbound (Seq ([Name "x"; Let("y", IntC 7, BoolC true); Set ("y",BoolC false)])) ["x";"y"]`
  should evaluate to `[]`  
+ `unbound (While (Name "b", Set ("loop", Add (Name "loop", IntC 1)))) []` should evaluate to `["b"; "loop"; "loop"]` (because `"loop"` appears twice in the expression)

#### _Test Cases_  

To get full credit for problem 3 your solution should earn at least 4/7 points.

# 4. Expression tree functions 

The file `lab5/funval.ml` extends our simple program representation to include functions and function applications.  We'll encode a few simple functions using this representation.

### Encoding Simple functions

The `funval.ml` file already has let declarations for three function values, that we should fill in.

#### `add1fun`

The name says it all: `add1fun` is a function that adds 1 to its argument.  Modify the let binding to the correct `expr` value representing this function. Example evaluations: `eval (Apply(add1fun, IntC 16)) []` should evaluate to `IntR 17`,
and `eval (Apply(add1fun, Name "z")) [("z",IntR 0)]` should evaluate to `IntR 1`.

#### `collatz_fun`

The *Collatz Function* takes an integer `n`, and checks if `n` is odd. If it is not, the function returns `n/2`, and otherwise it return `3*n+1`.  We can test whether `n` is odd by checking whether `2*(n/2) = n`.  Modify the let binding to a correct expr value representing this function.  Example evaluations: `eval (Apply(collatz_fun, IntC 31)) []` should evaluate to `IntR 94`, and `eval (Apply(collatz_fun, IntC 32)) []` should evaluate to `IntR 16`.

#### `kdelta`

The *Kronecker delta function* takes two integers as arguments and returns 1 if they are the same, and 0 otherwise.  Modify the let binding to a correct expr value representing this function.  Example evaluations: `eval (Apply(Apply(kdelta, IntC 17), IntC 3)) []` should evaluation to `IntR 0`, and `eval (Apply(Apply(kdelta, IntC 5), IntC 5)) []` should evaluate to `IntR 1`.

#### _Test Cases_  

To get full credit for problem 4 your solution should earn at least 4/6 points.
