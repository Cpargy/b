(* exn.ml -- solution *)

exception Reflect of int
let reflector x = raise (Reflect x)
let catcher r x = try (r x) with Reflect y -> y

let make_opt f e = fun y -> try (Some (f y)) with x when x=e -> None
let rec safe_substr s b l = if (b < 0) then invalid_arg "safe_substr" 
   else try String.sub s b l with (Invalid_argument _) -> safe_substr s b (l-1)

let rec rm_assoc_exit k lst = match lst with [] -> raise Exit
| (kk,vv)::t -> if k=kk then t else (kk,vv)::(rm_assoc_exit k t)

let rm_assoc k lst = try rm_assoc_exit k lst with Exit -> lst

