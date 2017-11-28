StratisSoftwareDesign.pdf: StratisSoftwareDesign.lyx
	lyx -batch --export pdf $<

PoolStateDiagrams:
	dot -Tsvg PoolAssembly.gv -o PoolAssembly.svg
	dot -Tsvg PoolHealth.gv -o PoolHealth.svg
	dot -Tsvg PoolSpace.gv -o PoolSpace.svg
	dot -Tsvg ThinDev.gv -o ThinDev.svg

clean:
	-rm StratisSoftwareDesign.pdf
	-rm PoolAssembly.svg
	-rm PoolHealth.svg
	-rm PoolSpace.svg
	-rm ThinDev.svg

check-closed-insets:
	@grep --quiet "^status open$$" StratisSoftwareDesign.lyx ; if [ $$? -ne "1" ] ; then exit 1 ; fi

check: check-closed-insets

.PHONY:
	check
	check-closed-insets
