#!/bin/sh

set -xe

cp -r /source /tmp/source
cd /tmp/source

flatpak-builder --force-clean  build-dir org.gnome.Mahjongg.yaml

flatpak-builder --repo=/tmp/repo --force-clean  build-dir org.gnome.Mahjongg.yaml

flatpak build-bundle \
  --runtime-repo=https://dl.flathub.org/repo/flathub.flatpakrepo \
  /tmp/repo /repo/Mahjongg.flatpak org.gnome.Mahjongg
