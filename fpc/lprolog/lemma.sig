%NOTE The atomic module is needed to close bipoles on search
%NOTE The two commented lines don't hinder compilation (where is the catch?)

sig lemma.

%accum_sig cert.
accum_sig atomic.

%type   idx    string -> idx.

kind   bt                 type.
type   btinit             bt.
type   btlemma, btlocal   idx -> bt -> bt.
type   btbranch           bt -> bt -> bt.

type   induction#   nonneg -> nonneg -> nonneg -> nonneg -> nonneg -> bt -> cert.
type   apply#       nonneg -> nonneg -> nonneg -> nonneg -> nonneg -> bt -> cert.

end
