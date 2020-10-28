scriptencoding utf-8

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
