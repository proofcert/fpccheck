%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Type module: natural numbers %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Type   zero   i.
Type   succ   i -> i.

Define is_nat : (i -> bool) -> prop by
	is_nat (mu Pred\Args\
		(some N\ (and (eq Args (N ++ argv))
		(or
			(eq N zero)
			(some N'\ (and
				(eq N (succ N'))
				(Pred (N' ++ argv)))))))).
