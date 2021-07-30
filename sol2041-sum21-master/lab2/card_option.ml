type suit = Hearts | Clubs | Diamonds | Spades
type value = Simple of int | Jack | Queen | King | Ace
type card = { suit : suit; value : value }

(* fill this one in *)
let rec trick_winner_trump (cards : card list) (trump: suit option) =
  let better_val = function
  | (Simple nv, Simple cv) -> nv > cv
  | (Simple _, _) -> false
  | (_,Simple _) -> true
  | (nf, cf) -> nf > cf in
  let better_card c cw = match trump with
  | None -> (c.suit == cw.suit) && better_val (c.value,cw.value)
  | Some s -> (c.suit = s && cw.suit <> s) ||
    ((c.suit == cw.suit) && better_val (c.value,cw.value)) in
  match cards with
  | [] -> invalid_arg "empty trick"
  | lead::t -> let rec trick_helper cs cw = match cs with
    | [] -> cw
    | c::t -> if better_card c cw then trick_helper t c
              else trick_helper t cw in
    trick_helper t lead
