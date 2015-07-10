%TODO Using built-in int instead of inductive nat for now

sig atomic.

accum_sig cert.

type   induction    nat -> nat -> nat -> nat -> nat                -> cert.
type   inductionS   nat -> nat -> nat -> nat -> nat -> (i -> bool) -> cert.
type   apply        nat -> nat -> nat -> nat -> nat                -> cert.
type   search                                                         cert.

type   idx   string -> idx.

end
