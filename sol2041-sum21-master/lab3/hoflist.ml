
(* No let recs! *)

let implode ls = List.fold_right (fun c r -> (String.make 1 c)^r) ls ""

let dot = List.fold_left2 (fun s u v -> s +. (u *. v)) 0.

let onlySomes lst = List.filter (fun o -> match o with None -> false | _ -> true) lst

(* Double Trouble *)

let isPrime n = List.for_all ((<>) 0) (List.init (n-2) (fun i -> n mod (i+2)))

let deOption ls = List.map (function Some x -> x | None -> invalid_arg "deOption") (onlySomes ls)

