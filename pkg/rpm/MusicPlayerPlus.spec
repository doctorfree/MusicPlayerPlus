Name: MusicPlayerPlus
Version:    %{_version}
Release:    %{_release}
BuildArch:  x86_64
Requires:   mpd, boost-filesystem, boost-locale, boost-program-options, boost-thread, libcurl, libcurl-minimal, libicu, libmpdclient, ncurses-libs, readline, taglib, ncurses-libs, xfce4-terminal, gnome-terminal, cool-retro-term, tilix
URL:        https://gitlab.com/doctorfree/MusicPlayerPlus
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

%changelog
