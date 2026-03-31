#
# ~/.bashrc
#

export PATH="$PATH:/home/ahaskell/.local/share/JetBrains/Toolbox/scripts";

export DOTNET_ROOT="/home/ahaskell/.dotnet";
export PATH="$PATH:$DOTNET_ROOT";
export PATH="$PATH:$DOTNET_ROOT/tools";

# If not running interactively, don't do anything
[[ $- != *i* ]] && return;

alias please='sudo -E -s';
alias ls='ls --color=auto';
alias grep='grep --color=auto';

alias e='nvim';
alias v='nvim';
alias vi='nvim';
alias vim='nvim';

alias top='htop';

alias f='ranger';
alias img='feh --auto-zoom --scale-down';

PS1='[\u@\h \W]\$ ';
eval "$(starship init bash)";
