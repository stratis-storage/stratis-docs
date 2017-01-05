StratisStyleGuidelines.pdf: StratisStyleGuidelines.lyx
	lyx -batch --export pdf $<

clean:
	-rm StratisStyleiGuidelines.pdf

check-closed-insets:
	@grep --quiet "^status open$$" StratisStyleGuiidelines.lyx ; if [ $$? -ne "1" ] ; then exit 1 ; fi

check: check-closed-insets

.PHONY:
	check
	check-closed-insets
