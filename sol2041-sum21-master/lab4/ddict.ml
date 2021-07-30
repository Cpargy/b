module type Elt = sig
  type k
  type v
  val eq : k -> k -> bool
end

module type Dict = sig
  type t
  type k
  type v
  val empty : t
  val add : k -> v -> t -> t
  val lookup : k -> t -> v
end

(* Add EqListDict Functor here *)
module EqListDict(E : Elt) : Dict with type k = E.k and type v = E.v  = struct
  type k = E.k
  type v = E.v
  type t = (k * v) list
  let empty = []
  let add k v d = (k,v)::d
  let rec lookup k d = match d with
  | [] -> raise Not_found
  | (k',v)::t -> if E.eq k k' then v else lookup k t
end

(* Add DefaultElt signature here *)
module type DefaultElt = sig
  include Elt
  val default : v
end

(* DefaultDict functor: *)
module DefaultDict(E: DefaultElt) : Dict with type k = E.k and type v = E.v =
struct
  type k = E.k
  type v = E.v
  type t = (k * v) list
  let empty = []
  let add k v d = (k,v)::d
  let rec lookup k d = match d with
  | [] -> E.default
  | (k',v)::t -> if E.eq k k' then v else lookup k t
end

(* DefaultDictFunctor: *)
module DefaultDictFunctor(E : DefaultElt)(D: Dict with type k = E.k and type v = E.v):
Dict with type k = E.k and type v = E.v
 = struct
  include D
  let rec lookup k d = try D.lookup k d with Not_found -> E.default
end
