#!/bin/sh

#set -x
set -e

echo "DBG: BUILDDIR=$BUILDDIR"
if [ "$BUILDDIR" = "" ]; then
    echo "ERROR: This script should be executed from within the guest OS"
    exit 1
fi

DESTDIR=$(echo $BUILDDIR | sed -e "s|$HOME|/vagrant/tmp|")
echo "DBG: DESTDIR=$DESTDIR"

mkdir -p "$DESTDIR/tmp/deploy"
cd "$BUILDDIR/tmp/deploy" && rsync -avz . "$DESTDIR/tmp/deploy/"

# EOF
