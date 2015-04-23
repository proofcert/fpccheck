#include "logic.mod".                % First-order logic syntax
#include "cert.sig".                 % Certificate declarations
#include "admin-fpc.mod".            % Concrete FPC (needed before kernel!)
#include "sim-undef-examples.sig".   % Concrete signature (needed before kernel!)
#include "kernel.mod".               % Kernel
#include "sim-undef-examples.".      % Concrete examples

#assert sim_refl
	(induce
		(ctrl (limits z z z z z z z z z) (names nil (name "X")))
		(Args\ some P\ some Q\ and (eq Args (P ++ Q ++ argv)) (eq P Q))
		(name "X")
		(name "X")
		(dummy\ start (ctrl (limits z z z z z z z z z) (names nil (name "X"))))).

#assert sim_refl
	(autoinduce
		(ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ start (ctrl (limits z z z z z z z z z) (names nil (name "X"))))).

#assert_not sim_trans Sim
	(induce
		(ctrl (limits z z z z z z z z (s z)) (names nil (name "X")))
		(Args\ some P\ some R\ and (eq Args (P ++ R ++ argv))
			(some Q\ and (Sim (P ++ Q ++ argv)) (Sim (Q ++ R ++ argv))))
		(name "X")
		(name "X")
		(dummy\ start (ctrl (limits z z z z z z z z z) (names nil (name "X"))))).

#assert sim_trans Sim
	(induce
		(ctrl (limits z z z z z z z z (s z)) (names nil (name "X")))
		% This automatic invariant looks very much like the one above! Good sign
		(Args\ some P\ some Q\ some R\ and (eq Args (P ++ R ++ argv))
			(and (Sim (P ++ Q ++ argv)) (Sim (Q ++ R ++ argv))))
		(name "X")
		(name "X")
		(dummy\ start (ctrl (limits (s (s z)) z z (s (s z)) z z z z (s z)) (names nil (name "X"))))).

#assert sim_trans _
	(autoinduce
		(ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ start (ctrl (limits (s (s z)) z z (s (s z)) z z z z (s z)) (names nil (name "X"))))).
