#!/bin/sh
set -xe

cd /tmp

flatpak --user install -y /repo/Chess.flatpak

~/.local/share/flatpak/exports/bin/org.gnome.Chess
