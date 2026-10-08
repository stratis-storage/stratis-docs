SITE=./public
PRE_SITE=./static
LYX := $(if $(shell which lyx),,foo)

.PHONY: pdfs
pdfs:
ifdef LYX
	@echo "ERROR: No lyx found in PATH, cannot build PDF documentation"
	exit 1
endif
	(cd ./docs/design ; $(MAKE) StratisSoftwareDesign.pdf)
	(cd ./docs/dbus; $(MAKE) DBusAPIReference.pdf)
	(cd ./docs/style; $(MAKE) StratisStyleGuidelines.pdf)

.PHONY: website-build
website-build: pdfs
	cp ./docs/design/StratisSoftwareDesign.pdf $(PRE_SITE)
	cp ./docs/dbus/DBusAPIReference.pdf $(PRE_SITE)
	cp ./docs/style/StratisStyleGuidelines.pdf $(PRE_SITE)
	cp ./docs/dbus/blockdev.xml ${PRE_SITE}
	cp ./docs/dbus/filesystem.xml ${PRE_SITE}
	cp ./docs/dbus/manager.xml ${PRE_SITE}
	cp ./docs/dbus/pool.xml ${PRE_SITE}

.PHONY: website-distrib
website-distrib: website-build
	@ZOLA=$$(which zola 2>/dev/null); \
	if [ -z "$$ZOLA" ]; then \
		echo "ERROR: zola not found in PATH"; \
		exit 1; \
	fi; \
	mkdir -p templates; \
	$$ZOLA build

.PHONY: website-test
website-test: website-distrib
	@ZOLA=$$(which zola 2>/dev/null); \
	if [ -z "$$ZOLA" ]; then \
		echo "ERROR: zola not found in PATH"; \
		exit 1; \
	fi; \
	$$ZOLA serve

.PHONY: yamllint
yamllint:
	yamllint --strict .github/workflows/*.yml
	yamllint --strict .yamllint.yaml

.PHONY: check
check:
	(cd ./docs/design ; $(MAKE) check)
	(cd ./docs/dbus ; $(MAKE) check)
	(cd ./docs/style ; $(MAKE) check)
	make website-distrib

.PHONY: clean
clean:
	- rm -Rf $(SITE)
	(cd ./docs/dbus ; $(MAKE) clean)
	(cd ./docs/design ; $(MAKE) clean)
	(cd ./docs/style ; $(MAKE) clean)

.PHONY: check-typos
check-typos:
	typos

.PHONY: fix-typos
fix-typos:
	typos -w

WEBSITE_REPO ?=
.PHONY: test-website-repo
test-website-repo:
	echo "Testing that WEBSITE_REPO environment variable is set to a directory path"
	test -d "${WEBSITE_REPO}"

COMMIT_MSG ?=
.PHONY: test-commit-msg
test-commit-msg:
	echo "Testing that COMMIT_MSG environment variable is non-empty"
	test "${COMMIT_MSG}"

.PHONY: website-copy
website-copy: test-website-repo test-commit-msg clean website-distrib
	(cd ${WEBSITE_REPO} && git checkout master && test `git status --porcelain | wc -l` = "0" && git ls-files | xargs rm)
	(cd ./public; cp * -R ${WEBSITE_REPO})
	(cd ${WEBSITE_REPO}; git add .; git commit -m "${COMMIT_MSG}")

.PHONY: fmt
fmt:
	(cd ./docs/dbus ; $(MAKE) fmt)

.PHONY: fmt-ci
fmt-ci:
	(cd ./docs/dbus ; $(MAKE) fmt-ci)

.PHONY: resave
resave:
	lyx -e lyx ./docs/dbus/DBusAPIReference.lyx
	lyx -e lyx ./docs/design/StratisSoftwareDesign.lyx
	lyx -e lyx ./docs/style/StratisStyleGuidelines.lyx
