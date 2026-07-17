#! /bin/bash
# Prior to conda-forge, Copyright 2014-2019 Peter Williams and collaborators.
# This file is licensed under a 3-clause BSD license; see LICENSE.txt.

set -e

DX11=""
# disable the Linux-only X11 accessibility backend on macOS —
# upstream doesn't support/need it here; forcing it on causes header
# mismatches like the GenericEvent error.
if [[ $target_platform == osx-arm64 ]]; then
  DX11="-Dx11=disabled"
fi

meson setup builddir \
    ${DX11} \
    --prefix=$PREFIX \
    --libdir=$PREFIX/lib  \
    --wrap-mode=nofallback

ninja -v -C builddir -j ${CPU_COUNT}

ninja -C builddir install -j ${CPU_COUNT}

cd $PREFIX
find . '(' -name '*.la' -o -name '*.a' ')' -delete
rm -rf etc/xdg lib/systemd share/gtk-doc share/locale
