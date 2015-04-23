#include "../kernel/logic.mod".
#include "../kernel/cert.sig".
#include "../fpc/admin-fpc.mod".
#include "sim-automata-examples.sig".
#include "../kernel/kernel.mod".
#include "sim-automata-examples.mod".

#assert nu_trivial
	(start (ctrl (limits z z z z z z z z z) (names nil (name "X")))).

#assert_not q0_sim_p0
	(start (ctrl (limits z z z z z z z z z) (names nil (name "X")))).

#assert q0_sim_p0
	(induce
		(ctrl (limits z z z z z z z z z) (names nil (name "X")))
		(Args\ or
			(eq Args (q0 ++ p0 ++ argv))
			(eq Args (q1 ++ p0 ++ argv)))
		(name "X")
		(name "X")
		(dummy\ start (ctrl (limits z z z (s z) z (s z) z z z) (names nil (name "X"))))).

% The trivial invariant doesn't work here
#assert_not q0_sim_p0
	(autoinduce
		(ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ start (ctrl (limits z z z (s z) z (s z) z z z) (names nil (name "X"))))).
