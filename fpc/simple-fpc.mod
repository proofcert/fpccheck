%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FPC for administrative lemmas %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A reusable FPC that enables automatic derivation of common administrative
% lemmas.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TODO Configurable limits and programmatic predicates or given by Bedwyr (best).
%Define inc : nat -> nat -> prop by
%	inc  0  1 ; inc  1  2 ; inc  2  3 ; inc  3  4 ; inc  4  5 ; inc  5  6 ;
%	inc  6  7 ; inc  7  8 ; inc  8  9 ; inc  9 10 ; inc 10 11 ; inc 11 12 ;
%	inc 12 13 ; inc 13 14 ; inc 14 15 ; inc 15 16 ; inc 16 17 ; inc 17 18 ;
%	inc 18 19 ; inc 19 20.

Define dec : nat -> nat -> prop by
	dec  1  0 ; dec  2  1 ; dec  3  2 ; dec  4  3 ; dec  5  4 ; dec  6  5 ;
	dec  7  6 ; dec  8  7 ; dec  9  8 ; dec 10  9 ; dec 11 10 ; dec 12 11 ;
	dec 13 12 ; dec 14 13 ; dec 15 14 ; dec 16 15 ; dec 17 16 ; dec 18 17 ;
	dec 19 18 ; dec 20 19.

%%%%%%%%%%%%%%%%
% Full indexes %
%%%%%%%%%%%%%%%%

%HACK This is used as "common" and shouldn't be FPC-specific
Kind   numidx   type.
Type   z        numidx.
Type   s        numidx -> numidx.

%HACK Yet 'nother
Type   name    string -> boolidx.

Type   idx   string -> idx.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Certificate constructors %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Self-contained certificates: they end a chain or constitute one unto
% themselves. May generally comprise several bipoles, so the following numeric
% parameters are given:
%  - number of bipoles;
%  - number of asynchronous unfolds per bipole;
%  - number of synchronous unfolds per bipole;
%  - number of asynchronous unfolds left in current bipole; and
%  - number of asynchronous unfolds left in current bipole.
% In principle, the last two should be initialized to be equal to the full
% counts and are meant to be passive: one should not try to mess with them.
% The search certificate simply tries to end this within the current bipole
% without doing anything particularly smart.
Type   induction   nat -> nat -> nat -> nat -> nat -> cert.
Type   apply       nat -> nat -> nat -> nat -> nat -> cert.
Type   search                                         cert.

% Chained certificates: they perform their mandate and proceed to the next
% continuation certificate(s) when they are done; a chain or branch thereof will
% end with a self-contained certificate. The current certificates are:
%  - induction, to be applied immediately, without doing anything smart;
%  - case, an asynchronous split, possible involving a number of allowed
%    asynchronous unfolds, and yielding certificates for both sides; and
%  - apply, which represents a bipole with concrete allowances for both kinds of
%    unfolding operations and ends upon release; the index directs whether a
%    local or a global decide will be performed.
Type   induction?                         cert -> cert.
Type   case?        nat        -> cert -> cert -> cert.
Type   apply?       nat -> nat -> idx  -> cert -> cert.

#include "debug-simple-fpc.mod".

%%%%%%%%%%%%%%%%%%%%%
% Helper predicates %
%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------%
% Control structure - Computation limits %
%----------------------------------------%

Define unfoldAsync : cert -> cert -> prop by
	unfoldAsync (apply N AU SU AC SC) (apply N AU SU AC' SC) := dec AC AC' ;
	unfoldAsync (apply? AC SC I C) (apply? AC' SC I C) := dec AC AC' ;
	unfoldAsync (case? AC CL CR) (case? AC' CL CR) := dec AC AC'.

Define unfoldSync : cert -> cert -> prop by
	unfoldSync (apply N AU SU AC SC) (apply N AU SU AC SC') := dec SC SC' ;
	unfoldSync (apply? AC SC I C) (apply? AC SC' I C) := dec SC SC'.

Define endBipole : cert -> cert -> prop by
	endBipole (apply N AU SU _ _) (apply N' AU SU AU SU) := dec N N' ;
	endBipole (apply 0 _  _  _ _) search ;
	endBipole (apply? _ _ _ C) C.

Define isNotCase? : cert -> prop by
	isNotCase? (induction _ _ _ _ _) ;
	isNotCase? (apply _ _ _ _ _) ;
	isNotCase? search ;
	isNotCase? (induction? _) ;
	isNotCase? (apply? _ _ _ _).

%%%%%%%%%%%%%%%%%%%%%%
% Clerks and experts %
%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------%
% Propositional asynchronous phase %
%----------------------------------%

Define ffClerk : cert -> prop by
	ffClerk Cert
	:= println "ffClerk" %DEBUG
	.

Define ttClerk : cert -> cert -> prop by
	ttClerk Cert Cert
	:= println "ttClerk" %DEBUG
	.

Define andClerk : cert -> cert -> prop by
	andClerk Cert Cert
	:= println "andClerk" %DEBUG
	.

Define orClerk : cert -> cert -> cert -> prop by
	orClerk Cert Cert Cert :=
		isNotCase? Cert
		/\ println "orClerk not case?" %DEBUG
		;
	orClerk (case? _ CertL CertR) CertL CertR
	:= println "orClerk case?" %DEBUG
	.

Define impClerk : cert -> cert -> prop by
	impClerk Cert Cert
	:= println "impClerk" %DEBUG
	.

Define eqClerk : cert -> cert -> prop by
	eqClerk Cert Cert
	:= println "eqClerk" %DEBUG
	.

%---------------------------------%
% Propositional synchronous phase %
%---------------------------------%

Define ttExpert : cert -> prop by
	ttExpert Cert
	:= println "ttExpert" %DEBUG
	.

Define andExpert : cert -> cert -> cert -> prop by
	andExpert Cert Cert Cert
	:= println "andExpert" %DEBUG
	.

Define orExpert : cert -> cert -> choice -> prop by
	orExpert Cert Cert left 
	:= println "orExpert left" %DEBUG
	;
	orExpert Cert Cert right
	:= println "orExpert right" %DEBUG
	.

Define impExpert : cert -> cert -> cert -> prop by impExpert _ _ _ := false.

Define impExpert' : cert -> cert -> cert -> prop by
	impExpert' Cert Cert Cert
	:= println "impExpert'" %DEBUG
	.

Define eqExpert : cert -> prop by
	eqExpert Cert
	:= println "eqExpert" %DEBUG
	.

%-------------%
% Quantifiers %
%-------------%

Define allClerk : cert -> (i -> cert) -> prop by
	allClerk Cert (_\ Cert)
	:= println "allClerk" %DEBUG
	.

Define someClerk : cert -> (i -> cert) -> prop by
	someClerk Cert (_\ Cert)
	:= println "someClerk" %DEBUG
	.

Define allExpert : cert -> cert -> i -> prop by
	allExpert Cert Cert _
	:= println "allExpert" %DEBUG
	.

Define someExpert : cert -> cert -> i -> prop by
	someExpert Cert Cert _
	:= println "someExpert" %DEBUG
	.

%-------------------------%
% Fixed points: induction %
%-------------------------%

Define indClerk : cert -> cert -> (i -> cert) -> (i -> bool) -> prop by
	indClerk _ _ _ _ := false.

Define indClerk' : cert -> (i -> cert) -> prop by
	indClerk' (induction N AU SU AC SC) (_\ apply N AU SU AC SC)
	:= println "indClerk' induction" %DEBUG
	;
	indClerk' (induction? Cert) (_\ Cert)
	:= println "indClerk' induction?" %DEBUG
	.

Define coindClerk : cert -> cert -> (i -> cert) -> (i -> bool) -> prop by
	coindClerk _ _ _ _ := false.

Define coindClerk' : cert -> (i -> cert) -> prop by coindClerk' _ _ := false.

%----------------------%
% Fixed points: unfold %
%----------------------%

Define unfoldLClerk : cert -> cert -> prop by
	unfoldLClerk Cert Cert' :=
		unfoldAsync Cert Cert'
		/\ println "unfoldLClerk" %DEBUG
		.

Define unfoldRExpert : cert -> cert -> prop by
	unfoldRExpert Cert Cert' :=
		unfoldSync Cert Cert'
		/\ println "unfoldRExpert" %DEBUG
		.

Define unfoldLExpert : cert -> cert -> prop by
	unfoldLExpert Cert Cert' :=
		unfoldSync Cert Cert'
		/\ println "unfoldLExpert" %DEBUG
		.

Define unfoldRClerk : cert -> cert -> prop by unfoldRClerk _ _ := false.

%----------------------------------%
% Fixed points: freeze and initial %
%----------------------------------%

Define freezeLClerk : cert -> cert -> idx -> prop by
	freezeLClerk Cert Cert (idx "atom")
	:= println "freezeLClerk" %DEBUG
	.

Define initRExpert : cert -> idx -> prop by
	initRExpert Cert (idx "atom")
	:= println "initRExpert" %DEBUG
	.

Define freezeRClerk : cert -> cert -> prop by
	freezeRClerk Cert Cert
	:= println "freezeLClerk" %DEBUG
	.

Define initLExpert : cert -> idx -> prop by
	initLExpert Cert _
	:= println "initLExpert" %DEBUG
	.

%------------------%
% Structural rules %
%------------------%

Define storeLClerk : cert -> cert -> idx -> prop by
	storeLClerk Cert Cert (idx "local")
	:= print "storeLClerk" %DEBUG
	.

%TODO Return singleton index?
Define decideLClerk : cert -> cert -> idx -> prop by
	decideLClerk Cert Cert (idx "local") :=
		Cert = (apply _ _ _ _ _)
		/\ print "decideLClerk apply" %DEBUG
		;
	decideLClerk Cert Cert Idx :=
		Cert = (apply? _ _ Idx _)
		/\ print "decideLClerk apply?" %DEBUG
		.

%TODO What to return? Or let the kernel fill the gaps
Define decideLClerk' : cert -> cert -> idx -> prop by
	decideLClerk' Cert Cert Idx :=
		Cert = (apply _ _ _ _ _)
		/\ print "decideLClerk' apply" /\ println Idx %DEBUG
		;
	decideLClerk' Cert Cert Idx :=
		Cert = (apply? _ _ Idx _)
		/\ print "decideLClerk' apply?" /\ println Idx %DEBUG
		.

Define storeRClerk : cert -> cert -> prop by
	storeRClerk Cert Cert
	:= println "storeRClerk" %DEBUG
	.

% In this case, adding apply? is not so clear because we can do it without giving a name, which would make no sense if we have lemmas there... so possibly modify this!
Define decideRClerk : cert -> cert -> prop by
	decideRClerk Cert Cert := (
		Cert = (apply _ _ _ _ _) \/
		Cert = (apply? _ _ _ _) \/
		Cert = search)
		/\ println "decideRClerk" %DEBUG
		.

Define releaseLExpert : cert -> cert -> prop by
	releaseLExpert Cert Cert' :=
		endBipole Cert Cert'
		/\ println "releaseLExpert" %DEBUG
		.

Define releaseRExpert : cert -> cert -> prop by
	releaseRExpert Cert Cert' :=
		endBipole Cert Cert'
		/\ println "releaseRExpert" %DEBUG
		.
