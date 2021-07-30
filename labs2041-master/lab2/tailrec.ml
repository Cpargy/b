(* tailrec.ml - lab set 2, CSci 2041, Summer 2021 *)
(* Your Name Here *)

(* Fill in tail-recursive index-sum *)
let rec index_sum ls = 0

(* Fix this: it has bugs and must be tail recursive... *)
let rec msort ls =
  let rec split lst (l1,l2) = match lst with
    | [] -> (l1,l2)
    | h::t -> split t (l2,h::l1) in
  let rec merge l1 l2 = match (l1,l2) with
    | (_,[]) -> l1
    | ([],_) -> l2
    | (h1::t1,h2::t2) -> if h1 < h2 then h1::(merge t1 l2) else h2::(merge l1 t2) in
  let (l1,l2) = split ls ([],[]) in merge (msort l1) (msort l2)

(* Fill in tail recursive range *)
let rec range m n = []

(* *@ operator *)
let ( *@ ) : int -> 'a list -> 'a list =
  let rec helper acc n l = [] in fun n ls -> helper [] n ls
