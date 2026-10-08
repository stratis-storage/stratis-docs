StratisStyleGuidelines.pdf: StratisStyleGuidelines.lyx
	lyx -batch --export pdf $<

.PHONY: clean
clean:
	-rm StratisStyleGuidelines.pdf

.PHONY: check-closed-insets
check-closed-insets:
	@grep --quiet "^status open$$" StratisStyleGuidelines.lyx ; if [ $$? -ne "1" ] ; then exit 1 ; fi

.PHONY: check
check: check-closed-insets
