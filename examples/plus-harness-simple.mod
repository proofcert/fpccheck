#include "../kernel/logic.mod".
#include "../kernel/cert.sig".
#include "../fpc/simple-fpc.mod".
#include "plus-examples.sig".
#include "../kernel/kernel.mod".
#include "plus-examples.mod".

#assert plus_zero _ (induction 1 0 1 0 1).

#assert plus_succ _ (induction 1 0 1 0 1).

#assert plus_comm _ _ (induction 2 1 0 1 0).

#assert plus_total _ (induction 1 0 1 0 1).

#assert plus_det _ (induction 1 1 0 1 0).

#assert plus_assoc _ (induction 1 1 1 1 1).

#assert augend_nat (induction 1 1 1 1 1).

#assert plus_assoc_rl (apply 7 0 0 0 0).
%#assert plus_assoc_rl
%	(guideLemma (ctrl (limits    z  z z z z z z                      z        z) (name "plus_comm")
%	(guideLemma (ctrl (limits (s z) z z z z z z                   (s z)       z) (name "addend_nat")
%	(guideLemma (ctrl (limits (s z) z z z z z z                (s (s z))      z) (name "plus_comm")
%	(guideLemma (ctrl (limits (s z) z z z z z z             (s (s (s z)))     z) (name "plus_assoc")
%	(guideLemma (ctrl (limits (s z) z z z z z z          (s (s (s (s z))))    z) (name "plus_comm")
%	(guideLemma (ctrl (limits (s z) z z z z z z       (s (s (s (s (s z)))))   z) (name "addend_nat")
%	(guideLemma (ctrl (limits (s z) z z z z z z    (s (s (s (s (s (s z))))))  z) (name "plus_comm")
%	(start      (ctrl (limits (s z) z z z z z z (s (s (s (s (s (s (s z))))))) z)
