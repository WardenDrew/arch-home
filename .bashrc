#
# ~/.bashrc
#

# Jebrains Scripts
export PATH="$PATH:/home/ahaskell/.local/share/JetBrains/Toolbox/scripts";

# DotNet
export DOTNET_ROOT="/home/ahaskell/.dotnet";
export PATH="$PATH:$DOTNET_ROOT";
export PATH="$PATH:$DOTNET_ROOT/tools";

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# If not running interactively, stop here
[[ $- != *i* ]] && return;

# Aliases
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
