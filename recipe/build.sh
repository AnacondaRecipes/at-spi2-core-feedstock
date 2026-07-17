#! /bin/bash
# Prior to conda-forge, Copyright 2014-2019 Peter Williams and collaborators.
# This file is licensed under a 3-clause BSD license; see LICENSE.txt.

set -e

if [ $target_platform == osx-64 ]; then
    # Force conda's X11 headers first; XQuartz on macOS runners can leak in otherwise
    export CPATH="$PREFIX/include${CPATH:+:$CPATH}"
fi

export CFLAGS="$CFLAGS -I$PREFIX/include"
export LDFLAGS="$LDFLAGS -L$PREFIX/lib"

meson setup builddir \
    --prefix=$PREFIX \
    --libdir=$PREFIX/lib  \
    --wrap-mode=nofallback

ninja -v -C builddir -j ${CPU_COUNT}

ninja -C builddir install -j ${CPU_COUNT}

cd $PREFIX
find . '(' -name '*.la' -o -name '*.a' ')' -delete
rm -rf etc/xdg lib/systemd share/gtk-doc share/locale
