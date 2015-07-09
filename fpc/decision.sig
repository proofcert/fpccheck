%TODO Using built-in int instead of inductive nat for now
%TODO Refactor against blocks (indexes...)
%TODO In addition, decisions need at least one block to terminate (improve?)

sig decision.

accum_sig cert.

type   induction?                         cert -> cert.
type   case?        int        -> cert -> cert -> cert.
type   apply?       int -> int -> idx  -> cert -> cert.

type   idx   string -> idx.

end
