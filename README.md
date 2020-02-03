# VIM Configuration

## Usage

requirement: bash, awk, mercurial(hg), git

### linux/unix

1. Clone to specify direcotry, e.g. `~/.vim`

```sh
hg clone https://bitbucket.org/zbinlin/vim ~/.vim
```

2. Before vim **7.3.1178**, you need create a vimrc file `~/.vimrc`, added the follow content:

```.vimrc
:source ~/.vim/vimrc
```

### Windows

**TODO**


**NOTE:**
*tern_for_vim* plugin require *npm* and *node*, when you cloned,
you should run `npm install` in *$VIM/vimfiles/bundle/45-tern_for_vim*.

*LanguageClient-neovim* plugin require *rust* and *cargo*, when you cloned,
you should run `make release` in *$VIM/vimfiles/bundle/45-lc*
