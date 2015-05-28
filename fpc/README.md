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
(but **not** reserved) name `"local"` is used to refer to local formulas where
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

* `(induction B AU SU AC SC)`: do the obvious (co)induction and perform bounded
  search as explained next.
* `(inductionS B AU SU AC SC S)`: like `(induction B AU SU AC SC)` using `S` as
  invariant.
* `(apply B AU SU AC SC)`: perform bounded search as explained next.
* `search`: apply the initial rules to finish the proof.

Bounded proof search depends on the following set of parameters:

* After the current negative-positive phase bipole, proof search may
  proceed up to `B` additional bipoles deeper, but no more.
* For each bipole following the current one, up to `AU` asynchronous
  unfolding operations may be performed during the negative phase.
* For each bipole following the current one, up to `SU` synchronous
  unfolding operations may be performed during the positive phase.
* For the remainder of the current bipole, up to `AC` asynchronous
  unfolding operations may be performed during the negative phase.
* For the remainder of the current bipole, up to `SC` synchronous
  unfolding operations may be performed during the positive phase.

Technically, `AC` and `SC` are decrementing counters initialized to `AU` and
`SU`, respectively, at the beginning of each bipole. There aren't many good
reasons to supply a certificate where the initial bipole counters are unequal to
the general bounds, and in this sense the certificate constructors are simple,
but a bit verbose.

In principle,
any theorem provable by the obvious induction followed by application of known
lemmas must have a certificate of the form `(induction B A S A S)` for suitable
values of `B`, `A`, `S`. Even more, any certificate `(induction B' A' S' A' S')`
with `B'` ≥ `B`, `A'` ≥ `A`, `S'` ≥ `S`, must succeed to prove the theorem as it
is merely allowed to search strictly more deeply than the first certificate.

This assumes that bounded search is implemented correctly in the framework of
the kernel. Of course, this will not be over quickly (and Bedwyr's lack of
emphasis on performance doesn't help here), but it should be possible to prove
many simple, tedious results with very little effort.

We said "in principle" above because Bedwyr's implementation throws errors upon
encountering certain unification problems outside the scope of the G logic. This
limitation will be removed in the near future.

#### Decision trees

These constructors represent the structure of a proof more faithfully, notably
by including relevant branching and decision events. They are fully local and
need no explicit bookkeeping.

* `(induction? C)`: do the obvious (co)induction on the first available fixed
  point and continue the proof using certificate `C`. (Note that freezing is not
  forbidden, so search can be a bit more complex than that, but has not been
  tested. Induction anywhere other than opening a proof doesn't work well yet.)
* `(inductionS? CL CR S)`: like `(induction? C)` using `S` as invariant, and
  continue the proof using `CL` and `CR` along each branch.
* `(case? A CL CR)`: in the current negative phase, look for the first left or.
  Apply the asynchronous unfolding operation at most `A` times to get to one
  such connective. To continue proof search, use certificates `CL` and `CR` for
  the left and right branch, respectively.
* `(apply? A S I C)`: finish the current bipole, and until that point perform at
  most `A` asynchronous unfolding operations and `S` synchronous unfolding
  operations. Use index `I` to select a formula for the positive phase. When the
  bipole is closed, use certificate `C` to continue proof search.

To close a branch in a nested certificate, simply use an atomic block. If
decision trees mimic proof scripts closely, this will most often be the simple
`search`.

Finally, to specify an index, give the name `N` of the lemma or local decision
inside the index constructor `(idx N)`.

#### Certificate pairs and elaborations

Certificates do not necessarily exist in isolation. They can complement one
another, for example by providing separate pieces of information that together
guide proof search more effectively. A certificate pair constructor provides the
basic framework for this development.

* `(pair# C1 C2)`: search for a proof using certificates `C1` and `C2` in
  parallel.

Clerks and experts treat certificate pairs simply by decomposing them and
essentially calling themselves recursively on each half, compounding their
individual results (e.g., continuation certificates) in result pairs. An obvious
consequence is that the collection of index constructors must be extended
(internally) with an "index pair" constructor. Where certificate pairs are used,
so will index pairs, everywhere except to decide on lemmas: these are external
and unconcerned with the fact that complex indexing schemes are being used
behind the scenes.

A straightforward application of pairing is certificate elaboration. In a
simple scenario, two certificates are given: a first full certificate that
drives proof search and a second certificate, in lockstep with the first and
missing some pieces of information that will be filled out as the two proceed
with their exploration of the search space. The second certificate is
essentially a copy of the first with some extra parameters, unspecified at the
outset.

If we compare the two previous families of certificates, i.e., atomic blocks and
decision trees, the most significant difference between them is the absence of
decisional information in the former. It is clear that any successful proof must
somehow figure out this information, so we can define variants of the block
certificates with an additional structure to represent this:

* `(induction# B AU SU AC SC D)`: like `(induction B AU SU AC SC)` with
  decisions handled as explained next.
* `(apply# B AU SU AC SC D)`: like `(apply B AU SU AC SC)` with
  decisions handled as explained next.

In these certificates, `D` is a decision tree that represents all branching
points (left ors) and decisions with their corresponding indexes.

Now we can take a certificate pair like
`(pair# (induction B A S A S) (induction# B A S A S D))`
where only `D` is unknown and proof search will work as if given the block
certificate on its own. However, the tree of decisions will be recorded in `D`,
and if proof search succeeds this information will substantially limit the
amount of searching necessary in any future executions. We may even elaborate it
into a nested certificate of the second kind.

#### Marshalling

Marshalled forms are provided for block certificates to reflect the fact that
when someone writes `(induction B A S A S)` or `(apply B A S A S)`, they
should not have to bother initializing (even more, correctly and redundantly)
the current bipole counters. To this end, the following shorthand forms are
declared:

* `(induction! B A S)`: becomes `(induction B A S A S)`.
* `(apply! B A S)`: becomes `(apply B A S A S)`.

### Limitations

* Nested induction and coinduction are unsupported (limited by the kernel).

* Bound range limitations.

  Bedwyr's pervasive signature defines the type of natural constants `nat` with
  the usual syntax. A significant limitation is that only equality is built in;
  no arithmetic operators are available. Moreover, they can only be implemented
  as operation tables.

  The simple FPC uses decrementing as the sole arithmetic primitive. An
  operator predicate is supplied for an interval [0, N] of the natural line and
  should be adjusted (perhaps automatically) if greater bounds are needed. By
  default, N = 20.

### Examples

See the [main README](../README.md) for a guided tutorial.

The administrative FPC
----------------------

This experimental template errs on the side of detail. Its certificates (can)
provide a significant amount of hand-holding to direct proof search accurately.
On a high level, it is structurally similar to, and the direct foundation of,
the simple FPC, with some important differences.

A general-purpose index is defined for storage of formulas. It consists of two
parts:
* A *numeric index* encoded as a Peano numeral with an additional don't-care
  value.
* A *Boolean index* that labels and describes a formula, as explained below.

For lemmas, the numeric index will be a don't-care value and the Boolean index
will be a simple name, i.e., that of the lemma. For local formulas, the numeric
index will be a unique identifier and the Boolean index will hold bookkeeping
information.

A word of caution is due.
In general, the smart strategies enabled by this certificate will tend to be
rather verbose. This is primarily because the current kernel is very opaque and
disallows all inspection of its internal state. Read-only access would simplify
matters considerably and add robustness. Lacking these capabilities, the only
way for clerks and experts to "synchronize" with what the kernel is doing is to
mimic the relevant pathways of its internal state. This is an **ugly hack** at
best, and very brittle, even if the kernel is meant to be extremely stable.
Improvements in this area are planned.

The inception of the FPC control structures was informed by the Tac style of
proof search, and subsequently refined. These structures are the subject of most
of the following subsections, and vestigial assumptions will be mentioned where
appropriate.

### Certificate constructors

The constructors in this FPC form a single family of tactics, similar to
though more subtle in their interactions than the ones in the simple FPC.

* `(induction Ctrl NamesB Cert)`: do the obvious (co)induction on the first
  available fixed point, constrained by `Ctrl`, and continue the proof using
  `Cert`. Use `NamesB` to give names to the components of the fixed point, as
  explained below.
* `(inductionS Ctrl S NamesB NamesS Cert)`: do (co)induction on the first
  available fixed point, constrained by `Ctrl`. Continue the proof using bounded
  search constrained by `Ctrl` for the *base case* and `Cert` for the *inductive
  case*. Use `NamesB` to give names to the components of the fixed point, as
  explained below. Use `S` as induction invariant and `NamesS` to give names to
  its components, as explained below.
* `(case Ctrl CertL CertR)`: do asynchronous case analysis (left or),
  constrained by `Ctrl`. Continue the proof using `CertL` and `CertR` for the
  left and right branch, respectively.
* `(apply Ctrl Idx Names Cert)`: do bounded search, constrained by `Ctrl`. Use
  `Idx` for the next global decision. Use `Names` to give names to the
  components of the lemma, as explained below. Continue the proof using `Cert`.
* `(search Ctrl)`: do bounded search constrained by `Ctrl`, except induction and
  global decisions.

#### Control structure

All certificates share a common control structure that maintains bounds and
bookkeeping parameters to constrain proof search. There is some variability in
the way these parameters are used by the FPC, as will be seen. The structure has
the form:

    (ctrl Limits Names)

Here `Names` represents a naming structure that will be the subject of the next
heading. Now we will devote our attention to the bounds and bookkeeping
structure `Limits`, which in turn is of the following shape:

    (limits D N L UL UR UM LN LL RR)

All the parameters are naturals represented as Peano numerals. They conform
several groups, usually distributed in pairs where explicit bookkeeping becomes
necessary.

* `D` is the depth in number of bipoles that proof search is allowed to inspect.
  After becoming zero, a release from the positive to the negative phase is no
  longer possible.
* `N` and `L` are bookkeeping counters for the local storage of formulas. Each
  formula to be stored is assigned a unique numeric index given by `L`, which is
  then incremented. Local decisions pick a number in the [0, `L` - 1] interval
  iterated by `N`. Both parameters should be initialized to zero.
  Both are meant to start at zero.
* `UL` is the maximum number of times that unfolding may be performed on the
  left for the current certificate.
* `UR` and `UM` are bookkeeping counters giving the maximum number of times that
  unfolding may be performed on the right for the current positive-negative
  phase and after each successive decision, respectively.
* `LN` and `LL` are internal bookkeeping counters to restrict global decision on
  lemmas. The current version of the FPC does not make use of them.
* `RR` is a special permission that allows bipoles to end with a right release
  rule, otherwise disallowed.

There are some interesting differences when we compare this with the much more
orthogonal configuration used in the simple FPC. They come from an original
application to Tac-like proofs involving least fixed points almost exclusively,
and extended only later to greatest fixed points. The treatment of unfoldings is
most telling, divided in left and right vs. asynchronous and synchronous. Right
unfoldings (usually synchronous) are reset on each decision on the assumption
that they constitute the computational bulk of the lot, whereas left unfoldings
are seen as essentially analytic. The special treatment of release on the
right reinforces this.

The use of nested certificates, generally necessary to express complex proofs
efficiently, blurs most of these distinctions, even for the mirrored treatment
of coinduction and greatest fixed points, which would appear to be somewhat more
involved. In this case, only minor differences are apparent.

#### Naming structure

Now we turn our attention to the second component of certificate control.
Consider the example of proof scripts written, say, in Abella. It is remarkable
that a script consists of a sequence of decisions, and these can be turned into
a certificate. In addition to selecting formulas and lemmas, an important part
of the instructions is the set of hypotheses that are used to instantiate each
formula that the proof operates upon.

This information has been absent from our certificates so far, which means
backtracking search must be applied to find a right combination of values, if
one indeed exists. In some cases this will be easy, but in others much time will
be wasted applying, say, sequences of lemmas that make no sense, or using the
wrong parameters, leading in the end to complex proof attempts that must be
discarded.

Syntactically, a formula can be seen as a tree whose nodes are the logical
connectives and whose leaves are chosen among the Boolean constants, the fixed
point operators and the equality operator. Interestingly, unfolding operations
can expand a fixed point leaf into a new subtree.

Given this interpretation, a *naming structure* associated to a formula is
another tree that replicates the branching structure of the first, at least down
to each and every one of its fixed points, and gives them names. For example,
the body of the fixed point for addition:

    (some K\ some M\ some N\ and
      (eq Args (K ++ M ++ N ++ argv))
      (or
        (and
          (eq K zero)
          (eq M N)
        )
        (some K'\ some N'\ and
          (and
            (eq K (succ K'))
            (eq N (succ N'))
          )
          (Pred (K' ++ M ++ N' ++ argv))
        )
      )
    )

May become:

    (split
      _
      (split
        _
        (split
          _
          (name "H1")
        )
      )
    )

Here linear branching (the quantifiers) is omitted from the syntax, and those
branches, simple or not, that do not contain any fixed points can be given
arbitrary identifiers because they will never be used to constrain the initial
rules that result in instantiation of fixed points, when used as atoms.

An additional precision regarding granularity is in order. If a leaf in a naming
tree covers an entire subformula, all leaves in the formula will be given the
name of the closest corresponding leaf in the naming structure. In this way it
is easy to declare "buckets" of formulas that can be selected using a single
name. For this reason anonymous variables should not be used for don't-care
branches. Instead, some other identifier is necessary.

The essence of naming structures is giving labels to the atoms in a formula so
that they can be matched with the contents of the context, in particular frozen
atoms acting as hypotheses. Formulas have no annotations, so these have to be
provided separately and in parallel. There are a few points where this is
possible. But first we need to consider how these structures are integrated in
the certificate constructors.

First we need to consider what the second member of the control structure does.
We have mentioned that the current implementation of logic formulas is
unannotated, but we still want to maintain some hypothesis naming information
for each relevant formula. We have also established that locally stored formulas
can hold this information in the Boolean half of their indexes, and so there
remain two parts of the sequent that lack indexing information: the list of
formulas being processed on the left, and the goal formula on the right. These
two will be stored in the second member:

    (names Delta Goal)

The trick creates a new requirement for the certificate: it must be aware of the
ways the kernel moves formulas around the sequent and replicate them exactly in
this control structure. This is a strong dependency that must be handled
carefully. By design, soundness is never at risk, though failure to keep track
of (exceptional) changes to the kernel would mean the pieces will not fit
together any more, and hypothesis naming would become unusable. (The predictable
solution is a slightly more transparent kernel that remains functionally
sealed.)

The root constructor of a certificate has to match the structure of the theorem
that is to be proved. If no naming features will be used, the following
suffices:

    (names nil (name "X"))

Initially, the list of formulas in progress is always empty. Using a single name
for all stored formulas is effectively the same as not performing any name
selection whatsoever. On the other hand, consider a theorem of the form:

    A -> B -> C

If we want to identify `A` with hypothesis `"H1"`, `B` with `"H2"` and C with
the goal `"G"`, we may write:

    (names nil (split (name "H1") (split (name "H2") (name "G"))))

Similarly, suppose there is in our collection a lemma of the form:

    D -> E

If our original `A` matches `D`, we may infer `E` from it. We can guide
selection by a certificate that supplies the name of this lemma and furthermore
picks the right hypotheses based on the names we gave them. So we would select
`"H1"` and give a new name to the conclusion, e.g. `"H3"`. We would write:

    (split (name "H1") (name "H3"))

The remaining important entry point of naming structures are the induction
certificates. These will always take a naming structure giving names to the
unfolding of the fixed point that is being induced upon. This means that we need
to know what our desired induction is, which given our guided use of induction
is a reasonable assumption.

For general induction, where the invariant is supplied by the certificate, an
additional naming structure matching the invariant must be supplied. For the
FPC to construct the naming structure that results from the induction rule,
the naming structure of the unfolding **must** indicate which leaf corresponds
to the place where the invariant (and its own naming structure) will be
injected. This is marked by the reserved leaf `(name "S")`.

Finally, consider that nested certificates inherit the state contained in the
naming structures of their immediate predecessors. Their immediate values are of
no consequence, as the state that will be passed to them cannot really be
predicted. In this regard, only the root value is meaningful.

#### Guessing



#### Marshalling

No marshalled constructors are currently declared, but can be used to hide
internal bookkeeping and initialization from public certificates while
preserving the general forms given here. A few running counters have as their
main function making selection more efficient and keeping some implementation
details relatively simple in the certificate. Besides that, they are useful for
debugging purposes.

### Limitations

* Nested induction and coinduction are unsupported (limited by the kernel).

* Obvious coinduction does not support naming structures fully.

### Examples



The dummy FPC
-------------

This certificate doesn't do anything remotely smart. It has a single certificate
constructor `dummy` and a single index `bucket`. All it does is propagate these
values whenever needed. It is syntactically correct and will prove some things
as well as establish obvious bugs in the kernel (given a good way to scaffold
tests).

It is unconstrained in its treatment of proof reconstruction, which compounded
with the DFS search strategy used by the current kernel means getting stuck is
what it's best at, besides inspecting the workings of an unfettered kernel.
