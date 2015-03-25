%NOTE In a way, we are putting together pieces (about the natural numbers,
% about lists) that we have considered before... so there is some refactoring to
% be done here.

%%%%%%%%%%%%%%%%%%%%%
% Type constructors %
%%%%%%%%%%%%%%%%%%%%%

% Number objects and arithmetic atoms (basis for 'atom')
% For now, I can get away without an explicit <> converter
Type   zi                i.
Type   si                i -> i.
Type   sumi, multi       i -> i -> i -> i.
Type   gcdi              i -> i -> i -> i.

% Lists of atoms
Type   nili              i.
Type   &&                i -> i -> i.

%%%%%%%%%%%%%%%%%%%
% List membership %
%%%%%%%%%%%%%%%%%%%

Define memb : (i -> bool) -> prop by
	memb (mu Pred\Args\
		(some E\ some L\ (and (eq Args (E ++ L ++ argv))
		(or
			(some L'\ (eq L (E && L')))
			(some F\ some L'\ (and
				(eq L (F && L'))
				(Pred (E ++ L' ++ argv)))))))).


%%%%%%%%%%%%%%%%%%%%%%
% List concatenation %
%%%%%%%%%%%%%%%%%%%%%%

Define append : (i -> bool) -> prop by
	append (mu Pred\Args\
		(some L1\ some L2\ some L3\ (and (eq Args (L1 ++ L2 ++ L3 ++ argv))
		(or
			(and
				(eq L1 nili)
				(eq L2 L3))
			(some N\ some L1'\ some L3'\ (and (and
				(eq L1 (N && L1'))
				(eq L3 (N && L3')))
				(Pred (L1' ++ L2 ++ L3' ++ argv)))))))).

%%%%%%%%%%%%
% Programs %
%%%%%%%%%%%%

% Programs have gone from object-level formulas on atoms to sets of atoms
Define prog : (i -> bool) -> prop by
	prog (mu Pred\Args\
		(some A\ some G\ (and (eq Args (A ++ G ++ argv)) (or
			% sumi
			(or
				(some N\ and
					(eq A (sumi zi N N))
					(eq G nili))
				(some N\ some M\ some P\ and
					(eq A (sumi (si N) M (si P)))
					(eq G ((sumi N M P) && nili))))
			% multi
			(or
				(some M\ and
					(eq A (multi zi M zi))
					(eq G nili))
				(some K\ some M\ some N\ and
					(eq A (multi (si K) M N))
					(some X\ eq G ((multi K M X) && (sumi X M N) && nili))))
	)))).

%%%%%%%%%%%%
% Contexts %
%%%%%%%%%%%%

% It is critical that predicates defined in prog and ctx be mutually exclusive!
Define ctx : (i -> bool) -> prop by
	ctx (mu Pred\Args\
		(some L\ (and (eq Args (L ++ argv)) (or
			(eq L nili)
			(some X\ some Y\ some Z\ some L'\ and
				(eq L ((gcdi X Y Z) && L'))
				(Pred (L' ++ argv)))
	)))).

%%%%%%%%%%%%
% Sequents %
%%%%%%%%%%%%

% The object-level connectives have been replaced by a set representation of
% Horn-like programs; treatment is now strictly recursive
Define seq : (i -> bool) -> prop by
	seq (mu Pred\Args\
		(some L\ some G\ (and (eq Args (L ++ G ++ argv)) (or
			(eq G nili) (or
			(some G1\ some G2\ and
				(eq G (G1 && G2)) (and
				(Memb (G1 ++ L ++ argv))
				(Pred (L ++ G2 ++ argv))))
			(some G1\ some G2\ and
				(eq G (G1 && G2)) (some L1\ and
				(Prog (G1 ++ L1 ++ argv)) (some L2\ and
				(Append (L ++ L1 ++ L2 ++ argv)) % Is there a "better order"?
				(Pred (L2 ++ G2 ++ argv)))))
	)))))
	:=
	memb Memb /\ prog Prog /\ append Append.
