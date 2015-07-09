%TODO Unlikely that we can mix catch-alls with the open world

module atomic.

ffClerk (induction _ _ _ _ _).
ffClerk (apply _ _ _ _ _).
ffClerk search.

ttClerk (induction N A S B T) (induction N A S B T).
ttClerk (apply N A S B T) (apply N A S B T).
ttClerk search search.

andClerk (induction N A S B T) (induction N A S B T).
andClerk (apply N A S B T) (apply N A S B T).
andClerk search search.

orClerk (induction N A S B T) (induction N A S B T) (induction N A S B T).
orClerk (apply N A S B T) (apply N A S B T) (apply N A S B T).
orClerk search search search.

impClerk (induction N A S B T) (induction N A S B T).
impClerk (apply N A S B T) (apply N A S B T).
impClerk search search.

eqClerk (induction N A S B T) (induction N A S B T).
eqClerk (apply N A S B T) (apply N A S B T).
eqClerk search search.

ttExpert (induction _ _ _ _ _).
ttExpert (apply _ _ _ _ _).
ttExpert search.

andExpert (induction N A S B T) (induction N A S B T) (induction N A S B T).
andExpert (apply N A S B T) (apply N A S B T) (apply N A S B T).
andExpert search search search.

orExpert (induction N A S B T) (induction N A S B T) left.
orExpert (induction N A S B T) (induction N A S B T) right.
orExpert (apply N A S B T) (apply N A S B T) left.
orExpert (apply N A S B T) (apply N A S B T) right.
orExpert search search left.
orExpert search search right.

%impExpert

impExpert' (induction N A S B T) (induction N A S B T) (induction N A S B T).
impExpert' (apply N A S B T) (apply N A S B T) (apply N A S B T).
impExpert' search search search.

eqExpert (induction _ _ _ _ _).
eqExpert (apply _ _ _ _ _).
eqExpert search.

allClerk (induction N A S B T) (x\ induction N A S B T).
allClerk (apply N A S B T) (x\ apply N A S B T).
allClerk search (x\ search).

someClerk (induction N A S B T) (x\ induction N A S B T).
someClerk (apply N A S B T) (x\ apply N A S B T).
someClerk search (x\ search).

allExpert (induction N A S B T) (induction N A S B T) _.
allExpert (apply N A S B T) (apply N A S B T) _.
allExpert search search _.

someExpert (induction N A S B T) (induction N A S B T) _.
someExpert (apply N A S B T) (apply N A S B T) _.
someExpert search search _.

%indClerk

indClerk' (induction N A S B T) (x\ apply N A S B T).

%coindClerk

coindClerk' (induction N A S B T) (x\ apply N A S B T).

unfoldLClerk (apply N A S B T) (apply N A S C T) :- B > 0, C is B - 1.

unfoldRExpert (apply N A S B T) (apply N A S B U) :- T > 0, U is T - 1.

unfoldLExpert (apply N A S B T) (apply N A S B U) :- T > 0, U is T - 1.

unfoldRClerk (apply N A S B T) (apply N A S C T) :- B > 0, C is B - 1.

freezeLClerk (induction N A S B T) (induction N A S B T) (idx "atom").
freezeLClerk (apply N A S B T) (apply N A S B T) (idx "atom").
freezeLClerk search search (idx "atom").

initRExpert (induction _ _ _ _ _) (idx "atom").
initRExpert (apply _ _ _ _ _) (idx "atom").
initRExpert search (idx "atom").

freezeRClerk (induction N A S B T) (induction N A S B T).
freezeRClerk (apply N A S B T) (apply N A S B T).
freezeRClerk search search.

initLExpert (induction _ _ _ _ _).
initLExpert (apply _ _ _ _ _).
initLExpert search.

storeLClerk (induction N A S B T) (induction N A S B T) (idx "local").
storeLClerk (apply N A S B T) (apply N A S B T) (idx "local").
storeLClerk search search (idx "local").

decideLClerk (apply N A S B T) (apply N A S B T) (idx "local").

decideLClerk' (apply N A S B T) (apply N A S B T) _.

storeRClerk (induction N A S B T) (induction N A S B T).
storeRClerk (apply N A S B T) (apply N A S B T).
storeRClerk search search.

decideRClerk (apply N A S B T) (apply N A S B T).
decideRClerk search search.

releaseLExpert (apply N A S _ _) (apply M A S A S) :- N > 0, M is N - 1.
releaseLExpert (apply 0 _ _ _ _) search.

releaseRExpert (apply N A S _ _) (apply M A S A S) :- N > 0, M is N - 1.
releaseRExpert (apply 0 _ _ _ _) search.

end
