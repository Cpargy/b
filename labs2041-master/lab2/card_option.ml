type suit = Hearts (* add some things here *)
type value = Simple of int | King | Ace (* and here *)
type card = { suit : suit; value : value }

(* fill this one in *)
let rec trick_winner_trump (cards : card list) (trump: suit option) = { suit=Hearts ; value = Simple 2}

