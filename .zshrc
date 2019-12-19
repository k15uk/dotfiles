## File Operation ##
autoload -U compinit
compinit -u
LISTMAX=1000
setopt auto_cd
setopt always_last_prompt # カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt auto_menu          # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys    # カッコの対応などを自動的に補完
setopt auto_param_slash   # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_pushd
setopt correctall
setopt globdots           # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt list_packed
setopt list_types         # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt magic_equal_subst  # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt mark_dirs          # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt nobeep
setopt print_eight_bit    #日本語ファイル名等8ビットを通す
setopt prompt_subst

unsetopt GLOB_DOTS

## plugins ##
# load zgen
source '/usr/share/zsh/share/zgen.zsh'
zgen load zsh-users/zsh-autosuggestions
zgen load zsh-users/zsh-completions
zgen load zsh-users/zsh-history-substring-search
zgen load tarruda/zsh-fuzzy-match
zgen load Tarrasch/zsh-bd

export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

if [ -f ~/.zsh/dircolors ]; then
    if type dircolors > /dev/null 2>&1; then
        eval $(dircolors ~/.zsh/dircolors)
    elif type gdircolors > /dev/null 2>&1; then
        eval $(gdircolors ~/.zsh/dircolors)
    fi
fi

zstyle ':completion:*:default' menu select=2
# 補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

# セパレータを設定する
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
zstyle ':completion:*' ignore-parents parent pwd ..

# 変数の添字を補完する
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

## PROMPT ##
autoload -U colors && colors

local prompt_color=""
if [[ -n "${REMOTEHOST}${SSH_CONNECTION}" ]]; then
  prompt_color="11"
else
  prompt_color="158"
fi

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
  export VISUAL="nvr -cc split --remote-wait +'setlocal bufhidden=wipe'"
  export GIT_EDITOR="nvr -cc split --remote-wait"
  export EDITOR="nvr"
  alias vi="nvr"
  alias vim="vi"
  alias nvim="vi"
  alias nvi="vi"
  alias v="vi"
fi

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
function _update_vcs_info_msg() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _update_vcs_info_msg

PROMPT="%F{$prompt_color}%B%n@%m% %b%f %F{231}%~%f%B%F{151}%1(v|%1v|)%f%b
 %(!.#.$)%  "
PROMPT2="%n> "
SPROMPT="%B%r is correct? [n,y,a,e]:%b "

RPROMPT="%F{217}%T%f"

## HISTORY ##
HISTFILE=~/.zsh/history
HISTSIZE=100000000
SAVEHIST=100000000
setopt extended_history
setopt hist_ignore_all_dups
setopt share_history    #share command history data
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
export PATH=$PATH:./node_modules/.bin/

## ALIAS COMMAND ##
setopt complete_aliases
alias ls="ls -F --color"
alias la="ls -a"
alias ll="la -lhtr"

export LC_ALL="ja_JP.UTF-8"
export LANG="ja_JP.UTF-8"
export GIT_MERGE_AUTOEDIT=no
export TERM=xterm-256color
export EDITOR='nvim'
export UNZIPOPT='-O CP932'

## fzf ##
alias fzf="fzf --ansi --height 40% --reverse --preview 'cat {}' --select-1 --exit-0 "
function fzf-history-selection() {
	BUFFER=`history -n 1 | tac | awk '!a[$0]++' | \fzf --reverse --select-1 --exit-0 `
	CURSOR=$#BUFFER
	zle reset-prompt
}

zle -N fzf-history-selection

bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey '^[[Z' reverse-menu-complete

#bindkey "^@" set-mark-command
bindkey "^A" beginning-of-line # this is default, important!
#bindkey "^B" backward-char
bindkey "^D" delete-char-or-list # this is default, important!
# ctrl-c important!
#bindkey "^E" end-of-line
#bindkey "^F" forward-char
#bindkey "^G" send-break
#bindkey "^H" backward-delete-char
bindkey -r "^H" # bind cursor key by window manager
#bindkey "^I" expand-or-complete
#bindkey "^J" accept-line
bindkey -r "^J" # bind cursor key by window manager
#bindkey "^K" kill-line
bindkey -r "^K" # bind cursor key by window manager
#bindkey "^L" clear-screen
bindkey -r "^L" # bind cursor key by window manager
#bindkey "^M" accept-line
#bindkey "^N" down-line-or-history
bindkey -r "^N" # bind backspace by window manager
#bindkey "^O" accept-line-and-down-history
#bindkey "^P" up-line-or-history
#bindkey "^Q" push-line
bindkey '^Q' fzf-history-selection
#bindkey "^R" history-incremental-search-backward
#bindkey "^S" history-incremental-search-forward
#bindkey "^T" fuzzy-match
#bindkey "^U" kill-whole-line
#bindkey "^V" quoted-insert
#bindkey "^W" backward-kill-word

## cd ##
function chpwd() { ls } #cdしたらls

## ctrl+s/ctrl+q disable ##
if [[ -t 0 ]]; then
  stty stop undef
  stty start undef
fi
