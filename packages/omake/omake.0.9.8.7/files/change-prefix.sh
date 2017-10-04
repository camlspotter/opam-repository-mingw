#!/bin/sh

set -eux

prefix="$(ocamlc -config | tr -d '\015' | awk '/^ranlib/ {print $2}' | sed 's|ranlib||g')"
sed -i "s|public.GCCTOOLPREFIX=i686-w64-mingw32-|public.GCCTOOLPREFIX=${prefix}|g" lib/build/C.om
sed -i 's|AR := $(AR)|AR := '"${prefix}ar|g" src/Makefile
