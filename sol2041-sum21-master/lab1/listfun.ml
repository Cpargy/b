(* listfun.ml - lab exercise set 2, CSci 2041, Spring 2019 *)
(* Your Name Here *)


(* Complete these functions on int lists *)
let rec range (m:int) (n:int) = if m >= n then []
  else m::(range (m+1) n)
let rec sum_positive (ls: int list) = match ls with
| [] -> 0
| h::t -> (sum_positive t) + (if h > 0 then h else 0)

let rec list_cat (ls : string list) : string = match ls with
| [] -> ""
| h::t -> h ^ (list_cat t)

(* Fix this definition *)
let rec take n lst = match (n,lst) with
| (_,[]) | (0,_ )-> []
| (n,h::t) -> h::(take (n-1) t)

(* Perhaps a little trickier *)
let rec unzip (ls : ('a * 'b) list) : ('a list) * ('b list) = match ls with
| [] -> ([],[])
| (a,b)::t -> let (aa,bb) = (unzip t) in (a::aa,b::bb)

(* a different solution, using helper functions: *)
(* grab the left element of each pair *)
let rec uzleft ls = match ls with
| [] -> []
| (h,_)::t -> h::(uzleft t)

(* grab the right element of each pair *)
let rec uzright ls = match ls with
| [] -> []
| (_,h)::t -> h::(uzright t)

let unzip ls = (uzleft ls, uzright ls)
