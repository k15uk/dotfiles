scriptencoding utf-8

" 挿入モードでクリップボードからペーストする時に自動でインデントさせないようにする
if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" clean plugins
function! Clean_plugins()
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endfunction

" auto reload myvimrc
augroup vimrc_update
  " update init.vim
  autocmd! BufWritePost $MYVIMRC nested
    \ source $MYVIMRC

  " update init.d/*.vim
  autocmd! BufWritePost ~/.config/nvim/init.d/*.vim nested
    \ runtime! init.d/*.vim

  " update dein.toml
  autocmd! BufWritePost s:toml nested
    \ call dein#load_toml( s:toml , { 'lazy' : 0 } )
    \ call Clean_plugins()

  " update dein_lazy.toml
  autocmd! BufWritePost s:lazy_toml nested
    \ call dein#load_toml( s:lazy_toml , { 'lazy' : 1 } )
    \ call Clean_plugins()

  " カーソル位置の復元
  autocmd!  BufRead *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END
