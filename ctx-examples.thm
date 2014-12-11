Define ctx1_struct : (i -> bool) -> (i -> bool) -> cert -> prop by
	ctx1_struct Member IsNat Cert :=
		ctx1 Ctx /\ memb Member /\ is_nat IsNat /\
		prove Cert (all N\ all L\ (imp
			(Ctx (L ++ argv)) (imp
			(Member (N ++ L ++ argv))
			(IsNat (N ++ argv))))).

Define ctx1_length : (i -> bool) -> cert -> prop by
	ctx1_length Length Cert :=
		ctx1_equal CtxEq /\ length Length /\
		prove Cert (all L1\ all L2\ (imp
			(CtxEq (L1 ++ L2 ++ argv))
			(some N\ (and
				(Length (L1 ++ N ++ argv))
				(Length (L2 ++ N ++ argv)))))).
