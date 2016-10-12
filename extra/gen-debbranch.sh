#!/bin/bash
set -ex

#
# This script will generate var DEBRANCH
# DEBRANCH format is ${SYMBOL}-${DATESTRING}
#

DEBDIR="./debian"
if [ ! -d "${DEBDIR}" ]; then
    echo "no such debian directory ${DEBDIR}"
    exit 1
fi

# Use the TRAVIS_BRANCH var if defined as 
# travis vm doesn't run the git symbolic-ref command.
if [ -n "$TRAVIS_BRANCH" ]; then
   BRANCH=${TRAVIS_BRANCH}
else
   BRANCH=$(git symbolic-ref --short -q HEAD)
fi

#Generate SYMBOL according to branch or tag
SYMBOL=test
if [[ "${BRANCH}" == *"master"* ]]; then
   SYMBOL=devel
elif [[ "${BRANCH}" == *"release"* ]]; then
   SYMBOL=rc
fi

#Tag format is to be confirmed
if [ -n "$TRAVIS_TAG" ] && [[ "$TRAVIS_TAG" =~ ^[0-9.]+$ ]]; then
   SYMBOL=release
fi

#Generate var DEBBRANCH
GITCOMMITDATE=$(git show -s --pretty="format:%ci")
DATESTRING=$(date -d "$GITCOMMITDATE" -u +"%Y%m%d%H%M%SZ")
if [ -z "$DEBBRANCH" ] && [ "$SYMBOL" != "release" ]; then
        DEBBRANCH=`echo "~${SYMBOL}-${DATESTRING}" | sed 's/[\/\_]/-/g'`
        echo $DEBBRANCH
fi