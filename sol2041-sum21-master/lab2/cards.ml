(* Minnesota Whist *)

type card_suit = Clubs | Diamonds | Spades | Hearts
type card_value = Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King | Ace
type card = { value : card_value ; suit : card_suit }

let string_of_value v = match v with
| Ace -> "A"
| King -> "K"
| Queen -> "Q"
| Jack -> "J"
| Ten -> "10"
| Nine -> "9"
| Eight -> "8"
| Seven -> "7"
| Six -> "6"
| Five -> "5"
| Four -> "4"
| Three -> "3"
| Two -> "2"

let string_of_suit s = match s with
| Clubs -> "C"
| Diamonds -> "D"
| Spades -> "S"
| Hearts -> "H"

let string_of_card { value; suit } = (string_of_value value) ^ (string_of_suit suit)

let suit_of_char c = match c with
| 'C' -> Clubs
| 'D' -> Diamonds
| 'S' -> Spades
| 'H' -> Hearts
| _ -> invalid_arg "not a suit of cards!"

let value_of_string c = match c with
| "2" -> Two
| "3" -> Three
| "4" -> Four
| "5" -> Five
| "6" -> Six
| "7" -> Seven
| "8" -> Eight
| "9" -> Nine
| "10" -> Ten
| "J" -> Jack
| "Q" -> Queen
| "K" -> King
| "A" -> Ace
| _ -> invalid_arg "not a card value!"

let card_of_string s = let l = (String.length s) - 1 in
  { value = value_of_string (String.sub s 0 l) ; suit = suit_of_char s.[l] }

let trick_winner cards = match cards with
| [] -> invalid_arg "empty trick"
| lead::t -> let rec win_helper cs cw = match cs with
  | c::t -> if c.suit = lead.suit && c.value > cw.value then win_helper t c
            else win_helper t cw
  | [] -> cw
  in win_helper t lead
