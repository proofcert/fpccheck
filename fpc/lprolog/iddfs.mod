module iddfs.

ffClerk (iddfs _).

ttClerk (iddfs N) (iddfs N).

andClerk (iddfs N) (iddfs N).

orClerk (iddfs N) (iddfs N) (iddfs N).

impClerk (iddfs N) (iddfs N).

eqClerk (iddfs N) (iddfs N).

ttExpert (iddfs _).

andExpert (iddfs N) (iddfs N) (iddfs N).

orExpert (iddfs N) (iddfs N) left.
orExpert (iddfs N) (iddfs N) right.

impExpert (iddfs N) (iddfs N) (iddfs N).

impExpert' (iddfs N) (iddfs N) (iddfs N).

eqExpert (iddfs _).

%TODO single starting point
allClerk (iddfs N) (x\ iddfs N).
allClerk startiddfs (x\ iddfs N) :-
	is_nonneg N.

someClerk (iddfs N) (x\ iddfs N).

allExpert (iddfs N) (iddfs N) _.

someExpert (iddfs N) (iddfs N) _.

% To simplify, one might assume a single induction to start and no more in the
% hope of simplifying the initial setup, but the formula will be commonly
% wrapped in quantifiers, and those are a better simplifying target.
indClerk (iddfs N) (iddfs N) (x\ iddfs N) _.

indClerk' (iddfs N) (x\ iddfs N). % troublesome without pairing

coindClerk (iddfs N) (iddfs N) (x\ iddfs N) _.

coindClerk' (iddfs N) (x\ iddfs N). % troublesome without pairing

% unfolds without pairing can be troublesome
unfoldLClerk (iddfs N) (iddfs N).

unfoldRExpert (iddfs N) (iddfs N).

unfoldLExpert (iddfs N) (iddfs N).

unfoldRClerk (iddfs N) (iddfs N).

freezeLClerk (iddfs N) (iddfs N) iddfsidx.

initRExpert (iddfs _) iddfsidx.

freezeRClerk (iddfs N) (iddfs N).

initLExpert (iddfs _).

storeLClerk (iddfs N) (iddfs N) iddfsidx.

decideLClerk (iddfs N) (iddfs N) iddfsidx.

% Potentially risky without external guidance (and good pairing composition).
decideLClerk' (iddfs N) (iddfs N) _.

storeRClerk (iddfs N) (iddfs N).

decideRClerk (iddfs N) (iddfs N).

releaseLExpert (iddfs (ss N)) (iddfs N).

releaseRExpert (iddfs (ss N)) (iddfs N).

end
