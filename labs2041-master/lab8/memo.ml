(* memo.ml - memoization with references *)

let rec pell n = match n with
| 0 -> 0
| 1 -> 1
| _ -> 2*(pell (n-1)) + (pell (n-2))

let rec alt4 n = match n with
| 0 -> 3
| 1 -> 1
| 2 -> 4
| 3 -> 2
| _ -> 1*(alt4 (n-1)) - (4 * (alt4 (n-2))) + (alt4 (n-3)) - (4 * (alt4 (n-4)))

(* replace these with correct definitions *)
let memopell n = 0

let memoalt4 n = 0
