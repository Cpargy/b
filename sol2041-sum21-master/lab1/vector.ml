let scale s (u,v) = (s*.u,s*.v)

let length (u,v) = sqrt ((u *. u) +. (v *. v))  

let vec_add (x1,y1) (x2,y2) = (x1+.x2, y1+.y2)

let dot (x1,y1) (x2,y2) = (x1 *. x2) +. (y1 *. y2)

let perp u v = (dot u v) = 0.

