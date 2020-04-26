#!/bin/bash

function set_brightness() {
  brightness=$( xrandr --verbose | grep -i brightness | cut -f2 -d ' ' )
  xrandr --output HDMI-0 --brightness $(echo "scale=2;" $brightness + $1 | bc )
  pkill -SIGRTMIN+1 i3blocks
}

case "$BLOCK_BUTTON" in
  1) set_brightness -0.05;;
  2) xrandr --output HDMI-0 --brightness 1; pkill -SIGRTMIN+1 i3blocks ;;
  3) set_brightness +0.05;;
  4) set_brightness +0.05;;
  5) set_brightness -0.05;;
esac

echo $( xrandr --verbose | grep -i brightness | cut -f2 -d ' ' )
