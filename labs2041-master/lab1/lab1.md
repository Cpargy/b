# Lab Problem Set 1: Beginning OCaml

*CSci 2041: Advanced Programming Principles, Summer 2021*

**Due:** Friday, June 11 at 11:59pm (CST)

# Starting out with github

+ In this preliminary portion of the problem set you will set up your University of Minnesota GitHub repository that will be used to turn in your programming assignments for this course.

+ You will also ensure you can use the OCaml compilers and associated tools that we will be using in this class.

+ Finally, you will modify an OCaml program, run it, and turn it in via GitHub.

+ These instructions will assume you are using a CSELabs machine, either via VOLE, ssh +X, VirtualBox, or in a physical(ly distanced) lab.  You should be able to follow them (with minor changes) on any Linux or Mac environment in which you have already installed OCaml and VSCode.

### GitHub:

* The University of Minnesota has its own GitHub installation that we
  will be using in the course.  We **are not** using
  https://github.com.

* Git is a software version control system that we will be using in
  the class.  You will turn your work in using GitHub, not Canvas.  We
  will provide autograder feedback on your work using GitHub as well.

### Set up your CSE Labs account if you do not have one

If you do not yet have a CSE Labs account, you will need to set it up now.

To do so, go to this web site and fill in the requested information:

https://wwws.cs.umn.edu/account-management/

### Initialize your GitHub account

+ If you've never logged into https://github.umn.edu, then do so now.Then wait until Dr. Nick comes into your breakout group and adds you to the course github organization.

+ Throughout this portion of the lab, we will refer to your UMN Internet ID, something like `user0123` if your UMN email address is `user0123@umn.edu`. Note that this is **not** your student ID number that appears on your student ID card.  We will never ask you for that number.

+ If you've already logged into https://github.umn.edu, then proceed to the next step since your repository should already be set up.

### Verify that your 2041 repository is set up

+ If your University Internet Id is **user0123** then your repository
will be named **repo-user0123**.  In the examples and text below,
replace **user0123** with your University Internet Id.

+ Log into https://github.umn.edu and select the **csci2041-sum21**
organization and click on the repository named **repo-user0123**.

+ At the URL
  https://github.umn.edu/csci2041-sum21/repo-user0123
  you should see a list of files in your repository.  This will
  include only a file named **README.md**.

If this file is not there, wait until Dr. Nick comes into your breakout group and adds you to the course github organization.

This repository is a database containing the files and the history of
all their changes made since they were added to the repository.  It is
much more than a simple copy of a set of files.

### Setting up Git in your CSE Labs account

+ Log into your CSE (College of Science and Engineering) account.

+ Verify Git is installed.  In a terminal window, execute the following:

(But don't type the `%`.  That is meant to symbolize the prompt you see in your terminal window.  It may be different that the `%` sign.  You'll just type `git --version`.  Don't type the `%` in any of the other examples below.)
```
% git --version
```

+ Configure Git.

You need to tell Git what your name, email address and favorite
editor are. Below is the series of commands that you should
enter. Be sure to fill in the appropriate details for yourself

```
% git config --global user.name "YOUR NAME HERE"
% git config --global user.email "YOUR UMN EMAIL ADDRESS"
% git config --global core.editor "code"
```

If you have a favorite text editor (for example `emacs` or `vim` or `gedit`) then you can enter the command to start that editor where you entered `code` above.

Note that your name appears between double quotes since it has spaces
in it. Your email address doesn't, so it doesn't need to be in
quotes. If you would like "emacs -nw" as your editor (emacs such that
it doesn't open a new window but opens in the terminal) then you'll
want double quotes around that 2 word phrase.

Check that these are set correctly; execute

```
% git config -l
```


### Create a space for your Git workspaces

Create a directory in your CSE account named "csci2041" (You can use some other name, of course, but in the discussion we will assume that you used "csci2041").

```
% mkdir csci2041
% cd csci2041
```

In **csci2041** we will put copies of several "public" read-only repositories containing files that we want to distribute to you during the semester and also space for your individual repository that only you and the TAs and instructor have access to.


### Clone your individual repository

The Git "clone" operation makes a copy of a repository and places it
in your account.  This copy contains the files and also all the
history of changes---just like the repository stored on
https://github.umn.edu.

There are two ways to do this.

1.  If you **did not** choose to set up ssh access following Professor Favonia's "Complete Guide to Setting Up OCaml and Git": In your **csci2041** directory, execute the following

```
% git clone https://github.umn.edu/csci2041-sum21/repo-user0123.git
```

You'll be asked to enter your UMN Internet ID and password.

2. If you **did** set up ssh access following Professor Favonia's guide, execute the following:

```
% git clone git@github.umn.edu:csci2041-sum21/repo-user0123.git
```
You won't need to enter a password.

Either way this will create the directory called `repo-user0123`.   It will contain a **README.md** file.

Execute the following:
```
% cd repo-user0123
% ls
```

When you clone your repository Git will create some hidden files
stored in the **`.git`** directory that contain the long name of this
repository, so that we won't need to type it anymore.  
This directory contains the copy of the repository with all the past
history of changes to the files and other information.  So now there
are two copies of your repository.

These hidden files tell Git where the GitHub central server is so that
operations involving the server won't need this long name.

Execute the following:
```
% ls -a
% ls .git/
```

Modifying these hidden **`.git`** files by hand, or creating them by
copying directories, is an extremely bad idea. It will cause you many
headaches with Git. **So don't do it!**  


*You only need to do this clone step once to initially install the
repository in your CSELabs account.*

If you have another computer and want to do some of your lab work on
that, then you will need to repeat this step for that computer as
well.

### Commands that access the repository

The following command reads these hidden files and will tell you the
URL of the central repository, and some other information.

Execute the following:
```
% git remote --verbose
```

A status operation will also tell you if you've made changes to your
workspace since the last time you updated it with files from the
repository. This is important because we grade your work by getting it
out of your repository. If it is in your workspace but not the central
GitHub repository we can't see it and it won't be graded.

Run the following: ``` % git status ``` Since the files in your
workspace (see below) and repositories (both local and the one on
https://github.umn.edu) are the same, Git tells you as much.


### Working files

So, if the hidden directory **`.git`** is another copy of the
repository, what are the files in this directory?

These files are copies of the files that you can edit.  You can create
new files and delete files that are no longer needed.  **But**, we
will need to "commit" any changes that we make to these files to the
repository, eventually, so that the repository and the "working files"
in your account are synchronized.

### Commands that access the repository

The following command reads these hidden files and will tell you the
URL of the central repository, and some other information.

Execute the following:
```
% git remote --verbose
```



A status operation will also tell you if you've made changes to your
workspace since the last time you updated it with files from the
repository. This is important because we grade your work by getting it
out of your repository. If it is in your workspace but not the central
GitHub repository we can't see it and it won't be graded.

Run the following: ``` % git status ``` Since the files in your
workspace (see below) and repositories (both local and the one on
https://github.umn.edu) are the same, Git tells you as much.


### Working files

So, if the hidden directory **`.git`** is another copy of the
repository, what are the files in this directory?

These files are copies of the files that you can edit.  You can create
new files and delete files that are no longer needed.  **But**, we
will need to "commit" any changes that we make to these files to the
repository, eventually, so that the repository and the "working files"
in your account are synchronized.

Create a `lab0` directory and change into it by executing the following:

```
% mkdir lab0
% cd lab0
```

Using the text editor of your choice, create a file named `nsum.ml`
in your just-created `lab0` directory.  We'll use VSCode in this example, so you will just type:

```
% code nsum.ml
```

Copy the following OCaml code into that file and save it.
```ocaml
(* Author: Dr. Nick
   Modified by: ... replace the text between the dots with your name ... *)

(* A function computing the sum of the non-negative numbers between 0 and n *)
let rec nsum n = if n <= 0 then 0 else n + nsum (n - 1)
(* compute 0 + 1 + 2 + ... + 10 *)
let k = nsum 10
```

Add your name into the comment on the second line of the file, and save it.

Don't worry about the rest of the file, we will learn how to read this
OCaml code soon enough.

### Adding files

Check the status of your working files and repository by executing the
following:

```
% git status
```

This tells you that there is now an "untracked" file named `nsum.ml`
and that Git is not tracking changes to this file.  To tell Git to do
so, we must `add` the file using the following command:

```
% git add nsum.ml
```

Now run `git status` again and see what it says.  What is Git telling
you here?

### Committing changes

Git is now aware of this file and sees that changes have been made
that have not be "committed".  Only "committed" changes to the file
will be pushed up to the central GitHub server (http://github.umn.edu)
and thus it is only these that will be graded or assessed.

To commit the file changes you've made, execute the following
```
% git commit -m "Adding my name to the file"
```

Now go back to your browser and refresh the page showing your
repository.  Does this file show up there?

No, it doesn't.  The **`commit`** command adds your changes to your
local repository only.  We now need to **`push`** those changes from
your local repository up to the one stored on https://github.umn.edu.
We will do that next.

But first, run ``` % git status ``` What is it telling you?  Your
changes are committed to the local repository but not the "central"
one on https://github.umn.edu


### Pushing changes

Type
```
% git push
```
This pushes your changes from your local repository up to the central
one.

Run
```
% git status
```
again.  It should now tell you that your working copy of the files and
both repositories are all synchronized.


In your web browser, check that a file named `lab0_feedback.md` has
been added to your repository.  You can click on the link to see its
contents.  These files will typically be generated for your
labs as soon as you push changes to your programs up to GitHub.
If the results here are not what you expect then you need to either
fix the issues identified with your program, or, talk to a TA or post
a question on Discord to see if there is a problem with the tools that
automatically generate these files.

In this case, these tools will verify that your program is in the
right directory, and in the right file.  Congratulations, you have set up git, and are almost ready to start the lab!


### Clone the public repository

Go back to your **csci2041** directory, by executing the following
command:
```
% cd ../..
```

Now clone the public class repository by executing the following
command:

```
% git clone http://github.umn.edu/csci2041-sum21/labs2041.git
```

or with ssh:

```
% git clone git@github.umn.edu:csci2041-sum21/labs2041.git
```

In the directory `labs2041/lab1` you will see the Markdown file
`lab1.md` from which this web page is generated, as well as a few other files that we will deal with below.

When we add new files to the central repository you will be asked to
execute the following:
```
% git pull
```
This "pulls" changes from the central repository down to your local
one and updates the working copy of those files in your account with
the changes.

Try it.  It doesn't have any effect, but it doesn't cause any harm
either.


# Interacting with an OCaml program

Now `cd` to the public lab exercise repository and do a `git pull` to
make sure you have the latest lab exercise materials.  You should find a directory there named `lab1`, and inside that directory will be files named `lab1.ml`, `functions.ml`, and `listfun.ml`.
Copy the directory and files to your personal repository, and remember
to do a `git add` on both.  

In this class, a typical method of developing and debugging OCaml programs will involve three windows or tabs:

+ You will write code in a text editor; several commonly used editors (e.g. emacs, gedit, atom, vscode)
  understand OCaml syntax and support syntax highlighting to help format your code.
  Open `lab1.ml` in VSCode (or your text editor of choice)

+ A terminal window with a shell in the directory where your code
  resides.  You can build and run the program from the shell using the
  command `ocamlc`.  To try building an executable for the program in `labex1.ml`, type
  ```
  % ocamlc -o lab1 lab1.ml
  ```
  at the shell prompt now.  The compiler will fail, since the program has
  several deliberate bugs; we'll get to these a bit more in a moment.

+ An ocaml top-level shell.  OCaml has a top-level
  Read-Evaluate-Print-Loop (REPL) shell that is included by default as
  `ocaml`, or we can use the nicer `utop` REPL, which provides
  name-completion and syntax highlighting, but otherwise functions in
  the same way as `ocaml`.  To load a file in `utop`, we first start
  utop in a terminal window:
  ```
  % utop
  ```
  Then at the `utop` shell prompt, we can load a file using the `#use`
  _directive_.  A _directive_ is a command given to the REPL shell
  that is not a valid part of an OCaml program: we'll never type
  `#use` in a `.ml` file.  To attempt to compile and test out
  `lab1.ml` in `utop`, type the following at the `utop` prompt:
  ```
  utop # #use "lab1.ml" ;;
  ```
  `utop` will attempt to compile labex1.ml and will also print out an
  error message.   (The `;;` delimiter is also a command to the REPL,
  telling it to read and evaluate whatever you've typed so far.  It
  should also never be used in a `.ml` file).
  Both atom (using the `platformio-ide-terminal` package) and VSCode allow you to open a terminal pane within the editor so you don't need to switch between windows to do this.

# 1. Debugging some errors

Now that we've got our programming environment set up, with the
editor, terminal and REPL loop, let's go back and look at what
`ocamlc` told us when we tried to compile `lab1.ml`.  In that
terminal window, you should see the error message:
```
File "lab1.ml", line 4, characters 17-18:
Error: Syntax error: operator expected.
```
Back in your editor, find the 4th line:
```
let zero = (-2 + )
```
We see that immediately before characters 16 and 17 there is a `+` but
there is no argument to `+`.  This is a syntax error, because there's
no way to read this as a valid expression (to _parse_ the line).  You
should fix this error by supplying a second argument to `+` that will
bind the name `zero` to the expected value.

If we try to build the program again using `ocamlc -o lab1 lab1.ml`, we'll
see a new error message.  This is progress! But we're not done yet:
```
File "lab1.ml", line 6, characters 4-7:
Error: Syntax error
```
Go back and find line 6 in the text editor window.  It might look like
this line is OK as a let expression: it defines a function that
returns its argument.  The problem here is that `fun` is an OCaml
keyword and can't be used as a variable name.  (Similarly, `function`
is also a keyword and can't be used.)  Choosing a new name for the
function, e.g. `fn` will fix this error; go ahead and do this.

Building again, you'll find another Syntax Error on the next line.
See if you can figure out from looking at the line in your text editor
what the problem is.  (Fixing this problem will also require changing
another line later in the program.)  Another very similar syntax error
appears on line 8.  You can again fix it by changing the name of a
variable, although this time the variable is an argument.

Once these syntax errors are cleared up, if you build again, you'll
see the error message:
```
File "lab1.ml", line 10, characters 17-18:
Error: Unbound value y
```
Find line 10 in the editor: can you see the problem?

The compiler is telling us that the let declaration on line 10 defines
a function, `mult`, which references the name `y`, but `y` has not
been bound (defined) before. Looking at the definition of `mult`, we
see that only one variable name appears on the left of the `=` sign,
but two names are used on the right.  If we add `y` to the list of
arguments, this error should go away; try it now.

The next compiler error looks very similar:
```
File "lab1.ml", line 12, characters 16-17:
Error: Unbound value x
```
Look at line 12 and see if you can fix the problem.

Moving on, we get an interesting error:
```
File "lab1.ml", line 14, characters 17-24:
Error: This expression has type string but an expression was expected of type
         int
```
Look at line 14; characters 17-24 are the string literal `"hello"`.
Why does OCaml "expect" an expression of type `int` here?  This is
because we're trying to give `"hello"` as an argument to the operator
`+`, which only operates on `int`s.  This is what's called a _type
error_, because we're calling a function or operator with an argument
whose expression evaluates to a different type than the one expected
by the callee.

What causes an error like this?  Well, either we're passing the wrong
arguments to the operator `+`, or, we're using the wrong operator.
Since it looks like this line of code is trying to concatenate the
arguments, we probably meant to call the string concatenation
operator, `^`.  Change this in the code and see what happens next.

If we now try to build the code, we get what looks like another type
error:
```
File "lab1.ml", line 16, characters 41-58:
Error: This expression has type int -> string
       but an expression was expected of type int
```
Looking at line 16, it seems that we are trying to take the last `t`
characters from the string `s`, by calling `String.sub` with the
arguments `s`, `last - t` and `t`.  But the compiler is complaining
about the "expression" `String.sub s last`.  What's going on?

The problem is that infix operators have a higher lower precedence
than function application, so instead of thinking we want to pass
`last - t` as an argument to `String.sub s`, the compiler thinks we
meant to pass `String.sub s last` as an argument to `-`.  We can fix
this with parentheses around `last - t` in order to clear up what the
arguments are to `-`.  Do this and try to build the file again.

Hey!  we made it!  Let's execute the program and see what happens.  At
the terminal shell prompt, type:
```
% ./lab1
```
You should see:
```
Fatal error: exception Invalid_argument("index out of bounds")
```
Uh oh.  Now what?  This is an example of a _run-time error_, a program
bug that happens when we encounter conditions that the compiler can't
predict before hand.  What's going wrong here?  Let's switch to the
`utop` top-level shell and try to compile and evaluate `lab1.ml`:
```
utop # #use "lab1.ml" ;;
val zero : int = 0
val fn : 'a -> 'a = <fun>
val beginning : string -> char = <fun>          
val len : string -> int = <fun>
val mult : int -> int -> int = <fun>
val or3 : bool -> bool -> bool -> bool = <fun>
val helloworld : string = "helloworld"
val ending : string -> int -> string = <fun>
Exception: Invalid_argument "index out of bounds".
```
It looks like the run-time error is happening after we evaluate the
let declaration binding `ending`.  If we look in the text editor, the
next expression is:
```
let c = beginning ""
```
What's going on here?  The type of `beginning` is `string -> char`,
and we're calling it with `""`, a string; so there's not a type error
or a syntax error here.  If we look at the definition of `beginning`,
we see that `beginning s` returns `s.[0]`, that is, it tries to return
the character at index `0` of its argument.  Since the argument here
is the empty string, `""`, it doesn't have a character at index 0,
resulting in the `index out of bounds` exception.  We'll learn later
how to handle exceptions; for now you can go ahead and "fix" this
problem by commenting out the offending expression.  Build and run the
program one last time, and declare victory!

_**Test cases:**_ No partial credit for this problem, `lab1.ml` must compile and run without errors while correctly binding all of the names it currently binds.

# 2. Writing new OCaml Functions

Now that we're experienced at understanding error messages, let's continue by writing some new Ocaml functions.  Open the file in your `lab1` directory called `functions.ml`.  

### Sumthing good?

In episode 1.2 and the synchronous meeting we saw the function `sumup : int -> int` that adds the integers `0` through `n`.  Let's write some similar functions:

+ Add a definition (to `functions.ml`) for a function `sumsquares : int -> int` such that `sumsquares n` is the sum of the squares of the integers from `0` to `n`, e.g. `sumsquares 0` should evaluate to 0, `sumsquares 1` should evaluate to `1`, and `sumsquares 4` should evaluate to 1 + 4 + 9 + 16 = `30`.

+ Now add a definition for a function `sumodds` such that `sumodds n` sums only the odd numbers between 1 and `n`, eg `sumodds 1` should evaluate to `1`, sumodds `4` should evaluate to `1+3`, and `sumodds 8` should evaluate to 1 + 3 + 5 + 7 = `16`.

+ *Challenge:* We can generalize both of these functions to the functions `sumf : (int -> int) -> int -> int`, which takes a function `f : int->int` and an int `n` as arguments, and returns `f 0` + `f 1` + ... + `f n`.  In the first case, `f = (fun n -> n*n)` and in the second, `f = (fun n -> if n mod 2 = 1 then n else 0)`  Write a definition for the function `sumf`.  Some test cases include `sumf (fun n -> 1) 10` = `11`, `sumf (fun n -> 2*n) 5` = `30`, and `sumf (fun n -> (n land 1)*n) 8` = `16`.

### String things

+ Write a function `countc : string -> char -> int` such that `countc s c` counts the number of times character `c` appears in the string `s`.  So for example `countc "acab" 'a'` should evaluate to `2`; `countc "birdofprey" 'z'` should evaluate to `0`; and `countc "zzzzz" 'z'` should evaluate to 5.  Hint: you will probably find it useful to define a helper function that counts the number of times `c` appears between either the beginning of the string and a given index or the end of the string and a given index.  

+ Write a function `rightjustify : int -> int -> string` such that `rightjustify w n` returns a string representation of `n` padded with enough spaces in front so that the string has width `w`.  (If the string representation of `n` has length greater than `w`, no padding should be added).  So `rightjustify 5 123` should evaluate to the string `"  123"` and `rightjustify 1 314` should evaluate to the string `"314"`

_**Test Cases:**_ For full credit your solution should pass 11/14 of the example evaluations given above.

# 3. Vector functions

Let's finish this lab exercise by writing a few functions that deal with 2-dimensional vectors, represented as pairs of `float`s.   (As a reminder, a 2-dimensional vector is basically just an (x,y) point in space: its length is its
distance from the origin - (0,0)) Create a file named `vector.ml` in your `lab1` directory.  Open `vector.ml` in the text editor and try writing OCaml definitions for the following functions:

### `scale`

Scalar multiplication of a vector by a real number simply multiplies both
components by the scalar.  Write a definition for `scale : float -> float * float -> float * float`  so that:

+ `scale 3. (1., 2.)` evaluates to `(3., 6.)` and
+ `scale 2. (-1.,4.)` evaluates to `(-2.,8.)`.

### `length`

The length of a vector (a,b) is the square root of a * a  + b * b.  So if we define `length : (float*float) -> float` we should have:

+ `length (3.,4.)` should evaluate to `5.`
+ `length (5.,12.)` should evaluate to `13.`

(There is an OCaml function, `sqrt : float -> float`, that computes
the square root of a floating-point number.)

### `vec_add`

We can use OCaml's tuples to represent two-dimensional vectors as
pairs of `float`s.  Write the OCaml definition for the function
`vec_add : (float * float) -> (float * float) -> (float*float)` that
adds two vectors together.  Some sample evaluations:

+ `vec_add (1.0,2.5) (3.0,-1.0)` evaluates to `(4., 1.5)`
+ `vec_add (0.0,1.0) (2.0,2.0)` evaluates to `(2., 3.)`

### `dot`

Recall that the dot-product or inner product of two vectors is the sum of the
component-wise products, e.g. in "math" the dot product of (a,b) and (c,d) is
a×c+b×d.  Write the OCaml definition for the function `dot : (float * float) ->
(float * float) -> float` to compute the dot product of two 2-dimensional
vectors.  Some sample evaluations:

+ `dot (0.0,2.0) (1.0,3.14)` evaluates to `6.28`
+ `dot (1.0,-1.0) (3.0,4.0)` evaluates to `-1.`

### `perp`
Two vectors are perpendicular or orthogonal if their inner product is 0.  Write the OCaml definition for the function `perp : float*float
-> float*float -> bool` that returns true if its arguments are
perpendicular and false otherwise.  Sample evaluations:

+ `perp (0.,1.) (-1.,0.)` evaluates to `true`
+ `perp (1.,2.) (-1.,1.)` evaluates to `false`

For implementation simplicity, assume that the 0-vector `(0.,0.)` is
perpendicular to any vector, including itself.


Your solution must pass 6/10 test cases to get full credit for this problem.

# 4. Some functions on lists

The file `lab1/listfun.ml` contains some syntax to get you started on this problem.  

### `range`

Students who have coded in python will likely be familiar with the function `range`, which can be used as a way to iterate through a list of integers via the idiom `for i in range(m,n): ...`.  Write the equivalent ocaml function:
```
range : int -> int -> int list
```
that takes two integers as parameters, and returns a list of all integers that are at least its first argument, and less than its second argument, that is:

+ `range 1 10` evaluates to `[1; 2; 3; 4; 5; 6; 7; 8; 9]`
+ `range 2 3` evaluates to `[2]`
+ `range 10 1` evaluates to `[]` (because there are no integers that are greater than or equal to `10` and less than `1`)

### `sum_positive`

The function `sum_positive : int list -> int` should take a list of integers as a parameter and return the sum of all of the positive integers in the list.  Some example evaluations:

+ `sum_positive []` evaluates to `0` because the sum of no integers is `0`.
+ `sum_positive [-1]` evaluates to `0`.
+ `sum_positive [1;-1;17]` evaluates to `18`

### `list_cat`

The function `list_cat : string list -> string` should take as input a list of
strings and produces the concatenation of the strings in the list.  Some example evaluations:

+ `list_cat ["what"; "is"; "this"; "I"; "don't"; "even"]` evaluates to
`"whatisthisIdon'teven"`.  
+ `list_cat []` evaluates to `""`.
+ `list_cat ["short "; "list"]` evaluates to `"short list"`

### `take`

The `listfun.ml` file contains a buggy implementation of the function `take :
int -> 'a list -> 'a list`.  The intended behavior is that `take n lst` returns
the first `n` elements of `lst`, or all of `lst` if it has fewer than `n`
elements.  Some example evaluations:

+ `take 1 []` evaluates to `[]`
+ `take 2 [ "a"; "b"; "c" ]` evaluates to `["a"; "b"]`
+ `take 0 [ 1; 2; 3 ]` evaluates to `[]`

Fix the implementation in the file to match this behavior.

### `unzip`

The `unzip` function takes as input a list `lst` of pairs, and returns a pair of
lists `(l1,l2)`: `l1` contains the first element of each pair in `lst` and `l2`
contains the second element of each pair in `lst`. Some example evaluations:

 + `unzip [ ("a",100); ("b",99); ("c",98) ]` should evaluate to `(["a"; "b"; "c"], [100; 99; 98])`
 + `unzip []` should evaluate to `([],[])`
 + `unzip [(true,"T");(false, "F")]` should evalate to `([true; false], ["T"; "F"])`

_**Test cases:**_ Your solution must compile and agree on 12/15 example evaluations given above to get full credit for this question.
