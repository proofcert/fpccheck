%TODO Refactor against blocks (indexes...)
%TODO In addition, decisions need at least one block to terminate (improve?)

sig decision.

%accum_sig cert.
accum_sig atomic.

type   induction?                               cert -> cert.
type   case?        nonneg           -> cert -> cert -> cert.
type   apply?       nonneg -> nonneg -> idx  -> cert -> cert.

type   inductionS?   cert -> (i -> cert) -> (i -> bool) -> cert.

%type   idx   string -> idx.

end
