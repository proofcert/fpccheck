#include "../kernel/logic.mod".
#include "../kernel/cert.sig".
#include "../fpc/simple-fpc.mod".
#include "prog-examples.sig".
#include "../kernel/kernel.mod".
#include "prog-examples.mod".

#assert ctx_sum_free (induction 1 1 0 1 0).
#assert ctx_sum_free (pair# (induction 1 1 0 1 0) (induction# 1 1 0 1 0 Idx)).

#assert sum_ctx_indep (induction 2 1 2 1 2).
#assert sum_ctx_indep (pair# (induction 2 1 2 1 2) (induction# 2 1 2 1 2 Idx)).

#assert ctx_mult_free (induction 1 1 0 1 0).
#assert ctx_mult_free (pair# (induction 1 1 0 1 0) (induction# 1 1 0 1 0 Idx)).

#assert mult_ctx_indep (induction 2 1 2 1 2).
#assert mult_ctx_indep (pair# (induction 2 1 2 1 2) (induction# 2 1 2 1 2 Idx)).
