(* imperative.ml - representing imperative programs *)
type result = IntR of int | BoolR of bool | UnitR
type expType = BoolT | IntT | UnitT
exception TypeError of string

type expr =
(* arithmetic *)
IntC of int | Add of expr*expr | Sub of expr*expr
| Mul of expr*expr | Div of expr*expr
(* booleans *)
| BoolC of bool | And of expr*expr | Or of expr*expr | Not of expr
(* comparisons *)
| Eq of expr*expr | Gt of expr*expr
(* binding *)
| Let of string*expr*expr | Name of string
(* conditionals *)
| If of expr*expr*expr
(* Imperative! *)
| Set of string*expr (* set var = value, assignment *)
| While of expr*expr (* while (e1) e2 *)
| Seq of expr list (* { e1; e2; e3 } *)

let p1 =
  Let ("x",IntC 1, Seq([
  Set ("x",Add(Name "x",IntC 1));
  Let ("y",Name "x",
  Name "y")]))

(* implementing assignment *)
let rec assign name value store =
  match store with
  | [] -> failwith "unbound assign"
  | (n,v)::t when n=name -> (name,value)::t
  | b::t -> b::(assign name value t)

let rec eval exp store = match exp with
| IntC i -> (IntR i, store) | BoolC b -> (BoolR b, store)
| Add (e1,e2) -> evalArith e1 e2 (+) store
| Mul (e1,e2) -> evalArith e1 e2 ( * ) store
| Sub (e1,e2) -> evalArith e1 e2 (-) store
| Div (e1,e2) -> evalArith e1 e2 (/) store
| And (e1,e2) -> evalBool e1 e2 (&&) store
| Or (e1,e2) -> evalBool e1 e2 (||) store
| Not e -> let (BoolR b, st) = eval e store in (BoolR (not b), st)
| Gt (e1,e2) -> evalComp e1 e2 (>) store
| Eq (e1,e2) -> evalComp e1 e2 (=) store
| If (c,t,e) -> evalIf c t e store
| Let (n,v,b) -> evalLet n v b store
| Name n -> (List.assoc n store, store)
| Set (name,v) -> let (vr,st') = (eval v store) in
    (UnitR, assign name vr st')
| Seq elist -> evalSeq elist store
| While (c,b) -> evalWhile c b store
and evalSeq el st = match el with
| [] -> (UnitR, st)
| [e] -> eval e st
| e::t -> let (_,st') = eval e st in evalSeq t st' (* tail rec! *)
and evalWhile c l st =
  let (BoolR b, st1) = eval c st in
  if not b then (UnitR, st1) else
  let (_, st2) = eval l st1 in evalWhile c l st2 (* tail rec! *)
and evalArith e1 e2 op st =
  let (IntR i1, st1) = eval e1 st in
  let (IntR i2, st2) = eval e2 st1 in (IntR (op i1 i2),st2)
and evalBool e1 e2 op st =
  let (BoolR b1, st1) = eval e1 st in
  let (BoolR b2, st2) = eval e2 st1 in (BoolR (op b1 b2),st2)
and evalComp e1 e2 op st =
  let (r1, st1) = eval e1 st in
  let (r2, st2) = eval e2 st1 in (BoolR (op r1 r2),st2)
and evalIf c t e st =
  let (BoolR b, st1) = eval c st in
  if b then eval t st1 else eval e st1
and evalLet n v b st =
  let (vr,st1) = eval v st in
  let (br,_::st2) = eval b ((n,vr)::st1)
  in (br, st2) (* no new bindings, strip n out of the state *)

let rec typeof exp ctx = match exp with
| Set (n,v) -> if (typeof v ctx) = (List.assoc n ctx) then UnitT
  else raise (TypeError "Set")
| While (c,b) -> if typeof c ctx = BoolT then
  let _ = typeof b ctx in UnitT else raise (TypeError "While")
| Seq [] -> UnitT
| Seq [e] -> typeof e ctx
| Seq (e::t) -> let _ = typeof e ctx in typeof (Seq t) ctx
| BoolC _ -> BoolT | IntC _ -> IntT
| Add (e1,e2) | Mul (e1,e2) | Div (e1,e2) | Sub (e1,e2)
  -> (arithCheck e1 e2 ctx)
| And (e1,e2) | Or (e1,e2) -> (boolCheck e1 e2 ctx)
| Not e -> if (typeof e ctx) = BoolT then BoolT else
            raise (TypeError "Not")
| Gt (e1,e2) | Eq (e1,e2) -> (compCheck e1 e2 ctx)
| If (c,thn,els) ->
  (match (typeof c ctx, typeof thn ctx, typeof els ctx) with
  (BoolT,t1,t2) when t1=t2 -> t1 | _ -> raise (TypeError "If"))
| Name n -> List.assoc n ctx
| Let (n, e1, e2) -> letCheck n e1 e2 ctx
and boolCheck e1 e2 ctx = match (typeof e1 ctx, typeof e2 ctx) with
  | (BoolT, BoolT) -> BoolT
  | _ -> raise (TypeError "Bool")
and arithCheck e1 e2 ctx = match (typeof e1 ctx, typeof e2 ctx) with
  | (IntT, IntT) -> IntT
  | _ -> raise (TypeError "Arithmetic")
and compCheck e1 e2 ctx = match (typeof e1 ctx, typeof e2 ctx) with
  | (IntT, IntT) -> BoolT
  | _ -> raise (TypeError "Compare")
and letCheck n e1 e2 ctx =
  let t = (typeof e1 ctx) in
    typeof e2 ((n,t)::ctx)

(* example *)
let p2 = Let("x", IntC 1,
  While (BoolC true,
  Seq[
    Set("x", Add(Name "x", IntC 1));
    Set("x", Mul(Name "x", Name "x"))
  ]))


let e_gcd = IntC 0 (* Change this! *) 

let e_rsqr = IntC 0 (* Change this! *)

let rec unbound ex bl = ["change_me"] (* Change This! *)
