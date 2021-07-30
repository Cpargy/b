let rec drop_until p lst = match lst with
| [] -> []
| h::t -> if (p h) then lst else drop_until p t

let rec take_while p = function
| [] -> []
| h::t -> if (p h) then h::(take_while p t) else []

let rec take_until p lst = match lst with
| [] -> []
| h::t -> if (p h) then [] else h::(take_until p t)
