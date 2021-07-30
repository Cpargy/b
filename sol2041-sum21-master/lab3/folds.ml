(* rank - acc (r) counts how many elements are less than x *)
let rank x = List.fold_left (fun r next -> r + (if next < x then 1 else 0)) 0

(* prefixes -
  accumulate the list of prefixes left-to-right; the next prefix is formed by
  appending the current element to the end of the previous prefix.
  *)

let prefixes = List.fold_left (fun (h::t) x -> (h@[x])::(h::t)) [[]]

(* another way, without pattern matching... *)
let prefixes = List.fold_left (fun acc x -> ((List.hd acc)@[x])::acc) [[]]

(* suffixes -
  fold in each element by consing it onto the head of the previous suffix;
  cons that whole suffix onto the list of all suffixes *)
let suffixes ls =  List.fold_right (fun x (h::t) -> (x::h)::(h::t)) ls [[]]

(* same goes for suffixes *)
let suffixes ls = List.fold_right (fun h r -> (h::(List.hd r))::r) ls [[]]

