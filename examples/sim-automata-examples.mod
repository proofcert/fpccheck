Define nu_trivial : cert -> prop by
	nu_trivial Cert :=
		sim Sim /\
		prove Cert (imp (Sim (q0 ++ p0 ++ argv)) (Sim (q0 ++ p0 ++ argv))).

Define q0_sim_p0 : cert -> prop by
	q0_sim_p0 Cert :=
		sim Sim /\
		prove Cert (Sim (q0 ++ p0 ++ argv)).
