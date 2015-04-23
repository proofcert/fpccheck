#include "plus.mod".

% Evaluate risk of unbounded backtracking
% Refactor common fragment to logic.thm
% Each module should probably have its definition (if only it were cumulative!)
Define copy_i : list imap -> i -> i -> prop by
	copy_i Theta argv argv ;
	copy_i Theta (X ++ Y) (U ++ V) := copy_i Theta X U /\ copy_i Theta Y V ;
	%
	copy_i Theta zero zero ;
	copy_i Theta (succ X) (succ U) := copy_i Theta X U ;
	%
	copy_i Theta X U := member (imap X U) Theta.

Define name_mnu : string -> (i -> bool) -> prop by
	name_mnu "plus"  Plus  := plus Plus ;
	name_mnu "nat"   IsNat := is_nat IsNat.
