(* syntax.ml  -- LabEx8 Part 1*)

(* Type for representing program fragments. Note the mutual recursion *)
type expr =
| Mul of expr * expr
| Add of expr * expr
| IntC of int
| Sub of expr * expr
| Div of expr * expr
| Let of string * expr * expr
| Name of string
| If of boolExpr * expr * expr
and boolExpr =
  Eq of expr * expr
| Gt of expr * expr
| Lt of expr * expr
| And of boolExpr * boolExpr
| Or of boolExpr * boolExpr
| Not of boolExpr
| BoolC of bool


(* Evaluation of exprs and boolExprs.  Note mutual recursion *)
let rec eval e env benv = match e with
| Mul (e1,e2) -> (eval e1 env benv) * (eval e2 env benv)
| Add (e1,e2) -> (eval e1 env benv) + (eval e2 env benv)
| IntC i -> i
| Sub (e1,e2) -> (eval e1 env benv) - (eval e2 env benv)
| Div (e1,e2) -> (eval e1 env benv) / (eval e2 env benv)
| Let (nm,e1,e2) -> let v = (eval e1 env benv) in eval e2 ((nm,v)::env) benv
| Name n -> List.assoc n env
| If (cnd,thn,els) -> if (beval cnd env benv) then eval thn env benv else eval els env benv
and beval bx env benv = match bx with
| And (l,r) -> (beval l env benv) && (beval r env benv)
| Or (l,r) -> (beval l env benv) || (beval r env benv)
| Not ex -> not (beval ex env benv)
| Eq (e1,e2) -> (eval e1 env benv) = (eval e2 env benv)
| Gt (e1,e2) -> (eval e1 env benv) > (eval e2 env benv)
| Lt (e1,e2) -> (eval e1 env benv) < (eval e2 env benv)
| BoolC b -> b

let e_collatz = IntC 0 (* Change this *)

let e_ifchain = IntC 0 (* and this *)

let e_uclid = IntC 0 (* and this *)
