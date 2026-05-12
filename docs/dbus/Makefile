DBusAPIReference.pdf: DBusAPIReference.lyx
	lyx -batch --export pdf $<

clean:
	-rm DBusAPIReference.pdf

check-closed-insets:
	@grep --quiet "^status open$$" DBusAPIReference.lyx ; if [ $$? -ne "1" ] ; then exit 1 ; fi

check-no-tabs:
	grep --quiet -P "\t" ./blockdev.xml ; if [ $$? -ne "1" ] ; then exit 1 ; fi
	grep --quiet -P "\t" ./filesystem.xml ; if [ $$? -ne "1" ] ; then exit 1 ; fi
	grep --quiet -P "\t" ./manager.xml ; if [ $$? -ne "1" ] ; then exit 1 ; fi
	grep --quiet -P "\t" ./pool.xml ; if [ $$? -ne "1" ] ; then exit 1 ; fi

check: check-closed-insets check-no-tabs

fmt:
	xmllint --format ./blockdev.xml --output ./blockdev.xml
	xmllint --format ./filesystem.xml --output ./filesystem.xml
	xmllint --format ./manager.xml --output ./manager.xml
	xmllint --format ./pool.xml --output ./pool.xml

fmt-ci:
	@xmllint --format ./blockdev.xml --output ./blockdev.new.xml
	diff --brief ./blockdev.xml ./blockdev.new.xml ; if [ $$? -eq "1" ] ; then exit 1 ; fi
	@xmllint --format ./filesystem.xml --output ./filesystem.new.xml
	diff --brief ./filesystem.xml ./filesystem.new.xml ; if [ $$? -eq "1" ] ; then exit 1 ; fi
	@xmllint --format ./manager.xml --output ./manager.new.xml
	diff --brief ./manager.xml ./manager.new.xml ; if [ $$? -eq "1" ] ; then exit 1 ; fi
	@xmllint --format ./pool.xml --output ./pool.new.xml
	diff --brief ./pool.xml ./pool.new.xml ; if [ $$? -eq "1" ] ; then exit 1 ; fi

.PHONY:
	check
	check-closed-insets
	check-no-tabs
	fmt
	fmt-ci
