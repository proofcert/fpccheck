#include "template.mod".

Define plus_zero : (i -> bool) -> cert -> prop by
	plus_zero Plus Cert :=
		plus Plus /\ is_nat IsNat /\
		prove Cert
			(all N\ (imp (IsNat (N ++ argv)) (Plus (N ++ zero ++ N ++ argv)))).

Define plus_succ : (i -> bool) -> cert -> prop by
	plus_succ Plus Cert :=
		plus Plus /\
		prove Cert (all K\ all M\ all N\ (imp
			(Plus (K ++       M  ++       N  ++ argv))
			(Plus (K ++ (succ M) ++ (succ N) ++ argv)))).

% [Here, the lemma should be expressed symbolically, not copied from above!]
Define plus_comm : (i -> bool) -> (i -> bool) -> cert -> prop by
	plus_comm Plus IsNat Cert :=
		plus Plus /\ is_nat IsNat /\ is_commutative Cert Plus IsNat
			((lemma (name "plus_zero") (all N\ (imp (IsNat (N ++ argv)) (Plus (N ++ zero ++ N ++ argv))))) ::
			 (lemma (name "plus_succ") (all K\ all M\ all N\ (imp (Plus (K ++ M  ++ N  ++ argv)) (Plus (K ++ (succ M) ++ (succ N) ++ argv))))) :: nil).

Define plus_total : (i -> bool) -> cert -> prop by
	plus_total Plus Cert :=
		plus Plus /\ is_nat IsNat /\ is_total Cert Plus IsNat.

Define plus_det : (i -> bool) -> cert -> prop by
	plus_det Plus Cert :=
		plus Plus /\ is_deterministic Cert Plus.

Define plus_assoc : (i -> bool) -> cert -> prop by
	plus_assoc Plus Cert :=
		plus Plus /\ is_associative Cert Plus.

%%%%%%%%%%%%%%%%%%%%
% Typing judgments %
%%%%%%%%%%%%%%%%%%%%

Define augend_nat_f : bool -> prop by
	augend_nat_f F :=
		plus Plus /\ is_nat IsNat /\ F =
		(all A\ all B\ all C\ imp
			(Plus (A ++ B ++ C ++ argv)) (imp
			(IsNat (C ++ argv))
			(IsNat (A ++ argv)))).

%TODO Cert missing!
Define augend_nat : cert -> prop by
	augend_nat Cert :=
		augend_nat_f AugendNat /\ prove Cert AugendNat.

Define addend_nat_f : bool -> prop by
	addend_nat_f F :=
		plus Plus /\ is_nat IsNat /\ F =
		(all A\ all B\ all C\ imp
			(Plus (A ++ B ++ C ++ argv)) (imp
			(IsNat (C ++ argv))
			(IsNat (B ++ argv)))).

%TODO Cert missing!
Define addend_nat : cert -> prop by
	addend_nat Cert :=
		augend_nat_f AddendNat /\ prove Cert AddendNat.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constructive permutations %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Define plus_assoc_rl_f : bool -> prop by
	plus_assoc_rl_f F :=
		plus Plus /\ is_nat IsNat /\ F =
		(all A\ all B\ all C\ all BC\ all ABC\ imp
			(Plus (B ++  C ++  BC ++ argv)) (imp
			(Plus (A ++ BC ++ ABC ++ argv)) (imp
			(IsNat (ABC ++ argv))
			(some AB\ and
				(Plus (A  ++ B ++ AB  ++ argv))
				(Plus (AB ++ C ++ ABC ++ argv)))))).

Define plus_assoc_rl : cert -> prop by
	plus_assoc_rl Cert :=
		%
		plus Plus /\ is_nat IsNat /\
		%
		addend_nat_f AddendNat /\
		commutative Plus IsNat PlusComm /\ associative Plus PlusAssoc /\
		%
		plus_assoc_rl_f PlusAssocRL /\
		prove_with_lemmas Cert PlusAssocRL (
			(lemma (name "addend_nat") AddendNat) ::
			(lemma (name "plus_comm" ) PlusComm ) ::
			(lemma (name "plus_assoc") PlusAssoc) :: nil).
