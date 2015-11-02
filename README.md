# opam mingw repository

My opam repository for windows - including an experimental build of opam
for windows (of course, you still need cygwin for nearly everything:
a shell interpreter to run configure scripts, git, rsync, ...)

## Download

* [32-bit](https://dl.dropboxusercontent.com/s/eo4igttab8ipyle/opam32.tar.xz)
* [64-bit](https://dl.dropboxusercontent.com/s/b2q2vjau7if1c1b/opam64.tar.xz)

The archives contain native versions of opam, flexdll and aspcud. They
are all not linked against cygwin1.dll, so you can use them with
either the 32-bit or 64-bit version of cygwin.


## Installation

* First install [cygwin](https://cygwin.com/) and a few additionals
  packages: rsync, patch, diffutils, curl (or wget), make, unzip, git,
  m4, perl.  And of course mingw64-i686-gcc-core and/or
  mingw64-x86_64-gcc-core.

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

## External dependencies

Some external dependencies can be installed through
[cygwinports](http://cygwinports.org/):

* add `/usr/i686-w64-mingw32/sys-root/mingw/bin` or
  `/usr/x86_64-w64-mingw32/sys-root/mingw/bin` to your $PATH (in front
  of `/bin`, not after it!)

* `opam install depext depext-cygwinports`

* use it, e.g.

```bash
$ opam depext zarith
$ opam install zarith # or just 'opam depext zarith -i'
```

Use at your own risk. It's was hastily put together,...

## Package list

Some packages that can be installed (latest versions only, depext
enabled):

alcotest atd base-bigarray base-bytes base-threads base-unix base58
base64 batteries bear beluga bench benchmark bencode bes bin_prot
biniou bisect bitmasks bitstring bitv bolt bson calendar callipyge
caml2html camlimages camlmix camlp4 camlp5 camlpdf camlprime
camltemplate camlzip camomile cconv ccss cfg cmdliner cohttp
comparelib conduit conf-gmp conf-gtksourceview conf-libpcre
conf-pkg-config config-file containers cow cppo crc cryptgps
cryptohash cryptokit cstruct csv ctypes ctypes-foreign cubicle cudf
custom_printf cygwinpath decompress depext depext-cygwinports deriving
dolog dose dum dyntype dypgen easy-format enumerate estring expect
extlib-compat ezjsonm faillib fieldslib fileutils functory gen getopt
gg hamt herelib hex humane-re integration1d ipaddr js_of_ocaml jsonm
lablgtk lambda-term lazy-trie lwt magic-mime menhir mikmatch monadlib
monomorphic mparser mstruct oasis ocaml-data-notation ocaml-inifiles
ocaml-top ocamlfind ocamlgraph ocamlify ocamlmod ocamlnet ocamlscript
ocp-build ocp-indent ocp-index ocplib-endian ocurl odate omake omd
optcomp optimization1d ospec otfm ounit pa_bench pa_monad_custom
pa_ounit pa_ovisitor pa_test pa_where pcre pipebang ppx_deriving
ppx_deriving_yojson ppx_import ppx_include ppx_test ppx_tools pxp
qtest re react reactiveData root1d rope sedlex sequence sexplib
spotlib stringext syndic text textwrap tophide type_conv typerep tyxml
ucorelib uint ulex uri utop uucd uucp uuidm uunf uutf variantslib vg
xml-light xmlm xstr xstrp4 yojson zarith zed

Try it out to see, if they were really installed successfully or opam
just didn't report any errors :)
