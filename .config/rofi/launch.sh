#!/bin/bash
alpha="cc"   # opacity (00〜FF)

options=(
  -modi            "drun,system:~/.config/rofi/system_menu.sh,ssh"
  -show            "drun"
  -font            "Noto sans Mono CJK JP 12"
  -width           "100"
  -fullscreen      true
  -padding         "200"
  -lines           "8"
  -fixed-num-lines
  -hide-scrollbar
  -sidebar-mode

  ##  key bindings  ##
	-kb-remove-char-back  "BackSpace"
	-kb-move-char-back    "Control+b"
	-kb-move-char-forward "Control+f"
  -kb-cancel            "Escape,Control+g,Control+bracketleft,Control+c"
  -kb-mode-next         "Control+l,Right,Control+Tab"
  -kb-mode-previous     "Control+h,Left,Control+Shift+Tab"
  -kb-remove-to-eol     ""
  -kb-accept-entry      "Control+m,Return"
  -kb-row-down          "Control+j,Down"
  -kb-row-up            "Control+k,Up"

  #### color scheme
  -color-enabled   "true"
  ## window         bg                   border               separator
  -color-window    "argb:${alpha}040404, argb:${alpha}040404, argb:${alpha}458588"
  ## text & cursor  bg             fg                   bg (alt)       bg (highlight)       fg (highlight)
  -color-normal    "argb:00000000, argb:${alpha}458588, argb:00000000, argb:${alpha}076678, argb:${alpha}83a598"
  -color-active    "argb:00000000, argb:${alpha}689d6a, argb:00000000, argb:${alpha}427b58, argb:${alpha}8ec07c"
  -color-urgent    "argb:00000000, argb:${alpha}b16286, argb:00000000, argb:${alpha}8f3f71, argb:${alpha}d3869b"
)

rofi "$@" "${options[@]}"
