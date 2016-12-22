StratisSoftwareDesign.pdf: StratisSoftwareDesign.lyx
	lyx -batch --export pdf $<

clean:
	-rm DBusAPIReference.pdf

check-closed-insets:
	@grep --quiet "^status open$$" DBusAPIReference.lyx ; if [ $$? -ne "1" ] ; then exit 1 ; fi

check: check-closed-insets

.PHONY:
	check
	check-closed-insets
