# No TJROOT; tj* must be in PATH.

%.lpo : %.mod %.sig
	tjcc $*

# Main build target
%.lp : %.lpo
	tjlink $*

-include depend
depend: *.mod *.sig
	tjdepend *.mod > depend-stage
	mv depend-stage depend

.PHONY: clean
clean:
	rm -f *.lpo *.lp depend
