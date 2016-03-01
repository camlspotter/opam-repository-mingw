# opam mingw repository

My opam repository for windows - including an experimental build of opam
for windows (of course, you still need cygwin for nearly everything:
a shell interpreter to run configure scripts, git, rsync, ...)

## Homepage

There is now a small homepage with installation instructions and usage
information: https://fdopen.github.io/opam-repository-mingw/

## Summary

### Download

* [32-bit](https://dl.dropboxusercontent.com/s/eo4igttab8ipyle/opam32.tar.xz)
* [64-bit](https://dl.dropboxusercontent.com/s/b2q2vjau7if1c1b/opam64.tar.xz)

The archives contain native versions of opam, flexdll and aspcud. They
are all not linked against cygwin1.dll, so you can use them with
either the 32-bit or 64-bit version of cygwin.


### Installation

* First install [cygwin](https://cygwin.com/) and a few additionals
  packages: rsync, patch, diffutils, curl, make, unzip, git, m4, perl.
  And of course mingw64-i686-gcc-core and/or mingw64-x86_64-gcc-core.

* If your logon name contains whitespace characters (e.g. 'Firstname
  Lastname') or any other character that would require quoting inside
  a unix shell or cmd.exe, follow the instructions at
  https://www.cygwin.com/faq.html#faq.setup.name-with-space

* Then proceed inside a cygwin shell:

```bash
$ tar -xf 'opam32.tar.xz' # or tar -xf 'opam64.tar.xz'
$ bash opam32/install.sh  # --prefix /usr/foo, the default prefix is /usr/local
                          # maybe you have to add /usr/local/bin to your PATH
$ opam init mingw 'https://github.com/fdopen/opam-repository-mingw.git' --comp 4.02.3+mingw32 --switch 4.02.3+mingw32
# or, if you prefer the 64-bit version
$ opam init mingw 'https://github.com/fdopen/opam-repository-mingw.git' --comp 4.02.3+mingw64 --switch 4.02.3+mingw64
$ eval `opam config env`
```
## Things to remember

* Add `/usr/i686-w64-mingw32/sys-root/mingw/bin` (or
  `/usr/x86_64-w64-mingw32/sys-root/mingw/bin`) to your $PATH, if you
  use
  [depext-cygwinports](https://fdopen.github.io/opam-repository-mingw/depext-cygwin/)

* Consider to use windows symlinks inside cygwin:
  `export CYGWIN='winsymlinks:native'`. Otherwise ocamlbuild and many build
  and test scripts will create symlinks, that are only understood by
  cygwin tools, not the OCaml compiler and other native windows programs.
