%TODO Decide left variants seem a bit redundant, here and elsewhere

module decision.

ffClerk (induction? _).
ffClerk (case? _ _ _).
ffClerk (apply? _ _ _ _).

ttClerk (induction? C) (induction? C).
ttClerk (case? A L R) (case? A L R).
ttClerk (apply? A S I C) (apply? A S I C).

andClerk (induction? C) (induction? C).
andClerk (case? A L R) (case? A L R).
andClerk (apply? A S I C) (apply? A S I C).

orClerk (induction? C) (induction? C) (induction? C).
orClerk (case? _ L R) L R.
orClerk (apply? A S I C) (apply? A S I C) (apply? A S I C).

impClerk (induction? C) (induction? C).
impClerk (case? A L R) (case? A L R).
impClerk (apply? A S I C) (apply? A S I C).

eqClerk (induction? C) (induction? C).
eqClerk (case? A L R) (case? A L R).
eqClerk (apply? A S I C) (apply? A S I C).

ttExpert (induction? _).
ttExpert (case? _ _ _).
ttExpert (apply? _ _ _ _).

andExpert (induction? C) (induction? C) (induction? C).
andExpert (case? A L R) (case? A L R) (case? A L R).
andExpert (apply? A S I C) (apply? A S I C) (apply? A S I C).

orExpert (induction? C) (induction? C) left.
orExpert (induction? C) (induction? C) right.
orExpert (case? A L R) (case? A L R) left.
orExpert (case? A L R) (case? A L R) right.
orExpert (apply? A S I C) (apply? A S I C) left.
orExpert (apply? A S I C) (apply? A S I C) right.

%impExpert

impExpert' (induction? C) (induction? C) (induction? C).
impExpert' (case? A L R) (case? A L R) (case? A L R).
impExpert' (apply? A S I C) (apply? A S I C) (apply? A S I C).

eqExpert (induction? _).
eqExpert (case? _ _ _).
eqExpert (apply? _ _ _ _).

allClerk (induction? C) (x\ induction? C).
allClerk (case? A L R) (x\ case? A L R).
allClerk (apply? A S I C) (x\ apply? A S I C).

someClerk (induction? C) (x\ induction? C).
someClerk (case? A L R) (x\ case? A L R).
someClerk (apply? A S I C) (x\ apply? A S I C).

allExpert (induction? C) (induction? C) _.
allExpert (case? A L R) (case? A L R) _.
allExpert (apply? A S I C) (apply? A S I C) _.

someExpert (induction? C) (induction? C) _.
someExpert (case? A L R) (case? A L R) _.
someExpert (apply? A S I C) (apply? A S I C) _.

%indClerk

indClerk' (induction? C) (x\ C).

%coindClerk

coindClerk' (induction? C) (x\ C).

unfoldLClerk (case? A L R) (case? B L R) :- A > 0, B is A - 1.
unfoldLClerk (apply? A S I C) (apply? B S I C) :- A > 0, B is A - 1.

unfoldRExpert (apply? A S I C) (apply? A T I C) :- S > 0, T is S - 1.

unfoldLExpert (apply? A S I C) (apply? A T I C) :- S > 0, T is S - 1.

unfoldRClerk (case? A L R) (case? B L R) :- A > 0, B is A - 1.
unfoldRClerk (apply? A S I C) (apply? B S I C) :- A > 0, B is A - 1.

freezeLClerk (induction? C) (induction? C) (idx "atom").
freezeLClerk (case? A L R) (case? A L R) (idx "atom").
freezeLClerk (apply? A S I C) (apply? A S I C) (idx "atom").

initRExpert (induction? C) (idx "atom").
initRExpert (case? A L R) (idx "atom").
initRExpert (apply? A S I C) (idx "atom").

freezeRClerk (induction? C) (induction? C).
freezeRClerk (case? A L R) (case? A L R).
freezeRClerk (apply? A S I C) (apply? A S I C).

initLExpert (induction? _).
initLExpert (case? _ _ _).
initLExpert (apply? _ _ _ _).

storeLClerk (induction? C) (induction? C) (idx "local").
storeLClerk (case? A L R) (case? A L R) (idx "local").
storeLClerk (apply? A S I C) (apply? A S I C) (idx "local").

decideLClerk (apply? A S I C) (apply? A S I C) I.

decideLClerk' (apply? A S I C) (apply? A S I C) I.

storeRClerk (induction? C) (induction? C).
storeRClerk (case? A L R) (case? A L R).
storeRClerk (apply? A S I C) (apply? A S I C).

decideRClerk (apply? A S I C) (apply? A S I C).

releaseLExpert (apply? A S I C) C.

releaseRExpert (apply? A S I C) C.

end
