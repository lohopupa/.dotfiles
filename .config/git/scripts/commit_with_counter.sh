#!/bin/bash

type="$1"
shift

count=$(git config --local --get counters."$type")
count=${count:-0}
next=$((count + 1))
prefix=""

case "$type" in
  bug) prefix="Fixed bug" ;;
  feature) prefix="Added feature" ;;
  chore) prefix="Performed chore" ;;
  test) prefix="Testing code" ;;
  deploy) prefix="DEPLOY" ;;
  ci) prefix="Test CI" ;;
  *) echo "Unknown type: $type" >&2; exit 1 ;;
esac

msg="$prefix #$next"
if [[ -n "$1" ]]; then
  msg="$msg: $*"
fi

if git commit -m "$msg"; then
  git config --local counters."$type" "$next"
fi
