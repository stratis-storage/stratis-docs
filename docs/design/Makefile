StratisSoftwareDesign.pdf: StratisSoftwareDesign.lyx
	lyx -batch --export pdf $<

.PHONY: clean
clean:
	-rm StratisSoftwareDesign.pdf

.PHONY: check-closed-insets
check-closed-insets:
	@grep --quiet "^status open$$" StratisSoftwareDesign.lyx ; if [ $$? -ne "1" ] ; then exit 1 ; fi

.PHONY: check
check: check-closed-insets
