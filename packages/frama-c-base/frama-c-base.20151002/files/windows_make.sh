# This script allows Frama-C to be compiled under Cygwin + MinGW OCaml

# Test if 'cygpath' exists, otherwise assume we are not compiling under Cygwin
command -v cygpath >/dev/null 2>&1
if [ $? -eq 0 ]
then
    # Fix path using cygpath
    make FRAMAC_TOP_SRCDIR="$(cygpath -a -m $PWD)" $*
else
    # No cygpath? Nothing special to do
    make $*
fi
