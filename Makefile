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
	cp ./docs/dbus/blockdev.xml ${PRE_SITE}
	cp ./docs/dbus/filesystem.xml ${PRE_SITE}
	cp ./docs/dbus/manager.xml ${PRE_SITE}
	cp ./docs/dbus/pool.xml ${PRE_SITE}

website-distrib: website-build
	zola build

website-test: website-distrib
	zola serve

yamllint:
	yamllint --strict .github/workflows/*.yml

check:
	(cd ./docs/design ; $(MAKE) check)
	(cd ./docs/dbus ; $(MAKE) check)
	(cd ./docs/style ; $(MAKE) check)
	make website-distrib

clean:
	- rm -Rf $(SITE)
	(cd ./docs/dbus ; $(MAKE) clean)
	(cd ./docs/design ; $(MAKE) clean)
	(cd ./docs/style ; $(MAKE) clean)

WEBSITE_REPO ?=
test-website-repo:
	echo "Testing that WEBSITE_REPO environment variable is set to a directory path"
	test -d "${WEBSITE_REPO}"

COMMIT_MSG ?=
test-commit-msg:
	echo "Testing that COMMIT_MSG environment variable is non-empty"
	test "${COMMIT_MSG}"

website-copy: test-website-repo test-commit-msg clean website-distrib
	(cd ${WEBSITE_REPO} && git checkout master && test `git status --porcelain | wc -l` = "0" && git ls-files | xargs rm)
	(cd ./public; cp * -R ${WEBSITE_REPO})
	(cd ${WEBSITE_REPO}; git add .; git commit -m "${COMMIT_MSG}")

.PHONY:
	check
	clean
	pdfs
	test-commit-msg
	test-website-repo
	website-copy
	website-distrib
	yamllint
