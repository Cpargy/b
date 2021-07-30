type 'a btree =
  Empty
  | Leaf of 'a
  | Node of 'a * 'a btree * 'a btree

let l0 = Leaf 1
let l1 = Leaf 2
let l2 = Leaf 4
let l3 = Leaf 8

let t0 = Node (9, Leaf 5, Leaf 12)
let t1 = Node (9, Leaf 6, Leaf 12)
let t2 = Node (9, Leaf 10, Leaf 12)
let t3 = Node (6, Leaf 3, t0)
let t4 = Node (6, Leaf 3, t1)
let t5 = Node (2, Leaf 0, t4)

let rec to_list t = match t with
| Empty -> []
| Leaf v -> [v]
| Node (v,lt,rt) -> (to_list lt) @ (v::(to_list rt))

let rec search v t = match t with
| Empty -> false
| Leaf v' -> v' = v
| Node (v',lt,rt) -> v'=v ||
  if (v < v') then search v lt else search v rt

let rec insert v t = match t with
| Empty -> Leaf v
| Leaf u -> if (v <= u)
  then Node (u, Leaf v, Empty)
  else Node (u, Empty, Leaf v)
| Node (u,lt,rt) -> if (v <= u)
  then Node(u, insert v lt, rt)
  else Node(u, lt, insert v rt)

(* finish this one *)
let rec tree_min t = match t with
| Empty -> None

(* and this one *)
let rec tree_max t = match t with
| Empty -> None

(* broken, fix it *)
let rec is_bstree t = match t with
  | Empty | Leaf _ -> true
  | Node (v,lt,rt) -> (is_bstree lt) && (is_bstree rt)  &&
    (match lt with Leaf v' | Node(v',_,_) -> v' <= v | Empty -> true ) &&
    (match rt with Leaf v' | Node(v',_,_) -> v' >= v | Empty -> true)
