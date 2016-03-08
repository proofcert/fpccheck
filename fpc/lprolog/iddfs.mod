module iddfs.

%TODO Common test cases for startiddfs are limited, and it may be desirable
% to extend them to cover all cases.

ffClerk (iddfs _).
ffClerk startiddfs.

ttClerk (iddfs N) (iddfs N).
ttClerk startiddfs (iddfs N) :-
	is_nonneg N.

andClerk (iddfs N) (iddfs N).
andClerk startiddfs (iddfs N) :-
	is_nonneg N.

orClerk (iddfs N) (iddfs N) (iddfs N).
orClerk startiddfs (iddfs N) (iddfs N) :-
	is_nonneg N.

impClerk (iddfs N) (iddfs N).
impClerk startiddfs (iddfs N) :-
	is_nonneg N.

eqClerk (iddfs N) (iddfs N).
eqClerk startiddfs (iddfs N) :-
	is_nonneg N.

ttExpert (iddfs _).
ttExpert startiddfs.

andExpert (iddfs N) (iddfs N) (iddfs N).
andExpert startiddfs (iddfs N) (iddfs N) :-
	is_nonneg N.

orExpert (iddfs N) (iddfs N) left.
orExpert (iddfs N) (iddfs N) right.
%TODO Test as needed: starting here with a choice and no outer guidance can be
% troublesome. If the kernel is ensured to resolve the problem, it should be
% fine (sa would simplifying the other pair clauses above).
orExpert startiddfs (iddfs N) _ :-
	is_nonneg N.

impExpert (iddfs N) (iddfs N) (iddfs N).
impExpert startiddfs (iddfs N) (iddfs N) :-
	is_nonneg N.

impExpert' (iddfs N) (iddfs N) (iddfs N).
impExpert' startiddfs (iddfs N) (iddfs N) :-
	is_nonneg N.

eqExpert (iddfs _).
eqExpert startiddfs.

allClerk (iddfs N) (x\ iddfs N).
allClerk startiddfs (x\ iddfs N) :-
	is_nonneg N.

someClerk (iddfs N) (x\ iddfs N).
someClerk startiddfs (x\ iddfs N) :-
	is_nonneg N.

allExpert (iddfs N) (iddfs N) _.
allExpert startiddfs (iddfs N) _ :-
	is_nonneg N.

someExpert (iddfs N) (iddfs N) _.
someExpert startiddfs (iddfs N) _ :-
	is_nonneg N.

indClerk (iddfs N) (iddfs N) (x\ iddfs N) _.
indClerk startiddfs (iddfs N) (x\ iddfs N) _ :-
	is_nonneg N.

indClerk' (iddfs N) (x\ iddfs N). % troublesome without pairing
indClerk' startiddfs (x\ iddfs N) :-
	is_nonneg N.

coindClerk (iddfs N) (iddfs N) (x\ iddfs N) _.
coindClerk startiddfs (iddfs N) (x\ iddfs N) _ :-
	is_nonneg N.

coindClerk' (iddfs N) (x\ iddfs N). % troublesome without pairing
coindClerk' startiddfs (x\ iddfs N) :-
	is_nonneg N.

% unfolds without pairing can be troublesome
unfoldLClerk (iddfs N) (iddfs N).
unfoldLClerk startiddfs (iddfs N) :-
	is_nonneg N.

unfoldRExpert (iddfs N) (iddfs N).
unfoldRExpert startiddfs (iddfs N) :-
	is_nonneg N.

unfoldLExpert (iddfs N) (iddfs N).
unfoldLExpert startiddfs (iddfs N) :-
	is_nonneg N.

unfoldRClerk (iddfs N) (iddfs N).
unfoldRClerk startiddfs (iddfs N) :-
	is_nonneg N.

freezeLClerk (iddfs N) (iddfs N) iddfsidx.
freezeLClerk startiddfs (iddfs N) iddfsidx :-
	is_nonneg N.

initRExpert (iddfs _) iddfsidx.
initRExpert startiddfs iddfsidx.

freezeRClerk (iddfs N) (iddfs N).
freezeRClerk startiddfs (iddfs N) :-
	is_nonneg N.

initLExpert (iddfs _).
initLExpert startiddfs.

storeLClerk (iddfs N) (iddfs N) iddfsidx.
storeLClerk startiddfs (iddfs N) iddfsidx :-
	is_nonneg N.

decideLClerk (iddfs N) (iddfs N) iddfsidx.
decideLClerk startiddfs (iddfs N) iddfsidx :-
	is_nonneg N.

% Potentially risky without external guidance (and good pairing composition).
decideLClerk' (iddfs N) (iddfs N) _.
decideLClerk' startiddfs (iddfs N) _ :-
	is_nonneg N.

storeRClerk (iddfs N) (iddfs N).
storeRClerk startiddfs (iddfs N) :-
	is_nonneg N.

decideRClerk (iddfs N) (iddfs N).
decideRClerk startiddfs (iddfs N) :-
	is_nonneg N.

releaseLExpert (iddfs (ss N)) (iddfs N).
releaseLExpert startiddfs (iddfs N) :-
	is_nonneg N.

releaseRExpert (iddfs (ss N)) (iddfs N).
releaseRExpert startiddfs (iddfs N) :-
	is_nonneg N.

end
