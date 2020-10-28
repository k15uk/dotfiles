scriptencoding utf-8

"インデント
set shiftwidth=2
set tabstop=2
set softtabstop=2
set autoindent
set smartindent

set textwidth=0 "自動改行の回避

"ファイルフォーマット
set fileencodings=utf-8
set fileencoding=utf-8

"キー待ち受け時間
set timeout
set timeoutlen=300
set ttimeout
set ttimeoutlen=200

set ignorecase "大文字小文字の区別なし
set number "行番号をつける

set laststatus=2 "常にステイタスバーを表示
set hlsearch
set mouse=a "マウスの使用可
set lazyredraw "コマンド実行中の再描画を行わない
set ttyfast
set hidden "バッファ切り替え時に隠す（メモリ解放をしない）
set clipboard+=unnamedplus
set viminfo='100,<1000,s100,h,n~/.config/nvim/viminfo
set noswapfile "スワップファイルをつくらない
set shell=zsh " shellはzsh使用
set splitbelow " プレビューウィンドウを下に
set ambiwidth=double
set expandtab " スペースによるタブがデフォルト

set inccommand=split
set showmatch " 括弧閉じる際、対応する開き括弧をハイライト

set cursorline

set autoread

set wildmenu
set wildmode=full " 補完時のタブキー押下ごとに次の候補を補完する

if has ( 'persistent_undo' )
  set undodir=~/.config/nvim/undo
  set undofile
endif
