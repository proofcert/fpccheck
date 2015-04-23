%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Certificate constructors %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TODO Integer indexes, if pervasive (the current kernel depends on them) need to
% be refactored!
Kind   numidx   type.
Type   z        numidx.
Type   s        numidx -> numidx.

Type   dummy    cert.
Type   bucket   idx.
%TODO decideLClerk' integrates more complex indexing assumptions in the kernel,
% which may have to be reconsidered or adequately promoted.
Type   idx      numidx -> boolidx -> idx.

%TODO This debugging definition is "taken" from the needs of the admin FPC. As
% debugging could be turned on, we currently need to supply everything to
% support all cases.
Define print_idx : numidx -> prop by print_idx I := print I.

%%%%%%%%%%%%%%%%%%%%%%
% Clerks and experts %
%%%%%%%%%%%%%%%%%%%%%%

Define andClerk     : cert ->       cert                                -> prop by andClerk C C.
Define orClerk      : cert ->       cert  -> cert                       -> prop by orClerk C C C.
Define impClerk     : cert ->       cert                                -> prop by impClerk C C.
Define ffClerk      : cert                                              -> prop by ffClerk C.
Define ttClerk      : cert ->       cert                                -> prop by ttClerk C C.
Define allClerk     : cert -> (i -> cert)                               -> prop by allClerk C (_\ C).
Define someClerk    : cert -> (i -> cert)                               -> prop by someClerk C (_\ C).
Define eqClerk      : cert ->       cert                                -> prop by eqClerk C C.
Define unfoldLClerk : cert ->       cert                                -> prop by unfoldLClerk C C.
Define indClerk     : cert ->       cert  -> (i -> cert) -> (i -> bool) -> prop by indClerk C C (_\C) (_\ tt).
Define indClerk'    : cert -> (i -> cert)                               -> prop by indClerk' C (_\C).
Define freezeLClerk : cert ->       cert  -> idx                        -> prop by freezeLClerk C C bucket.
Define unfoldRClerk : cert ->       cert                                -> prop by unfoldRClerk C C.
Define coindClerk   : cert ->       cert  -> (i -> cert) -> (i -> bool) -> prop by coindClerk C C (_\C) (_\ tt).
Define coindClerk'  : cert -> (i -> cert)                               -> prop by coindClerk' C (_\C).
Define freezeRClerk : cert ->       cert                                -> prop by freezeRClerk C C.

Define andExpert     : cert -> cert -> cert   -> prop by andExpert C C C.
Define orExpert      : cert -> cert -> choice -> prop by orExpert C C left ; orExpert C C right.
Define impExpert     : cert -> cert -> cert   -> prop by impExpert C C C.
Define impExpert'    : cert -> cert -> cert   -> prop by impExpert' C C C.
Define ttExpert      : cert                   -> prop by ttExpert C.
Define allExpert     : cert -> cert -> i      -> prop by allExpert C C _.
Define someExpert    : cert -> cert -> i      -> prop by someExpert C C _.
Define eqExpert      : cert                   -> prop by eqExpert C.
Define initLExpert   : cert         -> idx    -> prop by initLExpert C bucket.
Define unfoldLExpert : cert -> cert           -> prop by unfoldLExpert C C.
Define initRExpert   : cert         -> idx    -> prop by initRExpert C bucket.
Define unfoldRExpert : cert -> cert           -> prop by unfoldRExpert C C.

Define decideLClerk   : cert -> cert -> idx -> prop by decideLClerk C C bucket.
Define decideLClerk'  : cert -> cert -> idx -> prop by decideLClerk' C C bucket.
Define decideRClerk   : cert -> cert        -> prop by decideRClerk C C.
Define releaseLExpert : cert -> cert        -> prop by releaseLExpert C C.
Define releaseRExpert : cert -> cert        -> prop by releaseRExpert C C.
Define storeLClerk    : cert -> cert -> idx -> prop by storeLClerk C C bucket.
Define storeRClerk    : cert -> cert        -> prop by storeRClerk C C.
