# Basic Configuration
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim
ZSH_THEME="agnoster"

# ZSH Update Mode
zstyle ':omz:update' mode auto

# Plugins
plugins=(zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

# Sourcing Scripts
source $ZSH/oh-my-zsh.sh

for script in ~/scripts/*.sh; do
  source "$script"
done

bg[blue]='\e[48;2;20;157;252m'
source ~/.grc.zsh


# Aliases
alias ccat="/usr/bin/cat"
alias sl=ls
alias aeza="ssh aeza"
alias get='wget $(xclip -o)'
alias rz='source ~/.zshrc'

alias md='mkdir -p'
alias ff='find . -type f -iname'

NA_TOOLS=""

create_alias_if_exists() {
  local cmd=$1
  local alias_name=$2
  local alias_command=$3

  if command -v "$cmd" &> /dev/null; then
    alias "$alias_name"="$alias_command"
  else
    echo -e "$fg[red]Error:$reset_color Command $fg[yellow]$cmd$reset_color not found. Alias $fg[green]$alias_name$reset_color was not created.$reset_color" >&2
    if [[ ! " ${NA_TOOLS[@]} " =~ " $cmd " ]]; then
      NA_TOOLS+=("$cmd")
    fi
  fi
}

check_missing_tools() {
  if [[ ${#NA_TOOLS[@]} -gt 0 ]]; then
    echo -en "$fg[yellow]Missing tools:$reset_color"
    printf "$fg[blue]"
    printf "%s\n\t" "${NA_TOOLS[@]}"
    printf "$reset_color"
    echo -e "\r$fg[yellow]You can install them by running: $reset_color $fg[blue]yay -S \$NA_TOOLS $reset_color"
  fi
}

create_alias_if_exists "python" "py" "python"
create_alias_if_exists "python3" "pyserver" "python3 -m http.server"
create_alias_if_exists "git" "clone" 'git clone --depth=1 $(xclip -o)'
create_alias_if_exists "xclip" "copy" 'xclip -selection clipboard'
create_alias_if_exists "xclip" "past" 'xclip -selection clipboard -o'
create_alias_if_exists "bat" "cat" "bat"
create_alias_if_exists "eza" "ls" "eza --color=auto"
create_alias_if_exists "rg" "grep" "rg --color=auto"

check_missing_tools

rcode() {
  local entity
  entity="folder"
  
  while getopts "f" opt; do
    case $opt in
      f) entity="file" ;;
    esac
  done

  echo "select value from ItemTable where key like '%recent%';" | 
    sqlite3 ~/.config/Code/User/globalStorage/state.vscdb | 
    jq ".entries[] | select(.${entity}Uri != null) | .${entity}Uri" |
    fzf | 
    xargs -I {} code --${entity}-uri {}
}

mdc() {
  mkdir $1 && cd $1
}

# Custom Prompt Function
prompt_dir() {
  local path_length=50
  local short_path
  if [[ ${#PWD} -gt $path_length ]]; then
    short_path=$(echo ${PWD/#$HOME/\~} | awk -F'/' '{for(i=1;i<NF;i++) printf "%s/",substr($i,1,1); print $NF}')
  else
    short_path=${PWD/#$HOME/\~}
  fi
  prompt_segment blue $CURRENT_FG "$short_path"
}

# Pre-command Hook
precmd() {
  screen_title="s"
  if [[ -n "$STY" && "$PROMPT" != *"[$screen_title]"* ]]; then
    PROMPT="%{$fg[blue]%}[$screen_title]%{$reset_color%} $PROMPT"
  fi
}


export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
