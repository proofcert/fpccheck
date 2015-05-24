FPC templates
=============

This directory contains several useful FPC templates that allow varying types
and degrees of control over the checking process. The test harnesses in the
collection of examples supplied with the distribution are coded against these
certificate definitions, but can be checked against any other certificate.

The simple FPC
--------------

This template aims to be simple to read and write without sacrificing raw power
in the sense of the proofs that it can find compared to others, in particular
the administrative FPC.

It indexes stored formulas and lemmas by simple names, i.e., strings. A special
(but **not** reserved) name `"local"` is used to refer to local formulas if
needed.

### Certificate constructors

The FPC defines several families of certificates. They are meant to be modular
and usable independently from one another, but they can be mixed in some
meaningful ways that will be mentioned.

Note that Bedwyr operates under the closed world assumption and this fact
imposes that all clerk and expert definitions cover all families in one go,
making them seem somewhat more complex than they actually are.

#### Atomic blocks

These are constructors that fully characterize a region of the proof search
space. Being self-contained, and in the interest of simplicity, they manage
their own limited bookkeeping needs.

* `(induction B AU SU AC SC)`: do the obvious induction and perform bounded
  search as explained next.
* `(apply B AU SU AC SC)`: perform bounded search as explained next.
* `search`: apply the initial rules to finish the proof.

Bounded proof search depends on the following set of parameters:

* After the current negative-positive phase bipole, proof search may
  proceed up to `B` additional bipoles deeper, but no more.
* During each bipole following the current one, up to `AU` asynchronous
  unfolding operations may be performed during the negative phase.
* During each bipole following the current one, up to `SU` synchronous
  unfolding operations may be performed during the positive phase.
* For the remainder of the current bipole, up to `AC` asynchronous
  unfolding operations may be performed during the negative phase.
* For the remainder of the current bipole, up to `SC` synchronous
  unfolding operations may be performed during the positive phase.

Technically, `AC` and `SC` are decrementing counters initialized to `AU` and
`SU`, respectively, at the start of each bipole. There aren't many good reasons
to supply an initial certificate where the initial bipole counters are unequal
to the general bounds, and in this sense the certificate constructors are
simple, but a bit verbose.

In principle,
any theorem provable by the obvious induction followed by application of known
lemmas must have a certificate of the form `(induction B A S A S)` for suitable
values of `B`, `A`, `S`. Even more, any certificate `(induction B' A' S' A' S')`
with `B'` ≥ `B`, `A'` ≥ `A`, `S'` ≥ `S`, must succeed to prove the theorem as it
is merely allowed to search strictly more deeply than the first certificate.

This assumes that bounded search implements bounded search correctly in the
framework of the kernel. Of course, this will not be over quickly (and Bedwyr's
lack of emphasis on performance doesn't help), but it should be possible to
prove many simple, tedious results with very little effort.

We said "in principle" above because Bedwyr's implementation throws errors upon
encountering certain unification problems outside the scope of the G logic.

#### Decision trees

These constructors represent the structure of a proof more faithfully, notably
by including relevant branching and decision events. They are fully local and
need no explicit bookkeeping.

* `(induction? C)`: do the obvious induction on the first available fixed point
  and continue the proof using certificate `C`. (Note that freezing is not
  forbidden, so search can be a bit more complex than that, but has not been
  tested. Induction anywhere other than opening a proof could be troublesome.)
* `(case? A CL CR)`: in the current negative phase, look for the first left or.
  Apply the asynchronous unfolding operation at most `A` times to get to one
  such connective. To continue proof search, use certificates `CL` and `CR` for
  the left and right branch, respectively.
* `(apply? A S I C)`: finish the current bipole, and in the remainder perform at
  most `A` asynchronous unfolding operations and `S` synchronous unfolding
  operations. Use index `I` to select a formula for the positive phase. When the
  bipole is closed, use certificate `C` to continue proof search.

To close a branch in a nested certificate, simply use an atomic block. If
decision trees mimic proof scripts closely, this will most often be the simple
`search`.

Finally, to specify an index, give the name `N` of the lemma or local decision
inside the index constructor `(idx N)`.

#### Certificate pairs and elaborations

Certificates don't need to live in isolation. They can complement one another.

* `(pair# C1 C2)`: search for a proof using certificates `C1` and `C2` in
  parallel.

Extension of indexes. (Almost universal)

...

#### Marshalling

Marshalled forms are provided for block certificates to reflect the fact that
when someone writes `(induction B A S A S)` or `(apply B A S A S)`, they
should not have to bother initializing (even more, correctly and redundantly)
the current bipole counters. To this end, the following shorthand forms are
declared:

* `(induction! B A S)`: becomes `(induction B A S A S)`.
* `(apply! B A S)`: becomes `(apply B A S A S)`.

### Limitations

* Non-obvious induction invariants cannot be supplied.

* Nested induction is unsupported.

* Coinduction is unsupported.

* Bound range limitations.

  Bedwyr's pervasive signature defines the type of natural constants `nat` with
  the usual syntax. A significant limitation is that only equality is built in;
  no arithmetic operators are available. Moreover, they can only be implemented
  as operation tables.

  The simple FPC uses decrementation as its sole arithmetic primitive. An
  operator predicate is supplied for an interval [0, N] of the natural line and
  should be adjusted (perhaps automatically) if greater bounds are needed. By
  default, N = 20.

The administrative FPC
----------------------

These certificates (can) provide a significant amount of hand-holding.

Verbose (and brittle) due to kernel opacity.

Peano numerals.

vs. relatively unsupervised simple FPC: consider selection of hypotheses that
constitutes much of the information of a typical Abella script goes unencoded.

The dummy FPC
-------------

...
