#!/bin/bash

input=$(cat - | xargs)

pane_dir=$(tmux display-message -p -F "#{pane_current_path}")

file=$(echo "$input" | cut -d':' -f1)
line=$(echo "$input" | cut -d':' -f2)
column=$(echo "$input" | cut -d':' -f3)

code -g "$pane_dir/$file:$line:$column"
