Suppose we have the following definition:

```ocaml
let fact n =
  let rec tr_fact i acc =
    if i = 0 then acc
    else tr_fact (i-1) (acc*i)
  in tr_fact n 1
```
And want to prove that for all `n : ℕ`, `fact n = n!`.  Due to the structure of `fact`, we will first prove that for all `n : ℕ`, for all `𝒶 : ℕ`,

> `tr_fact n 𝒶` ≡ n!`*`𝒶

Using the inductive definition `0!` = `1`, `n!` = `n*(n-1)!`.  (From the lemma, we get that `fact n`≡`tr_fact n 1` ≡ `n! * 1` ≡ `n!`.

# `tr_fact`

### Property
P(𝓃): ∀ 𝒶 . `tr_fact n 𝒶` ≡ `𝓃! * 𝒶`.

### Base Case
P(0): ∀ 𝒶 `tr_fact 0 𝒶` ≡ `0! * 𝒶`

We have:

`tr_fact 0 𝒶` ≡ 𝒶 **[eval of `tr_fact`]**

≡ `1 * 𝒶` **[arithmetic]**

≡ `0! * 𝒶`  **[definition of 0!]**, ✓

### Inductive Case
∀ 𝓃 . [ ∀ 𝒶 . `tr_fact 𝓃 𝒶` ≡ `𝓃! * 𝒶` ] ⇒ [ ∀ 𝒶 . `tr_fact (𝓃+1) 𝒶` ≡ `(𝓃+1)! * 𝒶` ]

#### IH: ∀ 𝒶 . `trfact 𝓃 𝒶` ≡ `𝓃! * 𝒶`.

We need to prove that ∀ 𝒶 `tr_fact (𝓃 + 1) 𝒶` ≡ `(𝓃+1)! * 𝒶`.  We have:

`tr_fact (𝓃+1) 𝒶` ≡ `tr_fact 𝓃  ((𝓃+1) * 𝒶)` **[eval of `tr_fact`]**

≡ `𝓃! * ((𝓃+1)*𝒶)` **[by IH]**

≡ `(𝓃+1) * 𝓃! * 𝒶` **[simplification]**

≡ `(𝓃+1)! * 𝒶` **[definition of factorial]**, ✓
