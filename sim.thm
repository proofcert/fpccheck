% A suitable step predicate must be defined before inclusion!
Define sim : (i -> bool) -> prop by
	sim (nu Pred\Args\
		% Note how the dual of mu is achieved: some vs all, and vs imp
		(all P\ all Q\ (imp (eq Args (P ++ Q ++ argv))
		(all L\ all Pn\ (imp
			(Step (P ++ L ++ Pn ++ argv))
			(some Qn\ (and
				(Step (Q ++ L ++ Qn ++ argv))
				(Pred (Pn ++ Qn ++ argv)))))))))
	:=
	step Step.
