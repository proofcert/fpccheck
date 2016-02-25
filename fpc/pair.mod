%TODO Delegate all pairs instead of "simplifying"?
%TODO How to add debugging, here and elsewhere? Best during translation?
%NOTE orClerk does not treat induction# (but on origin does its siblings)
%TODO Split this in two? Pair constructors and concrete index pairs...
%TODO Close all index terms
%TODO Some helper code puts pair variants in explicit lockstep; modularized here
%NOTE Without mixing in the atomic code, treatable examples are very limited!

module pair.

%accumulate atomic. % If I want to have a complete certificate loading just this specification

ffClerk (pair# L0 R0) :-
	ffClerk L0,
	ffClerk R0.
ffClerk (induction# _ _ _ _ _ _).
ffClerk (apply# _ _ _ _ _ _).

ttClerk (pair# L0 R0) (pair# L1 R1) :-
	ttClerk L0 L1,
	ttClerk R0 R1.
ttClerk (induction# N A S B T D) (induction# N A S B T D).
ttClerk (apply# N A S B T D) (apply# N A S B T D).

andClerk (pair# L0 R0) (pair# L1 R1) :-
	andClerk L0 L1,
	andClerk R0 R1.
andClerk (induction# N A S B T D) (induction# N A S B T D).
andClerk (apply# N A S B T D) (apply# N A S B T D).

orClerk (apply# N A S B T (btbranch L R)) (apply# N A S B T L) (apply# N A S B T R).
orClerk (pair# L0 R0) (pair# L1 R1) (pair# L2 R2) :-
	orClerk L0 L1 L2,
	orClerk R0 R1 R2.

impClerk (pair# L0 R0) (pair# L1 R1) :-
	impClerk L0 L1,
	impClerk R0 R1.
impClerk (induction# N A S B T D) (induction# N A S B T D).
impClerk (apply# N A S B T D) (apply# N A S B T D).

eqClerk (pair# L0 R0) (pair# L1 R1) :-
	eqClerk L0 L1,
	eqClerk R0 R1.
eqClerk (induction# N A S B T D) (induction# N A S B T D).
eqClerk (apply# N A S B T D) (apply# N A S B T D).

ttExpert (pair# L0 R0) :-
	ttExpert L0,
	ttExpert R0.
ttExpert (induction# _ _ _ _ _ _).
ttExpert (apply# _ _ _ _ _ _).

andExpert (pair# L0 R0) (pair# L1 R1) (pair# L2 R2) :-
	andExpert L0 L1 L2,
	andExpert R0 R1 R2.
andExpert (induction# N A S B T D) (induction# N A S B T D) (induction# N A S B T D).
andExpert (apply# N A S B T D) (apply# N A S B T D) (apply# N A S B T D).

% removed separate branches for each choice, what if both sides don't care?
orExpert (pair# L0 R0) (pair# L1 R1) C :-
	orExpert L0 L1 C,
	orExpert R0 R1 C.
orExpert (induction# N A S B T D) (induction# N A S B T D) left.
orExpert (induction# N A S B T D) (induction# N A S B T D) right.
orExpert (apply# N A S B T D) (apply# N A S B T D) left.
orExpert (apply# N A S B T D) (apply# N A S B T D) right.

impExpert (pair# L0 R0) (pair# L1 R1) (pair# L2 R2) :-
	impExpert L0 L1 L2,
	impExpert R0 R1 R2.

impExpert' (pair# L0 R0) (pair# L1 R1) (pair# L2 R2) :-
	impExpert' L0 L1 L2,
	impExpert' R0 R1 R2.
impExpert' (induction# N A S B T D) (induction# N A S B T D) (induction# N A S B T D).
impExpert' (apply# N A S B T D) (apply# N A S B T D) (apply# N A S B T D).

eqExpert (pair# L0 R0) :-
	eqExpert L0,
	eqExpert R0.
eqExpert (induction# _ _ _ _ _ _).
eqExpert (apply# _ _ _ _ _ _).

allClerk (pair# L0 R0) (x\ pair# (L1 x) (R1 x)) :-
	allClerk L0 L1,
	allClerk R0 R1.
allClerk (induction# N A S B T D) (x\ induction# N A S B T D).
allClerk (apply# N A S B T D) (x\ apply# N A S B T D).

someClerk (pair# L0 R0) (x\ pair# (L1 x) (R1 x)) :-
	someClerk L0 L1,
	someClerk R0 R1.
someClerk (induction# N A S B T D) (x\ induction# N A S B T D).
someClerk (apply# N A S B T D) (x\ apply# N A S B T D).

allExpert (pair# L0 R0) (pair# L1 R1) T :-
	allExpert L0 L1 T,
	allExpert R0 R1 T.
allExpert (induction# N A S B T D) (induction# N A S B T D) _.
allExpert (apply# N A S B T D) (apply# N A S B T D) _.

someExpert (pair# L0 R0) (pair# L1 R1) T :-
	someExpert L0 L1 T,
	someExpert R0 R1 T.
someExpert (induction# N A S B T D) (induction# N A S B T D) _.
someExpert (apply# N A S B T D) (apply# N A S B T D) _.

indClerk (pair# L0 R0) (pair# L1 R1) (x\ pair# (L2 x) (R2 x)) S :-
	indClerk L0 L1 L2 S,
	indClerk R0 R1 R2 S.

indClerk' (pair# L0 R0) (x\ pair# (L1 x) (R1 x)) :-
	indClerk' L0 L1,
	indClerk' R0 R1.
indClerk' (induction# N A S B T D) (x\ apply# N A S B T D).

coindClerk (pair# L0 R0) (pair# L1 R1) (x\ pair# (L2 x) (R2 x)) S :-
	coindClerk L0 L1 L2 S,
	coindClerk R0 R1 R2 S.

coindClerk' (pair# L0 R0) (x\ pair# (L1 x) (R1 x)) :-
	coindClerk' L0 L1,
	coindClerk' R0 R1.
coindClerk' (induction# N A S B T D) (x\ apply# N A S B T D).

unfoldLClerk (pair# L0 R0) (pair# L1 R1) :-
	unfoldLClerk L0 L1,
	unfoldLClerk R0 R1.
unfoldLClerk (apply# N A S (ss B) T D) (apply# N A S B T D).

unfoldRExpert (pair# L0 R0) (pair# L1 R1) :-
	unfoldRExpert L0 L1,
	unfoldRExpert R0 R1.
unfoldRExpert (apply# N A S B (ss T) D) (apply# N A S B T D).

unfoldLExpert (pair# L0 R0) (pair# L1 R1) :-
	unfoldLExpert L0 L1,
	unfoldLExpert R0 R1.
unfoldLExpert (apply# N A S B (ss T) D) (apply# N A S B T D).

unfoldRClerk (pair# L0 R0) (pair# L1 R1) :-
	unfoldRClerk L0 L1,
	unfoldRClerk R0 R1.
unfoldRClerk (apply# N A S (ss B) T D) (apply# N A S B T D).

freezeLClerk (pair# L0 R0) (pair# L1 R1) (idx2 IL IR) :-
	freezeLClerk L0 L1 IL,
	freezeLClerk R0 R1 IR.
freezeLClerk (induction# N A S B T D) (induction# N A S B T D) idxatom.
freezeLClerk (apply# N A S B T D) (apply# N A S B T D) idxatom.

initRExpert (pair# L0 R0) (idx2 IL IR) :-
	initRExpert L0 IL,
	initRExpert R0 IR.
initRExpert (induction# _ _ _ _ _ _) idxatom.
initRExpert (apply# _ _ _ _ _ _) idxatom.

freezeRClerk (pair# L0 R0) (pair# L1 R1) :-
	freezeRClerk L0 L1,
	freezeRClerk R0 R1.
freezeRClerk (induction# N A S B T D) (induction# N A S B T D).
freezeRClerk (apply# N A S B T D) (apply# N A S B T D).

initLExpert (pair# L0 R0) :-
	initLExpert L0,
	initLExpert R0.
initLExpert (induction# _ _ _ _ _ _).
initLExpert (apply# _ _ _ _ _ _).

storeLClerk (pair# L0 R0) (pair# L1 R1) (idx2 IL IR) :-
	storeLClerk L0 L1 IL,
	storeLClerk R0 R1 IR.
storeLClerk (induction# N A S B T D) (induction# N A S B T D) idxlocal.
storeLClerk (apply# N A S B T D) (apply# N A S B T D) idxlocal.

decideLClerk (pair# L0 R0) (pair# L1 R1) (idx2 IL IR) :-
	decideLClerk L0 L1 IL,
	decideLClerk R0 R1 IR.
decideLClerk (apply# N A S B T (btlocal idxlocal D)) (apply# N A S B T D) idxlocal.

decideLClerk' (pair# L0 R0) (pair# L1 R1) I :-
	decideLClerk' L0 L1 I,
	decideLClerk' R0 R1 I.
decideLClerk' (apply# N A S B T (btlemma I D)) (apply# N A S B T D) I.

storeRClerk (pair# L0 R0) (pair# L1 R1) :-
	storeRClerk L0 L1,
	storeRClerk R0 R1.
storeRClerk (induction# N A S B T D) (induction# N A S B T D).
storeRClerk (apply# N A S B T D) (apply# N A S B T D).

decideRClerk (pair# L0 R0) (pair# L1 R1) :-
	decideRClerk L0 L1,
	decideRClerk R0 R1.
decideRClerk (apply# N A S B T (btlocal idxlocal D)) (apply# N A S B T D).

releaseLExpert (pair# L0 R0) (pair# L1 R1) :-
	releaseLExpert L0 L1,
	releaseLExpert R0 R1.
releaseLExpert (apply# (ss N) A S _ _ D) (apply# N A S A S D).
releaseLExpert (apply# zz _ _ _ _ _) search.

releaseRExpert (pair# L0 R0) (pair# L1 R1) :-
	releaseRExpert L0 L1,
	releaseRExpert R0 R1.
releaseRExpert (apply# (ss N) A S _ _ D) (apply# N A S A S D).
releaseRExpert (apply# zz _ _ _ _ _) search.

end
