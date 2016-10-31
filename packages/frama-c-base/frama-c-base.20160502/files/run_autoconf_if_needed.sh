#!/bin/sh -eux

if [ ! -f "configure" ]; then
  autoconf -f
fi
