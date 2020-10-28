scriptencoding utf-8

" wの誤爆でWがWqを補完して閉じることへの対策
command! -nargs=0 W w

" 入力モード中に素早くJJ/KKと入力した場合はESCとみなす
inoremap kk <Esc>
inoremap jj <Esc>

" Escの2回押しでハイライト消去
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>

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

