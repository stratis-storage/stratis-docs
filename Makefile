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
	cd ./docs/guide; $(MAKE); cd -
	cp ./docs/guide/howto.html $(SITE)
	cd ./docs/relnotes; $(MAKE); cd -
	mkdir -p $(SITE)/relnotes
	cp ./website/style.css $(SITE)/relnotes
	cp ./docs/relnotes/*.html $(SITE)/relnotes

check:
	cd ./docs/design ; $(MAKE) check && cd -
	cd ./docs/dbus ; $(MAKE) check && cd -
	cd ./docs/style ; $(MAKE) check && cd -

clean:
	- rm -Rf $(SITE)
	cd ./docs/dbus ; $(MAKE) clean && cd -
	cd ./docs/design ; $(MAKE) clean && cd -
	cd ./docs/faq ; $(MAKE) clean && cd -
	cd ./docs/guide; $(MAKE) clean && cd -
	cd ./docs/relnotes ; $(MAKE) clean && cd -
	cd ./docs/style ; $(MAKE) clean && cd -
	cd ./images ; $(MAKE) clean && cd -

.PHONY:
	check
	clean
	website-distrib
