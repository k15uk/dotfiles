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

syntax enable "シンタックス有効
colorscheme zenburn

" 背景色の設定
set background=dark
set termguicolors

highlight Normal      ctermbg=none guibg=none
highlight NormalNC    ctermbg=238  guibg=238
highlight NonText     ctermbg=none guibg=none
highlight LineNr      ctermbg=none guibg=none
highlight Folded      ctermbg=none guibg=none
highlight EndOfBuffer ctermbg=none guibg=none
highlight Visual      term=reverse cterm=reverse
highlight IndentGuidesOdd  ctermbg=240
highlight IndentGuidesEven ctermbg=238

" 閉じた後でもundoする
if has ( 'persistent_undo' )
  set undodir=~/.config/nvim/undo
  set undofile
endif

" #######################
" # indent space or tab #
" #######################
augroup indentSpaceTab
  autocmd!
  autocmd FileType pug set noexpandtab
augroup END

augroup phpTabStop
  autocmd!
  autocmd FileType php call SetPhpOptions()
augroup END

function! SetPhpOptions()
  set shiftwidth=4
  set tabstop=4
  set softtabstop=4
endfunction

" clean plugins
function! Clean_plugins()
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endfunction

" ##########
" ## 端末 ##
" ##########

" 端末を開く
function! ToggleTerminal()
	if bufexists('terminal')
    bw! terminal
    return
	endif
  split
  enew
  terminal
	execute ':f terminal'
  startinsert
endfunction

augroup terminal
  autocmd TermOpen * setlocal norelativenumber
  autocmd TermOpen * setlocal nonumber
  autocmd TermClose * call feedkeys('\<CR>' )
augroup END

nnoremap <silent><M-CR> :call ToggleTerminal()<CR>
tnoremap <silent><M-CR> <C-\><C-n>:call ToggleTerminal()<CR>

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

" ウインドウの移動のモード差異をなくす
inoremap <C-w> <Esc><C-w>
tnoremap <C-w> <C-\><C-n><C-w>

" disable commandline window
nnoremap q: <nop>
nnoremap Q <nop>

nnoremap II :<C-u>edit $MYVIMRC<CR>

" コマンド補完で上下キー押下時、補完候補を移動する
cnoremap <expr><Down> pumvisible() ? "<C-n>" : "<Down>"
cnoremap <expr><Up> pumvisible() ? "<C-p>" : "<Up>"

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
