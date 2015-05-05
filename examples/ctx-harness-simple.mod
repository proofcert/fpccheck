#include "../kernel/logic.mod".
#include "../kernel/cert.sig".
#include "../fpc/simple-fpc.mod".
#include "ctx-examples.sig".
#include "../kernel/kernel.mod".
#include "ctx-examples.mod".

#assert ctx1_struct _ _ (induction 1 1 0 1 0).

#assert ctx1_length _ (induction 1 1 2 1 2).
