Core interfaces
===============

The checker consists of the definition of the logic and the kernel that
implements a focused proof system based on that logic, as well as a small set of
interfaces that enable programmability.

Logic interface
---------------

The "theorem hopefuls" that we aspire to prove need to be formulated in the
intuitionistic logic used by the system.

### Terms

Term constructors are supplied together with the predicates that use them. They
are simply typed on `i`, so typing information must be given explicitly through
typing judgments on variables.

As will be seen, fixed point arguments are also terms. A special term syntax is
reserved for them and will be given below.

This elementary approach affords great flexibility at the cost of some verbosity
when typing information must be given. The main known limitation concerns the
use of abstractions based on type `i`, as when trying to implement a full logic
on top of it.

### First-order logic with equality

The usual connectives are available in infix notation.

* Truth: `tt`.
* False: `ff`.
* Conjunction: `(and P Q)`, with `P` and `Q` formulas.
* Disjunction: `(or P Q)`, with `P` and `Q` formulas.
* Implication: `(imp P Q)`, with `P` and `Q` formulas.
* Equality: `(eq T U)`, with `T` and `U` terms.
* Universal quantifier: `(all x\ P)`, with a term variable `x` bound in a
  formula `P`.
* Existential quantifier: `(some x\ P)`, with a term variable `x` bound in a
  formula `P`.

### Fixed points

The logic has no given set of undefined, abstract atoms. Instead, fixed points
and the notion of freezing are used. The two definitions are as given.

* Least fixed point: `(mu B T)`, with `B` the body of the fixed point and a term
  `T` representing its arguments.
* Greatest fixed point: `(nu B T)`, with `B` the body of the fixed point and a
  term `T` representing its arguments.

A fixed point is defined as an abstraction over a predicate and its arguments.
For example:

    (mu Pred\ Args\ ...)

The first argument is a formula which represents the predicate named `Pred` here
and can refer to itself, i.e., call itself recursively. It can also inspect and
make use of the arguments.

The second argument is an argument vector that allows representation of
arbitrary argument lists using the special list constructors `++` (for infix
cons) and `argv` (for nil). Argument lists are terms.

The usual way to define a reusable fixed point is by partial application,
binding the connective to the body and using this with different sets of
arguments as needed. So to see if a term is a Peano numeral we may have:

    (mu Pred\ Args\ or
      (eq Args (zero ++ argv))
      (some X\ and
        (eq Args ((succ X) ++ argv))
        (Pred (X ++ argv))
      )
    )

Here we see how to decompose and create argument lists, how to make calls
(recursive or not), and how to encode the clauses of a predicate using
disjunction. If this expression is available somewhere, say in a variable
`IsNat`, we can compose full fixed point formulas:

    (IsNat ((succ zero) ++ argv))
    (IsNat ((cons a (cons b nil)) ++ argv))

Kernel interface
----------------

From the point of view of the user, the kernel provides a checking service in
two variants:

* `prove C F`: use certificate `C` to try to check the theoremhood of formula
  `F`.
* `prove_with_lemmas C F L`: like `prove C F` using lemmas from list `L`. Items
  in the list are of the form `(lemma I F)`, where `I` is an index that names
  the lemma and `F` is its formula representation.

### Sequents

The kernel implements and extension of the two-sided μLJF sequent calculus. The
sequents feature additional zones for frozen formulas and atoms, as well as
lemmas. Nonetheless, it is trivial to discard these additions to recover the
original calculus.

It may be useful to know that in the asynchronous phase formulas on the left
hand side are processed first from head to tail of the list. The goal formula on
the right hand side is considered only when the left hand side list is empty.

FPC interface
-------------

The kernel is an abstract checker, that is, it defines a number of predicates
and their signatures that must be provided in order to create a concrete,
working checker. Since the only function of these interface predicates is to
constrain proof search, soundness can never be compromised.

### Certificate and index constructors

These two are the foundation of the FPC. The designer has full freedom to define
whichever structures suit their purposes, and will not be discussed here. The
[FPC documentation](../fpc/README.md) discusses the templates provided by the
distribution in full.

### Marshalling

A certificate-to-certificate translator, `unmarshal M U` takes the input
certificate `M` given to a call to the kernel interface and preprocesses into
the unmarshalled certificate `U` that will be used by the checking process
proper.

The predicate is offered in the interest of readability. Complex certificates
may maintain an internal state that is of no interest to the author of the
certificate. This allows a clean separation between interface certificates and
internal certificates while providing a central point of entry and isolating
clerks and experts from these transformations.

If separation of formats is not desired, using the identity function as
translator will effectively disable this functionality.

### Clerks and experts

The functional core of an FPC definition is in the clerk and expert predicates
that constrain the proof search to be performed by the kernel.

What follows is the public interface for the μLJF sequent calculus extended with
clerks and experts. For additional information consult this paper as a good
starting point:

> [*Foundational proof certificates in first-order logic*]
> (https://hal.inria.fr/hal-00906485/document)
> by Zakaria Chihani, Dale Miller and Fabien Renaud
> in Proceedings of CADE 2013, LNAI vol. 7898, pp. 162-177 (2013)

And now, the interface.

* `(ffClerk C0)`: finish with `ff` on the left under `C0`.
* `(ttClerk C0 C1)`: consume `tt` on the left under `C0` and continue with `C1`.
* `(andClerk C0 C1)`: consume `and` on the left under `C0` and continue with
  `C1`.
* `(orClerk C0 C1 C2)`: consume `or` on the left under `C0` and continue the
  left branch with `C1`, and the right branch with `C2`.
* `(impClerk C0 C1)`: consume `imp` on the right under `C0` and continue with
  `C1`.
* `(eqClerk C0 C1)`: consume `eq` on the left under `C0` and continue with `C1`.
* `(ttExpert C0)`: finish with `tt` on the right under `C0`.
* `(andExpert C0 C1 C2)`: consume `and` on the right under `C0` and continue the
  left branch with `C1`, and the right branch with `C2`.
* `(orExpert C0 C1 LR)`: consume `or` on the right under `C0` and continue with
  `C1` on the left or right branch as given by the choice `LR`.
* `(impExpert C0 C1 C2)`: consume `imp` on the left under `C0` and continue the
  left branch with `C1`, and the right branch with `C2`. Do the right branch
  first.
* `(impExpert' C0 C1 C2)`: consume `imp` on the left under `C0` and continue the
  left branch with `C1`, and the right branch with `C2`. Do the left branch
  first.
* `(eqExpert C0)`: finish with `eq` on the right under `C0`.
* `(allClerk C0 (x\ C1))`: consume `all` on the right under `C0` and continue
   with `(C1 z)`, where `z` is the new eigenvariable.
* `(someClerk C0 (x\ C1))`: consume `some` on the left under `C0` and continue
   with `(C1 z)`, where `z` is the new eigenvariable.
* `(allExpert C0 C1 T)`: consume `all` on the left under `C0` and continue with
  `C1`, using `T` as the instantiation term.
* `(someExpert C0 C1 T)`: consume `some` on the right under `C0` and continue
  with `C1`, using `T` as the instantiation term.
* `(indClerk C0 C1 (x\ C2) (x\ S))`: apply induction to the left formula in
  process with the invariant `(S z)` under `C0` and continue the left branch
  with `C1`, and the right branch with `(C2 z)`, where z is the new
  eigenvariable.
* `(indClerk' C0 (x\ C1))`: apply the obvious induction to the left formula in
  process under `C0` and continue with `(C1 z)`, where z is the new
  eigenvariable.
* `(coindClerk C0 C1 (x\ C2) (x\ S))`: apply coinduction to the goal formula
  with the invariant `(S z)` under `C0` and continue the left branch
  with `C1`, and the right branch with `(C2 z)`, where z is the new
  eigenvariable.
* `(coindClerk' C0 (x\ C1))`: apply the obvious coinduction to the goal formula
  under `C0` and continue with `(C1 z)`, where z is the new
  eigenvariable.
* `(unfoldLClerk C0 C1)`: unfold the left formula in process under `C0` and
  continue with `C1`.
* `(unfoldRExpert C0 C1)`: unfold the goal formula on focus under `C0` and
  continue with `C1`.
* `(unfoldLExpert C0 C1)`: unfold the left formula on focus under `C0` and
  continue with `C1`.
* `(unfoldRClerk C0 C1)`: unfold the goal formula under `C0` and continue with
  `C1`.
* `(freezeLClerk C0 C1 I)`: freeze the left formula in process with index `I`
  under `C0` and continue with `C1`.
* `(initRExpert C0 I)`: finish with the initial rule from the goal formula to
  frozen left formulas with index `I` under `C0`.
* `(freezeRClerk C0 C1)`: freeze the goal formula under `C0` and continue with
  `C1`.
* `(initLExpert C0 _)`: finish with the initial rule from the left formula on
  focus to the goal formula under `C0`.
* `(storeLClerk C0 C1 I)`: store the left formula in process using index `I`
  under `C0` and continue with `C1`.
* `(decideLClerk C0 C1 I)`: decide on stored left formulas with index `I` under
  `C0` and continue with `C1`.
* `(decideLClerk' C0 C1 I)`: decide on lemmas with index `I` under `C0` and
  continue with `C1`.
* `(storeRClerk C0 C1)`: store the goal formula under `C0` and continue with
  `C1`.
* `(decideRClerk C0 C1)`: focus on the goal formula under `C0` and continue with
  `C1`.
* `(releaseLExpert C0 C1)`: release the left formula on focus under `C0` and
  continue with `C1`.
* `(releaseRExpert C0 C1)`: release the goal formula under `C0` and continue
  with `C1`.

System interface
----------------

A concrete instance of the full checker depends on the kernel as well as on the
chosen FPC and the definitions of terms and theorems to be proven. These are
properly speaking the application domain that concerns end users of the system.
