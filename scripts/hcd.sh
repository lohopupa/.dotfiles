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
