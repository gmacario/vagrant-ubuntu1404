#!/bin/sh

#set -x
set -e

echo "DBG: BUILDDIR=$BUILDDIR"
if [ "$BUILDDIR" = "" ]; then
    echo "ERROR: This script should be executed from within the guest OS"
    exit 1
fi

#DESTBASEDIR="/vagrant/tmp"
DESTBASEDIR="gmacario@kruk.solarma.it:~/tmp"

DESTDIR=$(echo $BUILDDIR | sed -e "s|$HOME|$DESTBASEDIR|")
echo "DBG: DESTDIR=$DESTDIR"

if [ $(echo $DESTDIR | grep ":") ]; then
    REMOTEHOST=$(echo $DESTDIR | sed -e 's/:.*$//')
    REMOTEDIR=$(echo $DESTDIR | sed -e 's/^.*://')
    ssh "${REMOTEHOST}" mkdir -p "${REMOTEDIR}/tmp/deploy"
else
    mkdir -p "${DESTDIR}/tmp/deploy"
fi
cd "${BUILDDIR}/tmp/deploy" && rsync -avz . "${DESTDIR}/tmp/deploy/"

# EOF
