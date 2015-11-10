# opam mingw repository

My opam repository for windows - including an experimental build of opam
for windows (of course, you still need cygwin for nearly everything:
a shell interpreter to run configure scripts, git, rsync, ...)

## Download

* [32-bit](https://dl.dropboxusercontent.com/s/eo4igttab8ipyle/opam32.tar.xz) (updated 9. Nov 2015)
* [64-bit](https://dl.dropboxusercontent.com/s/b2q2vjau7if1c1b/opam64.tar.xz) (updated 9. Nov 2015)

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
$ opam install zarith
```

## Package list

Some packages that can be installed (depext-cygwinports enabled):

```
# Installed packages for 4.02.3+mingw64:
abella                      2.0.3  Interactive theorem prover based on lambda-tr
alcotest                    0.4.5  Alcotest is a lightweight and colourful test
atd                         1.1.2  Parser for the ATD data format description la
base58                      0.1.2  Base58 encoding and decoding
base64                      2.0.0  Base64 encoding and decoding library
batteries                   2.3.1  Community-maintained foundation library
bear                        0.0.1  Bare essential additions to the stdlib
beluga                      0.8.2  A Language for programming and reasoning usin
bench                         1.3  A benchmarking tool for statistically valid b
benchmark                     1.4  Benchmark running times of code.
bencode                     1.0.2  Read/Write bencode (.torrent) files in OCaml
bes                       0.9.4.2  boolean expression simplifier
bignum                  113.00.00  Core-flavoured wrapper around zarith's arbitr
bin_prot                113.00.00  A binary protocol generator
biniou                      1.0.9  Binary data format designed for speed, safety
bisect                        1.3  Code coverage tool for the OCaml language
bitmasks                    1.0.0  BitMasks over int and int64 exposed as sets
bitstring                   2.0.4  bitstrings and bitstring matching for OCaml
bitv                          1.1  A bit vector library
bolt                          1.4  Bolt is an OCaml Logging Tool
bson                       0.89.3  A bson data structure, including encoding/dec
calendar                   2.03.2  Library for handling dates and times in your
callipyge                     0.1  Curve25519 in OCaml
caml2html                   1.4.3  Produce ready-to-go HTML files
camlimages                  4.2.1  Image processing library
camlmix                     1.3.0  Camlmix is a generic preprocessor which conve
camlp4                     4.02+6  Camlp4 is a system for writing extensible par
camlp5                       6.14  Preprocessor-pretty-printer of OCaml
camlpdf                     2.1.1  Read, write and modify PDF files
camlprime                     0.5  Primality testing with lazy lists of prime nu
camltemplate                1.0.2  Library for generating text from templates
camlzip                      1.05  Provides easy access to compressed files in Z
camomile                    0.8.5  A comprehensive Unicode library
cconv                       0.3.1  Combinators for Type Conversion in OCaml, and
ccss                          1.5  CCSS is a preprocessor for CSS, extending the
cfg                         2.0.4  Manipulate context-free grammars
cmdliner                    0.9.8  Declarative definition of command line interf
cohttp                     0.19.3  HTTP(S) library for Lwt, Async and Mirage
comparelib              113.00.00  Part of Jane Street's Core library
conduit                     0.9.0  Network connection library for TCP and SSL
conf-gmp                        1  Virtual package relying on a GMP lib system i
conf-gtksourceview              2  Virtual package relying on a GtkSourceView sy
conf-libcurl                    1  Virtual package relying on a libcurl system i
conf-libpcre                    1  Virtual package relying on a libpcre system i
conf-pkg-config               1.0  Virtual package relying on pkg-config install
config-file                   1.2  Small library to define, load and save option
containers                   0.14  A modular extension of the OCaml standard lib
core_kernel             113.00.00  Industrial strength alternative to OCaml's st
cow                         1.4.0  XML, JSON, HTML, CSS, and Markdown syntax and
cppo                        1.3.1  Equivalent of the C preprocessor for OCaml pr
crc                         0.9.0  CRC implementation supporting strings and cst
cryptgps                    0.2.1  Cryptographic functions
cryptohash                    0.1  hash functions for OCaml
cryptokit                    1.10  Cryptographic primitives library.
cstruct                     1.7.0  access C structures via a camlp4 extension
csv                         1.4.2  A pure OCaml library to read and write CSV fi
ctypes                      0.4.1  Combinators for binding to C libraries withou
ctypes-foreign              0.4.0  Virtual package for enabling the ctypes.forei
cubicle                     1.0.2  SMT based model checker for parameterized sys
cudf                          0.7  CUDF library (part of the Mancoosi tools)
custom_printf           113.00.00  Extension for printf format strings
cygwinpath                  0.1.1  Convert Unix and Windows format paths
decompress                    0.3  Pure OCaml implementation of Zlib
depext                      0.8.1  Query and install external dependencies of OP
depext-cygwinports          0.0.2  cygwinports wrapper for opam-depext
deriving                      0.7  Extension to OCaml for deriving functions fro
dolog                         3.0  the dumb OCaml logger (lazy and optionally co
dose                      4.0-rc3  Dose3 is a library and a collection of tools
dum                         1.0.1  Inspect the runtime representation of arbitra
dyntype                     0.9.0  syntax extension which makes OCaml types and
dypgen                 20120619-1  Self-extensible parsers and lexers for OCaml
easy-format                 1.0.2  High-level and functional interface to the Fo
enumerate               111.08.00  Quotation expanders for enumerating finite ty
estring                       1.3  Extension for string literals
expect                      0.0.4  Simple implementation of "expect" to help bui
extlib-compat               1.7.0  A complete yet small extension for OCaml stan
ezjsonm                     0.4.2  An easy interface on top of the Jsonm library
ezxmlm                      1.0.1  Combinators to use with XMLM for parsing and
faillib                 111.17.00  Part of Jane Street's Core library
fieldslib               113.00.00  Syntax extension to define first class values
fileutils                   0.4.4  Library to provide pure OCaml functions to ma
fstar                     0.9.1.1  An ML-like language with a type system for pr
functory                      0.5  Distributed computing library.
gen                         0.2.4  Simple and efficient iterators (modules Gen a
getopt                   20120615  Parsing of command line arguments (similar to
gg                          0.9.1  Basic types for computer graphics in OCaml
git                         1.7.1  Low-level Git bindings in pure OCaml
hamt                          0.1  Hash Array Mapped Tries
herelib                 112.35.00  Part of Jane Street's Core library
hex                         1.0.0  Minimal library providing hexadecimal convert
humane-re                   0.1.1  A human friendly interface to regular express
imap                        1.1.1  Non-blocking client library for the IMAP4rev1
integration1d               0.4.1  Integration of functions of one variable.
iocamljs-kernel             0.4.6  An OCaml javascript kernel for the IPython no
ipaddr                      2.6.1  IP (and MAC) address representation library
js_of_ocaml                   2.6  Compiler from OCaml bytecode to Javascript
json-pointer              0.1.1-0  JSON pointer
jsonm                       0.9.1  Non-blocking streaming JSON codec for OCaml
lablgtk                    2.18.3  OCaml interface to GTK+
lablgtk-extras                1.5  A collection of additional tools and librarie
lambda-term                   1.9  Terminal manipulation library for OCaml
lazy-trie                   1.1.0  Implementation of lazy prefix trees
lwt                         2.5.0  A cooperative threads library for OCaml
lz4                         1.1.0  Bindings for LZ4, a very fast lossless compre
magic-mime                  1.0.0  Convert file extensions to MIME types
menhir                   20151103  LR(1) parser generator
merlin                        2.3  Editor helper, provides completion, typing an
mikmatch                    1.0.8  OCaml syntax extension for regexps
monadlib                      0.1  A starter library for monads, with transforme
monomorphic                   1.2  A small library used to shadow polymorphic op
mparser                       1.1  A simple monadic parser combinator library
mstruct                     1.3.2  Mstruct is a thin mutable layer on top of cst
nodejs                        0.4  js_of_ocaml bindings for nodejs
oasis                       0.4.5  Architecture for building OCaml libraries and
oasis2opam                  0.6.2  Tool to convert OASIS metadata to OPAM packag
ocaml-data-notation        0.0.11  Store data using OCaml notation
ocaml-inifiles                1.2  An ini file parser
ocaml-top                   1.1.2  The OCaml interactive editor for education
ocamlfind                   1.5.6  A library manager for OCaml
ocamlgraph                  1.8.6  A generic graph library for OCaml
ocamlify                    0.0.1  Include files in OCaml code
ocamlmod                    0.0.8  Generate OCaml modules from source files
ocamlnet                    4.0.4  Internet protocols (http, cgi, email etc.) an
ocamlscript                 2.0.4  Tool which compiles OCaml scripts into native
ocp-build             1.99.9-beta  Project manager for OCaml
ocp-indent                  1.5.2  A simple tool to indent OCaml programs
ocp-index                   1.1.4  Lightweight completion and documentation brow
ocplib-endian                 0.7  Optimised functions to read and write int16/3
ocurl                       0.7.6  Bindings to libcurl
odate                         0.5  Date & Duration Library
omake                0.10.0+mingw  Build system designed for scalability and por
omd                         1.2.6  A Markdown frontend in pure OCaml.
opium                      0.13.3  Sinatra like web toolkit based on Lwt + Cohtt
optcomp                       1.6  Optional compilation with cpp-like directives
optimization1d              0.5.1  Find extrema of 1D functions.
ospec                       0.3.2  Behavior-Driven Development tool for OCaml, i
otfm                        0.2.0  OpenType font decoder for OCaml
ounit                       2.0.0  Unit testing framework loosely based on HUnit
pa_bench                113.00.00  Syntax extension for inline benchmarks
pa_monad_custom            v6.0.0  Syntactic Sugar for Monads
pa_ounit                113.00.00  Syntax extension for oUnit
pa_ovisitor                 1.0.0  CamlP4 type_conv module to auto-generate visi
pa_test                 112.24.00  Quotation expander for assertions.
pa_where                      0.4  Backward declaration syntax
pcre                        7.1.6  pcre-ocaml - bindings to the Perl Compatibili
pipebang                113.00.00  Part of Jane Street's Core library
piqi                        0.7.4  Protocol Buffers, JSON and XML serialization
piqilib                    0.6.12  The Piqi library -- runtime support for multi
pprint                   20140424  an OCaml adaptation of Wadler's and Leijen's
ppx_core                113.09.00  Standard library for ppx rewriters
ppx_deriving                  3.0  Type-driven code generation for OCaml >=4.02
ppx_deriving_yojson           2.4  JSON codec generator for OCaml >=4.02
ppx_import                    1.0  A syntax extension for importing declarations
ppx_include                   1.0  Include OCaml source files in each other
ppx_test                    1.2.1  A ppx replacement of pa_ounit.
ppx_tools                  0.99.3  Tools for authors of ppx rewriters and other
pxp                         1.2.7  Polymorphic XML Parser
qtest                       2.1.0  iTeML / qtest : Inline (Unit) Tests for OCaml
quickcheck                  1.0.2  Translation of QuickCheck from Haskell into O
re                          1.4.1  RE is a regular expression library for OCaml
react                       1.2.0  Declarative events and signals for OCaml
reactiveData                  0.1  Functional reactive programming with incremen
res                         4.0.7  RES - Library for resizable, contiguous datas
result                        1.1  Compatibility Result module
root1d                        0.3  Find roots of 1D functions.
rope                          0.5  Ropes ("heavyweight strings")
safepass                      1.3  A library enabling the safe storage of user p
sedlex                     1.99.2  unicode-friendly lexer generator (successor o
sequence                    0.5.5  Simple and lightweight sequence abstract data
sexplib                 113.00.00  Library for serializing OCaml values to and f
smart-print                 0.2.0  The pretty-printing library which feels natur
sosa                        0.1.0  Sane OCaml String API
spotlib                     2.5.3  Useful functions for OCaml programming used b
sqlexpr                     0.5.5  Type-safe, convenient SQLite database access.
sqlite3                     4.0.1  sqlite3-ocaml - SQLite3 bindings
ssl                         0.5.0  Bindings for OpenSSL
stdint                    0.3.0-0  signed and unsigned integer types having spec
stringext                   1.4.0  Extra string functions for OCaml
syndic                        1.4  RSS1, RSS2, Atom and OPML1 parsing
tar-format                  0.4.1  A pure OCaml library to read and write tar fi
tdk                         0.2.0  The Decision Kit is a collection of data stru
text                        0.8.0  Library for dealing with "text", i.e. sequenc
textwrap                      0.2  Text wrapping and filling library
toml                        2.2.1  TOML parser.
tophide                     1.0.3  Hides toplevel values whose name starts with
type_conv               113.00.02  Library for building type-driven syntax exten
typerep                 113.00.00  typerep is a library for runtime types.
tyxml                       3.5.0  A simple library for building valid HTML5 and
ucorelib                    0.0.2  A light weight Unicode library for OCaml
uint                        1.2.0  Unsigned ints for OCaml
ulex                          1.1  lexer generator for Unicode and OCaml
uri                         1.9.1  RFC3986 URI/URL parsing library
user-setup                    0.4  Helper for the configuration of editors for t
utop                       1.18.1  Universal toplevel for OCaml
uucd                        3.0.0  Unicode character database decoder for OCaml
uucp                        1.0.0  Unicode character properties for OCaml
uuidm                       0.9.5  Module for universally unique identifiers (UU
uunf                        1.0.0  Unicode text normalization for OCaml
uutf                        0.9.4  Non-blocking streaming Unicode codec for OCam
variantslib             109.15.03  Part of Jane Street's Core library
vg                          0.8.2  Declarative 2D vector graphics for OCaml
xml-light                     2.4  Xml-Light is a minimal XML parser & printer f
xmlm                        1.2.0  Streaming XML codec for OCaml
xstr                        0.2.1  Functions for string searching/matching/split
xstrp4                        1.8  Brace expansion (alias 'interpolation') perfo
yojson                      1.2.3  Yojson is an optimized parsing and printing l
zarith                        1.4  Implements arithmetic and logical operations
zed                           1.4  Abstract engine for text edition in OCaml
```

Try it out to see, if they were really installed successfully or opam
just didn't report any errors :)
