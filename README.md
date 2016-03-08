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

ACheck
------

Together with the [Abella](http://abella-prover.org/) interactive theorem prover
and the [Bedwyr](http://slimmer.gforge.inria.fr/bedwyr/) logic programming
environment, FPCcheck conforms the system we call ACheck. With it, we can use
FPCs to independently verify results formulated, and possibly proved in, Abella.

The following tutorial sections illustrate the use of this system, which itself
relies on FPC templates and examples included in this distribution. To use the
system, you will need the code in this repository, as well as a working
installation of both Abella and Bedwyr (see dependency notes for current
versions).

For more information you can refer to the following working paper:

> *Proof outlines as proof certificates: a system description*
> by Roberto Blanco and Dale Miller.
> [Draft](http://www.lix.polytechnique.fr/Labo/Dale.Miller/papers/acheck.pdf)
> dated 15 September 2015

The script `acheck.pl` automates a simple workflow given an Abella session file
and full paths to both Abella and Bedwyr. As with the other scripts, it is quick
and dirty with no advanced security built in, and best (one could argue
peremptorily) used in a controlled environment.

Tutorial
--------

Here we use the checker to certify results from the Abella proof assistant by
means of simple FPCs. A basic familiarity with its workflow is assumed, but can
easily be gained if needed by referring to the first sections of this primer:

> [*Abella: a system for reasoning about relational specifications*]
> (http://jfr.unibo.it/article/view/4650)
> by David Baelde *et al.*
> in Journal of Formalized Reasoning, vol. 7, no. 2, pp. 1-89 (2014)

Dependencies:

* [Abella 2.0.3-fpc](https://github.com/robblanco/abella/tree/fpc-translation)
  * OCaml 4.02.0 or newer

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
* `fpc-sign.thm`: signature based on `fpc-decl.thm` for internal use.
* `fpc-thms.thm`: for each theorem, an encoding for the checker and a verifier
  that takes a certificate and uses it to try to prove the theorem.
* `fpc-test.thm`: instantiation of the checker and proof assertions for all
  verifiers.

If the working directory is a direct subfolder of the checker, all its
components will be found and assembled. If necessary, correct the paths at the
top of `fpc-test.thm` to point to the actual location of the checker (i.e., all
those outside the set of files just mentioned).

The harness file `fpc-test.thm` furnishes default certificates that should be
able to prove many relatively simple results. To run the checker, use:

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
certificates (cf. the [FPC documentation](fpc/README.md) for further
information).

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

### From proof to certificate

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

### Adding lemmas

Let us now extend our session file with a proof of the commutativity of
addition, which employs lemmas for the sub-proofs of the *zero case* and the
*successor case* that will result from a proof by induction of the main result:

    Theorem plus0com : forall N, nat N ->  plus N z N.
    induction on 1. intros. case H1.
      search.
      apply IH to H2. search.

    Theorem plusscom : forall M, nat M -> forall N, nat N ->
                       forall P, plus M N P -> plus M (s N) (s P).
    induction on 1. intros. case H1.
      case H3. search.
      case H3. apply IH to H4. apply H6 to H2. apply H7 to H5. search.

    Theorem pluscom : forall N, nat N -> forall M, nat M ->
                      forall S, plus N M S -> plus M N S.
    induction on 1. intros. case H1.
      case H3. apply plus0com to H2. search.
      case H3. apply IH to H4. apply H6 to H2. apply H7 to H5.
        apply plusscom to H2. apply H9 to H4. apply H10 to H8. search.

We will focus on the main result, `pluscom`; the two lemmas will make for easy
practice after the explanation.

First of all, an important technical point that has some bearing on the
transition from Abella proofs to certificates: if you step throughout the proof
in Abella, you will notice that the *successor case* opens with the following
sequent:

    Variables: M S N1
    IH : forall N, nat N * ->
           (forall M, nat M -> (forall S, plus N M S -> plus M N S))
    H2 : nat M
    H3 : plus (s N1) M S
    H4 : nat N1 *
    ============================
     plus M (s N1) S

Here, the annotations match `N1` in `H4` with the natural number `N` upon which
we are inducing. The successor case shows up in `H3`, which is the subject of
the first step in the case: a natural, determinate unfolding. Critically, later
on we will appeal to `H4` directly to move forth with the proof, but the
induction rule of our sequent calculus **consumes** the fixed point it is
applied to: it appears unfolded, but not directly, in the resulting sequent. If
the proof relies on its presence, minor adjustments may be needed, as will be
seen shortly.

For now, let us duplicate the inductive assumption so that it will be present in
both systems (improvements in the translation procedure will enable automation
of this process easily). Thus, we will prove the following variant of the
theorem instead:

    Theorem pluscom : forall N, nat N -> nat N -> forall M, nat M ->
                      forall S, plus N M S -> plus M N S.
    induction on 1. intros. case H1.
      case H4. apply plus0com to H3. search.
      case H2. case H4. apply IH to H5 H6. apply H8 to H3. apply H9 to H7.
        apply plusscom to H3. apply H11 to H5. apply H12 to H10. search.

After the usual induction scheme and associated certificate, we commence with
the *zero case* for the first of two missing branches:

    Variables: M S
    IH : forall N, nat N * -> nat N ->
           (forall M, nat M -> (forall S, plus N M S -> plus M N S))
    H2 : nat z
    H3 : nat M
    H4 : plus z M S
    ============================
     plus M z S

Still in the asynchronous phase, we detect a clear unfolding candidate in `H4`,
and add it to the resources our certificate will need. Then we get to:

    Variables: S
    IH : forall N, nat N * -> nat N ->
           (forall M, nat M -> (forall S, plus N M S -> plus M N S))
    H2 : nat z
    H3 : nat S
    ============================
     plus S z S

Among our hypotheses, we have everything we need to invoke the previous lemma
`plus0com` to derive the desired conclusion, so everything is frozen and a
"global decision" is made to move to the synchronous phase. At the end, we will
have the conclusion among our premises. Therefore, the partial certificate is:

    (apply? 1 0 (idx "plus0com") ...)

And the resulting sequent:

    Variables: S
    IH : forall N, nat N * -> nat N ->
           (forall M, nat M -> (forall S, plus N M S -> plus M N S))
    H2 : nat z
    H3 : nat S
    H5 : plus S z S
    ============================
     plus S z S

So we simply close with `search` (also in the certificate) and move on to the
*successor case*:

    Variables: M S N1
    IH : forall N, nat N * -> nat N ->
           (forall M, nat M -> (forall S, plus N M S -> plus M N S))
    H2 : nat (s N1)
    H3 : nat M
    H4 : plus (s N1) M S
    H5 : nat N1 *
    ============================
     plus M (s N1) S

Here we see two obvious candidates for deterministic case analysis, i.e.,
asynchronous unfolding. Interestingly, one of those is the still unfolded form
of the inductive hypothesis, and the point of junction with our aforementioned
adjustments. We also let the proof proceed with the appeal to `IH`, as explained
before, and arrive at:

    Variables: M N1 P
    IH : forall N, nat N * -> nat N ->
           (forall M, nat M -> (forall S, plus N M S -> plus M N S))
    H3 : nat M
    H5 : nat N1 *
    H6 : nat N1
    H7 : plus N1 M P
    H8 : forall M, nat M -> (forall S, plus N1 M S -> plus M N1 S)
    ============================
     plus M (s N1) (s P)

At this point, the synchronous phase must follow. The proof script instructs to
select the implication `H8` (a local decide) picking one of the hypotheses to
satisfy the left branch, giving value to the free variable in the process and
producing `H9`:

    Variables: M N1 P
    IH : forall N, nat N * -> nat N ->
           (forall M, nat M -> (forall S, plus N M S -> plus M N S))
    H3 : nat M
    H5 : nat N1 *
    H6 : nat N1
    H7 : plus N1 M P
    H8 : forall M, nat M -> (forall S, plus N1 M S -> plus M N1 S)
    H9 : forall S, plus N1 M S -> plus M N1 S
    ============================
     plus M (s N1) (s P)

Still in the synchronous phase and focused on the resulting formula `H9`, we
find another implication, which we treat analogously yielding:

    Variables: M N1 P
    IH : forall N, nat N * -> nat N ->
           (forall M, nat M -> (forall S, plus N M S -> plus M N S))
    H3 : nat M
    H5 : nat N1 *
    H6 : nat N1
    H7 : plus N1 M P
    H8 : forall M, nat M -> (forall S, plus N1 M S -> plus M N1 S)
    H9 : forall S, plus N1 M S -> plus M N1 S
    H10 : plus M N1 P
    ============================
     plus M (s N1) (s P)

The product is a least fixed point, which by virtue of its polarity ends the
synchronous phase. So we ended the bipole with a local decision and two
asynchronous unfoldings, which betokens the certificate:

    (apply? 2 0 (idx "local") ...)

Now we can apply the successor lemma. This constitutes a shallow bipole: simply
decide on the lemma, choose the right hypotheses, and release with the new
conclusion hypothesis:

    Variables: M N1 P
    IH : forall N, nat N * -> nat N ->
           (forall M, nat M -> (forall S, plus N M S -> plus M N S))
    H3 : nat M
    H5 : nat N1 *
    H6 : nat N1
    H7 : plus N1 M P
    H8 : forall M, nat M -> (forall S, plus N1 M S -> plus M N1 S)
    H9 : forall S, plus N1 M S -> plus M N1 S
    H10 : plus M N1 P
    H11 : forall N, nat N -> (forall P, plus M N P -> plus M (s N) (s P))
    ============================
     plus M (s N1) (s P)

The certificate is likewise simple, filling part of the gap left by the previous
bipole and leaving room for a bit more of the proof:

    (apply? 0 0 (idx "plusscom") ...)

The rest of the proof is as the first bipole in the branch: there is nothing to
do except make a decision on the conclusion of the lemma, picking hypotheses for
its assumptions during the synchronous phase. At the end, we obtain a negative
formula that closes the bipole and coincides with the desired conclusion, so
`search` concludes both branch and proof.

    (apply? 0 0 (idx "local") search)

Here is the certificate for the full proof:

    (induction?
      (case? 0
        (apply? 1 0 (idx "plus0com") search)
        (apply? 2 0 (idx "local") (apply? 0 0 (idx "plusscom") (apply? 0 0 (idx "local") search)))
      )
    )

### From simple certificates to simple proofs

Simple certificates can be easier to arrive at and are certainly shorter. The
trade-off is less information and longer verification times spent in search of
the critical pieces of information left out of the proof outline.

Suppose now that by whichever dark arts we concoct the following block
certificate for `pluscom`:

    (induction 3 2 0 2 0)

From our previous efforts we can easily infer that this expresses a sufficiently
wide search space to prove the theorem, provided that the necessary lemmas are
available. But we do not need this to be the case, and it is often a reasonable
guess that a good library of lemmas will allow many results to be proven by such
basic certificates.

A more interesting question is how to go from a general, blind certificate to
a specific, guided one, closer to the proof reconstruction than the proof search
end of the spectrum, and in most cases substantially faster to check. In the
certificate constructors considered so far, there are two important kinds of
information: bounds and decisions. The latter both constrain the former and are
in general far more difficult to fiddle with. They constitute the skeleton of a
proof, and we will focus on them in this part.

The simple FPC template defines two additional families of constructors of
interest.

1. `(induction# B A S A S D)` and `(apply# B A S A S D)`: decorated counterparts
   of the block certificates with an additional parameter `D` representing the
   tree of decisions that are made throughout the proof.
2. `(pair# C1 C2)`: a certificate pair that takes two certificates `C1` and
   `C2` and uses them in tandem during checking.

One important idea behind certificate pairs is that they can be used to
implement _certificate elaboration_: checking one, fully defined certificate,
and using the reconstructed proof to produce a second, refined certificate, with
additional or different information.

In particular, we would like to retrieve the tree of decisions from the block
certificate `(induction 3 2 0 2 0)` in order to speed up subsequent checking of
the theorem. To this end, we can pair it with its decorated counterpart, where
the decision tree is unknown:

    (pair# (induction 3 2 0 2 0) (induction# 3 2 0 2 0 D))

If we attempt to check this certificate, and in the absence of contradicting
information, the first half must lead to the same proof as before. The second
half, proceeding in lockstep, will collect the tree of decisions and output it
upon success. We can use this to build a more detailed certificate like the one
we obtained constructively from the Abella proof script above. Slightly more
sophisticated marshalling will let the checker move from the decision tree to
the nested certificate by itself.

It should be noted that Bedwyr as runtime is not optimized for speed, and for
deep proofs detailed certificates currently have a very clear advantage over
simple ones.

Contributing
------------

Drop a line or get hacking!

How to know if you've broken something? Bedwyr support for debugging and unit
testing is rudimentary, so things can get interesting. The file `debug.thm`
implements the conventional debugging predicates and (generous) traces can be
obtained uncommenting lines ended with the `%DEBUG` marker in `.thm` files. To
toggle tracing, `debug.pl` can be used (this script rewrites files, play with it
with the usual care).

The current best shot at a test battery is the collection of harness files and
Abella sessions available in the `examples` folder. These can be thought of (and
run as) integration tests for the system. To run the whole test battery, use
`test.pl`.
