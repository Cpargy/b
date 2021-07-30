# `tr_len`

### Property
P(`ℓ`): ∀ 𝒶. `tr_len 𝒶 ℓ ≡ 𝒶 + length ℓ`

### Base Case
P([]): `tr_len 𝒶 [] ≡ 𝒶 + (length [])`

We have:

+ `tr_len 𝒶 [] ≡ 𝒶` ***[eval. `tr_len`]***
+ `≡ 𝒶 + 0` ***[arith.]***
+ `≡ 𝒶 + (length [])` ***[reverse eval `length`]***, ✓

### Inductive Case
Prove that P(`ℓ`) ⇒ ∀x. P(`x::ℓ`)

#### IH:
Assume that for all `𝒶`, `tr_len 𝒶 l ≡ 𝒶 + (length l)`

We want to prove that ∀`a`, ∀`x`, `tr_len a (x::l) ≡ a + (length (x::l))`

We have:

+ `tr_len a (x::l) ≡ tr_len (a+1) l` ***[eval `tr_len`]***
+ `≡ (a+1) + (length l)` ***[IH]***
+ `≡ a + (1 + (length l))` ***[arith]***
+ `≡ a + (length (x::l))` ***[reverse eval `length`]***, ✓
