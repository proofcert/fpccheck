%TODO Using built-in int instead of inductive nat for now

sig atomic.

accum_sig cert.

type   induction    int -> int -> int -> int -> int                -> cert.
type   inductionS   int -> int -> int -> int -> int -> (i -> bool) -> cert.
type   apply        int -> int -> int -> int -> int                -> cert.
type   search                                                         cert.

type   idx   string -> idx.

end
