# -*- mode: Make; -*-
# 2022-12-29T1530 LOLH

CCL-GIT-URL := https://github.com/Clozure/ccl.git ccl-dev
CCL-BINARIES := curl -L -O https://github.com/Clozure/ccl/releases/download/v1.12.1/darwinx86.tar.gz
GIT-CLONE := git clone
GIT-CLONE-DEPTH := --depth 1
CCL-REBUILD := CCL_DEFAULT_DIRECTORY="" ./dx86cl64 --quiet --batch --no-init --eval '(ccl:rebuild-ccl :clean t)' --eval '(quit)'
NCPU := -j$(getconf _NPROCESSORS_ONLN)

CCL-DIR := /usr/local/dev/ccl
CCL-SRC-DIR := $(CCL-DIR)/src
CCL-SRC-CCL := $(CCL-SRC-DIR)/ccl-dev
CCL-GIT-DIR := $(CCL-SRC-CCL)/.git
CCL-BUILD-DIR := $(CCL-SRC-CCL)/lisp-kernel/darwinx8664

CCL-EXE := $(CCL-SRC-CCL)/dx86cl64
CCL-BOOT-IMAGE := $(CCL-SRC-CCL)/x86-boot64.image
BIN-CCL := /usr/local/bin/ccl

ccl: $(CCL-BOOT-IMAGE)

# this will probably require sudo
install: ccl $(BIN-CCL)

ccl-exe: | $(CCL-EXE)

clone-git: | ccl-git-dir

update-git: clone-git
	cd $(CCL-SRC-CCL); \
	git pull;

ccl-dir: | $(CCL-DIR)

ccl-src-dir: | ccl-dir $(CCL-SRC-DIR)

ccl-git-dir: | ccl-src-dir $(CCL-GIT-DIR)

$(BIN-CCL):
	touch $(BIN-CCL)
	echo "#! /bin/zsh" >> $(BIN-CCL); \
	echo "exec $(CCL-EXE)" >> $(BIN-CCL); \
	chmod +x /usr/local/bin/ccl; \

$(CCL-BOOT-IMAGE): | ccl-exe
	rm -rf ~/.cache/common-lisp;
	cd $(CCL-BUILD-DIR); \
	make clean; \
	make $(NCUP); \
	cd ../..; \
	$(CCL-REBUILD);

$(CCL-EXE): | update-git
	cd $(CCL-SRC-DIR); \
	$(CCL-BINARIES); \
	cd $(CCL-SRC-CCL); \
	tar -xf ../darwinx86.tar.gz;

$(CCL-GIT-DIR):
	cd $(CCL-SRC-DIR); \
	$(GIT-CLONE) $(GIT-CLONE-DEPTH) $(CCL-GIT-URL);

$(CCL-SRC-DIR):
	cd $(CCL-DIR); \
	mkdir src;

$(CCL-DIR):
	mkdir -p $(CCL-DIR)

clean-all:
	rm -rf $(CCL-DIR)

PHONEY: install-ccl ccl ccle-exe clone-git update-git ccl-dir ccl-src-dir ccl-git-dir clean-all
