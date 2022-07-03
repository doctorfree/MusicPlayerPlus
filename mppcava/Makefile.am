AUTOMAKE_OPTIONS = foreign

ACLOCAL_AMFLAGS = -I m4

bin_PROGRAMS = mppcava
mppcava_SOURCES = cava.c cavacore.c config.c input/common.c input/fifo.c input/shmem.c \
               output/terminal_noncurses.c output/raw.c output/noritake.c
mppcava_CPPFLAGS = -DPACKAGE=\"$(PACKAGE)\" -DVERSION=\"$(VERSION)\" \
           -D_POSIX_SOURCE -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE_EXTENDED \
	   -DFONTDIR=\"@FONT_DIR@\"
mppcava_CFLAGS = -std=c99 -Wall -Wextra -Wno-unused-result -Wno-unknown-warning-option -Wno-maybe-uninitialized -Wno-vla-parameter

if OSX
    mppcava_CFLAGS += -DNORT
    mppcava_LDADD =
else
    mppcava_LDADD = -lrt
    mppcava_font_dir = @FONT_DIR@
    mppcava_font__DATA = mppcava.psf
endif

if ALSA
    mppcava_SOURCES += input/alsa.c
endif

if PORTAUDIO
    mppcava_SOURCES += input/portaudio.c
endif

if PULSE
    mppcava_SOURCES += input/pulse.c
endif

if SNDIO
    mppcava_SOURCES += input/sndio.c
endif

if NCURSES
    mppcava_SOURCES += output/terminal_ncurses.c
endif

if SDL
    mppcava_SOURCES += output/sdl_cava.c
endif

