SITE=./public
PRE_SITE=./static
ZOLA := $(if $(shell which zola),,foo)
LYX := $(if $(shell which lyx),,foo)

website-build:
ifdef LYX
	@echo "ERROR: No lyx found in PATH, cannot build PDF documentation"
	exit 1
endif
ifdef ZOLA
	@echo "ERROR: No zola found in PATH, cannot build website. Follow instructions at https://getzola.org/documentation/"
	exit 1
endif
	cd ./docs/design ; $(MAKE) StratisSoftwareDesign.pdf; cd -
	cp ./docs/design/StratisSoftwareDesign.pdf $(PRE_SITE)
	cd ./docs/dbus; $(MAKE) DBusAPIReference.pdf; cd -
	cp ./docs/dbus/DBusAPIReference.pdf $(PRE_SITE)
	cd ./docs/style; $(MAKE) StratisStyleGuidelines.pdf; cd -
	cp ./docs/style/StratisStyleGuidelines.pdf $(PRE_SITE); cd -

website-distrib: website-build
	zola build

website-test: website-build
	zola serve

check:
	cd ./docs/design ; $(MAKE) check && cd -
	cd ./docs/dbus ; $(MAKE) check && cd -
	cd ./docs/style ; $(MAKE) check && cd -

clean:
	- rm -Rf $(SITE)
	cd ./docs/dbus ; $(MAKE) clean && cd -
	cd ./docs/design ; $(MAKE) clean && cd -
	cd ./docs/style ; $(MAKE) clean && cd -
	cd ./images ; $(MAKE) clean && cd -

.PHONY:
	check
	clean
	pdfs
	website-distrib
