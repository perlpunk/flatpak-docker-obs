FROM opensuse/leap:15.1

RUN zypper refresh && zypper -n install \
    xeyes \
    gzip \
    flatpak \
    flatpak-builder \
    xz \
    librsvg \
    gdk-pixbuf-loader-rsvg \
  && true

RUN flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

RUN flatpak install -y flathub runtime/org.gnome.Platform/x86_64/3.36

RUN flatpak install -y flathub runtime/org.gnome.Sdk/x86_64/3.36

RUN flatpak install -y flathub runtime/org.freedesktop.Platform.ffmpeg/x86_64/1.6

RUN flatpak install -y flathub runtime/org.kde.Sdk/x86_64/5.14

RUN flatpak install -y flathub runtime/org.kde.Platform/x86_64/5.14

