#!/bin/bash

#  This script will modify .bintray-deb.json for deployment on bintray 

# Ensure we're always in the right directory.
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $SCRIPT_DIR/..

#modify bintray cfg
VERSION=`dpkg-parsechangelog --show-field Version`
DEBBRANCH=$(./extra/gen-debbranch.sh)
REVISION=${VERSION}${DEBBRANCH}
if [ -z "$DEBBRANCH" ]; then
    COMPONENT=release
else
    COMPONENT=main
fi
sed -e "s/#REVISION#/${REVISION}/g" \
    -e "s/#COMPONENT#/${COMPONENT}/g" \
    .bintray-deb.json.in > .bintray-deb.json