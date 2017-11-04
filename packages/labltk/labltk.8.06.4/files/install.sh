#!/bin/bash
set -e

system="$(ocamlfind ocamlc -config | awk -F '[\t \r]+' '/^system:/ {print $2}')"
CC=$(ocamlfind ocamlc -config 2>/dev/null | awk -F '[\t \r]+' '/^bytecomp_c_compiler/ {for(i=2;i<=NF;i++) printf "%s " ,$i}')
export CC
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

make -f Makefile.nt install
