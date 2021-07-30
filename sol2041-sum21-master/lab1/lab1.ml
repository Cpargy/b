(* OCaml file for lab 1. 
   Fix the errors in this file.  *)

let zero = (-2 + 2 )

let fn x = x
let beginning s = s.[zero]
let len v = String.length v
  
let mult x y = x * y

let or3 x y z = x || y || z

let helloworld = "hello" ^ "world"

let ending s t = let last = (len s) - 1 in String.sub s (last - t) t  

(* let c = beginning "" *)
	       
let () = print_string (ending "Looks like we made it!\n" 9)

