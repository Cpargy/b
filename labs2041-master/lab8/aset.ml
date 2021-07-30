(* aset.ml - int sets as bool arrays *)

let s1 = [|false; true; false; false; false|] (* { 1 } *)
let s2 = [|false; true; true; false; false|] (* {1,2} *)
let s3 = [|false; true; true; true; false|] (* {1,2,3} *)

let empty max = Array.make max false
let is_empty a = Array.for_all not a
let add i a = a.(i) <- true
let mem i a = a.(i)
let union s1 s2 = Array.map2 (||) s1 s2
let inter s1 s2 = Array.map2 (&&) s1 s2
let length s = Array.fold_left (fun a b -> if b then a+1 else a) 0 s
let fold_left f a s = snd (Array.fold_left
  (fun (i,a) b -> (i+1, if b then (f a i) else a)) (0,a) s)

(* correct these *)

let subset s1 s2 = false

let of_list max lst = [||]
