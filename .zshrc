# ========================
# Basic Configuration
# ========================
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim
ZSH_THEME="agnoster"
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
# ========================
# Secrets
# ========================

if [ -e "~/.secrets.sh" ]; then
  source ~/.secrets.sh
fi

# ========================
# Oh-My-Zsh Configuration
# ========================

# ZSH_AUTOSUGGEST_STRATEGY=(history)
zstyle ':omz:update' mode auto
plugins=(zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# ========================
# Pyenv Configuration
# ========================
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"

# ========================
# Aliases
# ========================
alias kat="/usr/bin/cat"
alias sl=ls
alias get='wget $(xclip -o)'
alias rz='source ~/.zshrc && echo ".zsrc reloaded"'
alias md='mkdir -p'
alias ff='find . -type f -iname'
alias grepv='grep -Pn --vimgrep'
alias vim='nvim'
alias nano='nvim'
alias rc='rcode'
alias cod='code .'
alias games="sudo grub-reboot 'Windows Boot Manager (on /dev/nvme1n1p1)' && reboot"
alias df=duf
alias sss='/home/lohopupa/dev/cat-ssh/./script.sh'

# ========================
# External Scripts
# ========================
source ~/.grc.zsh
for script in ~/scripts/*.sh; do
  source "$script"
done

# ========================
# Ubuntu lab
# ========================

alias ubuntu='docker exec -it ubuntu-lab zsh'

reload-ubuntu() {
  docker kill ubuntu-lab
  docker rm ubuntu-lab
  # docker run --restart always -d --name ubuntu-lab ubuntu-lab tail -f /dev/null
  docker run --restart always -d --name ubuntu-lab -p 2222:22 ubuntu-lab
}

restart-ubuntu() {
  docker kill ubuntu-lab
  docker rm ubuntu-lab
  cd ~/.ubuntu
  docker build -t ubuntu-lab .
  # docker run --restart always -d --name ubuntu-lab ubuntu-lab tail -f /dev/null
  docker run --restart always -d --name ubuntu-lab -p 2222:22 ubuntu-lab
}
# ========================
# Missing Tools Checker
# ========================
NA_TOOLS=()

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

# ========================
# Functions
# ========================

rand-str() {
  length=${1:-15}

  head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c"$length"
}

rand-int() {
  length=${1:-5}

  head /dev/urandom | tr -dc '0-9' | head -c"$length"
}

tmuks() {
  tmux_session=$(tmux ls | fzf | cut -d':' -f1)
  [ -n "$tmux_session" ] && tmux a -t "$tmux_session"
}

path() {
  fp=$1
  dp=$(pwd)
  echo "$dp/$fp"
}

INT_PATH=$HOME/.int

next-int() {
  [[ -f "$INT_PATH" ]] || echo 0 > "$INT_PATH"
  CURRENT=$(<"$INT_PATH")
  CURRENT=$((CURRENT + 1))
  echo "$CURRENT" > "$INT_PATH"
  echo "$CURRENT"
}

reset-int() {
  echo 0 > "$INT_PATH"
}

tmuks() {
  dir_name=$(basename "$PWD")
  session_name="$dir_name"

  tmux has-session -t "$session_name" 2>/dev/null
  if [ $? -eq 0 ]; then
    tmux attach -t "$session_name"
    return
  fi

  tmux new-session -d -s "$session_name" -n docker
  tmux new-window -t "$session_name" -n shell

  [ -d backend ] && tmux new-window -t "$session_name" -n backend -c backend

  tmux select-window -t "$session_name":docker
  tmux attach -t "$session_name"
}


# Moved to /home/lohopupa/dev/rcode-python/main.py
#    probably need to add it here?

# rcode() {
#   local entity="folder"
#   while getopts "f" opt; do
#     case $opt in
#     f) entity="file" ;;
#     esac
#   done

#   echo "select value from ItemTable where key like '%recent%';" |
#     sqlite3 ~/.config/Code/User/globalStorage/state.vscdb |
#     jq ".entries[] | select(.${entity}Uri != null) | .${entity}Uri" |
#     fzf | xargs -I {} code --${entity}-uri {}
# }


# md() {
#   mkdir -p "$@"
# }

mdc() {
  mkdir $1 && cd $1
}

git() {
  case "$1" in
    log)
      shift
      command git log --graph --oneline --decorate --parents "$@"
      ;;
    commit)
      case "$2" in
        bug)
          shift 2
          command git bug "$*"
          ;;
        ft)
          shift 2
          command git ft "$*"
          ;;
        test)
          shift 2
          command git test "$*"
          ;;
        *)
          command git "$@"
          ;;
      esac
      ;;
    *)
      command git "$@"
      ;;
  esac
}



# ========================
# Prompt Customization
# ========================
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
export PATH="$HOME/go/bin:$PATH"
