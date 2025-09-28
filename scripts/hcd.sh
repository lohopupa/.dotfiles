# TODO: add rankin paths by frequency

# Do not overwrite defined path
[[ -z "$CD_HISTORY_PATH" ]] && CD_HISTORY_PATH=~/.cd_history

cd() {
  builtin cd "$@" && pwd >> "$CD_HISTORY_PATH"
}

# Filter existing directories
_fed() {
  while IFS= read -r folder; do
    [ -d "$folder" ] && echo "$folder"
  done
}

# Unique directories
_ud() {
  declare -A seen
  result=()

  while IFS= read -r folder; do
    if [[ -z ${seen["$folder"]} ]]; then
      result+=("$folder")
      seen["$folder"]=1
    fi
  done

  printf "%s\n" "${result[@]}"
}

hcd() {
  local dir
  if [[ ! -f "$CD_HISTORY_PATH" ]]; then
    echo "Error: $CD_HISTORY_PATH does not exist."
    return 1
  fi
  dir=$(tac "$CD_HISTORY_PATH" | _ud | _fed | fzf --tmux -q "$1")
  if [[ -n $dir ]]; then
    cd "$dir"
  fi
}

# hcd() {
#   local dir
#   echo "[$(date +%s%3N)] TAC" >&2
#   tac "$CD_HISTORY_PATH" > /tmp/hcd.1
#   echo "[$(date +%s%3N)] _ud" >&2
#   _ud < /tmp/hcd.1 > /tmp/hcd.2
#   echo "[$(date +%s%3N)] _fed" >&2
#   _fed < /tmp/hcd.2 > /tmp/hcd.3
#   echo "[$(date +%s%3N)] FZF" >&2
#   dir=$(fzf --tmux -q "$1" < /tmp/hcd.3)
#   echo "[$(date +%s%3N)] END" >&2
#   [[ -n $dir ]] && cd "$dir"
# }

# hc() {
#   local dir
#   if [[ ! -f "$CD_HISTORY_PATH" ]]; then
#     echo "Error: $CD_HISTORY_PATH does not exist."
#     return 1
#   fi
#   dir=$(tac "$CD_HISTORY_PATH" | _ud | _fed | fzf --tmux -q "$1")
#   if [[ -n $dir ]]; then
#     echo "$dir"
#   fi
# }