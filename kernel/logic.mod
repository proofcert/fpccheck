%%%%%%%%%
% Logic %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A logic system based on the intuitionistic fragment, i.e. muLJF with (for now)
% relatively minor additions (unfolding on both sides) and a unified fixed point
% implementation that maximizes reuse and minimizes repetition with minimal
% syntactic rococo.
% Consistently with said dictum, terms are single-typed and no explicit
% polymorphism is currently supported. This encompasses the encoding of argument
% lists for fixed points (which is not yet fully fossilized).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Base types
Kind   bool, i   type.

% Variable maps for term rewriting (optimal location?)
Kind   imap   type.
Type   imap   i -> i -> imap.

% Fixed point argument lists
Type   argv   i.
Type   ++     i -> i -> i.

% Logical constants
Type   tt, ff         bool.
Type   and, or, imp   bool -> bool -> bool.
Type   all, some      (i -> bool) -> bool.
Type   eq             i -> i -> bool.
Type   mu, nu         ((i -> bool) -> i -> bool) -> i -> bool.

% Polarities
Define negative : bool -> prop by
  negative (imp _ _) ;
  negative (all _) ;
  negative (nu _ _).

Define positive : bool -> prop by
  positive tt ; positive ff ;
  positive (and _ _) ; positive (or _ _) ;
  positive (some _) ;
  positive (eq _ _) ;
  positive (mu _ _).
