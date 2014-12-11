Define announce : prop -> prop by
	announce G :=
		print ">>" /\ println G /\ false.

Define spy : prop -> prop by
	spy G :=
		print ">Entering " /\ println G /\
		G /\
		print ">Success "  /\ println G ;
	spy G :=
		print ">Leaving "  /\ println G /\
		false.

Define print_success : prop by
	print_success :=
		printstr "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n".

Define print_failure : prop by
	print_failure :=
		printstr "--------------------------------------------------------------------------------\n".

Define spy_noheader : prop -> prop by
	spy_noheader G :=
		G /\ print_success ;
	spy_noheader G :=
		print_failure /\ false.
