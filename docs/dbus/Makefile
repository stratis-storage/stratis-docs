DBusAPIReference.pdf: DBusAPIReference.lyx
	@LYX=$$(which lyx 2>/dev/null); \
	if [ -z "$$LYX" ]; then \
		echo "ERROR: lyx not found in PATH"; \
		exit 1; \
	fi; \
	$$LYX -batch --export pdf $<

.PHONY: clean
clean:
	-rm DBusAPIReference.pdf

.PHONY: check-closed-insets
check-closed-insets:
	@grep --quiet "^status open$$" DBusAPIReference.lyx ; if [ $$? -ne "1" ] ; then exit 1 ; fi

.PHONY: check-no-tabs
check-no-tabs:
	grep --quiet -P "\t" ./blockdev.xml ; if [ $$? -ne "1" ] ; then exit 1 ; fi
	grep --quiet -P "\t" ./filesystem.xml ; if [ $$? -ne "1" ] ; then exit 1 ; fi
	grep --quiet -P "\t" ./manager.xml ; if [ $$? -ne "1" ] ; then exit 1 ; fi
	grep --quiet -P "\t" ./pool.xml ; if [ $$? -ne "1" ] ; then exit 1 ; fi

.PHONY: check
check: check-closed-insets check-no-tabs

.PHONY: fmt
fmt:
	xmllint --format ./blockdev.xml --output ./blockdev.xml
	xmllint --format ./filesystem.xml --output ./filesystem.xml
	xmllint --format ./manager.xml --output ./manager.xml
	xmllint --format ./pool.xml --output ./pool.xml

.PHONY: fmt-ci
fmt-ci:
	@xmllint --format ./blockdev.xml --output ./blockdev.new.xml
	diff --brief ./blockdev.xml ./blockdev.new.xml ; if [ $$? -eq "1" ] ; then exit 1 ; fi
	@xmllint --format ./filesystem.xml --output ./filesystem.new.xml
	diff --brief ./filesystem.xml ./filesystem.new.xml ; if [ $$? -eq "1" ] ; then exit 1 ; fi
	@xmllint --format ./manager.xml --output ./manager.new.xml
	diff --brief ./manager.xml ./manager.new.xml ; if [ $$? -eq "1" ] ; then exit 1 ; fi
	@xmllint --format ./pool.xml --output ./pool.new.xml
	diff --brief ./pool.xml ./pool.new.xml ; if [ $$? -eq "1" ] ; then exit 1 ; fi
