(* Data type for programs with primitive types and functions *)

type expType = BoolT | IntT | FunT of expType * expType

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
  | Apply of expr * expr
  | Fun of string * expType * expr (* name of parameter, type of parameter, body*)
type result = BoolR of bool | IntR of int | Closure of expr * string * env
and env = (string * result) list

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
  | Apply(e1,e2) -> let (Closure (e,arg,env)) = eval e1 env in
    let arval = eval e2 env in eval e ((arg,arval)::env)
  | Fun (aname, atype, bx) -> Closure (bx, aname, env)
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
  | Apply (e1, e2) -> (unbound e1 bound) @ (unbound e2 bound)
  | Fun (aname, atype, bx) -> (unbound bx (aname::bound))

exception TypeError of string
let rec typeof exp env = match exp with
  | IntC _ -> IntT
  | BoolC _ -> BoolT
  | Add (e1,e2)
  | Mul (e1,e2)
  | Div (e1,e2)
  | Sub (e1,e2) -> (arithCheck e1 e2 env)
  | And (e1,e2) | Or (e1,e2) -> (boolCheck e1 e2 env)
  | Not e -> if (typeof e env) = BoolT then BoolT
             else raise (TypeError "Not")
  | Lt (e1,e2)
  | Gt (e1,e2)
  | Eq (e1,e2) -> (compCheck e1 e2 env)
  | Name n -> List.assoc n env
  | Let(n,v,b) -> let vt = (typeof v env) in (typeof b ((n,vt)::env))
  | Apply(e1,e2) -> funAppCheck e1 e2 env
  | Fun (aname,atype,bx) -> FunT (atype, typeof bx ((aname,atype)::env))
  | If(c,thn,els) -> if (typeof c env) <> BoolT then raise (TypeError "If cond")
                     else ( match (typeof thn env, typeof els env) with
                            | (IntT, IntT) -> IntT
                            | (BoolT, BoolT) -> BoolT
                            | _ -> raise (TypeError "If case"))
and arithCheck e1 e2 env = match (typeof e1 env,typeof e2 env) with
  | (IntT,IntT) -> IntT
  | _ -> raise (TypeError "arithOp")
and boolCheck e1 e2 env = match (typeof e1 env, typeof e2 env) with
  | (BoolT,BoolT) -> BoolT
  | _ -> raise (TypeError "boolOp")
and compCheck e1 e2 env = match (typeof e1 env, typeof e2 env) with
  | (IntT, IntT) -> BoolT
  | (BoolT,BoolT) -> BoolT
  | _ -> raise (TypeError "compare")
and funAppCheck e1 e2 env = match (typeof e1 env) with
  | FunT (t1,t2) -> if (typeof e2 env) = t1 then t2 else raise (TypeError "FunArg")
  | _ -> raise (TypeError "FunApp")

let add1fun = IntC 0

let collatz_fun = IntC 1

let kdelta = IntC (-1)

