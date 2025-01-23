[[ -z "$CMD_RUNNER_DATA" ]] && CMD_RUNNER_DATA=~/.cmd_runner_data.db

# Initialize the database if it doesn't exist
if [[ ! -f "$CMD_RUNNER_DATA" ]]; then
sqlite3 "$CMD_RUNNER_DATA" "CREATE TABLE commands (name TEXT, pwd TEXT, command TEXT, PRIMARY KEY (name, pwd));"
fi

cmd() {
  case "$1" in
    run)
      shift
      local selected_name
      if [[ -z "$1" ]]; then
        selected_name=$(_select_command_with_fzf) || return
      else
        selected_name="$1"
        shift
      fi
      _cmdrun "$selected_name" "$@"
      ;;
    add)
      shift
      if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: cmd add <name> \"<command>\""
      else
        _cmdadd "$1" "$2"
      fi
      ;;
    rm)
      shift
      if [[ -z "$1" ]]; then
        echo "Usage: cmd rm <name>"
      else
        _cmdrm "$1"
      fi
      ;;
    ls)
      shift
      _cmdls "$@"
      ;;
    cp | copy)
      shift
      if [[ -z "$1" ]]; then
        echo "Usage: cmd cp <source-directory> [command-name]"
      else
        _cmdcp "$1" "$2"
      fi
      ;;
    clear)
      _cmdclear      
      ;;
    help | --help | -h | *)
      _cmdhelp
      ;;
  esac
}

_cmdclear(){
    local pwd="$(pwd)"
    sqlite3 "$CMD_RUNNER_DATA" "DELETE FROM commands WHERE pwd = '$pwd';"
    echo "All commands for the current directory have been removed."
}

_cmdhelp(){
    echo "CMD: A simple command runner for managing and executing named commands in specific directories."
    echo
    echo "Usage: cmd <action> [args]"
    echo
    echo "Actions:"
    echo "  run <name>         Run the command with the given name in the current directory."
    echo "  add <name> \"<cmd>\" Add a new command or update an existing one."
    echo "  rm <name>          Remove the command with the given name in the current directory."
    echo "  clear              Remove all commands for the current directory."
    echo "  ls [-a|-f[filter]] List all commands in the current directory, optionally filtered by name."
    echo "  cp <source_dir> [name]   Copy all commands from <source_dir> to the current directory, or copy the specific command <name>."
    echo "  help               Show this help message."
    echo
    echo "This tool allows you to save, retrieve, and execute frequently used shell commands associated with the current directory."
    echo "Commands are stored in a lightweight SQLite database, tied to both their name and the current working directory (CWD)."
}

_cmdrun() {
  local name="$1"
  shift
  local pwd="$(pwd)"

  local command
  command=$(sqlite3 "$CMD_RUNNER_DATA" "SELECT command FROM commands WHERE name = '$name' AND pwd = '$pwd';")

  if [[ -n "$command" ]]; then
    eval "$command $*"
  else
    echo "Command with name '$name' not found for the current directory."
  fi
}

_cmdadd() {
  local name="$1"
  local command="$2"
  local pwd="$(pwd)"

  sqlite3 "$CMD_RUNNER_DATA" "INSERT OR REPLACE INTO commands (name, pwd, command) VALUES ('$name', '$pwd', '$command');"
  echo "Command '$name' added/updated successfully."
}

_cmdrm() {
  local name="$1"
  local pwd="$(pwd)"

  local rows_affected=$(sqlite3 "$CMD_RUNNER_DATA" "DELETE FROM commands WHERE name = '$name' AND pwd = '$pwd'; SELECT changes();")

  if [[ "$rows_affected" -gt 0 ]]; then
    echo "Command '$name' removed successfully."
  else
    echo "Error: Command '$name' not found in the current directory."
  fi
}

_cmdls() {
  local option="$1"
  local query
  local pwd="$(pwd)"

  case "$option" in
    -a)
      # Show all commands with paths
      query="SELECT pwd, name, command FROM commands;"
      ;;
    -f)
      shift
      local filter="$1"
      if [[ -n "$filter" ]]; then
        query="SELECT name, command FROM commands WHERE pwd = '$pwd' AND name LIKE '%$filter%';"
      fi
      ;;
    *)
      query="SELECT name, command FROM commands WHERE pwd = '$pwd';"
      ;;
  esac

  sqlite3 "$CMD_RUNNER_DATA" "$query" | tr "|" "\t\t"

}



_cmdcp() {
  local source_dir="$1"
  local target_name="$2"
  local pwd="$(pwd)"

  if [[ ! -d "$source_dir" ]]; then
    echo "Error: Source directory '$source_dir' does not exist."
    return 1
  fi


  source_dir=$(realpath "$source_dir")

  if [[ -z "$target_name" ]]; then
    local commands
    commands=$(sqlite3 "$CMD_RUNNER_DATA" "SELECT name, command FROM commands WHERE pwd = '$source_dir';")
    if [[ -z "$commands" ]]; then
      echo "No commands found in the source directory."
      return 1
    fi
    
    while read -r command; do
      local name command_text
      name=$(echo "$command" | cut -d'|' -f1)
      command_text=$(echo "$command" | cut -d'|' -f2-)
      _cmdadd "$name" "$command_text" > /dev/null 2>&1
    done <<< "$commands"

    echo "All commands from '$source_dir' copied to the current directory."
  else
    local command
    command=$(sqlite3 "$CMD_RUNNER_DATA" "SELECT command FROM commands WHERE name = '$target_name' AND pwd = '$source_dir';")

    if [[ -z "$command" ]]; then
      echo "Error: Command '$target_name' not found in source directory '$source_dir'."
      return 1
    fi

    _cmdadd "$target_name" "$command"
    echo "Command '$target_name' copied from '$source_dir' to the current directory."
  fi
}

_select_command_with_fzf() {
  local pwd="$(pwd)"
  
  # Fetch all commands for the current directory
  local commands
  commands=$(sqlite3 "$CMD_RUNNER_DATA" "SELECT name || ': ' || command FROM commands WHERE pwd = '$pwd';")

  if [[ -z "$commands" ]]; then
    echo "No commands found for the current directory."
    return 1
  fi

  # Use fzf to select a command
  local selected
  selected=$(echo "$commands" | fzf-tmux --prompt="Select a command to run: ")

  if [[ -z "$selected" ]]; then
    echo "No command selected."
    return 1
  fi

  # Extract the name (before the colon) and return it
  echo "$selected" | cut -d':' -f1
  return 0
}