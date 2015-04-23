#include "logic.mod".            % First-order logic syntax
#include "cert.sig".             % Certificate declarations
#include "admin-fpc.mod".        % Concrete FPC (needed before kernel!)
#include "times-examples.sig".   % Concrete signature (needed before kernel!)
#include "kernel.mod".           % Kernel
#include "times-examples.mod".   % Concrete examples

#assert times_zero
	(autoinduce (ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ start (ctrl (limits (s (s z)) z z z z (s (s z)) z z z) (names nil (name "X"))))).

#assert times_total'
	(autoinduce         (ctrl (limits    z  z z z z    z  z z z) (names nil (name "X"))) (name "X")
		(dummy\ guideOr (ctrl (limits    z  z z z z    z  z z z) (names nil (name "X")))
			(start      (ctrl (limits    z  z z z z (s z) z z z) (names nil (name "X"))))
			(guideLemma (ctrl (limits (s z) z z z z    z  z z z) (names nil (name "X"))) (name "plus_total") (name "X")
				(start  (ctrl (limits (s z) z z z z (s z) z z z) (names nil (name "X")))))
		)
	).

#assert times_det
	(autoinduce         (ctrl (limits    z  z z    z  z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ guideOr (ctrl (limits    z  z z    z  z z z z z) (names nil (name "X")))
			(start      (ctrl (limits    z  z z (s z) z z z z z) (names nil (name "X"))))
			(guideLemma (ctrl (limits (s z) z z (s z) z z z z z) (names nil (name "X"))) (name "plus_det") (name "X")
				(start  (ctrl (limits (s z) z z    z  z z z z z) (names nil (name "X"))))))).

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% What if I don't know which lemma to pick?
#assert times_det
	(autoinduce         (ctrl (limits    z  z z    z  z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ guideOr (ctrl (limits    z  z z    z  z z z z z) (names nil (name "X")))
			(start      (ctrl (limits    z  z z (s z) z z z z z) (names nil (name "X"))))
			(guideLemma (ctrl (limits (s z) z z (s z) z z z z z) (names nil (name "X"))) (name Lemma) (name "X")
				(start  (ctrl (limits (s z) z z    z  z z z z z) (names nil (name "X"))))))).
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#assert times_comm
	(autoinduce         (ctrl (limits       z   z z    z  z z z             z     z) (names nil (name "X"))) (name "X")
		(dummy\ guideOr (ctrl (limits       z   z z    z  z z z             z     z) (names nil (name "X")))
			(guideLemma (ctrl (limits       z   z z    z  z z z             z     z) (names nil (name "X"))) (name "times_zero") (name "X")
				(start  (ctrl (limits    (s z)  z z    z  z z z             z     z) (names nil (name "X")))))
			(guideLemma (ctrl (limits       z   z z (s z) z z z          (s z)    z) (names nil (name "X"))) (name "augend_nat") (name "X")
			(guideLemma (ctrl (limits (s (s z)) z z    z  z z z       (s (s z))   z) (names nil (name "X"))) (name "times_succ'") (name "X")
			(guideLemma (ctrl (limits    (s z)  z z    z  z z z    (s (s (s z)))  z) (names nil (name "X"))) (name "plus_det"  ) (name "X")
				(start  (ctrl (limits    (s z)  z z    z  z z z (s (s (s (s z)))) z) (names nil (name "X"))))))))).

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% What if I don't know which lemma to pick? (note the combination of buckets and lemma uncertainty can be costly indeed)... this one in particular needs to be checked just in case, but I think everything works
#assert times_comm
	(autoinduce         (ctrl (limits       z   z z    z  z z z             z     z) (names nil (name "X"))) (name "X")
		(dummy\ guideOr (ctrl (limits       z   z z    z  z z z             z     z) (names nil (name "X")))
			(guideLemma (ctrl (limits       z   z z    z  z z z             z     z) (names nil (name "X"))) (name "times_zero") (name "X")
				(start  (ctrl (limits    (s z)  z z    z  z z z             z     z) (names nil (name "X")))))
			(guideLemma (ctrl (limits       z   z z (s z) z z z          (s z)    z) (names nil (name "X"))) (name "augend_nat") (name "X")
			(guideLemma (ctrl (limits (s (s z)) z z    z  z z z       (s (s z))   z) (names nil (name "X"))) (name Lemma1       ) (name "X")
			(guideLemma (ctrl (limits    (s z)  z z    z  z z z    (s (s (s z)))  z) (names nil (name "X"))) (name Lemma2      ) (name "X")
				(start  (ctrl (limits    (s z)  z z    z  z z z (s (s (s (s z)))) z) (names nil (name "X"))))))))).
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% Whenever we enter a lemma, we will need to escape it, and its continuation
% needs to open one new bipole at least (and hopefully just one).
%   Probably, I want to favor freezes without "successor"-like stuff, which I'd
% unroll prior to that point: here how to pick efficiently is very important
% (and from the "case" tactice there seems to be enough information in the
% Abella script to decide).

% Needs something else to work
%#assert times_succ
%	...
