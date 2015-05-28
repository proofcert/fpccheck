Define sim_refl : cert -> prop by
	sim_refl Cert :=
		sim Sim /\
		prove Cert (all P\ Sim (P ++ P ++ argv)).

Define sim_trans : (i -> bool) -> cert -> prop by
	sim_trans Sim Cert :=
		sim Sim /\
		prove Cert (all P\ all Q\ all R\ (imp
			(Sim (P ++ Q ++ argv)) (imp
			(Sim (Q ++ R ++ argv))
			(Sim (P ++ R ++ argv))))).
