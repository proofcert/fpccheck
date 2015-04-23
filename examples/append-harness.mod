#include "../kernel/logic.mod".
#include "../kernel/cert.sig".
#include "../fpc/admin-fpc.mod".
#include "append-examples.sig".
#include "../kernel/kernel.mod".
#include "append-examples.mod".

#assert appendable (start (ctrl (limits z z z z _ (s z) _ _ z) _))
	null null null.

#assert appendable (start (ctrl (limits z z z z _ (s (s z)) _ _ z) _))
	(cons a null) null (cons a null).

#assert appendable (start (ctrl (limits z z z z _ (s z) _ _ z) _))
	null (cons a null) (cons a null).

#assert appendable (start (ctrl (limits z z z z _ (s (s z)) _ _ z) _ ))
	(cons a null) (cons b null) (cons a (cons b null)).

#assert eigen_unify (start (ctrl (limits z z z z _ z _ _ z) _ )).

%#assert append_total Append
%	(induce (ctrl (s z) z z z _ z _ _)
%		(x\ all A\ all B\ imp
%			(eq x (A ++ argv))
%			(some C\ Append (A ++ B ++ C ++ argv)))
%		(dummy\ start (ctrl (s z) z z z _ (s z) _ _))).

#assert append_total _
	(autoinduce (ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ start (ctrl (limits (s z) z z z z (s z) z z z) (names nil (name "X"))))).

%#assert_not append_total _
%	(autoinduce (ctrl z z z z _ z _ _) (dummy\ start (ctrl z z z z _ (s z) _ _))).

%#assert append_det Append
%	(induce (ctrl (s z) z z z _ (s (s z)) _ _)
%		(x\ all I\ all J\ all K\ all L\ imp
%			(eq x (I ++ J ++ K ++ argv)) (imp
%			(Append (I ++ J ++ L ++ argv))
%			(eq K L)
%		))
%		(dummy\ start (ctrl (s z) z z (s z) _ z _ _))).

#assert append_det _
	(autoinduce (ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ start (ctrl (limits (s z) z z (s z) z z z z z) (names nil (name "X"))))).

%#assert append_assoc Append
%	(induce (ctrl (s z) z z z _ z _ _)
%		(x\ all l1\ all l2\ all l4\ all l6\ all l7\ imp
%			(eq x (l4 ++ l2 ++ l6 ++ argv)) (imp
%			(Append (l6 ++ l1 ++ l7 ++ argv))
%			(some l3\ and
%				(Append (l2 ++ l1 ++ l3 ++ argv))
%				(Append (l4 ++ l3 ++ l7 ++ argv))
%			)
%		))
%		(dummy\ start (ctrl (s z) z z (s z) _ (s z) _ _))).

#assert append_assoc _
	(autoinduce (ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ start (ctrl (limits (s z) z z (s z) z (s z) z z z) (names nil (name "X"))))).
