# Install Emacs from Git Source
#
# Installation/emacs/Makefile
# Time-stamp: <2023-01-01 19:19:05 minilolh3>
#
# The  target `install-emacs-app`  clones the  Git source,  builds the
# NextStep    version    of    Emacs     and    installs    it    into
# $HOME/Applications/Emacs.app via  a symlink.   The prior  version of
# ~/Applications/Emacs.app is  overwritten.  If you want,  you can add
# (or replace)  the ~/.emacs.d/init.el file  with a template  found in
# this  repository  using  the  target  `replace-init`.   Any  current
# `init.el` is  saved as  a versioned backup  in the  hidden directory
# `.~` prior to being replaced.
#
# Also clone SLIME while we're at it.

#---------------------------------------------------------------------
# Here are  some suggestions  on setting  up your  system to  use this
# application from the command-line:

# If you add PATH references to
#
# - $HOME/Applications/Emacs.app/Contents/MacOS/Emacs,
# - $HOME/Applications/Emacs.app/Contents/MacOS/Emacs/bin,
# - $HOME/Applications/Emacs.app/Contents/MacOS/Emacs/libexec
#
# in  /etc/paths.d/Emacs,  (you need  to  make  these absolute  paths,
# however)
#
# you can  then start  Emacs.app by entering  the command
#
# $ Emacs&
# or
# $ Emacs <file>&
#
# (or  `emacs'  on  a  system   without  case  recognition)  from  the
# command-line.  You can  also start a terminal emacs  by entering the
# command
#
# $ emacs -nw <file>.
#
# Note that there is also a target `install-emacs' that will install a
# non-NextStep version  in `/usr/local'  but this will  interfere with
# the above setup  because there is now ambiguity as  to which file to
# run, `emacs' or  `Emacs', so only one target or  the other should be
# used.  (However, if your system  is case-sensitive, then this should
# work to have both installed.)

# Next, add the following code to your `init.el' to start the Emacs.app
# server the first time Emacs.app is started:

# (require 'server)
# (when (display-graphic-p)
#   (unless (server-running-p)
#      (server-start)))

# If you wish to have two  Emacs servers running, one in the graphical
# application and one in the terminal, create a terminal server.  Here
# is one suggested method.

# Add the  following code to  your `~/.zshrc`  init file to  start the
# terminal  server when  the  terminal  is booted.   It  checks for  a
# running process that includes the server name `termserver'.

# if ! pgrep -qlf termserver
# then
#   emacs -nw --daemon=termserver
# fi

# This code  will start the  Emacs.app program from  the command-line,
# but is  not necessary if  you wish to  start the app  manually.  The
# default name of the created server is `server'.

# if ! pgrep -qf Emacs
# then
#   Emacs&
# fi

# Finally, add the following shell functions to utilize the respective
# emacsclient servers:

# ecg () {
#         emacsclient -s server "$@"
# }
# ect () {
#         emacsclient -s termserver "$@"
# }

# Now running ecg `file' will load the file into the Emacs.app server,
# while ect `file' will load the file into the emacs -nw server.
#---------------------------------------------------------------------

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
SYMLINK-EMACS-APP := ln -fs $(EMACS-APP-BUILD-DIR)/nextstep/Emacs.app $$HOME/Applications
# use parallel processing in make -j#
NCPU := -j$(getconf _NPROCESSORS_ONLN)
EMACS-INIT-INPROGRESS := ./init.el.in-progress
EMACS-INIT := $(EMACS-DIR)/init.el

SLIME-GIT-URL := https://github.com/slime/slime.git
SLIME-SRC-DIR := $(EMACS-SRC-DIR)/slime
SLIME-GIT-DIR := $(SLIME-SRC-DIR)/.git


all: install-emacs-app slime-clone

clone-git: | $(EMACS-GIT-DIR)

update-git: clone-git
	cd $(EMACS-SRC-EMACS); \
	git pull;

emacs-app-build-dir: clone-git | $(EMACS-APP-BUILD-DIR)
emacs-build-dir: clone-git | $(EMACS-BUILD-DIR)

install-emacs-app: emacs-app
	cd $(EMACS-APP-BUILD-DIR); \
	make $(NCPU) install; \
	$(SYMLINK-EMACS-APP);

emacs-app: emacs-app-build-dir $(EMACS-APP-EXE)
$(EMACS-APP-EXE): | update-git
	cd $(EMACS-SRC-EMACS); \
	./autogen.sh; \
	cd $(EMACS-APP-BUILD-DIR); \
	../configure $(APP-CONFIGURE-OPTIONS); \
	make $(NCPU)

install-emacs: emacs
	cd $(EMACS-BUILD-DIR); \
	sudo make $(NCPU) install;

emacs:  emacs-build-dir $(EMACS-EXE)
$(EMACS-EXE): | update-git
	cd $(EMACS-SRC-EMACS); \
	./autogen.sh; \
	cd $(EMACS-BUILD-DIR); \
	../configure $(CONFIGURE-OPTIONS); \
	make $(NCPU);

$(EMACS-GIT-DIR): | $(EMACS-SRC-DIR)
	cd $(EMACS-SRC-DIR); \
	$(GIT-CLONE) $(GIT-CLONE-DEPTH) $(EMACS-GIT-URL);

$(EMACS-SRC-DIR):
	mkdir -p $(EMACS-SRC-DIR)

$(EMACS-APP-BUILD-DIR):
	mkdir $(EMACS-APP-BUILD-DIR)

$(EMACS-BUILD-DIR):
	mkdir $(EMACS-BUILD-DIR)

# This loads init.el, sets the time-stamp, and immediately saves it,
# thereby creating a numbered (versioned) backup in the subdirectory .~
# before replacing it with the template.
replace-init:
	emacs -nw -Q --batch \
	--eval '(save-current-buffer \
			(find-file-literally (locate-user-emacs-file "init.el")) \
			(setf backup-by-copying t version-control t \
			 backup-directory-alist (quote (("init.el" . ".~")))) \
			(time-stamp) \
			(save-buffer 64))'
	cp -f $(EMACS-INIT-INPROGRESS) $(EMACS-INIT)
	sed -i '' -e 's/.in-progress/ from template/' $(EMACS-INIT)

#===================================================================================

slime-clone: | $(SLIME-GIT-DIR)

slime-update: slime-clone
	cd $(SLIME-SRC-DIR); \
	git pull

$(SLIME-GIT-DIR): | $(EMACS-SRC-DIR)
	cd $(EMACS-SRC-DIR); \
	$(GIT-CLONE) $(GIT-CLONE-DEPTH) $(SLIME-GIT-URL)

#===================================================================================

clean:
	rm -rf $(EMACS-DIR)

clean-build-dirs:
	clean-app-build-dir
	clean-build-dir

clean-app-build-dir:
	rm -rf $(EMACS-APP-BUILD-DIR)

clean-build-dir:
	rm -rf $(EMACS-BUILD-DIR)

PHONEY: all emacs emacs-app install-emacs install-emacs-app  emacs-app-build-dir
PHONEY: emacs-build-dir build-app-emacs build-emacs
PHONEY: clone-git clean clean-build-dir clean-app-build-dir clean-build-dirs
