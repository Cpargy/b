(* Minnesota Whist *)

type card_suit = Clubs | Diamonds (* More stuff goes here *)
type card_value = Two | Three | King | Ace (* and here too... *)
type card = { value : card_value ; suit : card_suit }

(* Just generally a lot of missing code below... *)
let string_of_value v = match v with
| Ace -> "A"
| King -> "K"
| Three -> "3"
| Two -> "2"

let string_of_suit s = match s with
| Clubs -> "C"
| Diamonds -> "D"

let string_of_card { value; suit } = (string_of_value value) ^ (string_of_suit suit)

let suit_of_char c = match c with
| 'C' -> Clubs
| 'D' -> Diamonds
| _ -> invalid_arg "not a suit of cards!"

let value_of_string c = match c with
| "2" -> Two
| "3" -> Three
| "K" -> King
| "A" -> Ace
| _ -> invalid_arg "not a card value!"

let card_of_string s = let l = (String.length s) - 1 in
  { value = value_of_string (String.sub s 0 l) ; suit = suit_of_char s.[l] }

let trick_winner cards = match cards with
| [] -> invalid_arg "empty trick"
| lead::t -> lead (* the lead card is _not_ always the winner! *)