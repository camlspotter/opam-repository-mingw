#!/bin/bash
set -e
prefix="$(readlink -f "$1")"

#WHERE="${prefix}/lib/ocaml"
#INSTALLDIR="${prefix}/lib/labltk"
#INSTALLBINDIR="${prefix}/bin"

system="$(ocamlfind ocamlc -config | awk '/^system:/ {print $2}')"
CC=$(shell $(OCAMLC) -config 2>/dev/null | awk '/^bytecomp_c_compiler/ {for(i=2;i<=NF;i++) printf "%s " ,$$i}')
export CC
#RANLIB=ranlib
case "$system" in
    mingw64)
        sys_root=/usr/x86_64-w64-mingw32/sys-root/mingw
        if which x86_64-w64-mingw32-ranlib 2>/dev/null 2>&1; then
            RANLIB=x86_64-w64-mingw32-ranlib
            export RANLIB
        fi
        ;;
    mingw*)
        sys_root=/usr/i686-w64-mingw32/sys-root/mingw
        if which i686-w64-mingw32-ranlib 2>/dev/null 2>&1; then
            RANLIB=x86_64-w64-mingw32-ranlib
            export RANLIB
        fi

        ;;
    *)
        echo "system unsupported" >&2
        exit 1
esac

libtcl=
libtk=
tkversion=
for f in "${sys_root}/lib/tk"* ; do
    [ ! -d "$f" ] && continue
    tkversion="$(basename "$f" | tr -d 'tk')"
    p="$(echo "$tkversion" | tr -d '.')"
    #tkversion=${tkversion:2}
    f="${sys_root}/lib/libtcl${p}.a"
    if [ -f "$f" ]; then
        libtcl=$f
    fi
    f="${sys_root}/lib/libtk${p}.a"
    if [ -f "$f" ]; then
        libtk=$f
    fi
done
if [ -z "$libtcl" ] || [ -z "$libtk" ]; then
    echo "libtcl or libtk not found" >&2
    exit 1
fi
cat - >config/Makefile <<EOF
USE_FINDLIB=yes
OPT=.opt
include ${prefix}/lib/ocaml/Makefile.config
INSTALLDIR=${prefix}/lib/labltk
INSTALLBINDIR=${prefix}/bin
TK_DEFS= -I${sys_root}/include/tcl${tkversion}
TK_LINK=-lws2_32 ${libtcl} ${libtk}
EOF

make -f Makefile.nt all allopt
