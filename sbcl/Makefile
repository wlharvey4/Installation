# -*- mode: Make; -*-
# 2022-12-29T2120

SBCL-GIT-URL := https://github.com/sbcl/sbcl.git sbcl-dev
GIT-CLONE := git clone
GIT-CLONE-DEPTH := --depth 1
NCPU := -j$(getconf _NPROCESSORS_ONLN)

SBCL-DIR := /usr/local/dev/sbcl
SBCL-SRC-DIR := $(SBCL-DIR)/src
SBCL-SRC-SBCL := $(SBCL-SRC-DIR)/sbcl-dev
SBCL-GIT-DIR := $(SBCL-SRC-SBCL)/.git
SBCL-DOC-DIR := $(SBCL-SRC-SBCL)/doc/manual

SBCL-EXE := $(SBCL-SRC-SBCL)/run-sbcl.sh
SBCL-INFO := $(SBCL-DOC-DIR)/sbcl.info

# sudo make install
# installs sbcl into /usr/local/bin
# and documentation into /usr/local/share/info, etc.

sbcl: $(SBCL-EXE)

doc: $(SBCL-INFO)

install: sbcl doc
	cd $(SBCL-SRC-SBCL); \
	sh install.sh

clone-git: | sbcl-git-dir

update-git: clone-git
	cd $(SBCL-SRC-SBCL); \
	git pull;

sbcl-dir: | $(SBCL-DIR)

sbcl-src-dir: | sbcl-dir $(SBCL-SRC-DIR)

sbcl-git-dir: | sbcl-src-dir $(SBCL-GIT-DIR)

$(SBCL-EXE):
	cd $(SBCL-SRC-SBCL); \
	echo '"1.0.99.999"' > version.lisp-expr; \
	sh make.sh ccl

$(SBCL-DIR):
	mkdir -p $(SBCL-DIR)

$(SBCL-SRC-DIR):
	cd $(SBCL-DIR); \
	mkdir src;

$(SBCL-GIT-DIR):
	cd $(SBCL-SRC-DIR); \
	$(GIT-CLONE) $(GIT-CLONE-DEPTH) $(SBCL-GIT-URL);

$(SBCL-INFO):
	cd $(SBCL-DOC-DIR); \
	make;

clean-all:
	rm -rf $(SBCL-DIR)

PHONEY: sbcl doc install clone-git update-git sbcl-dir sbcl-src-dir sbcl-git-dir clean-all
