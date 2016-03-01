module quick.

% Set membership
type   member   A -> list A -> o.
member X [X | _].
member X [_ | L] :-
	member X L.

%ffClerk (qcert _ _).
%
%ttClerk (qcert D G) (qcert D G).
%
%andClerk (qcert D G) (qcert D G).
%
%orClerk (qcert D G) (qcert D G) (qcert D G).
%
%impClerk (qcert D G) (qcert D G).
%
%eqClerk (qcert D G) (qcert D G).
%
%ttExpert (qcert _ _).

andExpert (qcert Map Delta qnone             ) (qcert Map Delta qnone) (qcert Map Delta qnone).
andExpert (qcert Map Delta (qand Form1 Form2)) (qcert Map Delta Form1) (qcert Map Delta Form2).

% In this simplified case, having two probabilities is redundant: only the
% ratio matters, and the total is defined by convention.
orExpert (qcert Map Delta qnone)                     (qcert Map Delta qnone) _.
orExpert (qcert Map Delta (qor Pr1 Pr2 Form1 Form2)) (qcert Map Delta Form)  Choice :-
	print "Enter random 0-100 finished with a dot: ",
	read Random, % A stand-in that hopefully Bedwyr can stomach.
	(
		Random <= Pr1,
		Form = Form1,
		Choice = left
	;
		Random > Pr1,
		Form = Form2,
		Choice = right
	).

%impExpert (qcert D G)(qcert D G)(qcert D G).
%
%impExpert' (qcert D G)(qcert D G)(qcert D G).
%
%eqExpert (qcert D G).
%
%allClerk (qcert D G)(x\ qcert D G).
%
%someClerk (qcert D G)(x\ qcert D G).
%
%allExpert (qcert D G)(qcert D G) _.

someExpert (qcert Map Delta Goal) (qcert Map Delta Goal) _.

%indClerk (qcert D G)(qcert D G)(x\ qcert D G) _.
%
%indClerk' (qcert D G)(x\ qcert D G).
%
%coindClerk (qcert D G)(qcert D G)(x\ qcert D G) _.
%
%coindClerk' (qcert D G)(x\ qcert D G).
%
%unfoldLClerk (qcert D G)(qcert D G).

unfoldRExpert (qcert Map Delta qnone)        (qcert Map Delta qnone).
unfoldRExpert (qcert Map Delta (qname Name)) (qcert Map Delta Form) :-
	member (qmap Name Form) Map.

%unfoldLExpert (qcert D G)(qcert D G).
%
%unfoldRClerk (qcert D G)(qcert D G).
%
%freezeLClerk (qcert D G)(qcert D G) qidx.
%
%initRExpert (qcert _ _) qidx.
%
%freezeRClerk (qcert D G)(qcert D G).
%
%initLExpert (qcert _ _).
%
%storeLClerk (qcert D G)(qcert D G) qidx.
%
%decideLClerk (qcert D G)(qcert D G) qidx.
%
%decideLClerk' (qcert D G)(qcert D G) _.

storeRClerk (qcert Map Delta Goal) (qcert Map Delta Goal).

decideRClerk (qcert Map Delta Goal) (qcert Map Delta Goal).

%releaseLExpert (qcert D G)(qcert D G).
%
%releaseRExpert (qcert D G)(qcert D G).

end
