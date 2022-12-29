# Install Emacs from Git Source
# 2022-12-28T2030 LOLH
#
# install-emacs-app clones the Git source, builds the NextStep version of Emacs
# and installs it into $HOME/Applications/Emacs.app
# You need to add PATH references to $HOME/Applications/Emacs.app/Contents/MacOS/Emacs, /bin, and /libexec
# You can then start Emacs.app by entering the command `emacs` (on a system without case recognition).
# You can also start a terminal emacs by entering the command `emacs -nw`.
# There is also a target `install-emacs` that will install a non-NextStep version in /usr/local/bin
# but this will interfere with the above setup, so only one or the other should be used.

EMACS-GIT-URL := https://git.savannah.gnu.org/git/emacs.git
GIT-CLONE := git clone
GIT-CLONE-DEPTH := --depth 1
EMACS-DIR := ~/.emacs.d
EMACS-SRC-DIR  := $(EMACS-DIR)/src
EMACS-SRC-EMACS := $(EMACS-SRC-DIR)/emacs
EMACS-GIT-DIR := $(EMACS-SRC-EMACS)/.git
EMACS-APP-BUILD-DIR := $(EMACS-SRC-EMACS)/app-build
EMACS-APP-EXE := $(EMACS-APP-BUILD-DIR)/nextstep/Emacs.app
EMACS-BUILD-DIR := $(EMACS-SRC-EMACS)/build
EMACS-EXE := $(EMACS-BUILD-DIR)/src/emacs
APP-CONFIGURE-OPTIONS :=
CONFIGURE-OPTIONS := --without-ns --disable-ns-self-contained

all: install-emacs-app

clone-git: | $(EMACS-GIT-DIR)

update-git: clone-git
	cd $(EMACS-SRC-EMACS); \
	git pull;

emacs-app-build-dir: clone-git | $(EMACS-APP-BUILD-DIR)
emacs-build-dir: clone-git | $(EMACS-BUILD-DIR)

install-emacs-app: emacs-app
	cd $(EMACS-APP-BUILD-DIR); \
	make install; \
	cp -fR $(EMACS-APP-BUILD-DIR)/nextstep/Emacs.app $$HOME/Applications;

emacs-app: emacs-app-build-dir $(EMACS-APP-EXE)
$(EMACS-APP-EXE): | update-git
	cd $(EMACS-SRC-EMACS); \
	./autogen.sh; \
	cd $(EMACS-APP-BUILD-DIR); \
	../configure $(APP-CONFIGURE-OPTIONS); \
	make -j6

install-emacs: emacs
	cd $(EMACS-BUILD-DIR); \
	sudo make install;

emacs:  emacs-build-dir $(EMACS-EXE)
$(EMACS-EXE): | update-git
	cd $(EMACS-SRC-EMACS); \
	./autogen.sh; \
	cd $(EMACS-BUILD-DIR); \
	../configure $(CONFIGURE-OPTIONS); \
	make -j6;

$(EMACS-GIT-DIR): | $(EMACS-SRC-DIR)
	cd $(EMACS-SRC-DIR); \
	$(GIT-CLONE) $(GIT-CLONE-DEPTH) $(EMACS-GIT-URL);

$(EMACS-SRC-DIR):
	mkdir -p $(EMACS-SRC-DIR)

$(EMACS-APP-BUILD-DIR):
	mkdir $(EMACS-APP-BUILD-DIR)

$(EMACS-BUILD-DIR):
	mkdir $(EMACS-BUILD-DIR)

clean:
	rm -rf $(EMACS-DIR)

clean-build-dirs:
	clean-app-build-dir
	clean-build-dir

clean-app-build-dir:
	rm -rf $(EMACS-APP-BUILD-DIR)

clean-build-dir:
	rm -rf $(EMACS-BUILD-DIR)

PHONEY: all emacs emacs-app install-emacs install-emacs-app  emacs-app-build-dir emacs-build-dir build-app-emacs build-emacs clone-git clean clean-build-dir clean-app-build-dir clean-build-dirs
