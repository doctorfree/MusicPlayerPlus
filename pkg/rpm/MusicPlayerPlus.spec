Name: MusicPlayerPlus
Version:    %{_version}
Release:    %{_release}%{?dist}
BuildArch:  noarch
AutoReqProv: no
%if 0%{?centos} > 0
Requires: alsa-utils, bc, boost, coreutils, curl, dialog, dnf-plugins-core, flac, iniparser, jq, libcurl, libmpdclient, ncurses, readline, taglib, mpd, tmux, inotify-tools, figlet, python3-devel, python3-pip, mplayer, libchromaprint-devel, dconf, util-linux, sqlite, libavdevice, wget, wmctrl, xdpyinfo, xprop, xrandr, ImageMagick
%else
Requires: alsa-utils, bc, boost, coreutils, curl, dialog, dnf-plugins-core, flac, iniparser, jq, libcurl, ncurses, readline, taglib, mediainfo, tmux, inotify-tools, mpc, python3-devel, python3-pip, libchromaprint-devel, dconf, util-linux, sqlite, wget, wmctrl, xdpyinfo, xprop, xrandr, ImageMagick
%endif
URL:        https://github.com/doctorfree/MusicPlayerPlus
Vendor:     Doctorwhen's Bodacious Laboratory
Packager:   ronaldrecord@gmail.com
License     : GPLv2+
Summary     : Featureful ncurses based MPD client with spectrum visualizer

%global __os_install_post %{nil}

%description
Music Player Plus provides a streaming audio server, music player client,
and spectrum visualizer along with utilities to administer and control
the audio system. The player and visualizer run in a terminal window.
No graphical utilities or capability is required other than a terminal window.
A featureful ncurses based MPD client inspired by ncmpc. The main features are:

- tag editor
- playlist editor
- easy to use search engine
- media library
- music visualizer
- ability to fetch artist info from last.fm
- new display mode
- alternative user interface
- ability to browse and add files from outside of MPD music directory

%prep

%build

%install
cp -a %{_sourcedir}/usr %{buildroot}/usr

%pre

%post

%preun

%files
/usr
%exclude %dir /usr/share/man/man1
%exclude %dir /usr/share/man
%exclude %dir /usr/share/doc
%exclude %dir /usr/share/menu
%exclude %dir /usr/share
%exclude %dir /usr/bin

%changelog
