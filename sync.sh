#!/bin/bash

# define dotfiles paths
nvim="$HOME/.config/nvim/init.vim"
zsh="$HOME/.zshrc"
tmux="$HOME/.tmux.conf"
alacritty="$HOME/.config/alacritty/alacritty.yml"
karabiner="$HOME/.config/karabiner/karabiner.json"
hammerspoon_init="$HOME/.hammerspoon/init.lua"
hammerspoon_hyper="$HOME/.hammerspoon/hyper_plus.lua"
starship="$HOME/.config/starship.toml"
firefox="$HOME/Library/Application\ Support/Firefox/Profiles/horx90mb.default-1555412934393/chrome/userChrome.css"

# current dotfiles dir
dotfilesdir="$HOME/projects/dotfiles"

# Declare an array of string with type
declare -a StringArray=("$nvim" "$zsh" "$tmux" "$alacritty" "$karabiner" "$hammerspoon_init" "$hammerspoon_hyper" "$starship" "$firefox")

# Iterate the string array using for loop
for val in "${StringArray[@]}"; do
    test -f $val && echo "OK -> $val"

    # remove old dotfile if exists
    [ -f $val ] && rm "$dotfilesdir/${val##*/}"
    # copy over new dotfile
    [ -f $val ] && cp "$val" "$dotfilesdir/${val##*/}"
done

