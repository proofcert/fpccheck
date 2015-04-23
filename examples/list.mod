#include "nat.mod".

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Type module: item lists %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

Type   null   i.
Type   cons   i -> i -> i.

Define is_list : (i -> bool) -> prop by
	is_list (mu I\Args\
		(some L\ (and (eq Args (L ++ argv))
		(or
			(eq L null)
			(some N\ some L'\ (and
				(eq L (cons N L'))
				(I (L' ++ argv)))))))).

% Suboptimal/multi-matching when E = F
Define memb : (i -> bool) -> prop by
	memb (mu Pred\Args\
		(some E\ some L\ (and (eq Args (E ++ L ++ argv))
		(or
			(some L'\ (eq L (cons E L')))
			(some F\ some L'\ (and
				(eq L (cons F L'))
				(Pred (E ++ L' ++ argv)))))))).

Define length : (i -> bool) -> prop by
	length (mu Pred\Args\
		(some L\ some N\ (and (eq Args (L ++ N ++ argv))
		(or
			(and (eq L null) (eq N zero))
			(some E\ some L'\ some N'\ (and
				(eq L (cons E L')) (and
				(eq N (succ N'))
				(Pred (L' ++ N' ++ argv))))))))).
