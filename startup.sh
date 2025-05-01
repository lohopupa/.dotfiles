#!/usr/bin/bash

google-chrome-stable &
spotify &
telegram-desktop &
wezterm &

disown -a

sudo modprobe k10temp