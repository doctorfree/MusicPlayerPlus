#!/bin/bash
#
## @file any2any.sh
## @brief Convert from any audio/video format to any other
## @author Ronald Joe Record (rr at ronrecord dot com)
## @copyright Copyright (c) 2014, Ronald Joe Record, all rights reserved.
## @date Written 7-Mar-2014
## @version 1.0.1
##
##   This program works by either linking or copying any2any to a file
##   which specifies the desired input and output formats by its name.
##   Alternately, the -i and -o command line options can be used to specify
##   the input and output file formats.
##
##   For example, if you want to convert from WMV to MP4 then you could
##   create a symbolic link from any2any to wmv2mp4 as follows:
##       ln -s any2any wmv2mp4
##   Similarly, symbolic links (or copies or hard links) could be created
##   to convert from any (3 lowercase letter representation) audio/video format
##   to any other audio/video format. Commonly used conversions include:
##       wmv2mkv avi2mpg wmv2mp4 and so on.
##
##   Naming restricton: [3 lowercase letter input]2[3 lowercase letter output]
##   for a 7 letter name with "2" in the middle. The 3 letter prefix and suffix
##   must also be a filename suffix that ffmpeg recognizes as a valid
##   audio/video format.
##
##   For example, the following are filenames that conform to this restriction:
##       ape2m4a flv2mp4 mkv2mp4 wmv2mp4 avi2mpg wmv2mkv wma2m4a
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# The Software is provided "as is", without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose and noninfringement. In no event shall the
# authors or copyright holders be liable for any claim, damages or other
# liability, whether in an action of contract, tort or otherwise, arising from,
# out of or in connection with the Software or the use or other dealings in
# the Software.
#

ME=`basename $0`
if [ "$ME" = "any2any" ]
then
    PRE="wmv"
    SUF="mp4"
    INP="WMV"
    DIR="MP4"
else
    PRE="${ME:0:3}"
    SUF="${ME:4:3}"
    INP=`echo $PRE | tr '[:lower:]' '[:upper:]'`
    DIR=`echo $SUF | tr '[:lower:]' '[:upper:]'`
fi

CODEC=
SIZE=
OVER=
TELL=
USAGE=
ACODEC=
VCODEC=
PRESET="-preset slow"
QSCALE=
RATE=
ASAMPLE=
VSAMPLE=
THREAD=
ITUNES=

## @fn usage()
## @brief Display command line usage options
## @param none
##
## Exit the program after displaying the usage message and example invocations
usage() {
  printf "\nUsage: $ME [-a audio codec] [-v video codec] [-c codec] [-p preset]"
  printf "\n\t\t[-i input format (lower case)] [-o output format (lower case)]"
  printf "\n\t\t[-q scale] [-r rate] [-b audio bitrate] [-z video bitrate]"
  printf "\n\t\t[-s size] [-t threads] [-I] [-d] [-y] [-u] file1 [file2 ...]"
  printf "\n\nWhere:\n\t-d indicates tell me what you would do"
  printf "\n\t-i input format specifies the 3 letter lower case input format"
  printf "\n\t-o output format specifies the 3 letter lower case output format"
  printf "\n\t-a audio codec specifies the output audio codec"
  printf "\n\t-v video codec specifies the output video codec"
  printf "\n\t-s size specifies the output video size (widthxheight)"
  printf "\n\t-c codec specifies the output codec"
  printf "\n\t-I indicates add the converted file to Apple Music"
  printf "\n\t-p preset specifies the ffmpeg preset to use"
  printf "\n\t\t Useful presets:"
  printf "\n\t\t ultrafast superfast veryfast faster fast medium slow"
  printf "\n\t\t slower veryslow. Default preset is 'slow'"
  printf "\n\t-q scale specifies the qscale variable bit rate quality"
  printf "\n\t-r rate specifies the rate for Constant Rate Factor (CRF)"
  printf "\n\t\tencoding. Use \"-r 0\" to disable for formats other than x264"
  printf "\n\t-b bitrate specifies the bitrate (default 128k)"
  printf "\n\t-t threads specifies the number of threads to use"
  printf "\n\t-y indicates overwrite output files without asking"
  printf "\n\t-u displays this usage message\n"
  printf "\nCurrent invocation defaults to:\n\nffmpeg -i INPUT -loglevel warning -strict -2 $OPTS OUTPUT\n"
  printf "\nExamples:"
  printf "\n\tThe most common use is conversion using the default parameters"
  printf "\n\t\t$ME $INP/example.$SUF"
  printf "\n\tCopy audio and video codecs, convert the container"
  printf "\n\t\t$ME -c copy $INP/example.$SUF"
  printf "\n\tSpecify output video size of 640 width by 480 height"
  printf "\n\t\t$ME -s 640x480 $INP/example.$SUF"
  printf "\n\tSpecify libx264 output video codec and use ipod640 preset"
  printf "\n\t\t$ME -v libx264 -p ipod640 $INP/example.$SUF"
  printf "\n\tSpecify 512k bitrate and add converted file to Apple Music"
  printf "\n\t\t$ME -b 512k -I $INP/example.$SUF"
  printf "\n\tSpecify libx264 output video codec and variable bit rate"
  printf "\n\t\t$ME -v libx264 -r 0 -q 3 $INP/example.$SUF\n"
  exit 1
}

while getopts i:o:p:q:r:b:t:s:v:z:a:c:Iydu flag; do
    case $flag in
        a)
            ACODEC="-acodec $OPTARG"
            ;;
        b)
            ASAMPLE="-ab $OPTARG"
            ;;
        i)
            PRE=$OPTARG
            INP=`echo $PRE | tr '[:lower:]' '[:upper:]'`
            ;;
        o)
            SUF=$OPTARG
            DIR=`echo $SUF | tr '[:lower:]' '[:upper:]'`
            ;;
        z)
            VSAMPLE="-vb $OPTARG"
            ;;
        c)
            CODEC="-codec $OPTARG"
            ;;
        d)
            TELL=1
            ;;
        i)
            inst=`type -p osascript`
            if [ "$inst" ]
            then
                ITUNES=1
            else
                echo "AppleScript is not supported on this platform."
                echo "Unable to automate the installation in Apple Music."
            fi
            ;;
        p)
            PRESET="-preset $OPTARG"
            ;;
        q)
            QSCALE="-qscale $OPTARG"
            RATE=
            ;;
        r)
            if [ $OPTARG -eq 0 ]
            then
                RATE=
            else
                RATE="-crf $OPTARG"
            fi
            ;;
        s)
            SIZE="-s $OPTARG"
            ;;
        t)
            THREAD="-threads $OPTARG"
            ;;
        y)
            OVER="-y"
            ;;
        v)
            VCODEC="-vcodec $OPTARG"
            ;;
        u)
            USAGE=1
            ;;
    esac
done
shift $(( OPTIND - 1 ))

# Set ffmpeg conversion options based upon the desired output format
[ "$SUF" = "mp4" ] && {
    VCODEC="-vcodec libx264"
## See http://slhck.info/articles/crf for info on Constant Rate Factor (CRF)
    RATE="-crf 23"
    ASAMPLE="-ab 128k"
    THREAD="-threads 0"
}
[ "$SUF" = "wmv" ] && {
    ACODEC="-acodec adpcm_ms"
    VCODEC="-vcodec msmpeg4"
## See http://www.kilobitspersecond.com/2007/05/24/ffmpeg-quality-comparison
    QSCALE="-qscale 5"
    ASAMPLE="-ab 128k"
    THREAD="-threads 0"
}
[ "$SUF" = "avi" ] && {
    ACODEC="-acodec adpcm_ms"
    VCODEC="-vcodec libxvid"
    QSCALE="-qscale 5"
    ASAMPLE="-ab 128k"
    THREAD="-threads 0"
}
[ "$SUF" = "mp3" ] && {
    ACODEC="-acodec libmp3lame"
    PRESET=""
    VCODEC="-vn -c:v copy"
    QSCALE="-qscale:a 0"
    THREAD="-threads 0"
}
# TODO: Add desired default settings for other format encodings here.
#
# Set any options specified on the command line - the sed part is just
# removing any leading or trailing spaces.
OPTS=`echo "$OVER $ACODEC $CODEC $SIZE $VCODEC $PRESET $QSCALE $RATE $ASAMPLE $VSAMPLE $THREAD" | sed -e 's/^ *//' -e 's/ *$//'`
# Check for incompatible ffmpeg arguments
[ "$RATE" ] && [ "$QSCALE" ] && {
    printf "\nCannot specify both constant and variable bit rate values."
    printf "\nCurrent invocation would invoke:\n\nffmpeg -i INPUT -loglevel warning -strict -2 $OPTS OUTPUT\n"
    printf "\nExiting.\n"
    exit 1
}

# Display usage message and exit if -u was given on the command line.
# We delay until now in order to gather up all the other command line options.
[ "$USAGE" ] && usage

[ -d "$DIR" ] || {
    printf "\nOutput directory $DIR does not exist or is not a directory.\n"
    while true
    do
        read -p "Do you want to create the output directory ? (y/n) " yn
        case $yn in
            [Yy]* ) mkdir -p "$DIR"; break;;
            [Nn]* ) printf "\nExiting.\n"; exit 1;;
                * ) echo "Please answer yes or no.";;
        esac
    done
}

for i in "$@"
do
    [ -f "$i" ] || {
        echo "Input file $i does not exist or is not a regular file. Skipping."
        continue
    }
    # Set the output directory and filename
    d=`dirname "$i"`
    if [ "$d" = "." ]
    then
        j=${DIR}/`echo "$i" | sed -e "s/\.${PRE}/\.${SUF}/"`
    else
        # I always have to guess how many backslashes to use. I love sed.
        # Anyway, we need to turn slashes into backslashed slashes so the
        # subsequent sed to set the output directory will work.
        INP=`echo "$d" | sed -e 's/\//\\\\\//g'`
        j=`echo "$i" | sed -e "s/${INP}/${DIR}/" -e "s/\.${PRE}/\.${SUF}/"`
    fi
    echo "ffmpeg -i $i -loglevel warning -strict -2 $OPTS $j"
    [ "$TELL" ] || {
        ffmpeg -i "$i" -loglevel warning -strict -2 $OPTS "$j"
        [ "$ITUNES" ] && {
            # Construct full pathname of output file
            k=`pwd`/"$j"
            echo "Adding $j to Apple Music"
            osascript -e "tell application \"Music\" to add POSIX file \"$k\""
        }
    }
done
