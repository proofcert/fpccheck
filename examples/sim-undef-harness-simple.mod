#include "../kernel/logic.mod".
#include "../kernel/cert.sig".
#include "../fpc/simple-fpc.mod".
#include "sim-undef-examples.sig".
#include "../kernel/kernel.mod".
#include "sim-undef-examples.mod".

#assert sim_refl (induction 1 0 0 0 0).

#assert sim_trans _ (induction 3 0 2 0 2).
