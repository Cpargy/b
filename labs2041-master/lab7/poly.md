# `poly.md`

### Property `P`
`P(p)`: `deg p` ≡ `deg (simplify p)`.

### Base Cases:
There are two non-inductive constructors, so we must prove:

+ `P(X)`: `deg (simplify X) ≡ deg X` by evaluation of `simplify`, ✓
+ `P(Int i)` : `deg (simplify (Int i)) ≡ deg (Int i)` by evaluation of `simplify`, ✓

Then we have two inductive cases to prove:

### Inductive Case
We want to prove that for all `p1, p2 : polyExpr`, [`deg p1 ≡ deg (simplify p1)` and `deg p2 ≡ deg (simplify p2)`] ⇒ [`deg Add(p1,p2) ≡ deg (simplify (Add (p1,p2)))`].  Thus we assume the following

#### IH:
`deg p1 ≡ deg (simplify p1)` and `deg p2 ≡ deg (simplify p2)`.

Then we have:

`deg (simplify (Add(p1,p2))) ≡ deg Add(simplify p1, simplify p2)` **[eval simplify]**
`≡ max (deg (simplify p1)) (deg (simplify p2))` **[eval deg]**
`≡ max (deg p1) (deg p2)` **[by IH]**
`≡ deg (Add (p1,p2))` **[reverse val `deg`]**, ✓

### Inductive Case
We want to prove that for all `p1, p2 : polyExpr`, [`deg p1 ≡ deg (simplify p1)` and `deg p2 ≡ deg (simplify p2)`] ⇒ [`deg Mul(p1,p2) ≡ deg (simplify (Mul (p1,p2)))`].  Thus we assume the following

#### IH:
`deg p1 ≡ deg (simplify p1)` and `deg p2 ≡ deg (simplify p2)`.

Then we have:

`deg (simplify (Mul(p1,p2))) ≡ deg Mul(simplify p1, simplify p2)` **[eval simplify]**
`≡ (deg (simplify p1)) + (deg (simplify p2))` **[eval deg]**
`≡ (deg p1) + (deg p2)` **[by IH]**
`≡ deg (Mul (p1,p2))` **[reverse val `deg`]**, ✓

### Note
Technically we skipped the following intermediate step:
if `(simplify p1, simplify p2)` matches `(Int _, Int _)` then
`deg simplify (Mul (p1,p2)) ≡ deg (Int _) ≡ 0 ≡ 0+0 ≡ (deg (simplify p1)) + (deg (simplify p2)) ≡ (deg p1) + (deg p2)`, and the same step with `max` swapped for `+` in the `Add` case. 
