#include "../kernel/logic.mod".
#include "../kernel/cert.sig".
#include "../fpc/simple-fpc.mod".
#include "times-examples.sig".
#include "../kernel/kernel.mod".
#include "times-examples.mod".

#assert times_zero (induction 2 0 2 0 2).
#assert times_zero (pair# (induction 2 0 2 0 2) (induction# 2 0 2 0 2 Idx)).

#assert times_total' (induction 2 0 1 0 1).
#assert times_total' (pair# (induction 2 0 1 0 1) (induction# 2 0 1 0 1 Idx)).

#assert times_det (induction 2 1 0 1 0).
#assert times_det (pair# (induction 2 1 0 1 0) (induction# 2 1 0 1 0 Idx)).

#assert times_comm
	(induction?
	(case? 0
		(apply? 0 0 (idx "times_zero")
		search)
		(apply? 1 0 (idx "augend_nat")
		(apply? 0 0 (idx "local")
		(apply? 0 0 (idx "times_succ'")
		(apply? 0 0 (idx "plus_det")
		search)))))).

%#assert times_comm (induction 4 1 0 1 0).
%#assert times_comm
%	(autoinduce         (ctrl (limits       z   z z    z  z z z             z     z)
%		(dummy\ guideOr (ctrl (limits       z   z z    z  z z z             z     z)
%			(guideLemma (ctrl (limits       z   z z    z  z z z             z     z) (name "times_zero") 
%				(start  (ctrl (limits    (s z)  z z    z  z z z             z     z)
%			(guideLemma (ctrl (limits       z   z z (s z) z z z          (s z)    z) (name "augend_nat") 
%			(guideLemma (ctrl (limits (s (s z)) z z    z  z z z       (s (s z))   z) (name "times_succ'") 
%			(guideLemma (ctrl (limits    (s z)  z z    z  z z z    (s (s (s z)))  z) (name "plus_det") 
%				(start  (ctrl (limits    (s z)  z z    z  z z z (s (s (s (s z)))) z)
