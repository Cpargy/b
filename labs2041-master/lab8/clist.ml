type 'a clist = Nil | CCons of 'a * 'a clist ref
let chd = function Nil -> invalid_arg "chd" | CCons(h,_) -> h
let ctl = function Nil -> invalid_arg "ctl" | CCons(_,t) -> !t

let rec clist_of_list ls = match ls with
| [] -> Nil
| h::t -> CCons(h, ref (clist_of_list t))

(* fill in these two: *)
let make_cyclic cl = ()

let findcycle cl = false
