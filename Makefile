SITE=./_site

website-distrib: check
	mkdir $(SITE)
	cp -R ./website/* $(SITE)
	cd ./docs/design ; $(MAKE) StratisSoftwareDesign.pdf; cd -
	cp ./docs/design/StratisSoftwareDesign.pdf $(SITE)

check:
	cd ./docs/design ; $(MAKE) check && cd -

clean:
	- rm -Rf $(SITE)

.PHONY:
	check
	clean
	website-distrib
