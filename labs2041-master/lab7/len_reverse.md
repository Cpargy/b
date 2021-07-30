# `length (reverse l) ≡ (length l)`

### Property
P(l): `length (reverse l) ≡ (length l)`

### Base Case
P([]):`length (reverse []) ≡ (length [])`

We have

+ `length (reverse [])` ≡ `length []` ***[eval of `reverse`]***, ✓

### Inductive Case
∀ l . [`length (reverse l) ≡ (length l)`] ⇒ [ ∀ h . `length (reverse (h::l)) ≡ (length (h::l))` ]

#### IH: `length (reverse l) ≡ (length l)`
Let `h` be an arbitrary element, then we want to show that `length (reverse (h::l)) ≡ (length (h::l))`:

+ `length (reverse (h::l))` ≡ `length (append (reverse l) [h])` ***[eval of `reverse`]***
+ ≡ `(length (reverse l)) + (length [h])` ***[length(append) thm.]***
+ ≡ `(length l) + (length [h])` ***[by IH]***
+ ≡ `(length l) + 1` ***[2x eval of `length`]***
+ ≡ `(length (h::l))` ***[reverse eval of `length`]***, ✓
