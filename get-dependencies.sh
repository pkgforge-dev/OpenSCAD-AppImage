#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1

if [ "${DEVEL_RELEASE-}" = 1 ]; then
	_pkgname=openscad-git
	make-aur-package "$_pkgname"
	pacman -Syu --noconfirm kvantum qt6ct lxqt-qtplugin
else
	_pkgname=openscad
	# TODO: Fix this once upstream makes a stable release with Qt6
	pacman -Syu --noconfirm "$_pkgname" kvantum-qt5 qt5-wayland qt5ct

	# on archlinux qt5-wayland also adds the server side plugins
	# remove them so that they do not get deployed. This is not a problem
	# with Qt6 since the client side libs are already qt6-base
	rm -rf /usr/lib/qt/plugins/wayland-graphics-integration-server
fi

pacman -Q "$_pkgname" | awk '{print $2; exit}' > ~/version
