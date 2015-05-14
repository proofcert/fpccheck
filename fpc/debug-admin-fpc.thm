% Note: when printers are used, no _ placeholders should be used i.e. for
% don't-care indexes, as these will generate sequences of matches.

%%%%%%%%%%%%%%%%%%%%%
% Helper predicates %
%%%%%%%%%%%%%%%%%%%%%

% Little-endian encoding
Define increment_string : list string -> list string -> prop by
	increment_string ("0" :: Str) ("1" :: Str) ;
	increment_string ("1" :: Str) ("2" :: Str) ;
	increment_string ("2" :: Str) ("3" :: Str) ;
	increment_string ("3" :: Str) ("4" :: Str) ;
	increment_string ("4" :: Str) ("5" :: Str) ;
	increment_string ("5" :: Str) ("6" :: Str) ;
	increment_string ("6" :: Str) ("7" :: Str) ;
	increment_string ("7" :: Str) ("8" :: Str) ;
	increment_string ("8" :: Str) ("9" :: Str) ;
	increment_string ("9" :: nil) ("0" :: "1" :: nil) ;
	increment_string ("9" :: LSB :: Str) ("0" :: Str') :=
		increment_string (LSB :: Str) Str'.

Define idx_to_string : numidx -> list string -> prop by
	idx_to_string z ("0" :: nil) ;
	idx_to_string (s N) Str := exists Str',
		idx_to_string N Str' /\
		increment_string Str' Str.

Define print_little_endian : list string -> prop by
	print_little_endian nil ;
	print_little_endian (LSB :: Rest) :=
		print_little_endian Rest /\
		printstr LSB.

%%%%%%%%%%%%%%%%%%%
% Pretty printers %
%%%%%%%%%%%%%%%%%%%

%NOTE Careful! Now this is just a small part of an index (misleading name)
Define print_idx : numidx -> prop by
	print_idx I := exists S,
		idx_to_string I S /\
		print_little_endian S.

%NOTE not doing anything with names, now and yet...
Define print_ctrl : ctrl -> prop by
	print_ctrl (ctrl (limits D N L UL UR UM LN LL RR) (names Delta Goal)) :=
		printstr "Depth " /\ print_idx D /\ printstr ", " /\
		printstr "Store (" /\ print_idx N /\ printstr "," /\ print_idx L /\ printstr "), " /\
		printstr "UnfoldL " /\ print_idx UL /\ printstr ", " /\
		printstr "UnfoldR (" /\ print_idx UR /\ printstr "," /\ print_idx UM /\ printstr "), " /\
		printstr "Lemma (" /\ print_idx LN /\ printstr "," /\ print_idx LL /\ printstr "), " /\
		printstr "ReleaseR " /\ print_idx RR /\
		printstr "\n  Δ: " /\ print Delta /\
		printstr "\n  Ω: " /\ print Goal.

% WARNING: Infinite backtracking risk on don't cares: use with caution!
Define print_cert : cert -> prop by
%	print_cert Cert.
	print_cert (search     Ctrl        ) :=
		printstr "  Ξ: simple  " /\ print_ctrl Ctrl /\ printstr "\n" ;
	print_cert (inductionS Ctrl _ _ _ _) :=
		printstr "  Ξ: man-ind " /\ print_ctrl Ctrl /\ printstr "\n" ;
	print_cert (induction  Ctrl _ _    ) :=
		printstr "  Ξ: imm-ind " /\ print_ctrl Ctrl /\ printstr "\n" ;
	print_cert (apply      Ctrl _ _ _  ) := % not sure the alignment of _'s is meaningful
		printstr "  Ξ: gLemma  " /\ print_ctrl Ctrl /\ printstr "\n" ;
	print_cert (case       Ctrl _ _    ) :=
		printstr "  Ξ: gOr     " /\ print_ctrl Ctrl /\ printstr "\n".
