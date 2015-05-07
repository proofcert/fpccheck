#include "../kernel/logic.mod".
#include "../kernel/cert.sig".
#include "../fpc/simple-fpc.mod".
#include "prog-examples.sig".
#include "../kernel/kernel.mod".
#include "prog-examples.mod".

#assert ctx_sum_free (induction 1 1 0 1 0).

#assert sum_ctx_indep (induction 2 1 2 1 2).

#assert ctx_mult_free (induction 1 1 0 1 0).

#assert mult_ctx_indep (induction 2 1 2 1 2).
