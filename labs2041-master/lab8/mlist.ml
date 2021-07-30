type 'a ll = { mutable hd : 'a ; mutable tl : 'a mlist}
 and 'a mlist = List of 'a ll | Nil

let rec list_of_mlist ml = match ml with
  | Nil -> []
  | List mc -> mc.hd :: (list_of_mlist mc.tl)

let mlist_of_list ls = Nil

let rev_mlist l = l

let append_m l1 l2 = Nil

(* Create a new list with b after the first occurence of a.
   raise Not_found if lst does not contain any occurrences of a
   This is the immutable list version *)
let rec insert_after a b lst = match lst with
  | [] -> raise Not_found
  | h::t -> if h=a then h::(b::t) else h::(insert_after a b t)

(* Create a list of all items in lst that do not satisfy the predicate p
  This is the immutable list version *)
let rec exclude p lst = match lst with
  | [] -> []
  | h::t -> let et = exclude p t in
            if (p h) then et else h::et

(* Modify the list ml to insert b after the first occurence of a *)
let rec insert_after_m a b ml = ()

(* Modify the list ml to exclude all items that satisfy the predicate p *)
let rec exclude_m p ml = ()
