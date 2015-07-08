sig cert.

kind cert type.
kind i type.
kind idx type.

kind choice type.
type left, right choice.

type ffClerk cert -> o.
type ttClerk cert -> cert -> o.
type andClerk cert -> cert -> o.
type orClerk cert -> cert -> cert -> o.
type impClerk cert -> cert -> o.
type eqClerk cert -> cert -> o.

type ttExpert cert -> o.
type andExpert cert -> cert -> cert -> o.
type orExpert cert -> cert -> choice -> o.
type impExpert cert -> cert -> cert -> o.
type impExpert' cert -> cert -> cert -> o.
type eqExpert cert -> o.

type allClerk cert -> (i -> cert) -> o.
type someClerk cert -> (i -> cert) -> o.
type allExpert cert -> cert -> i -> o.
type someExpert cert -> cert -> i -> o.

%type indClerk cert -> cert -> (i -> cert) -> (i -> bool) -> o.
type indClerk' cert -> (i -> cert) -> o.
%type coindClerk cert -> cert -> (i -> cert) -> (i -> bool) -> o.
type coindClerk' cert -> (i -> cert) -> o.

type unfoldLClerk cert -> cert -> o.
type unfoldRExpert cert -> cert -> o.
type unfoldLExpert cert -> cert -> o.
type unfoldRClerk cert -> cert -> o.

type freezeLClerk cert -> cert -> idx -> o.
type initRExpert cert -> idx -> o.
type freezeRClerk cert -> cert -> o.
type initLExpert cert -> o.

type storeLClerk cert -> cert -> idx -> o.
type decideLClerk cert -> cert -> idx -> o.
type decideLClerk' cert -> cert -> idx -> o.
type storeRClerk cert -> cert -> o.
type decideRClerk cert -> cert -> o.
type releaseLExpert  cert -> cert -> o.
type releaseRExpert  cert -> cert -> o.

end
