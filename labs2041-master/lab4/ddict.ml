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

module ListDict = struct
    type ('k,'v) t = ('k * 'v) list
    let empty = []
    let add k v d = (k,v)::d
    let lookup k d = List.assoc k d
    let rec update k v d = match d with
      | [] -> [(k,v)]
      | (key,_)::t when key=k -> (k,v)::t
      | kv::t -> kv::(update k v t)
    let rec fold f a d = List.fold_left f a d
  end

(* Add ListDict Functor here *)
(* you'll need to add a sharing constraint like Dict with type k = and type v = *)
module EqListDict = struct end

(* Add DefaultElt signature here *)
module type DefaultElt = sig end

(* DefaultDict functor will also need a similar constraint: *)
module DefaultDict = struct end

(* DefaultDictFunctor will need a similar sharing constraint, but for *) 
(* both the Dict argument and the Dict output *)
module DefaultDictFunctor = struct end
