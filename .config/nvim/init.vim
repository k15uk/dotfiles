set encoding=utf-8
scriptencoding utf-8

let mapleader="\<Space>"
" ########
" # dein #
" ########
"プラグイン読み込み完了までオフ
filetype off

let s:dein_dir = expand( '~/.config/nvim/dein/' )
let s:dein_repo_dir = s:dein_dir . 'repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory( s:dein_repo_dir )
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

if dein#load_state( s:dein_dir )
  call dein#begin( s:dein_dir )
  let s:dein_rc_dir = expand( '~/.config/nvim/' )
  let s:toml = s:dein_rc_dir . 'dein.toml'
  let s:lazy_toml = s:dein_rc_dir . 'lazy_dein.toml'

  call dein#load_toml( s:toml , { 'lazy' : 0 } )
  call dein#load_toml( s:lazy_toml , { 'lazy' : 1 } )

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype on

" ############
" # 基本設定 #
" ############
"インデント
set shiftwidth=2
set tabstop=2
set softtabstop=2
set autoindent

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
set showtabline=2 " 常にタブ表示
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
set cursorline

set inccommand=split

syntax enable "シンタックス有効
colorscheme zenburn

" 背景色の設定
set background=dark

set termguicolors

highlight Normal      ctermbg=black guibg=none
highlight NormalNC    ctermbg=233   guibg=gray8
highlight NonText     ctermbg=black guibg=none
highlight LineNr      ctermbg=black guibg=none
highlight Folded      ctermbg=black guibg=none
highlight EndOfBuffer ctermbg=black guibg=none
highlight CursorLine  ctermbg=233   guibg=gray8

" 閉じた後でもundoする
if has ( 'persistent_undo' )
  set undodir=~/.config/nvim/undo
  set undofile
endif

augroup VimWrapper
  " autocmd! VimWrapper VimEnter * execute 'RestoreSession'
  " autocmd! VimWrapper VimLeave * execute 'SaveSession'
augroup END

command! RestoreSession :source ~/.nvimSession
command! SaveSession    :mksession! ~/.nvimSession

" #######################
" # indent space or tab #
" #######################
augroup indentSpaceTab
  autocmd!
  autocmd FileType pug set noexpandtab
  autocmd FileType lua,coffee,vue,javascript,vim,toml,conf,go,python,java set expandtab
augroup END

" clean plugins
function! Clean_plugins()
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endfunction

" ############
" # keybinds #
" ############
" wの誤爆でWがWqを補完して閉じることへの対策
command! -nargs=0 W w

" 行移動を見た目どおりにする
nnoremap <silent>j gj
vnoremap <silent>j gj
nnoremap <silent>k gk
vnoremap <silent>k gk

" xでレジスタを汚さない
nnoremap x "_x
" 無効化
nnoremap s <Nop>
nnoremap <C-z> <Nop>

" ウインドウの移動
nnoremap <silent><C-h> :wincmd h<CR>
nnoremap <silent><C-j> :wincmd j<CR>
nnoremap <silent><C-k> :wincmd k<CR>
nnoremap <silent><C-l> :wincmd l<CR>

nnoremap <silent><Left>  :wincmd h<CR>
nnoremap <silent><Down>  :wincmd j<CR>
nnoremap <silent><Up>    :wincmd k<CR>
nnoremap <silent><Right> :wincmd l<CR>
nnoremap <silent>ww :wincmd w<CR>

nnoremap <silent><S-Left>  :wincmd h<CR>
nnoremap <silent><S-Down>  :wincmd j<CR>
nnoremap <silent><S-Up>    :wincmd k<CR>
nnoremap <silent><S-Right> :wincmd l<CR>

tnoremap <silent><S-Left>  <C-\><C-n>:wincmd h<CR>
tnoremap <silent><S-Down>  <C-\><C-n>:wincmd j<CR>
tnoremap <silent><S-Up>    <C-\><C-n>:wincmd k<CR>
tnoremap <silent><S-Right> <C-\><C-n>:wincmd l<CR>

" ウィンドウサイズの変更
nnoremap <silent>+ :wincmd ><CR>
nnoremap <silent>_ :wincmd <<CR>
nnoremap <silent>= :wincmd +<CR>
nnoremap <silent>- :wincmd -<CR>

" ウインドウを分割
nnoremap <silent>so :only<CR>
nnoremap <silent>sc :close<CR>

" ウインドウの移動のモード差異をなくす
inoremap <C-w> <Esc><C-w>
tnoremap <C-w> <C-\><C-n><C-w>

" disable commandline window
nnoremap q: <nop>
nnoremap Q <nop>

" 端末モードでのモード変更
tnoremap <Esc><Esc> <C-\><C-n>

" 端末クリックでの挿入モード解除対策
tnoremap <LeftRelease> <Nop>
nnoremap <expr> <LeftMouse> &buftype ==# 'terminal' ? '<cmd>startinsert<cr>' : ''
nnoremap <expr> <CR> &buftype ==# 'terminal' ? '<cmd>startinsert<cr>' : ''

" ##########
" # etc... #
" ##########
" auto reload .vimrc
augroup vimrcautoreload
  autocmd! BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END

augroup autoreload
  autocmd! BufWritePost *.md,*.uml,*.plantuml call s:autoreload()
augroup END

function! s:autoreload()
  let l:file_title = expand('%:t')
  let l:browser_title = system( 'xdotool search --onlyvisible --class chromium getwindowname' )
  let l:terminal = system( 'xdotool getactivewindow' )
  if match( l:browser_title, l:file_title . '.*' ) == -1
    execute '!chromium %'
  else
    call system( 'xdotool windowactivate $(xdotool search --onlyvisible --name chromium )' )
    call system( 'xdotool key --delay 60 ctrl+r' )
  endif
  call system( 'xdotool windowactivate ' . l:terminal )
endfunction

" カーソル位置の復元
augroup vimrcEx
  autocmd!  BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END

filetype plugin indent on " ファイルタイプ識別をオン
