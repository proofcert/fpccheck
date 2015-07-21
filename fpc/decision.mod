%TODO Decide left variants seem a bit redundant, here and elsewhere

module decision.

ffClerk (induction? _).
ffClerk (inductionS? _ _ _).
ffClerk (case? _ _ _).
ffClerk (apply? _ _ _ _).

ttClerk (induction? C) (induction? C).
ttClerk (inductionS? L R I) (inductionS? L R I).
ttClerk (case? A L R) (case? A L R).
ttClerk (apply? A S I C) (apply? A S I C).

andClerk (induction? C) (induction? C).
andClerk (inductionS? L R I) (inductionS? L R I).
andClerk (case? A L R) (case? A L R).
andClerk (apply? A S I C) (apply? A S I C).

orClerk (induction? C) (induction? C) (induction? C).
orClerk (inductionS? L R I) (inductionS? L R I) (inductionS? L R I).
orClerk (case? _ L R) L R.
orClerk (apply? A S I C) (apply? A S I C) (apply? A S I C).

impClerk (induction? C) (induction? C).
impClerk (inductionS? L R I) (inductionS? L R I).
impClerk (case? A L R) (case? A L R).
impClerk (apply? A S I C) (apply? A S I C).

eqClerk (induction? C) (induction? C).
eqClerk (inductionS? L R I) (inductionS? L R I).
eqClerk (case? A L R) (case? A L R).
eqClerk (apply? A S I C) (apply? A S I C).

ttExpert (induction? _).
ttExpert (inductionS? _ _ _).
ttExpert (case? _ _ _).
ttExpert (apply? _ _ _ _).

andExpert (induction? C) (induction? C) (induction? C).
andExpert (inductionS? L R I) (inductionS? L R I) (inductionS? L R I).
andExpert (case? A L R) (case? A L R) (case? A L R).
andExpert (apply? A S I C) (apply? A S I C) (apply? A S I C).

orExpert (induction? C) (induction? C) left.
orExpert (induction? C) (induction? C) right.
orExpert (inductionS? L R I) (inductionS? L R I) left.
orExpert (inductionS? L R I) (inductionS? L R I) right.
orExpert (case? A L R) (case? A L R) left.
orExpert (case? A L R) (case? A L R) right.
orExpert (apply? A S I C) (apply? A S I C) left.
orExpert (apply? A S I C) (apply? A S I C) right.

%impExpert

impExpert' (induction? C) (induction? C) (induction? C).
impExpert' (inductionS? L R I) (inductionS? L R I) (inductionS? L R I).
impExpert' (case? A L R) (case? A L R) (case? A L R).
impExpert' (apply? A S I C) (apply? A S I C) (apply? A S I C).

eqExpert (induction? _).
eqExpert (inductionS? _ _ _).
eqExpert (case? _ _ _).
eqExpert (apply? _ _ _ _).

allClerk (induction? C) (x\ induction? C).
allClerk (inductionS? L R I) (x\ inductionS? L R I).
allClerk (case? A L R) (x\ case? A L R).
allClerk (apply? A S I C) (x\ apply? A S I C).

someClerk (induction? C) (x\ induction? C).
someClerk (inductionS? L R I) (x\ inductionS? L R I).
someClerk (case? A L R) (x\ case? A L R).
someClerk (apply? A S I C) (x\ apply? A S I C).

allExpert (induction? C) (induction? C) _.
allExpert (inductionS? L R I) (inductionS? L R I) _.
allExpert (case? A L R) (case? A L R) _.
allExpert (apply? A S I C) (apply? A S I C) _.

someExpert (induction? C) (induction? C) _.
someExpert (inductionS? L R I) (inductionS? L R I) _.
someExpert (case? A L R) (case? A L R) _.
someExpert (apply? A S I C) (apply? A S I C) _.

indClerk (inductionS? L R I) L R I.

indClerk' (induction? C) (x\ C).

coindClerk (inductionS? L R I) L R I.

coindClerk' (induction? C) (x\ C).

unfoldLClerk (case? (ss A) L R) (case? A L R).
unfoldLClerk (apply? (ss A) S I C) (apply? A S I C).

unfoldRExpert (apply? A (ss S) I C) (apply? A S I C).

unfoldLExpert (apply? A (ss S) I C) (apply? A S I C).

unfoldRClerk (case? (ss A) L R) (case? A L R).
unfoldRClerk (apply? (ss A) S I C) (apply? A S I C).

freezeLClerk (induction? C) (induction? C) idxatom.
freezeLClerk (inductionS? L R I) (inductionS? L R I) idxatom.
freezeLClerk (case? A L R) (case? A L R) idxatom.
freezeLClerk (apply? A S I C) (apply? A S I C) idxatom.

initRExpert (induction? _) idxatom.
initRExpert (inductionS? _ _ _) idxatom.
initRExpert (case? _ _ _) idxatom.
initRExpert (apply? _ _ _ _) idxatom.

freezeRClerk (induction? C) (induction? C).
freezeRClerk (inductionS? L R I) (inductionS? L R I).
freezeRClerk (case? A L R) (case? A L R).
freezeRClerk (apply? A S I C) (apply? A S I C).

initLExpert (induction? _).
initLExpert (inductionS? _ _ _).
initLExpert (case? _ _ _).
initLExpert (apply? _ _ _ _).

storeLClerk (induction? C) (induction? C) idxlocal.
storeLClerk (inductionS? L R I) (inductionS? L R I) idxlocal.
storeLClerk (case? A L R) (case? A L R) idxlocal.
storeLClerk (apply? A S I C) (apply? A S I C) idxlocal.

decideLClerk (apply? A S I C) (apply? A S I C) I.

decideLClerk' (apply? A S I C) (apply? A S I C) I.

storeRClerk (induction? C) (induction? C).
storeRClerk (inductionS? L R I) (inductionS? L R I).
storeRClerk (case? A L R) (case? A L R).
storeRClerk (apply? A S I C) (apply? A S I C).

decideRClerk (apply? A S I C) (apply? A S I C).

releaseLExpert (apply? A S I C) C.

releaseRExpert (apply? A S I C) C.

end
