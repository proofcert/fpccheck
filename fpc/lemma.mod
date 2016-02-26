%TODO How to add debugging, here and elsewhere? Best during translation?
%TODO Some helper code puts pair variants in explicit lockstep; modularized here
%NOTE orClerk does not treat induction# (but on origin does its siblings)
%TODO Close all index terms
%NOTE Without mixing in the atomic code, treatable examples are very limited!

module lemma.

%accumulate atomic. % If I want to have a complete certificate loading just this specification

ffClerk (induction# _ _ _ _ _ _).
ffClerk (apply# _ _ _ _ _ _).

ttClerk (induction# N A S B T D) (induction# N A S B T D).
ttClerk (apply# N A S B T D) (apply# N A S B T D).

andClerk (induction# N A S B T D) (induction# N A S B T D).
andClerk (apply# N A S B T D) (apply# N A S B T D).

orClerk (apply# N A S B T (btbranch L R)) (apply# N A S B T L) (apply# N A S B T R).

impClerk (induction# N A S B T D) (induction# N A S B T D).
impClerk (apply# N A S B T D) (apply# N A S B T D).

eqClerk (induction# N A S B T D) (induction# N A S B T D).
eqClerk (apply# N A S B T D) (apply# N A S B T D).

ttExpert (induction# _ _ _ _ _ _).
ttExpert (apply# _ _ _ _ _ _).

andExpert (induction# N A S B T D) (induction# N A S B T D) (induction# N A S B T D).
andExpert (apply# N A S B T D) (apply# N A S B T D) (apply# N A S B T D).

orExpert (induction# N A S B T D) (induction# N A S B T D) left.
orExpert (induction# N A S B T D) (induction# N A S B T D) right.
orExpert (apply# N A S B T D) (apply# N A S B T D) left.
orExpert (apply# N A S B T D) (apply# N A S B T D) right.

%impExpert

impExpert' (induction# N A S B T D) (induction# N A S B T D) (induction# N A S B T D).
impExpert' (apply# N A S B T D) (apply# N A S B T D) (apply# N A S B T D).

eqExpert (induction# _ _ _ _ _ _).
eqExpert (apply# _ _ _ _ _ _).

allClerk (induction# N A S B T D) (x\ induction# N A S B T D).
allClerk (apply# N A S B T D) (x\ apply# N A S B T D).

someClerk (induction# N A S B T D) (x\ induction# N A S B T D).
someClerk (apply# N A S B T D) (x\ apply# N A S B T D).

allExpert (induction# N A S B T D) (induction# N A S B T D) _.
allExpert (apply# N A S B T D) (apply# N A S B T D) _.

someExpert (induction# N A S B T D) (induction# N A S B T D) _.
someExpert (apply# N A S B T D) (apply# N A S B T D) _.

%indClerk

indClerk' (induction# N A S B T D) (x\ apply# N A S B T D).

%coindClerk

coindClerk' (induction# N A S B T D) (x\ apply# N A S B T D).

unfoldLClerk (apply# N A S (ss B) T D) (apply# N A S B T D).

unfoldRExpert (apply# N A S B (ss T) D) (apply# N A S B T D).

unfoldLExpert (apply# N A S B (ss T) D) (apply# N A S B T D).

unfoldRClerk (apply# N A S (ss B) T D) (apply# N A S B T D).

freezeLClerk (induction# N A S B T D) (induction# N A S B T D) idxatom.
freezeLClerk (apply# N A S B T D) (apply# N A S B T D) idxatom.

initRExpert (induction# _ _ _ _ _ _) idxatom.
initRExpert (apply# _ _ _ _ _ _) idxatom.

freezeRClerk (induction# N A S B T D) (induction# N A S B T D).
freezeRClerk (apply# N A S B T D) (apply# N A S B T D).

initLExpert (induction# _ _ _ _ _ _).
initLExpert (apply# _ _ _ _ _ _).

storeLClerk (induction# N A S B T D) (induction# N A S B T D) idxlocal.
storeLClerk (apply# N A S B T D) (apply# N A S B T D) idxlocal.

decideLClerk (apply# N A S B T (btlocal idxlocal D)) (apply# N A S B T D) idxlocal.

decideLClerk' (apply# N A S B T (btlemma I D)) (apply# N A S B T D) I.

storeRClerk (induction# N A S B T D) (induction# N A S B T D).
storeRClerk (apply# N A S B T D) (apply# N A S B T D).

decideRClerk (apply# N A S B T (btlocal idxlocal D)) (apply# N A S B T D).

releaseLExpert (apply# (ss N) A S _ _ D) (apply# N A S A S D).
releaseLExpert (apply# zz _ _ _ _ _) search.

releaseRExpert (apply# (ss N) A S _ _ D) (apply# N A S A S D).
releaseRExpert (apply# zz _ _ _ _ _) search.

end
