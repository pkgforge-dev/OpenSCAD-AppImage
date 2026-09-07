#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export ICON=/usr/share/icons/hicolor/512x512/apps/openscad.png
export DESKTOP=/usr/share/applications/openscad.desktop
export DEPLOY_OPENGL=1

# On Arch Linux qt5-wayland also adds the server side plugins
# remove them so that they do not get deployed
rm -rf /usr/lib/qt/plugins/wayland-graphics-integration-server

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
