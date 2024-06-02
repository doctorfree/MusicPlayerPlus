#!/bin/bash
#
# Cover art script for mpcplus-ueberzug

## SETTINGS
KITTY_SOCKET="/tmp/__mppkitty__"
# Get music library location from MusicPlayerPlus configuration
MUSIC_DIR=
[ -f "${HOME}/.config/mpprc" ] && . "${HOME}/.config/mpprc"
# If music library location not set, get it from MPD configuration
[ "${MUSIC_DIR}" ] || {
  MPDCONF="${HOME}/.config/mpd/mpd.conf"
  [ -f "${MPDCONF}" ] && {
    MUSIC_DIR=`grep ^music_directory ${MPDCONF}`
    MUSIC_DIR=`echo ${MUSIC_DIR} | awk ' { print $2 } ' | sed -e "s/\"//g"`
  }
  [ "${MUSIC_DIR}" ] || MUSIC_DIR="$HOME/Music"
}

[ -f ${HOME}/.venv/bin/activate ] && source ${HOME}/.venv/bin/activate

# Need to expand a tilda to $HOME
music_library="${MUSIC_DIR/#\~/$HOME}"
fallback_image="$HOME/.config/mpcplus/ueberzug/img/fallback.png"

# Only set this if the geometries are wrong or mpcplus shouts at you to do it.
# Visually select/highlight a character on your terminal, zoom in an image 
# editor and count how many pixels a character's width and height are.
font_height=45
font_width=22
max_width=24
reserved_playlist_cols=30
reserved_cols_in_percent="false"
force_square="false"
square_alignment="top"
left_aligned="true"
use_kitty=

unset LINES COLUMNS # Required in order for tput to work in a script
term_lines=$(tput lines)
term_cols=$(tput cols)

# Customize padding for each supported terminal emulator
[ "${MPP_ENV_MODE}" ] && MPP_MODE="${MPP_ENV_MODE}"
case "${MPP_MODE}" in
  console)
    padding_top=3
    padding_bottom=1
    padding_right=1
    padding_left=2
    ;;
  current)
    padding_top=3
    padding_bottom=2
    padding_right=0
    padding_left=1
    ;;
  gnome)
    padding_top=5
    padding_bottom=1
    padding_right=0
    padding_left=4
    ;;
  kitty)
    padding_top=3
    padding_bottom=1
    padding_right=0
    padding_left=1
#   use_kitty=1
    ;;
  retro)
    padding_top=2
    padding_left=0
    padding_bottom=1
    padding_right=0
    ;;
  simple)
    padding_top=3
    padding_left=1
    padding_bottom=1
    padding_right=0
    ;;
  tilix)
    padding_top=4
    padding_bottom=1
    padding_right=0
    padding_left=2
    ;;
  *)
    padding_top=5
    padding_left=5
    padding_bottom=1
    padding_right=1
    ;;
esac

[ "${OVERRIDE_PADDING}" ] && {
    [ "${padding_override_top}" ] && padding_top=${padding_override_top}
    [ "${padding_override_bottom}" ] && padding_bottom=${padding_override_bottom}
    [ "${padding_override_left}" ] && padding_left=${padding_override_left}
    [ "${padding_override_right}" ] && padding_right=${padding_override_right}
}
[ "${OVERRIDE_FONT_SIZE}" ] && {
    [ "${font_override_width}" ] && font_width=${font_override_width}
    [ "${font_override_height}" ] && font_height=${font_override_height}
}

main() {
    kill_previous_instances >/dev/null 2>&1
    find_cover_image        >/dev/null 2>&1
    display_cover_image     2>/dev/null
    detect_window_resizes   >/dev/null 2>&1
}

# ==== Main functions =========================================================

kill_previous_instances() {
    script_name=$(basename "$0")
    for pid in $(pidof -x "$script_name"); do
        if [ "$pid" != $$ ]; then
            kill -15 "$pid"
        fi 
    done
}

find_cover_image() {

    # First we check for an external cover art image
    album="$(mpc --format %album% current)"
    file="$(mpc --format %file% current)"
    album_dir="${file%/*}"
    album_dir="$music_library/$album_dir"
    found_covers="$(find "$album_dir" -type d -exec find {} -maxdepth 1 -type f \
    -iregex ".*/.*\(${album}\|cover\|folder\|artwork\|front\).*[.]\\(jpe?g\|png\|gif\|bmp\)" \; )"
    cover_path="$(echo "$found_covers" | head -n1)"
    if [ -n "$cover_path" ]; then
        return
    fi

    # If no external image is available then use embedded art if it exists
    ext="$(mpc --format %file% current | sed 's/^.*\.//')"
    if [ "$ext" = "flac" ]; then
        # since FFMPEG cannot export embedded FLAC art we use metaflac
        metaflac --export-picture-to=/tmp/mpd_cover.jpg \
            "$(mpc --format "$music_library"/%file% current)" &&
            cover_path="/tmp/mpd_cover.jpg" && return
    else
        ffmpeg -y -i "$(mpc --format "$music_library"/%file% | head -n 1)" \
            /tmp/mpd_cover.jpg &&
            cover_path="/tmp/mpd_cover.jpg" && return
    fi
    [ -f "${cover_path}" ] || cover_path=

    # If we still failed to find a cover image, we use the fallback
    if [ -z "$cover_path" ]; then
        cover_path=$fallback_image
    fi
}

display_cover_image() {
    compute_geometry

    if [ "${use_kitty}" ]
    then
      # Not yet working, Kitty still uses Ueberzug for now
      [ -S ${KITTY_SOCKET} ] && {
        kitty @ --to unix:${KITTY_SOCKET} icat --silent --clear
        kitty @ --to unix:${KITTY_SOCKET} \
            icat --align=left --z-index=-1 --hold --silent \
            --place="${ueber_width}x${ueber_height}@${ueber_left}x${padding_top}" \
            "${cover_path}"
      }
    else
      send_to_ueberzug \
        action "add" \
        identifier "mpd_cover" \
        path "$cover_path" \
        x "$ueber_left" \
        y "$padding_top" \
        height "$ueber_height" \
        width "$ueber_width" \
        synchronously_draw "True" \
        scaler "forced_cover" \
        scaling_position_x "0.5"
    fi
}

detect_window_resizes() {
    {
        trap 'display_cover_image' WINCH
        while :; do sleep .1; done
    } &
}


# ==== Helper functions =========================================================

compute_geometry() {
    if [ -z "$font_height" ] || [ -z "$font_width" ]; then
        guess_font_size
    fi

    ueber_height=$(( term_lines - padding_top - padding_bottom ))
    # Because Ueberzug uses characters as a unit we must multiply
    # the line count (height) by the font size ratio in order to
    # obtain an equivalent width in column count
    ueber_width=$(( ueber_height * font_height / font_width ))
    ueber_left=$(( term_cols - ueber_width - padding_right ))

    if [ "$left_aligned" = "true" ]; then
        compute_geometry_left_aligned
    else
        compute_geometry_right_aligned
    fi

    apply_force_square_setting
}

compute_geometry_left_aligned() {
    ueber_left=$padding_left
    max_width_chars=$(( term_cols * max_width / 100 ))
    [ "$max_width" != 0 ] && {
      [ $(( ueber_width + padding_right + padding_left )) -gt "$max_width_chars" ] && {
        ueber_width=$(( max_width_chars - padding_left - padding_right ))
      }
    }
}

compute_geometry_right_aligned() {
    if [ "$reserved_cols_in_percent" = "true" ]; then
        ueber_left_percent=$(printf "%.0f\n" $(calc "$ueber_left" / "$term_cols" '*' 100))
        if [ "$ueber_left_percent" -lt "$reserved_playlist_cols" ]; then
            ueber_left=$(( term_cols * reserved_playlist_cols / 100  ))
            ueber_width=$(( term_cols - ueber_left - padding_right ))
        fi
    else
        if [ "$ueber_left" -lt "$reserved_playlist_cols" ]; then
            ueber_left=$reserved_playlist_cols
            ueber_width=$(( term_cols - ueber_left - padding_right ))
        fi

    fi

    if [ "$max_width" != 0 ] && [ "$ueber_width" -gt "$max_width" ]; then
        ueber_width=$max_width
        ueber_left=$(( term_cols - ueber_width - padding_right ))
    fi
}

apply_force_square_setting() {
    if [ $force_square = "true" ]; then
        ueber_height=$(( ueber_width * font_width / font_height ))
        case "$square_alignment" in
            center)
                area=$(( term_lines - padding_top - padding_bottom ))
                padding_top=$(( padding_top + area / 2 - ueber_height / 2  ))
                ;;
            bottom)
                padding_top=$(( term_lines - padding_bottom - ueber_height ))
                ;;
            *) ;;
        esac
    fi
}

guess_font_size() {
    # A font width and height estimate is required to
    # properly compute the cover width (in columns).
    # We are reproducing the arithmetic used by Ueberzug
    # to guess font size.
    # https://github.com/seebye/ueberzug/blob/master/ueberzug/terminal.py#L24

    guess_terminal_pixelsize

    approx_font_width=$(( term_width / term_cols ))
    approx_font_height=$(( term_height / term_lines ))

    term_xpadding=$(( ( - approx_font_width * term_cols + term_width ) / 2 ))
    term_ypadding=$(( ( - approx_font_height * term_lines + term_height ) / 2 ))

    font_width=$(( (term_width - 2 * term_xpadding) / term_cols ))
    font_height=$(( (term_height - 2 * term_ypadding) / term_lines ))
}

guess_terminal_pixelsize() {
    # We are re-using the same Python snippet that
    # Ueberzug utilizes to retrieve terminal window size.
    # https://github.com/seebye/ueberzug/blob/master/ueberzug/terminal.py#L10

    python <<END
import sys, struct, fcntl, termios

def get_geometry():
    fd_pty = sys.stdout.fileno()
    farg = struct.pack("HHHH", 0, 0, 0, 0)
    fretint = fcntl.ioctl(fd_pty, termios.TIOCGWINSZ, farg)
    rows, cols, xpixels, ypixels = struct.unpack("HHHH", fretint)
    return "{} {}".format(xpixels, ypixels)

output = get_geometry()
f = open("/tmp/mpcplus_geometry.txt", "w")
f.write(output)
f.close()
END

    # ioctl doesn't work inside $() for some reason so we
    # must use a temporary file
    term_width=$(awk '{print $1}' /tmp/mpcplus_geometry.txt)
    term_height=$(awk '{print $2}' /tmp/mpcplus_geometry.txt)
    rm -f "/tmp/mpcplus_geometry.txt"

    if ! is_font_size_successfully_computed; then
        echo "Failed to guess font size, try setting it in mpcplus_cover_art.sh settings"
    fi
}

is_font_size_successfully_computed() {
    [ -n "$term_height" ] && [ -n "$term_width" ] &&
        [ "$term_height" != "0" ] && [ "$term_width" != "0" ]
}


calc() {
    awk "BEGIN{print $*}"
}

send_to_ueberzug() {
    old_IFS="$IFS"

    # Ueberzug's "simple parser" uses tab-separated
    # keys and values so we separate words with tabs
    # and send the result to the wrapper's FIFO
    IFS="$(printf "\t")"
    echo "$*" > "$FIFO_UEBERZUG"

    IFS=${old_IFS}
}


main
