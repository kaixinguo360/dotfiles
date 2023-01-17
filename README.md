Dotfiles
=======

My dotfiles, which include some useful bash tools, configure files, install scripts, project templates...

## Supported OS

- Ubuntu
- Alpine
- Termux

You can also use them in Docker or WSL

## How to use

**WARNING: Your data in these location will be removed and covered automatically with the config in this project!**
- ~/.bashrc
- ~/.bashrc.d/
- ~/.vimrc
- ~/.screenrc
- ~/.mplayer/

Run below commands to install this dotfiles to your linux server.

```
git clone git@github.com:kaixinguo360/dotfiles ~/.dotfiles \
    && ~/.dotfiles/install.sh \
    && source ~/.bashrc
```

This command will automatically pull project to ~/.dotfiles, and install config to home directory using soft link. Some bin path and bash alias will be added to your environment, so you can simply type their name if you want to use them.

For more details, see the [Project Structure](#project-structure) section.

## Project Structure

This project should be located in ~/.dotfiles

```
~/.dotfiles
├── bin     # Some useful mini bash tools
├── config  # Config files for bash/vim/...
├── docker  # Some useful Dockerfiles
├── lib     # Shared lib of bash scripts
├── list    # Some package lists
├── sbin    # Some management tools
├── script  # Some install/remove scripts
├── snippet     # Some code snippets
└── template    # Some project templates
```

## README for tools in bin/

### tool-activate

A tool to create tmp environment with specific docker image, inspired by python-venv

```bash
# Example

kaixinguo@ubuntu:~$ ls
a.mp3  b.mp4  c.mp5

kaixinguo@ubuntu:~$ ffmpeg
ffmpeg: command not found

kaixinguo@ubuntu:~$ tool-activate
alpine3      gcc          gradle       nodejs       python3      ubuntu16.04
ffmpeg       golang       java8        php7.2       rust

kaixinguo@ubuntu:~$ tool-activate ffmpeg

(ffmpeg) kaixinguo@ubuntu:~$ which ffmpeg
/tmp/tmp.dU5l6OH5zz/ffmpeg

(ffmpeg) kaixinguo@ubuntu:~$ cat /tmp/tmp.dU5l6OH5zz/ffmpeg
#!/bin/sh
docker run --rm -it \
    -v "$HOME/dc/home":"/root" \
    -v "$HOME/.dotfiles":"/root/.dotfiles" \
    -v "${RUN_ROOT_DIR:-$PWD}":"${RUN_ROOT_DIR:-$PWD}" \
    -w "$PWD" \
    $(env | sed -E \
        -e '/^[A-Za-z0-9_]+=.*$/!d' \
        -e 's/^([A-Za-z0-9_]+)=.*$/\1/g' \
        -e "/^(PATH|HOME|PWD|TERM|TERMCAP|SHELL|USER)$/d" \
        -e 's/^/-e /g'
    ) \
    "linuxserver/ffmpeg:latest" \
    "$(basename "$0" | sed "s/^enter-ffmpeg$/sh/g")" \
    "$@"

(ffmpeg) kaixinguo@ubuntu:~$ ffmpeg -version
Unable to find image 'linuxserver/ffmpeg:latest' locally
latest: Pulling from linuxserver/ffmpeg
d2f83cd07e8a: Pull complete
665a26860e09: Pull complete
a51681ef853e: Pull complete
94601407af37: Pull complete
73482616b689: Pull complete
7a98b855f994: Pull complete
8bf78fee0913: Pull complete
a952264701dc: Pull complete
Digest: sha256:0c4e33c9a7fd886f6e9c35b5a198766481d006982244ac23251538f7a7124406
Status: Downloaded newer image for linuxserver/ffmpeg:latest
ffmpeg version 5.1.2 Copyright (c) 2000-2022 the FFmpeg developers
built with gcc 11 (Ubuntu 11.3.0-1ubuntu1~22.04)
configuration: --disable-debug --disable-doc --disable-ffplay --enable-ffprobe --enable-cuvid --enable-gpl --enable-libaom --enable-libass --enable-libfdk_aac --enable-libfreetype --enable-libkvazaar --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-libopus --enable-libtheora --enable-libv4l2 --enable-libvidstab --enable-libvmaf --enable-libvorbis --enable-libvpx --enable-libxml2 --enable-libx264 --enable-libx265 --enable-libxvid --enable-nonfree --enable-nvdec --enable-nvenc --enable-opencl --enable-openssl --enable-small --enable-stripping --enable-vaapi --enable-vdpau --enable-version3
libavutil      57. 28.100 / 57. 28.100
libavcodec     59. 37.100 / 59. 37.100
libavformat    59. 27.100 / 59. 27.100
libavdevice    59.  7.100 / 59.  7.100
libavfilter     8. 44.100 /  8. 44.100
libswscale      6.  7.100 /  6.  7.100
libswresample   4.  7.100 /  4.  7.100
libpostproc    56.  6.100 / 56.  6.100

(ffmpeg) kaixinguo@ubuntu:~$ exit

kaixinguo@ubuntu:~$ ffmpeg
ffmpeg: command not found

kaixinguo@ubuntu:~$ ls /tmp/tmp.dU5l6OH5zz/
ls: cannot access '/tmp/tmp.dU5l6OH5zz/': No such file or directory

```

### epack

```bash
Usage; epack <command> <arguments>...
Encryption package generator

Commands
  gen <target>  generate a empty encryption package
                use './path_to_pack' to view existing package
                use './path_to_pack -e' to edit existing package
  lite <target> generate a read-only package
                read-only package don't have -e flag
  edit <pack>   edit an existing package
                [Warn] edit package will cover the original data!
  help          print this help info

Use 'rm -rf /' to remove all the trouble.
Use 'shutdown -h now' to have a happy day.
```

### bat-wrap

```
Usage: bat-wrap WSL_CMD [BAT_CMD(default: =WSL_CMD)]

Wrapping a WSL command as .bat script.
Then, you can use them in powershell.exe or cmd.exe.

Example:

    # Print this help info
    bat-wrap --help

    # Wrap WSL command 'cat' to .bat script 'cat.bat'
    bat-wrap cat

    # Change the name of generated script (example: 'wsl_cat.bat')
    bat-wrap cat wsl_cat

    # By default, the script will be generated in the current working directory.
    # Change this location by define the env 'BAT_WRAP_LOCATION' (example: '~/wsl-tools')
    BAT_WRAP_LOCATION=~/wsl-tools bat-wrap cat

    # Generated script will auto change all '\' in args to '/', but keep '\\' as '\'.
    C:\> cat.bat ".\test\test.sh"  ==>  $ cat "./test/test.sh"
    C:\> printf.bat "hello\\n"     ==>  $ printf "hello\n"

```

### cvs

```
Usage: csv FILE LINE [COLUMN]
Extract data from csv file
```

