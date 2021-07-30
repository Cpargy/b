(* functions.ml - labex 1 problem 2 *)

let rec sumsquares n = if n = 0 then 0 else (n*n) + (sumsquares (n-1))

let rec sumodds n = if n = 0 then 0 else (sumodds (n-1)) + (if n mod 2 = 1 then n else 0)

let rec sumf f n = if n = 0 then (f 0) else (f n) + (sumf f (n-1))


(* With a helper function *)
let rec countc_helper s c idx = 
        if idx >= String.length s then 0
        else (if s.[idx] = c then 1 else 0) + (countc_helper s c (idx+1))

let countc s c = countc_helper s c 0 

(* With a nested function *)
let countc s c = 
        let n = String.length s in
        let rec fromi i = 
                if i >= n then 0 
                else (if s.[i] = c then 1 else 0) + (fromi (i+1))
        in fromi 0

(* rightjustify helper: make a string of k spaces *)
let rec spstr k = if k = 0 then "" else " " ^ (spstr (k-1))

let rightjustify w n = 
        let sn = string_of_int n in
        let wn = String.length sn in
        if wn >= w then sn else ((spstr (w-wn))^sn) 
