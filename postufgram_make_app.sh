#!/bin/bash

TARGET="$1"
if [ "$TARGET" == "" ]; then
	echo "Usage: sh postufgram_make.sh target adhoc|appstore"
	exit 1
fi

if [ "$TARGET" != "adhoc" ] && [ "$TARGET" != "appstore" ]; then
	echo "Usage: sh postufgram_make.sh target adhoc|appstore"
	exit 1
fi

SIGNING_DIR="build-system/fake-codesigning/certs/distribution"
PROVISIONS_DIR="build-system/fake-codesigning/profiles/appstore"

rm -rf "$SIGNING_DIR"
mkdir "$SIGNING_DIR"

cp -a "$HOME/postufgram/certs/" "$SIGNING_DIR"

rm -rf "$PROVISIONS_DIR"
mkdir "$PROVISIONS_DIR"

cp -a "$HOME/postufgram/profiles/$TARGET/" "$PROVISIONS_DIR"

sh "$HOME/postufgram/Config.sh" make app

rm -rf "$SIGNING_DIR"
rm -rf "$PROVISIONS_DIR"
rm -rf "buildbox/fake-codesigning/certs/distribution"
rm -rf "buildbox/fake-codesigning/profiles/appstore"
