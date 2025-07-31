[[ -z "$VENVS_FOLDER" ]] && VENVS_FOLDER=~/.python-envs

[ -d $VENVS_FOLDER ] || mkdir -p $VENVS_FOLDER

DEFAULT_ENV=default

env-path(){
    echo "$VENVS_FOLDER/$1"
}

DEFAULT_ENV_PATH=$(env-path $DEFAULT_ENV)

[ -d $DEFAULT_ENV_PATH ] || python -m venv $DEFAULT_ENV_PATH


venv() {
  env="${1:-$DEFAULT_ENV}"
  env_path=$(env-path $env)
  if [[ ! -d $env_path ]]; then
    echo "Environment doesnt exists"
    return -1
  fi
  source "$env_path/bin/activate"
}

venvs(){
    ls $VENVS_FOLDER
}


# TODO: 
# - [ ] create venvs