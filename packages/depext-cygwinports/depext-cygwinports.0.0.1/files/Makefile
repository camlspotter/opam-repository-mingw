.PHONY: all clean distclean install uninstall

PREFIX?= /usr/local
OCAMLFLAGS= -g -bin-annot -safe-string -w A-4-39

OSTYPE:=$(shell $(OCAMLFIND) ocamlc -config | awk '/^os_type/ { print $$2}')

ifeq ($(OSTYPE),$(filter $(OSTYPE),Win32 Cygwin))
all: nc pkg-config.exe
else
all: nc
endif

SOURCES= run.mli run.ml cygwininstall.mli cygwininstall.ml
RESULT= cygwin-install

PACKS = unix re.pcre ppx_deriving_yojson

pkg-config.exe: symlink.c config.h
	$(CC) -s symlink.c -o pkg-config.exe

clean::
	@rm -f *.a *.o *.cm* cygwin-install.exe *.dll *.so

distclean:: clean
	@rm -f config.h cygwin-dl.exe depext-cygwin.json *~

install: 
	mkdir -p $(PREFIX)/bin $(PREFIX)/etc
	install -m 0755 pkg-config.exe cygwin-dl.exe cygwin-install.exe $(PREFIX)/bin
	install -m 0644 depext-cygwin.json ports.gpg $(PREFIX)/etc

uninstall:
	rm -f $(PREFIX)/bin/pkg-config.exe $(PREFIX)/bin/cygwin-dl.exe $(PREFIX)/bin/cygwin-install.exe $(PREFIX)/etc/depext-cygwin.json $(PREFIX)/etc/ports.gpg

include OCamlMakefile
