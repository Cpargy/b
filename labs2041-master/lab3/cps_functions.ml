type 'a btree = Node of 'a * 'a btree * 'a btree | Empty

let rec length_k lst k = k 0

let rec find_all_k p lst k = k []

let rec postorder_k t k = k []

let rec flip_tree_k t k = k Empty
