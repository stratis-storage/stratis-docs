DBusAPIReference.pdf: DBusAPIReference.lyx
	lyx -batch --export pdf $<

clean:
	-rm DBusAPIReference.pdf

check-closed-insets:
	@grep --quiet "^status open$$" DBusAPIReference.lyx ; if [ $$? -ne "1" ] ; then exit 1 ; fi

check: check-closed-insets

fmt:
	xmllint --format ./blockdev.xml --output ./blockdev.xml
	xmllint --format ./filesystem.xml --output ./filesystem.xml
	xmllint --format ./manager.xml --output ./manager.xml
	xmllint --format ./pool.xml --output ./pool.xml

.PHONY:
	check
	check-closed-insets
	fmt
