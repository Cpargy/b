let fixduck = List.map (function
  | "goose" -> "grey duck"
  | "duck" -> "duck"
  | s -> s ^ " duck" )

let hex_list = List.map (Printf.sprintf "%X")

let de_parenthesize = List.filter (function | '(' | ')' -> false | _ -> true)

let p_hack = List.filter (fun (p,s) -> p <= 0.05)

