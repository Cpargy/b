(* Static analysis for programs with primitive types - Lab5 part 2 *)


type expr =
  Add of expr * expr
  | Mul of expr * expr
  | Sub of expr * expr
  | Div of expr * expr
  | IntC of int
  | Let of string * expr * expr
  | Name of string
  | If of expr * expr * expr
  | BoolC of bool
  | And of expr * expr
  | Or of expr * expr
  | Not of expr
  | Eq of expr * expr
  | Lt of expr * expr
  | Gt of expr * expr
type result = BoolR of bool | IntR of int 

let rec eval expr env = match expr with
  | Add (e1,e2) -> evalInt (+) e1 e2 env
  | Mul (e1,e2) -> evalInt ( * ) e1 e2 env
  | Sub (e1,e2) -> evalInt (-) e1 e2 env
  | Div (e1, e2) -> evalInt (/) e1 e2 env
  | IntC i -> IntR i
  | Let(n,v,b) -> let v1 = (eval v env) in (eval b ((n,v1)::env))
  | Name s -> List.assoc s env
  | If(cnd,thn,els) ->
     let (BoolR c) = eval cnd env in
     if c then (eval thn env) else (eval els env)
  | BoolC b -> BoolR b
  | And(e1,e2) -> evalBool (&&) e1 e2 env
  | Or(e1,e2) -> evalBool (||) e1 e2 env
  | Not(e) -> let (BoolR b) = (eval e env) in BoolR (not b)
  | Eq(e1,e2) -> BoolR ((eval e1 env) = (eval e2 env))
  | Lt(e1,e2) -> evalComp (<) e1 e2 env
  | Gt(e1,e2) -> evalComp (>) e1 e2 env
and evalInt f e1 e2 env =
  let (IntR i1, IntR i2) = (eval e1 env, eval e2 env) in
  IntR(f i1 i2)
and evalBool f e1 e2 env =
  let (BoolR b1, BoolR b2) = (eval e1 env, eval e2 env) in
  BoolR(f b1 b2)
and evalComp f e1 e2 env =
  let (IntR i1, IntR i2) = (eval e1 env, eval e2 env) in
  BoolR(f i1 i2)

let rec unbound exp bound = match exp with
  | IntC _ | BoolC _ -> []
  | Add(e1,e2)
  | Mul(e1,e2)
  | Sub(e1,e2)
  | Div(e1,e2)
  | And(e1,e2)
  | Or(e1,e2)
  | Eq(e1,e2)
  | Lt(e1,e2)
  | Gt(e1,e2) -> (unbound e1 bound) @ (unbound e2 bound)
  | Not e -> unbound e bound
  | If(e1,e2,e3) -> (unbound e1 bound) @ (unbound e2 bound) @ (unbound e3 bound)
  | Name n -> if (List.mem n bound) then [] else [n]
  | Let(n,v,b) -> (unbound v bound) @ (unbound b (n::bound))

exception TypeError of string
type expType = BoolT | IntT 
let rec typeof exp env = match exp with
  | IntC _ -> IntT
  | BoolC _ -> BoolT
  | Add (e1,e2)
  | Mul (e1,e2)
  | Div (e1,e2)
  | Sub (e1,e2) -> (arithCheck e1 e2 env)
  | And (e1,e2) | Or (e1,e2) -> (boolCheck e1 e2 env)
  | Not e -> if (typeof e env) = BoolT then BoolT
             else raise (TypeError "not")
  | Lt (e1,e2)
  | Gt (e1,e2)
  | Eq (e1,e2) -> (compCheck e1 e2 env)
  | Name n -> List.assoc n env
  | Let(n,v,b) -> let vt = (typeof v env) in (typeof b ((n,vt)::env))
  | If(c,thn,els) -> if (typeof c env) <> BoolT then raise (TypeError "If")
                     else ( match (typeof thn env, typeof els env) with
                            | (IntT, IntT) -> IntT
                            | (BoolT, BoolT) -> BoolT
                            | _ -> raise (TypeError "If"))
and arithCheck e1 e2 env = match (typeof e1 env,typeof e2 env) with
  | (IntT,IntT) -> IntT
  | _ -> raise (TypeError "IntOp")
and boolCheck e1 e2 env = match (typeof e1 env, typeof e2 env) with
  | (BoolT,BoolT) -> BoolT
  | _ -> raise (TypeError "BoolOp")
and compCheck e1 e2 env = match (typeof e1 env, typeof e2 env) with
  | (IntT, IntT)
  | (StringT, StringT)
  | (UnitT, UnitT) -> BoolT
  | _ -> raise (TypeError "Compare")

