[[ -z "$GG_FILE" ]] && GG_FILE=~/.go_file

gg() {
  if [ -z "$1" ]; then
    local selected_package
    selected_package=$(cat "$GG_FILE" | sort -u | fzf)
    if [ -n "$selected_package" ]; then
    go get "$selected_package" 2>/dev/null
    fi
  else
    go get "$1" 2>/dev/null
    echo "$1" >> "$GG_FILE"
  fi
}