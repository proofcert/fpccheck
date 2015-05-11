#include "../kernel/logic.mod".
#include "../kernel/cert.sig".
#include "../fpc/simple-fpc.mod".
#include "sim-undef-examples.sig".
#include "../kernel/kernel.mod".
#include "sim-undef-examples.mod".

#assert sim_refl (induction 1 0 0 0 0).
#assert sim_refl (pair# (induction 1 0 0 0 0) (induction# 1 0 0 0 0 Idx)).

#assert sim_trans _ (induction 3 0 2 0 2).
#assert sim_trans _ (pair# (induction 3 0 2 0 2) (induction# 3 0 2 0 2 Idx)).
