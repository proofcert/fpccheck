%TODO Delegate all pairs instead of "simplifying"?
%TODO How to add debugging, here and elsewhere? Best during translation?
%NOTE orClerk does not treat induction# (but on origin does its siblings)
%TODO Split this in two? Pair constructors and concrete index pairs...
%TODO Close all index terms
%TODO Some helper code puts pair variants in explicit lockstep; modularized here
%NOTE Without mixing in the atomic code, treatable examples are very limited!

module pair.

ffClerk (pair# _ _).
ffClerk (induction# _ _ _ _ _ _).
ffClerk (apply# _ _ _ _ _ _).

ttClerk (pair# L R) (pair# L R).
ttClerk (induction# N A S B T D) (induction# N A S B T D).
ttClerk (apply# N A S B T D) (apply# N A S B T D).

andClerk (pair# L R) (pair# L R).
andClerk (induction# N A S B T D) (induction# N A S B T D).
andClerk (apply# N A S B T D) (apply# N A S B T D).

orClerk (apply# N A S B T (btbranch L R)) (apply# N A S B T L) (apply# N A S B T R).
orClerk (pair# L R) (pair# M S) (pair# N T) :- orClerk L M N, orClerk R S T.

impClerk (pair# L R) (pair# L R).
impClerk (induction# N A S B T D) (induction# N A S B T D).
impClerk (apply# N A S B T D) (apply# N A S B T D).

eqClerk (pair# L R) (pair# L R).
eqClerk (induction# N A S B T D) (induction# N A S B T D).
eqClerk (apply# N A S B T D) (apply# N A S B T D).

ttExpert (pair# _ _).
ttExpert (induction# _ _ _ _ _ _).
ttExpert (apply# _ _ _ _ _ _).

andExpert (pair# L R) (pair# L R) (pair# L R).
andExpert (induction# N A S B T D) (induction# N A S B T D) (induction# N A S B T D).
andExpert (apply# N A S B T D) (apply# N A S B T D) (apply# N A S B T D).

orExpert (pair# L R) (pair# L R) left.
orExpert (pair# L R) (pair# L R) right.
orExpert (induction# N A S B T D) (induction# N A S B T D) left.
orExpert (induction# N A S B T D) (induction# N A S B T D) right.
orExpert (apply# N A S B T D) (apply# N A S B T D) left.
orExpert (apply# N A S B T D) (apply# N A S B T D) right.

%impExpert

impExpert' (pair# L R) (pair# L R) (pair# L R).
impExpert' (induction# N A S B T D) (induction# N A S B T D) (induction# N A S B T D).
impExpert' (apply# N A S B T D) (apply# N A S B T D) (apply# N A S B T D).

eqExpert (pair# _ _).
eqExpert (induction# _ _ _ _ _ _).
eqExpert (apply# _ _ _ _ _ _).

allClerk (pair# L R) (x\ pair# (M x) (S x)) :- allClerk L M, allClerk R S.
allClerk (induction# N A S B T D) (x\ induction# N A S B T D).
allClerk (apply# N A S B T D) (x\ apply# N A S B T D).

someClerk (pair# L R) (x\ pair# (M x) (S x)) :- someClerk L M, someClerk R S.
someClerk (induction# N A S B T D) (x\ induction# N A S B T D).
someClerk (apply# N A S B T D) (x\ apply# N A S B T D).

allExpert (pair# L R) (pair# L R) _.
allExpert (induction# N A S B T D) (induction# N A S B T D) _.
allExpert (apply# N A S B T D) (apply# N A S B T D) _.

someExpert (pair# L R) (pair# L R) _.
someExpert (induction# N A S B T D) (induction# N A S B T D) _.
someExpert (apply# N A S B T D) (apply# N A S B T D) _.

%indClerk

indClerk' (pair# L R) (x\ pair# (M x) (S x)) :- indClerk' L M, indClerk' R S.
indClerk' (induction# N A S B T D) (x\ apply# N A S B T D).

%coindClerk

coindClerk' (pair# L R) (x\ pair# (M x) (S x)) :- coindClerk' L M, coindClerk' R S.
coindClerk' (induction# N A S B T D) (x\ apply# N A S B T D).

unfoldLClerk (pair# L R) (pair# M S) :- unfoldLClerk L M, unfoldLClerk R S.
unfoldLClerk (apply# N A S (s B) T D) (apply# N A S B T D).

unfoldRExpert (pair# L R) (pair# M S) :- unfoldRExpert L M, unfoldRExpert R S.
unfoldRExpert (apply# N A S B (s T) D) (apply# N A S B T D).

unfoldLExpert (pair# L R) (pair# M S) :- unfoldLExpert L M, unfoldLExpert R S.
unfoldLExpert (apply# N A S B (s T) D) (apply# N A S B T D).

unfoldRClerk (pair# L R) (pair# M S) :- unfoldRClerk L M, unfoldRClerk R S.
unfoldRClerk (apply# N A S (s B) T D) (apply# N A S B T D).

freezeLClerk (pair# L R) (pair# M S) (idx2 I J) :- freezeLClerk L M I, freezeLClerk R S J.
freezeLClerk (induction# N A S B T D) (induction# N A S B T D) (idx "atom").
freezeLClerk (apply# N A S B T D) (apply# N A S B T D) (idx "atom").

initRExpert (pair# L R) (idx2 I J) :- initRExpert L I, initRExpert R J.
initRExpert (induction# _ _ _ _ _ _) (idx "atom").
initRExpert (apply# _ _ _ _ _ _) (idx "atom").

freezeRClerk (pair# L R) (pair# L R).
freezeRClerk (induction# N A S B T D) (induction# N A S B T D).
freezeRClerk (apply# N A S B T D) (apply# N A S B T D).

initLExpert (pair# L R) :- initLExpert L, initLExpert R.
initLExpert (induction# _ _ _ _ _ _).
initLExpert (apply# _ _ _ _ _ _).

storeLClerk (pair# L R) (pair# M S) (idx2 I J) :- storeLClerk L M I, storeLClerk R S J.
storeLClerk (induction# N A S B T D) (induction# N A S B T D) (idx "local").
storeLClerk (apply# N A S B T D) (apply# N A S B T D) (idx "local").

decideLClerk (pair# L R) (pair# M S) (idx2 I J) :- decideLClerk L M I, decideLClerk R S J.
decideLClerk (apply# N A S B T (btlocal (idx "local") D)) (apply# N A S B T D) (idx "local").

decideLClerk' (pair# L R) (pair# M S) I :- decideLClerk' L M I, decideLClerk' R S I.
decideLClerk' (apply# N A S B T (btlemma I D)) (apply# N A S B T D) I.

storeRClerk (pair# L R) (pair# L R).
storeRClerk (induction# N A S B T D) (induction# N A S B T D).
storeRClerk (apply# N A S B T D) (apply# N A S B T D).

decideRClerk (pair# L R) (pair# M S) :- decideRClerk L M, decideRClerk R S.
decideRClerk (apply# N A S B T (btlocal (idx "local") D)) (apply# N A S B T D).

releaseLExpert (pair# L R) (pair# M S) :- releaseLExpert L M, releaseLExpert R S.
releaseLExpert (apply# (s N) A S _ _ D) (apply# N A S A S D).
releaseLExpert (apply# z _ _ _ _ _) search.

releaseRExpert (pair# L R) (pair# M S) :- releaseRExpert L M, releaseRExpert R S.
releaseRExpert (apply# (s N) A S _ _ D) (apply# N A S A S D).
releaseRExpert (apply# z _ _ _ _ _) search.

end
