module Stack = struct
  type 'a t = 'a list
  let push x st = x::st
  let pop = function t::st -> st
  | [] -> invalid_arg "pop"
  let top = function t::st -> t
  | [] -> invalid_arg "top"
  let empty = []
end

module type N = sig
  val n : int
end

module Next(X: N) : N = struct
  let n = X.n+1
end

module N3 = Next(struct let n = 2 end)

module Nat = struct
  type t = Zero | Next of t
  let zero = Zero
  let incr x = Next x
  let decr = function Next x -> x | Zero -> invalid_arg "decr"
  let rec to_int = function Zero -> 0 | Next n -> 1 + (to_int n)
  let rec of_int = function 0 -> Zero | n -> Next (of_int (n-1))
end

module type NatSig = sig
  type t
  val zero : t
  val incr : t -> t
  val decr : t -> t
end

