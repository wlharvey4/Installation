# Install CCL Makefile
## Install Clozure Common Lisp from the Command-Line
### About

This Makefile will install Clozure Common Lisp (CCL) from the command-line
into `/usr/local/dev/ccl/src/ccl-dev`.

The install process is completely self-containted (self-bootstrapping) so no prior
Common Lisp executable is needed (unlike SBCL).

The executable is installed into `/usr/local/dev/ccl/src/ccl-dev/`
and a shell script is added to /usr/local/bin as `ccl`, which looks like this:

```
#! /bin/zsh
exec /usr/local/dev/ccl/src/ccl-dev/dx86cl64 "$@"
```
