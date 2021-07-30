(* hostinfo, the "name" of a computer connected to the Internet *)
type hostinfo = IP of int*int*int*int | DNSName of string

(* Here's where your definition of tld goes: *)
let tld = function
  | IP _ -> None
  | DNSName s ->
     let pos = 1 + (String.rindex s '.' ) in
     let len = (String.length s) - pos in
     Some (String.sub s pos len)
