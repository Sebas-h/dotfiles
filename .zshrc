# Enable starship prompt
eval "$(starship init zsh)"

# Set common useful aliases
# alias l='ls -alG'
# alias l='gls -l -a --color -h --group-directories-first'
alias l='exa -la --group-directories-first'
alias gs='git status -sb'

alias sz='source $HOME/.zshrc'                          # source '.zshrc'

alias v='nvim'
alias ev='nvim $HOME/.config/nvim/init.vim'             # edit (neo)vim conifg
alias ez='nvim $HOME/.zshrc'                            # edit zshrc config
alias etm='nvim $HOME/.tmux.conf'                       # edit tmux config
alias ea='nvim $HOME/.config/alacritty/alacritty.yml'   # edit tmux config

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias cat='bat'

# in alacritty LC_CTYPE is not set (necessary for starship prompt in tmux)
export LC_CTYPE="UTF-8"

# colorful man pages
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode – red
export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode – bold, magenta
export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode – yellow
export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode – cyan

# make ctrl-s and ctrl-q available in vim for mappings
# (https://superuser.com/questions/588846/cannot-get-vim-to-remap-ctrls-to-w)
stty -ixon

################################################################################
# Luke's config for the Zoomer Shell
################################################################################
# Enable colors and change prompt:
autoload -U colors && colors
setopt autocd		# Automatically cd into typed directory.
# PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
# Basic auto/tab complete:
autoload -Uz compinit promptinit
compinit
promptinit
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)   # Include hidden files.
setopt COMPLETE_ALIASES # For autocompletion of command line switches for aliases

################################################################################
# PATH
################################################################################
typeset -U PATH path
path=("$HOME/.local/bin" "$path[@]")
export PATH
