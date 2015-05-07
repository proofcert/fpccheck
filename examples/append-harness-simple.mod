#include "../kernel/logic.mod".
#include "../kernel/cert.sig".
#include "../fpc/simple-fpc.mod".
#include "append-examples.sig".
#include "../kernel/kernel.mod".
#include "append-examples.mod".

#assert appendable (apply 1 0 1 0 1) null null null.

#assert appendable (apply 1 0 2 0 2) (cons a null) null (cons a null).

#assert appendable (apply 1 0 1 0 1) null (cons a null) (cons a null).

#assert appendable (apply 1 0 2 0 2)
	(cons a null) (cons b null) (cons a (cons b null)).

#assert eigen_unify (apply 1 0 0 0 0).

#assert append_total _ (induction 1 0 1 0 1).

#assert append_det _ (induction 1 1 0 1 0).

#assert append_assoc _ (induction 1 1 1 1 1).
