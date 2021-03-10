SITE=./public
PRE_SITE=./static
ZOLA := $(if $(shell which zola),,foo)
LYX := $(if $(shell which lyx),,foo)

pdfs:
ifdef LYX
	@echo "ERROR: No lyx found in PATH, cannot build PDF documentation"
	exit 1
endif
	(cd ./docs/design ; $(MAKE) StratisSoftwareDesign.pdf)
	(cd ./docs/dbus; $(MAKE) DBusAPIReference.pdf)
	(cd ./docs/style; $(MAKE) StratisStyleGuidelines.pdf)

website-build: pdfs
ifdef ZOLA
	@echo "ERROR: No zola found in PATH, cannot build website. Follow instructions at https://getzola.org/documentation/"
	exit 1
endif
	cp ./docs/design/StratisSoftwareDesign.pdf $(PRE_SITE)
	cp ./docs/dbus/DBusAPIReference.pdf $(PRE_SITE)
	cp ./docs/style/StratisStyleGuidelines.pdf $(PRE_SITE)

website-distrib: website-build
	zola build

website-test: website-build
	zola serve

yamllint:
	yamllint --strict .github/workflows/main.yml

check:
	(cd ./docs/design ; $(MAKE) check)
	(cd ./docs/dbus ; $(MAKE) check)
	(cd ./docs/style ; $(MAKE) check)
	(make website-distrib; make clean)

clean:
	- rm -Rf $(SITE)
	(cd ./docs/dbus ; $(MAKE) clean)
	(cd ./docs/design ; $(MAKE) clean)
	(cd ./docs/style ; $(MAKE) clean)

.PHONY:
	check
	clean
	pdfs
	website-distrib
	yamllint
