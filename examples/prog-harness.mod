#include "../kernel/logic.mod".
#include "../kernel/cert.sig".
#include "../fpc/admin-fpc.mod".
#include "prog-examples.sig".
#include "../kernel/kernel.mod".
#include "prog-examples.mod".

#assert ctx_sum_free
	(autoinduce (ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ start (ctrl (limits (s z) z z (s z) z z z z z) (names nil (name "X"))))).

% An explicit case analysis with clear, independent bounds
#assert sum_ctx_indep
	(autoinduce (ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ guideOr (ctrl (limits z z z z z z z z z) (names nil (name "X")))
			(guideLemma (ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "ctx_sum_free") (name "X")
				(start (ctrl (limits (s z) z z z z z z z z) (names nil (name "X")))))
		(       guideOr (ctrl (limits z z z z z z z z z) (names nil (name "X")))
			(start (ctrl (limits z z z z z z z z z) (names nil (name "X"))))
		(       guideOr (ctrl (limits z z z z z z z z z) (names nil (name "X")))
			(start (ctrl (limits z z z z z z z z z) (names nil (name "X"))))
		(       guideOr (ctrl (limits z z z z z z z z z) (names nil (name "X")))
			(start (ctrl (limits z z z z z z z z z) (names nil (name "X"))))
		(       guideOr (ctrl (limits z z z z z z z z z) (names nil (name "X")))
			(start (ctrl (limits z z z z z z z z z) (names nil (name "X"))))
			(start (ctrl (limits (s z) z z (s z) z (s (s z)) z z z) (names nil (name "X"))))
		)))))
	).

% More compact, less efficient: each step is the maximum of all sequential paths
#assert sum_ctx_indep
	(autoinduce (ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ guideLemma (ctrl (limits (s z) z z (s z) z (s (s z)) z z z) (names nil (name "X"))) (name "ctx_sum_free") (name "X")
			(start (ctrl (limits (s z) z z z z z z z z) (names nil (name "X")))))).

% For multiplication... and again, this should be refactored
#assert ctx_mult_free
	(autoinduce (ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ start (ctrl (limits (s z) z z (s z) z z z z z) (names nil (name "X"))))).

#assert mult_ctx_indep
	(autoinduce (ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ guideLemma (ctrl (limits (s z) z z (s z) z (s (s z)) z z z) (names nil (name "X"))) (name "ctx_mult_free") (name "X")
			(start (ctrl (limits (s z) z z z z z z z z) (names nil (name "X")))))).
