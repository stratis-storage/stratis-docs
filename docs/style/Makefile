StratisStyleGuidelines.pdf: StratisStyleGuidelines.lyx
	@LYX=$$(which lyx 2>/dev/null); \
	if [ -z "$$LYX" ]; then \
		echo "ERROR: lyx not found in PATH"; \
		exit 1; \
	fi; \
	$$LYX -batch --export pdf $<

.PHONY: clean
clean:
	-rm StratisStyleGuidelines.pdf

.PHONY: check-closed-insets
check-closed-insets:
	@grep --quiet "^status open$$" StratisStyleGuidelines.lyx ; if [ $$? -ne "1" ] ; then exit 1 ; fi

.PHONY: check
check: check-closed-insets
