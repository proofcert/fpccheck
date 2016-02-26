% Using inductively defined nat, renamed nonneg to avoid clash in Bedwyr

sig atomic.

accum_sig cert.

kind nonneg type.
type zz nonneg.
type ss nonneg -> nonneg.

type   induction    nonneg -> nonneg -> nonneg -> nonneg -> nonneg                -> cert.
type   inductionS   nonneg -> nonneg -> nonneg -> nonneg -> nonneg -> (i -> bool) -> cert.
type   apply        nonneg -> nonneg -> nonneg -> nonneg -> nonneg                -> cert.
type   search                                                         cert.

type   idxatom    idx.
type   idxlocal   idx.
type   idx        nonneg -> idx.
%type   idx   string -> idx.

end
