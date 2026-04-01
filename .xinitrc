#!/bin/sh

prefix="/usr"
exec_prefix="${prefix}"
xrdb="xrdb"
xinitdir="/etc/X11/xinit"
xmodmap="xmodmap"
xmonad="~/.local/bin/xmonad"

userresources="$HOME/.Xresources"
usermodmap="$HOME/.Xmodmap"
sysresources="$xinitdir/.Xresources"
sysmodmap="$xinitdir/.Xmodmap"

# merge in defaults and keymaps

if [ -f "$sysresources" ]; then
  if [ -x /usr/bin/cpp ] ; then
    "$xrdb" -merge "$sysresources"
  else
    "$xrdb" -nocpp -merge "$sysresources"
  fi
fi

if [ -f "$sysmodmap" ]; then
  "$xmodmap" "$sysmodmap"
fi

if [ -f "$userresources" ]; then
  if [ -x /usr/bin/cpp ] ; then
    "$xrdb" -merge "$userresources"
  else
    "$xrdb" -nocpp -merge "$userresources"
  fi
fi

if [ -f "$usermodmap" ]; then
  "$xmodmap" "$usermodmap"
fi

# start some nice programs

if [ -d "$xinitdir"/xinitrc.d ] ; then
  for f in "$xinitdir/xinitrc.d"/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Disables the "Middle Click" button (2) on the bottom
# Of the touchpad and maps it left-click (1) instead
# I kept middle clicking when intending to left click
# And the upper physical left/middle/right buttons
# Are still available and on a different xinput device.
xinput set-button-map 10 1 1 3 4 5 6 7
# Decreases delay and increase rate for held buttons repeating
xset r rate 200 25;

exec "$xmonad";
