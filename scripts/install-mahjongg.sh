#!/bin/sh
set -xe

cd /tmp

flatpak --user install -y /repo/Mahjongg.flatpak

~/.local/share/flatpak/exports/bin/org.gnome.Mahjongg
