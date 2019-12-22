unbind-key -n C-a
unbind-key -n C-k

bind k split-window -c "#{pane_current_path}" \; swap-pane -s :. -t :.- \; select-pane -t :.-
bind j split-window -c "#{pane_current_path}"
bind l split-window -h -c "#{pane_current_path}"
bind h split-window -h -c "#{pane_current_path}" \; swap-pane -s :. -t :.- \; select-pane -t :.-

bind -n C-right select-pane -R
bind -n C-left  select-pane -L
bind -n C-up    select-pane -U
bind -n C-down  select-pane -D

bind -n M-, next-window
bind -n M-. previous-window

bind -n M-Tab select-pane -t :.+

bind x kill-pane

bind -n S-right resize-pane -R
bind -n S-left  resize-pane -L
bind -n S-up    resize-pane -U
bind -n S-down  resize-pane -D

#コピーモードの設定--------------------------------
#キーバインドをviにする
setw -g mode-keys vi
bind-key -T copy-mode-vi v send-keys -X begin-selection
#tmuxのbufferとxのclipboardを連携させる
bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "xsel -ip && xsel -op | xsel -ib"
bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel "xsel -ip && xsel -op | xsel -ib"

unbind-key -n C-f
set -g prefix ^F
set -g prefix2 F12
bind f send-prefix
