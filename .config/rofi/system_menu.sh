#!/bin/bash
# rofi_system_menu.sh / JennyM 2017 malkalech.com

list=(
  ##  Power ##
  "Suspend"     "sudo systemctl suspend"
  "Hibernate"   "sudo systemctl hibernate"
  "---------"   ""
  "---------"   ""
  "Reboot"      "sudo systemctl reboot"
  "Shutdown"    "sudo systemctl poweroff"
)

for (( i=1; i<=$((${#list[@]}/2)); i++ )); do
  [[ -z "$@" ]] && echo "${i}. ${list[$i*2-2]}" && continue
  [[ "$@" == "${i}. ${list[$i*2-2]}" ]] && command="${list[$i*2-1]}" && break
done
eval "${command:-:}"
