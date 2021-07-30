(* index sum: accumulate sum while also tracking index *)
let index_sum ls = 
        let rec idxloop i acc = function [] -> acc 
        | (h::t) -> idxloop (i+1) (i*h + acc) t
in idxloop 1 0 ls

(* msort with tail-recursive merge and split *)
let rec msort ls =
    let rec split lst (l1,l2) = match lst with
      | [] -> (l1,l2)
      | h::t -> split t (l2,h::l1) in
    let rec merge l1 l2 acc = match (l1,l2) with
      | ([],[]) -> List.rev acc
      | (h::t,[]) -> merge t l2 (h::acc)
      | ([],h::t) -> merge t [] (h::acc)
      | (h1::t1,h2::t2) -> if h1 < h2 then merge t1 l2 (h1::acc) else merge l1 t2 (h2::acc) in
    match ls with [] -> []
    | [h] -> [h]
    | _ -> let (l1,l2) = split ls ([],[]) in merge (msort l1) (msort l2) []

(* tail-recursive range: build accumulator from the back *)
(* you could also build it by incrementing m, and then reverse the result *)
let range m n =
  let rec tail_range m n acc = if m >= n then acc
    else tail_range m (n-1) ((n-1)::acc)
  in tail_range m n []

(* fully tail-recursive *@ operator
  simpler version with non-tail recursive append, would be fine, but
  stack space is technically not constant, it grows length of ls *)
let ( *@ ) m ls =
  (* revrevapp reverses l1 and then appends in reverse order to l2 *)
  let rec revrevapp l1 rl1 l2 = match (l1,rl1) with
  | ([],[]) -> l2
  | ([],h::t) -> revrevapp [] t (h::l2)
  | (h::t, _) -> revrevapp t (h::rl1) l2 in
  (*  It would be fine here to replace revrevapp call with (ls @ acc), but see note above *)
  let rec times m ls acc = if m = 0 then acc
    else times (m-1) ls (revrevapp ls [] acc)
  in times m ls []
