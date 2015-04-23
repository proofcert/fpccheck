FPCcheck
========

A prototype checker that uses foundational proof certificates (FPCs) to guide proof search. It accepts intuitionistic specifications written as logic programs. Internally, it uses a focused sequent calculus for the logic of choice.

Installation
------------

Dependencies:

* Bedwyr 1.4-beta1 or newer (will be bumped up presently).

Usage
-----

From scratch:

1. Define or choose an FPC template.
2. Write predicates and theorems.
3. Assemble the system and possibly write certificates for the theorems.
4. Load instantiated checker on Bedwyr.

To check everything:

    bedwyr -t -I my-system-harness.mod

Or interactively just:

    bedwyr my-system-harness.mod

More realistically, use a translator to bypass steps 1-3 (more about this soon).

Contributing
------------

Drop a line or get hacking!
