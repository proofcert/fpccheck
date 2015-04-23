#include "logic.mod".          % First-order logic syntax
#include "cert.sig".           % Certificate declarations
#include "admin-fpc.mod".      % Concrete FPC (needed before kernel!)
#include "ctx-examples.sig".   % Concrete signature (needed before kernel!)
#include "kernel.mod".         % Kernel
#include "ctx-examples.mod".   % Concrete examples

%#assert ctx1_struct Member IsNat
%	(induce (ctrl (limits (s z) z z z _ z z z) _)
%		(Args\ all N\ all L\ imp
%			(eq Args (L ++ argv)) (imp
%			(Member (N ++ L ++ argv))
%			(IsNat (N ++ argv))))
%		(dummy\ start (ctrl (limits (s z) z z (s z) _ z z z) _))).

#assert ctx1_struct _ _
	(autoinduce (ctrl (limits z z z z z z z z z) (names nil (name "X"))) (name "X")
		(dummy\ start (ctrl (limits (s z) z z (s z) z z z z z) (names nil (name "X"))))).

%#assert ctx1_length Length
%	(induce (ctrl (limits (s z) z z z _ (s z) z z) _)
%		(Args\ all L1\ all L2\ imp
%			(eq Args (L1 ++ L2 ++ argv))
%			(some N\ (and
%				(Length (L1 ++ N ++ argv))
%				(Length (L2 ++ N ++ argv)))))
%		(dummy\ start (ctrl (limits (s z) z z (s z) _ (s (s z)) z z) _))).

#assert ctx1_length _
	(autoinduce (ctrl (limits z z z z z (s z) z z z) (names nil (name "X"))) (name "X")
		(dummy\ start (ctrl (limits (s z) z z (s z) z (s (s z)) z z z) (names nil (name "X"))))).
