# README for `alsa-capabilities`

**alsa-capabilities** is a bash (>=4) script that lists the audio
output interfaces of alsa. For each interface it displays it's
hardware address (eg `hw:x,y`), the device and interface names, and
additional details, like (optionally) the encodings and sample rates each interface supports.

For a quick try, you can run it straight from the web::

```bash
bash <(wget -q -O - "https://gitlab.com/sonida/alsa-capabilities/-/raw/master/alsa-capabilities")
```


## Contents

- [Rationale and general information](rationale-and-general-information)
- [Getting the script](getting-the-script)
- [Running the script](running-the-script)
- [Basic Usage](basic-usage)
- [Usage in other programs](usage-in-other-programs)


## Rationale and general information

See: [Alsa-capabilities shows which digital audio formats your USB DA-converter supports](https://web.archive.org/web/20190803165537/http://lacocina.nl/detect-alsa-output-capabilities) (on archive.org)

## Getting the script

### Dependencies

Besides bash (>=4), `alsa-capabilities` only needs the `aplay` utility
from the `alsa-utils` package.


### Installing the script

#### Arch Linux

- Install the
  [alsa-capabilities](https://aur.archlinux.org/packages/alsa-capabilities/)
  package from the AUR.
  
  (See
  [AUR_helpers](https://wiki.archlinux.org/index.php/AUR_helpers) on
  the Arch wiki).

#### Debian/Ubuntu

- (coming soon)


### Downloading the script

When you want to download it to your computer, you could do the following:

```bash
wget "https://gitlab.com/sonida/alsa-capabilities/-/raw/master/alsa-capabilities"
```

### Running the script

When you've installed a package, run:

```bash
alsa-capabilities
```

Or, when you've downloaded the script:

```bash
bash alsa-capabilities
```

Or, if you trust the developer ;) run it straight from the web:

```bash
bash <(wget -q -O - "https://gitlab.com/sonida/alsa-capabilities/-/raw/master/alsa-capabilities")
```

This can be handy if you quickly want to check your remote music
streamer, to which you have SSH-access but which you don't want to
mess up or install packages on:

```bash
ssh ${username}@${remotehost} "bash <(wget -q -O - "https://gitlab.com/sonida/alsa-capabilities/-/raw/master/alsa-capabilities")"
```


## Basic usage

```bash
alsa-capabilities
```

To get help:-

```bash
alsa-capabilities --help
## or
man alsa-capabilities
```

### Using the command line arguments

In the following example, the output will be limited to only output
interfaces which support USB Audio Class 1 or 2 (using `-l usb`),
while adding the listing of supported sample rates for each supported
encoding format (the `-s` option):

```bash
alsa-capabilities -l usb -s
```

To use commandline arguments when running the script straight from the
web, use the following syntax:

```bash
bash <(wget -q -O - "https://gitlab.com/sonida/alsa-capabilities/-/raw/master/alsa-capabilities") -l usb -s
```

To display the alsa playback interfaces on a remote host to which you
have ssh access, use:

```bash
ssh ${username}@${remotehost} "bash <(wget -q -O - "https://gitlab.com/sonida/alsa-capabilities/-/raw/master/alsa-capabilities") -l usb -s"
```

### Command line arguments: General

`-h`, or `--help`
:   Display usage information.

`-s`, or `--samplerates`
:   List the samplerates for each encoding format the interface supports.

  **NOTE**
  : To get the supported samplerates for an interface, the scripts
    needs exclusive access to it; when the interface is in use by
    another program, it will display the name and identifier (it’s
    process id or `PID`), so may you examine, stop or kill it, and run
    the script again

### Command line arguments: Advanced

The following filters can be added to restrict the results. Multiple
(unique) filters may be used concurrently.

`-l` *TYPEFILTER*, or `--limit` *TYPEFILTER*
:   Only include interfaces of type *TYPEFILTER*, which can be one of

- `a` (or `analog`),
- `d` (or `digital`), for interfaces which have one of the words
  `"usb"`, `"digital"`, `"hdmi"`, `"i2s"`, `"spdif"`, `"toslink"` or
  `"adat"` in them, or
- `u` (or `usb`) for interfaces that adhere to the *USB Audio Class*
  (UAC) 1 or 2 standards.


**TIP**
: Short and long options and arguments can be mixed:

```bash
## limit to UAC interfaces
alsa-capabilities -l u
alsa-capabilities -l usb
alsa-capabilities --limit usb
### limit and show samplerates
alsa-capabilities -l u -s
alsa-capabilities --limit usb --samplerates
```

`-c` *`REGEXP`*, or `--customlimit` *`REGEXP`*
:   Only include interfaces whose *device name* matches *`REGEXP`*,
    eg. **`"\[Hh\]\[Dd\]\[Mm\]\[Ii\]"`**, or **`"My Funky Brand"`**. 
    
**NOTE**
: Regular expressions are case sensitive and should be
  surrounded by single or double quotes. The should follow
  [Bash-builtin *Pattern Matching*](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html).


`-a` *`HWADDRESS`*, or `--address` *`HWADDRESS`*
:   Only include interfaces which have the specified *`HWADDRESS`*,
    eg. **`hw:0,1`** means the second interface (`1`) of the first
    device (`0`).

The output returned by the script can be supressed or altered for
[usage in other programs or scripts](#usage-in-other-programs).


`-j`, or `--json` 
:   Prints the results as valid json data for easy parsing by web
    services like REST-api's, or command line parsers, like **`jq`**.

`-q`, or `--quiet`
:   Surpress listing each interface with its details, ie. only store
    the details of each card in the appropriate bash arrays.



## Usage in other programs

Besides using the **-q**, **\--quiet** [output options](#Output options),
**alsa-capabilities** was designed to be sourced and used by other
programs. 


### Sourcing and usage in other programs

Besides directly running `alsa-capabilities`, it was designed to be
sourced and used by other programs as well, like
[mpd-configure](https://gitlab.com/sonida/mpd-configure) does.

Furthermore the script can be sourced. That way one may automate and
store certain properties for use in other scripts or config files,
like mpd-configure does. Here’s a rough example.

```bash
source alsa-capabilities
# run the function return_alsa_interface to fill up the array
return_alsa_interface --limit analog
# store the first item in the array in your own variable
myvar="${ALSA_AIF_HWADDRESSES[0]}"
# do something with it 
echo "${myvar}"
# display the corresponding character device: `/dev/snd/pcmCxDyp`:
echo "${ALSA_AIF_CHARDEVS[0]}"
```

To see all properties that can be accessed this way see the scripts
source or grep for arrays starting with `ALSA_AIF` (short for *"Alsa
Audio Interface"*):

```bash
grep 'declare -a ALSA_AIF' alsa-capabilities  | awk '{ print $9}'
```


### Using alsa-capabilities to generate machine-parsible json data 

By using the `-j` (or `--json`) argument, the script supresses normal
output but prints valid json data insteads for easy parsing by web
services like REST-api's.

* In the json output, sound cards (or UAC DACs) are members of the
  `"cards"` array; audio outputs are members of the `"outputs"` array.

* Example output *without* the `-s` (`--samplerates`) argument; 
  `"encoding_formats"` is a simple array:

```bash
alsa-capabilities -j
```

```json
{ 
"cards": [ 
  {
        "card_id": 1,
        "name": "HDMI",
        "label": "HDA ATI HDMI",
        "outputs": [
           {
              "output_id": 3,
              "name": "HDMI 0",
              "label": "HDMI 0",
              "hwaddress": "hw:1,3",
              "hwaddress_alt": "hw:HDMI,3",
              "devicetype": "Digital non-UAC",
              "uacclass": "(n/a)",
              "encoding_formats": [ 
                 "S16_LE", 
                 "S32_LE"
              ], 
              "paths": {
                  "hwparams": "/proc/asound/card1/pcm3p/sub0/hw_params",
                  "streamfile": "(n/a)",
                  "chardev": "/dev/snd/pcmC1D3p",
                  "monitorfile": "/proc/asound/card1/pcm3p/sub0/hw_params",
                  "statusfile": "/proc/asound/card1/pcm3p/sub0/status"
              }
          }
       ] 
    }
  ]
}
```

* Example output *with* the `-s` (`--samplerates`) argument;
 `"encoding_formats"` is an array where each member contains another
   array holding the sample rate values:
  
```bash
alsa-capabilities --samplerates --json
```

```json
{ 
"cards": [ 
  {
        "card_id": 1,
        "name": "HDMI",
        "label": "HDA ATI HDMI",
        "outputs": [
           {
              "output_id": 3,
              "name": "HDMI 0",
              "label": "HDMI 0",
              "hwaddress": "hw:1,3",
              "hwaddress_alt": "hw:HDMI,3",
              "devicetype": "Digital non-UAC",
              "uacclass": "(n/a)",
              "encoding_formats": [ 
                 { "S16_LE":
                    [ 
                        384000,
                        352800,
                        192000,
                        176400,
                        96000,
                        88200,
                        48000,
                        44100 
                    ]
                 }, 
                 { "S32_LE":
                    [
                        384000,
                        352800,
                        192000,
                        176400,
                        96000,
                        88200,
                        48000,
                        44100 
                    ]
                 }
              ], 
              "paths": {
                  "hwparams": "/proc/asound/card1/pcm3p/sub0/hw_params",
                  "streamfile": "(n/a)",
                  "chardev": "/dev/snd/pcmC1D3p",
                  "monitorfile": "/proc/asound/card1/pcm3p/sub0/hw_params",
                  "statusfile": "/proc/asound/card1/pcm3p/sub0/status"
              }
          }

       ] 
    }
  ]
}
```

* Example output using `jq` selectors to get the first output of the second card:

```bash
./alsa-capabilities -j | jq '.cards[1].outputs[0]'
```

```json
{
  "output_id": 3,
  "name": "HDMI 0",
  "label": "HDMI 0",
  "hwaddress": "hw:1,3",
  "hwaddress_alt": "hw:HDMI,3",
  "devicetype": "Digital non-UAC",
  "uacclass": "(n/a)",
  "encoding_formats": 
    [
        "S16_LE",
        "S32_LE"
    ],
  "paths": {
    "hwparams": "/proc/asound/card1/pcm3p/sub0/hw_params",
    "streamfile": "(n/a)",
    "chardev": "/dev/snd/pcmC1D3p",
    "monitorfile": "/proc/asound/card1/pcm3p/sub0/hw_params",
    "statusfile": "/proc/asound/card1/pcm3p/sub0/status"
  }
}
```

## Source code and development

The script is written in bash. Originally for the
[mpd-configure](https://gitlab.com/sonida/mpd-configure) project, but
since September 2019 hosted a seperate project on Gitlab:

- https://gitlab.com/sonida/alsa-capabilities

