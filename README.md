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

## TODO

*To be continued...*
