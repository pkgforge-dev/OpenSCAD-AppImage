#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export ICON=/usr/share/icons/hicolor/512x512/apps/openscad.png
export DESKTOP=/usr/share/applications/openscad.desktop
export USE_HOST_DRIVERS_EXPERIMENTAL=1

# Deploy dependencies
quick-sharun \
	/usr/bin/openscad \
	/usr/share/Kvantum \
	/usr/share/openscad

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
