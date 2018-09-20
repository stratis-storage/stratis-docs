SITE=./_site

website-distrib: check
	mkdir $(SITE)
	cp -R ./website/* $(SITE)
	cd ./docs/design ; $(MAKE) StratisSoftwareDesign.pdf; cd -
	cp ./docs/design/StratisSoftwareDesign.pdf $(SITE)
	cd ./docs/dbus; $(MAKE) DBusAPIReference.pdf; cd -
	cp ./docs/dbus/DBusAPIReference.pdf $(SITE)
	cd ./docs/style; $(MAKE) StratisStyleGuidelines.pdf; cd -
	cp ./docs/style/StratisStyleGuidelines.pdf $(SITE)
	cd ./docs/faq; $(MAKE); cd -
	cp ./docs/faq/FAQ.html $(SITE)

check:
	cd ./docs/design ; $(MAKE) check && cd -
	cd ./docs/dbus ; $(MAKE) check && cd -
	cd ./docs/style ; $(MAKE) check && cd -

clean:
	- rm -Rf $(SITE)

.PHONY:
	check
	clean
	website-distrib
