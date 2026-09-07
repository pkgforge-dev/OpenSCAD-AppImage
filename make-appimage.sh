#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q openscad | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/512x512/apps/openscad.png
export DESKTOP=/usr/share/applications/openscad.desktop
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun \
	/usr/bin/openscad \
	/usr/share/openscad

# Turn AppDir into AppImage
quick-sharun --make-appimage

quick-sharun --simple-test ./dist/*.AppImage
