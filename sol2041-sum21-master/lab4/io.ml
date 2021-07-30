(* io.ml -- lab exercise 6.2 solution *)

let rm_comment s = try (String.sub s 0 (String.index s '#')) with Not_found -> s
let uncomment f = 
    let ic = open_in f in
    let rec reader acc = 
        let nl = try Some (input_line ic) with End_of_file -> None in
        match nl with None -> List.rev acc | Some l -> reader ((rm_comment l)::acc)
    in let l = reader [] in let () = close_in ic in l

let tabulate l f = 
    let oc = open_out f in
    let rec ppair l = match l with [] -> ()
    | [(x,y)] -> Printf.fprintf oc "%.2e,%.2e" x y
    | (x,y)::t -> let () = Printf.fprintf oc "%.2e,%.2e\n" x y in  ppair t
    in let () = ppair l in close_out oc

