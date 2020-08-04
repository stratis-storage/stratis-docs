StratisErrorManagement.pdf: StratisErrorManagement.lyx
	lyx -batch --export pdf $<

clean:
	-rm StratisErrorManagement.pdf

check-closed-insets:
	@grep --quiet "^status open$$" StratisErrorManagement.lyx ; if [ $$? -ne "1" ] ; then exit 1 ; fi

check: check-closed-insets

.PHONY:
	check
	check-closed-insets
