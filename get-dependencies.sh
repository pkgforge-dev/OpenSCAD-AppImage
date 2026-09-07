#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
if [ "${DEVEL_RELEASE-}" = 1 ]; then
	pacman -Syu --noconfirm kvantum kvantum-qt5
else
	pacman -Syu --noconfirm kvantum kvantum-qt5 openscad qt5-wayland
fi

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
if [ "${DEVEL_RELEASE-}" = 1 ]; then
	make-aur-package openscad-git
	pacman -Q openscad-git | awk '{print $2; exit}' > ~/version
else
	pacman -Q openscad | awk '{print $2; exit}' > ~/version
fi
