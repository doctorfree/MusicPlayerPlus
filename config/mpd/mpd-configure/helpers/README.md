The alsa-capabilities script –which can be executed on any computer running Linux and alsa– will show the available alsa interfaces for audio playback, and the digital audio formats each sound card or external USB DAC supports.

Instructions for running it straight from the web
-------------------------------------------------

Open a terminal screen1 on the computer connected to your DAC and copy-and-paste or type the line below in the terminal screen, followed by pressing ENTER:
```bash
bash <(wget -q -O - "https://lacocina.nl/alsa-capabilities")
```

That’s it!

This will display a list of each alsa audio output interface with its details. When an interface is in use by another program, it will display the name and identifier (it’s process id or PID), so may you examine, stop or kill it, and run the script again.

Downloading the script locally
------------------------------

When you want to download it to your computer, you could do the following:

```bash
wget https://lacocina.nl/alsa-capabilities
bash alsa-capabilities
```

Or, manually ‘install’ it and make it executable, ie:

```bash
# 1. let's get a writable directory in your PATH and move the script there
while IFS=":" read -r dir; do \[\[ -w "${dir}" ]] && ( echo "${dir} is ok"; break ); done
# 2. download the script 
wget -O "${dir}/alsa-capabilities" https://lacocina.nl/alsa-capabilities
# 3. make it executable
chmod +x "${dir}/alsa-capabilities"
```

Next time you can just type `alsa-capabilities` in any terminal window.

Commandline arguments
---------------------

Options can be added to the commandline like in the following example, which limits the output to only devices which support USB Audio Class 1 or 2 (using `-l usb`) while adding the listing of supported sample rates for each supported encoding format (the `-s` option):

```bash
bash alsa-capabilities -l usb -s
```

To display all options run the script with the `-h` option:

```bash
bash alsa-capabilities -h
```
