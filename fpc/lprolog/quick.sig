sig quick.

accum_sig atomic.

% Here we are faced with the common problem of "kernel annotation", i.e., the
% need to mimic zones of the kernel and their effect on formulas in order to
% keep the certificate and its guidance in lockstep with the deduction. This
% situation has arisen before and it may be beneficial to refactor the pattern
% if this is in agreement with the kernel's API, that is to say, if its
% behavior is well defined and can be assumed by the FPC.

% Formula stubs representing fixed point predicates and their relevant
% structure: disjunctions indicating a cumulative probability for each side,
% conjunctions to refine the parts of each disjunctive clause, names for
% inductive fixed points, and a don't care symbol for uninteresting subtrees.
%   Probabilities, weights and randomness make the disjunctive structure
% tricky, and clean and simple solutions are not immediate (nor is how
% directly they translate across systems). For now, the convention is to
% make the weights of both branches add to 100, and draw a new random number
% at each disjunction. This makes modeling distribution probabilities awkward,
% but at this stage something is better than nothing, or too little.
kind   qform   type.
type   qor     int -> int -> qform -> qform -> qform.
type   qand                  qform -> qform -> qform.
type   qname   string -> qform.
type   qnone   qform.

% Map a "predicate name" to its structure, where fixed point recursion must
% make consistent use of names, as must the mappings given in the certificate
% to match the sequents to be proved. A context will be a list (used as a set)
% of mappings.
kind   qmap   type.
type   qmap   string -> qform.

% Examples of maps: integers and lists of integers. Care must be taken to
% ensure that probabilities add up, and to respect the structure of the
% corresponding fixed point definition and its branching points, paying special
% attention to associativity.
%qmap "is_int" (qor 20 80 qnone (qand qnone (qname "is_int")))
%qmap "is_intlist" (qor 50 50 qnone (qand (qand qnone (qname "is_int")) (qname "is_intlist")))

%WIP At the very least, a certificate takes maps for both left and right side
% of the sequent.
type   qcert   list qmap -> qmap -> cert.

% To stay out of trouble, a dummy index.
type   qidx   idx.

end
