FPCcheck
========

A prototype checker that uses foundational proof certificates (FPCs) to guide proof search. It accepts intuitionistic specifications written as logic programs. Internally, it uses a focused sequent calculus for the logic of choice.

Installation
------------

Dependencies:

* Bedwyr 1.4-beta1 or newer (will be bumped up presently).

The checker is meant to be instantiated and loaded on top of the Bedwyr runtime, and thus requires no dedicated installation procedure.

Usage
-----

Documentation and references coming shortly. The basic workflow is as follows.

From scratch:

1. Define or choose an FPC template.
2. Write predicates and theorems.
3. Assemble the system and possibly write certificates for the theorems.
4. Load instantiated checker on Bedwyr.

To check everything:

    bedwyr -t -I my-system-harness.mod

Or interactively just:

    bedwyr my-system-harness.mod

More realistically, use a translator to bypass steps 1-3 as shown below.

As Bedwyr has primitive support for modules and namespaces, be mindful to avoid, and remember to check for, the usual silly errors: name clashes, order of declarations and includes, etc.

Tutorial
--------

Here we use the checker to certify results from the Abella proof assistant by means of simple FPCs.

Dependencies:

* Abella 2.0.3-dev with translation capabilities.

The first thing you need is a file with the contents of an Abella session: declarations, definitions and theorems. Proofs are currently ignored and can be elided: to trust the correctness of the theorem (and its proof) we will put our faith no longer in Abella, but in the checker; not in the proof script, but in the certificate.

Run the session file through a translator prepared to export proof obligations to the checker. Currently, this is an instrumented fork of Abella that can be built and run normally and is available from github.com/robblanco/abella. Interactive use is possible but somewhat more sensitive to errors. A (mostly) error-free session is assumed. For batch processing, use:

    abella my-session-file.mod

The integrated translator in the background generates a collection of files in the working directory, currently named as follows:

* fpc-decl.mod: declarations and definitions encoded for the checker.
* fpc-sign.mod: signature based on fpc-decl.mod for internal use.
* fpc-thms.mod: for each theorem, an encoding for the checker and a verifier that takes a certificate and uses it to try to prove the theorem.
* fpc-test.mod: instantiation of the checker and proof assertions for all verifiers.

If the working directory is a direct subfolder of the checker, all its components will be found and assembled. If necessary, correct the paths at the top of fpc-test.mod to point to the actual location of the checker (i.e., all those outside the set of files just mentioned).

The harness file fpc-test.mod furnishes default certificates that should be able to prove many relatively simple results. To run the checker, use:

    bedwyr -t -I fpc-test.mod

This will try to prove each theorem in turn using its verifier and the certificate given in the corresponding assertion, terminating upon failure. This failure could arise from a certificate that does not admit a proof of the theorem, or possibly (if it was proved by Abella) from a bug in Abella itself: the so called theorem may not be such!

For our current, tutorial purposes, let us assume the latter will not be the case. :-)

After the definition of the original Abella file, the main user task would be the production and refinement of certificates for each failing assertion until all theorems are checked by their respective certificates. The translation makes use of a simple FPC template that admits the following main types of certificates (cf. ??? for further information).

1. Simple certificates: proofs as bounded-depth search.

* (induction B A S A S): induct greedily once, and attempt to find a proof with a maximum depth of B bipoles, plus initial rules at the end. Each bipole may unfold A times during each asynchronous phase, and S times during each synchronous phase.
* (apply B A S A S): attempt to find a proof with a maximum depth of B bipoles, plus initial rules at the end. Each bipole may unfold A times during each asynchronous phase, and S times during each synchronous phase.

2. Nested certificates: proofs as trees of operations.

* (induction? C): induct greedily and using certificate C. Currently, it can only be used as the root of a tree.
* (case? A C1 C2): perform asynchronous case analysis greedily (left or) after at most A (asynchronous) unfoldings. Continue along each branch using certificates C1 and C2, respectively.
* (apply? A S I C): close the current bipole unfolding at most A times during the remainder of the asynchronous phase and S times during the synchronous phase. Use index I to arbitrate the transition between both phases making either a local or global decision, i.e., a lemma. Continue using certificate C after closing the bipole.
* search: try to finish the proof by application of the initial rules.

The translation generates verifiers accepting certificates of these shapes. In any given proof, all previous theorems may be used as lemmas. Under the previous certificate schemes of the simple FPC, indexing is given as:

* (idx "local"): make a local, internal decision, therefore private to the checker.
* (idx "my-theorem-name"): decide globally using my-theorem-name, declared earlier in the session.

Detailed (i.e., nested) certificates with tight bounds should always work well in principle. On the other hand, being overly generous with unfoldings may, in some cases, lead Bedwyr to unification problems it cannot solve, terminating the proof instead of backtracking to safety.

Contributing
------------

Drop a line or get hacking!
