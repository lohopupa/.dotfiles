SELECTEL_SSH_CONFIG_FILE="/home/lohopupa/.ssh/selectel/config"

CONFIG_TEMPLATE="Host selectel
  HostName %s
  User root
  IdentityFile ~/.ssh/selectel/selectel
"

is_valid_ip() {
    [[ $1 =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] && return 0
    return 1
}

update_selectel_host() {
  if is_valid_ip "$1"; then
    printf $CONFIG_TEMPLATE $1 > $SELECTEL_SSH_CONFIG_FILE
  else
      echo "Invalid IP address: $1"
  fi
}
