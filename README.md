FPCcheck
========

A prototype checker that uses foundational proof certificates (FPCs) to define
small outline proofs of lemmas that require simple inductions and previously 
proved lemmas. These definitions are given as intuitionistic specifications
written  as logic programs using least fixed point definitions. A focused
sequent calculus is used to structure the search used in the proof checker.

Installation
------------

Dependencies:

* [Bedwyr](http://slimmer.gforge.inria.fr/bedwyr/) 1.4-beta1 or newer (will be
  bumped up presently).

The checker is meant to be instantiated and loaded on top of the Bedwyr runtime,
and thus requires no dedicated installation procedure.

Usage
-----

Documentation and references coming shortly. The basic workflow is as follows.

From scratch:

1. Define or choose an FPC template.
2. Write predicates and theorems.
3. Assemble the system and possibly write certificates for the theorems.
4. Load instantiated checker on Bedwyr.

To check everything:

    bedwyr -t -I my-system-harness.thm

Or interactively just:

    bedwyr my-system-harness.thm

More realistically, use a translator to bypass steps 1-3 as shown below.

As Bedwyr has primitive support for modules and namespaces, be mindful to avoid,
and remember to check for, the usual silly errors: name clashes, order of
declarations and includes, etc.

Tutorial
--------

Here we use the checker to certify results from the Abella proof assistant by
means of simple FPCs.

Dependencies:

* [Abella 2.0.3-fpc](https://github.com/robblanco/abella/tree/fpc-translation)

The first thing you need is a file with the contents of an Abella session:
declarations, definitions and theorems. Proofs are currently ignored and can be
elided: to trust the correctness of the theorem (and its proof) we will put our
faith no longer in Abella, but in the checker; not in the proof script, but in
the certificate.

Run the session file through a translator prepared to export proof obligations
to the checker. Currently, this is an instrumented fork of Abella that can be
built and run normally and is available from
[here](https://github.com/robblanco/abella) (branch `fpc-translation`).
Interactive use is possible but somewhat more sensitive to errors. A (mostly)
error-free session is assumed. For batch processing, use:

    abella my-session-file.thm

The integrated translator in the background generates a collection of files in
the working directory, currently named as follows:

* `fpc-decl.thm`: declarations and definitions encoded for the checker.
* `fpc-sign.thm`: signature based on fpc-decl.thm for internal use.
* `fpc-thms.thm`: for each theorem, an encoding for the checker and a verifier
  that takes a certificate and uses it to try to prove the theorem.
* `fpc-test.thm`: instantiation of the checker and proof assertions for all
  verifiers.

If the working directory is a direct subfolder of the checker, all its
components will be found and assembled. If necessary, correct the paths at the
top of fpc-test.thm to point to the actual location of the checker (i.e., all
those outside the set of files just mentioned).

The harness file fpc-test.thm furnishes default certificates that should be able
to prove many relatively simple results. To run the checker, use:

    bedwyr -t -I fpc-test.thm

This will try to prove each theorem in turn using its verifier and the
certificate given in the corresponding assertion, terminating upon failure. This
failure could arise from a certificate that does not admit a proof of the
theorem, or possibly (if it was proved by Abella) from a bug in Abella itself:
the so called theorem may not be such!

For our current, tutorial purposes, let us assume the latter will not be the
case. :-)

After the definition of the original Abella file, the main user task would be
the production and refinement of certificates for each failing assertion until
all theorems are checked by their respective certificates. The translation makes
use of a simple FPC template that admits the following main types of
certificates (cf. ??? for further information).

1. Simple certificates: proofs as bounded-depth search.
  * `(induction B A S A S)`: induct greedily once, and attempt to find a proof
    with a maximum depth of `B` bipoles, plus initial rules at the end. Each
    bipole may contain `A` instances of the unfold inference rule during each 
    asynchronous phase, and `S` occurrences during each synchronous phase.
  * `(apply B A S A S)`: attempt to find a proof with a maximum depth of `B`
    bipoles, plus initial rules at the end. Each bipole may contain `A`
    instances of the unfold inference rule during each asynchronous phase, and
    `S` occurrences during each synchronous phase.

2. Nested certificates: proofs as trees of operations.
  * `(induction? C)`: induct greedily and continue using certificate `C`.
    Currently, it can only be used as the root of a tree.
  * `(case? A C1 C2)`: perform asynchronous case analysis greedily (left or)
    after at most `A` (asynchronous) unfoldings. Continue along each branch
    using certificates `C1` and `C2`, respectively.
  * `(apply? A S I C)`: close the current bipole unfolding at most `A` times
    during the remainder of the asynchronous phase and `S` times during the
    synchronous phase. Use index `I` to arbitrate the transition between both
    phases making either a local or global decision, i.e., a lemma. Continue
    using certificate `C` after closing the bipole.
  * `search`: try to finish the proof by application of the initial rules.

The translation generates verifiers accepting certificates of these shapes. In
any given proof, all previous theorems may be used as lemmas. Under the previous
certificate schemes of the simple FPC, indexing is given as:

* `(idx "local")`: make a local, internal decision, therefore private to the
  checker.
* `(idx "my-theorem-name")`: decide globally using `my-theorem-name`, declared
  earlier in the session.

Detailed (i.e., nested) certificates with tight bounds should always work well
in principle. On the other hand, being overly generous with unfoldings may, in
some cases, lead Bedwyr to unification problems it cannot solve, terminating the
proof instead of backtracking to safety.

Example
-------

To illustrate usage of the full system, suppose we have the following simple
Abella session, `plus.thm`:

    Kind   nat   type.
    Type   z     nat.
    Type   s     nat -> nat.

    Define nat : nat -> prop by
      nat z ;
      nat (s N) := nat N.

    Define plus : nat -> nat -> nat -> prop by
      plus z N N ;
      plus (s N) M (s P) := plus N M P.

    Theorem plustotal :
      forall N, nat N -> forall M, nat M -> exists S, plus N M S.
    induction on 1. intros. case H1.
      search.
      apply IH to H3. apply H4 to H2. search.

Ignoring for now the presence of proof scripts, we can now run the file through
Abella:

    abella plus.thm

This will generate a bunch of `.thm` files (as described above). Chief in
importance for us is `fpc-test.thm`, which opens with the following include
declarations:

    #include "../kernel/logic.thm".
    #include "../kernel/cert-sig.thm".
    #include "../fpc/simple-fpc.thm".
    #include "fpc-sign.thm".
    #include "../kernel/kernel.thm".
    #include "fpc-thms.thm".

If necessary, we adjust the `..` "placeholders" to point to the absolute or
relative path to the main checker directory. Once done, we turn our attention to
certificate design.

Considering the structure of the Abella proof of `plustotal`, there is the
common induction pattern:

    induction on #. intros. case H#.

We can achieve a similar result by application of the obvious induction, which
includes the case analysis that derives as many goals as the predicate has
clauses: two in the case of `plus`, the *zero case* and the *successor case*.
(If necessary, to accommodate the greedy nature of induction certificates, we
would reorder the hypotheses so that `H#` becomes `H1`.) In certificate terms,
this translates into:

    (induction?
      (case? 0
        ...
        ...
      )
    )

Where the two missing pieces are the sub-certificates for each case. Now, we
consider each resulting goal in turn.

For the *zero case*, we have:

    Variables: M
    IH : forall N, nat N * -> (forall M, nat M -> (exists S, plus N M S))
    H2 : nat M
    ============================
     exists S, plus z M S

All the script does is apply the `search` tactic. It is easy to see this
involves focusing on the right for the positive phase, unfolding once on the
right and applying initial rules. So following our certificate syntax, we get:

    (apply? 0 1 (idx "local") search)

For the *successor case*, we have:

    Variables: M N1
    IH : forall N, nat N * -> (forall M, nat M -> (exists S, plus N M S))
    H2 : nat M
    H3 : nat N1 *
    ============================
     exists S, plus (s N1) M S

Whereas in Abella we need to appeal to the induction hypothesis explicitly, it
becomes a natural consequence of the asynchronous phase, and we need not deal
with it explicitly in the certificate. After doing this, we arrive at this
state:

    Variables: M N1
    IH : forall N, nat N * -> (forall M, nat M -> (exists S, plus N M S))
    H2 : nat M
    H3 : nat N1 *
    H4 : forall M, nat M -> (exists S, plus N1 M S)
    ============================
     exists S, plus (s N1) M S

Note that at this point we have a collection of "atoms" and negative formulas
on the left, and a positive goal on the right: if nothing is done to the atoms,
they will be frozen, never to be touched again, and we will have reached the end
of the negative phase. The proof script instructs to operate on `H4` using other
hypotheses for assumptions. Thus, as explained, fixed points will be frozen and
the bipole will transition to the positive phase. Thus, we have one bipole:

    (apply? 0 0 (idx "local") ...)

After release, we will begin a new bipole:

    Variables: M N1 S
    IH : forall N, nat N * -> (forall M, nat M -> (exists S, plus N M S))
    H2 : nat M
    H3 : nat N1 *
    H4 : forall M, nat M -> (exists S, plus N1 M S)
    H5 : plus N1 M S
    ============================
     exists S, plus (s N1) M S

As before, the `search` tactic concludes the goal, and with it the proof:

    (apply? 0 1 (idx "local") search)

And so we arrive at the final certificate:

    (induction?
      (case? 0
        (apply? 0 1 (idx "local") search)
        (apply? 0 0 (idx "local") (apply? 0 1 (idx "local") search))
      )
    )

We could include this information in the Abella file making use of the `ship`
tactic, with the only proviso that double quotes should be encoded as single
quotes within the `.thm` file. The theorem would be stated thus:

    Theorem plustotal :
      forall N, nat N -> forall M, nat M -> exists S, plus N M S.
    ship "
      (induction?
        (case? 0
          (apply? 0 1 (idx 'local') search)
          (apply? 0 0 (idx 'local') (apply? 0 1 (idx 'local') search))
        )
      )
    ".

The resulting harness file `fpc-test.thm` will contain proof harnesses for each
theorem with a shipped certificate. Those proved or skipped within Abella will
present commented placeholders, but the translation will assume that trust in
their correctness lies elsewhere. In this way, we can verify all shipped
theorems without further action on our part:

    bedwyr -t -I fpc-test.thm

Note that full trust in the certificate requires that a certificate be supplied
and verified for every single theorem. Otherwise, correctness on the whole would
be proved subject to the correctness of the elided proofs.

Certificates can be written or rewritten directly on the `fpc-test.thm` file. In
this case, double quotes are written normally. Furthermore, there is no need to
fix everything prior to execution. Rather, we can load the system interactively:

    bedwyr fpc-test.thm

Within the session, we can attempt to prove a theorem invoking its proof
predicate (the theorem name concatenated with the suffix `__proof__`) and
supplying a certificate. For example:

    plustotal__proof__ (induction 1 0 1 0 1).

Contributing
------------

Drop a line or get hacking!
