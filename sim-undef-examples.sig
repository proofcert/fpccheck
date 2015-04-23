#include "sim-undef.mod".

Define copy_i : list imap -> i -> i -> prop by
	copy_i Theta argv argv ;
	copy_i Theta (X ++ Y) (U ++ V) := copy_i Theta X U /\ copy_i Theta Y V ;
	%
	copy_i Theta X U := member (imap X U) Theta.

% For some reason, retrieving the Sim name from the fixed point doesn't seem to work!
Define name_mnu : string -> (i -> bool) -> prop by
	name_mnu "step" Step := step Step ;
	name_mnu "sim"  Sim  := sim  Sim.
