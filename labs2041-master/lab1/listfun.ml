(* listfun.ml - lab exercise 1.4, CSci 2041, Summer 2021 *)
(* Your Name Here *)


(* Complete these functions on int lists *)
let rec range (m:int) (n:int) = range n m
let rec sum_positive (ls: int list) = 0
let rec list_cat (ls : string list) : string = ""

(* Fix this definition *)
let rec take m lst = match (m,lst) with
| (_,[]) -> []
| (n,h::t) -> h::(take (n-1) t)
| (0,_) -> []

(* Perhaps a little trickier *)
let rec unzip (ls : ('a * 'b) list) : ('a list) * ('b list) = ([],[])
