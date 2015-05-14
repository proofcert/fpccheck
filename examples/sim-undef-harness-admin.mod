#include "../kernel/logic.mod".
#include "../kernel/cert.sig".
#include "../fpc/admin-fpc.mod".
#include "sim-undef-examples.sig".
#include "../kernel/kernel.mod".
#include "sim-undef-examples.mod".

#assert sim_refl
	(inductionS
		(ctrl (limits z z z z z z z z z) (names nil (name "X")))
		(Args\ some P\ some Q\ and (eq Args (P ++ Q ++ argv)) (eq P Q))
		(name "X")
		(name "X")
		(dummy\ search (ctrl (limits z z z z z z z z z) (names nil (name "X"))))).

#assert sim_refl
	(induction
		(ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ search (ctrl (limits z z z z z z z z z) (names nil (name "X"))))).

#assert_not sim_trans Sim
	(inductionS
		(ctrl (limits z z z z z z z z (s z)) (names nil (name "X")))
		(Args\ some P\ some R\ and (eq Args (P ++ R ++ argv))
			(some Q\ and (Sim (P ++ Q ++ argv)) (Sim (Q ++ R ++ argv))))
		(name "X")
		(name "X")
		(dummy\ search (ctrl (limits z z z z z z z z z) (names nil (name "X"))))).

#assert sim_trans Sim
	(inductionS
		(ctrl (limits z z z z z z z z (s z)) (names nil (name "X")))
		% This automatic invariant looks very much like the one above! Good sign
		(Args\ some P\ some Q\ some R\ and (eq Args (P ++ R ++ argv))
			(and (Sim (P ++ Q ++ argv)) (Sim (Q ++ R ++ argv))))
		(name "X")
		(name "X")
		(dummy\ search (ctrl (limits (s (s z)) z z (s (s z)) z z z z (s z)) (names nil (name "X"))))).

#assert sim_trans _
	(induction
		(ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ search (ctrl (limits (s (s z)) z z (s (s z)) z z z z (s z)) (names nil (name "X"))))).
