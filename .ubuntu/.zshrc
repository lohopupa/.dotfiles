# ========================
# Basic Configuration
# ========================
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
export EDITOR=nvim
ZSH_THEME="agnoster"

# ========================
# Oh-My-Zsh Configuration
# ========================
zstyle ':omz:update' mode auto
# plugins=(zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

# ========================
# Aliases
# ========================
alias sl=ls
alias rz='source ~/.zshrc && echo ".zsrc reloaded"'
alias md='mkdir -p'
alias ff='find . -type f -iname'


# mdc() {
#   mkdir $1 && cd $1
# }

# scr() {
#   session=$(screen -ls | awk '/\t/ {print $1}' | cut -d '.' -f 2 | fzf --print-query -q "$1" | tail -n 1)
#   [ -n "$session" ] && screen -R "$session"
# }


# prompt_dir() {
#   local path_length=50
#   local short_path
#   if [[ ${#PWD} -gt $path_length ]]; then
#     short_path=$(echo ${PWD/#$HOME/\~} | awk -F'/' '{for(i=1;i<NF;i++) printf "%s/",substr($i,1,1); print $NF}')
#   else
#     short_path=${PWD/#$HOME/\~}
#   fi
#   prompt_segment blue $CURRENT_FG "$short_path"
# }

# # Pre-command Hook
# precmd() {
#   screen_title="${STY##*.}"
#   if [[ -n "$STY" && "$PROMPT" != *"[$screen_title]"* ]]; then
#     PROMPT="%{$fg[blue]%}[$screen_title]%{$reset_color%} $PROMPT"
#   fi
# }
