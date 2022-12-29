# -*- mode: Text; -*-

# Emacs Makefile
## Install Emacs in ~/Applications/Emacs.app from the Git source
### About

The  target  `install-emacs-app` clones  the  Git  source, builds  the
NextStep    version     of    Emacs     and    installs     it    into
`$HOME/Applications/Emacs.app` via  a symlink.   The prior  version of
`$HOME/Applications/Emacs.app` is  overwritten. (Actuall, since  it is
only a symlink, the code was overwritten when the target was built.)

### Suggestions on Configuring Your System

Here  are some  suggestions  on setting  up your  system  to use  this
application from the command-line:

If you add PATH references to

- $HOME/Applications/Emacs.app/Contents/MacOS/Emacs,
- $HOME/Applications/Emacs.app/Contents/MacOS/Emacs/bin,
- $HOME/Applications/Emacs.app/Contents/MacOS/Emacs/libexec

in  `/etc/paths.d/Emacs`,  (you need  to  make  these absolute  paths,
however) you can  then start  Emacs.app by entering  the command:

```
$ Emacs&
or
$ Emacs <file>&
```

(or  `emacs'  on  a  system   without  case  recognition)  from  the
command-line.  You can  also start a terminal emacs  by entering the
command

`$ emacs -nw <file>`

Note that there is also a target `install-emacs` that will install a
non-NextStep version  in `/usr/local`  but this will  interfere with
the above setup  because there is now ambiguity as  to which file to
run, `emacs` or  `Emacs`, so only one target or  the other should be
used.  (However, if your system  is case-sensitive, then this should
work to have both installed.)

Next, add the following code to your `init.el` to start the Emacs.app
server the first time Emacs.app is started:

```
(require 'server)
(when (display-graphic-p)
  (unless (server-running-p)
     (server-start)))
```

If you wish to have two  Emacs servers running, one in the graphical
application and one in the terminal, create a terminal server.  Here
is one suggested method.

Add the  following code to  your `~/.zshrc`  init file to  start the
terminal  server when  the  terminal  is booted.   It  checks for  a
running process that includes the server name `termserver`.

```
if ! pgrep -qlf termserver
then
  emacs -nw --daemon=termserver
fi
```

This code  will start the  Emacs.app program from  the command-line,
but is  not necessary if  you wish to  start the app  manually.  The
default name of the created server is `server'.

```
if ! pgrep -qf Emacs
then
  Emacs&
fi
```

Finally, add the following shell functions to utilize the respective
emacsclient servers:

```
ecg () {
        emacsclient -s server "$@"
}
ect () {
        emacsclient -s termserver "$@"
}
```

Now running `ecg <file>` will load the file into the Emacs.app server,
while `ect file` will load the file into the emacs -nw server.
