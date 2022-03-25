Name: MusicPlayerPlus
Version:    %{_version}
Release:    %{_release}
BuildArch:  x86_64
Requires: boost (>= 1.76.0), libcurl (>= 7.79.1), libmpdclient (>= 2.20), ncurses (>= 6), readline (>= 8.1), taglib (>= 1.12), mpd (>= 0.23.6), tilix (>= 1.9.1), xfce4-terminal (>= 0.8.9.1), cool-retro-term (>= 1.1.1), gnome-terminal (>= 3.42.2)
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
