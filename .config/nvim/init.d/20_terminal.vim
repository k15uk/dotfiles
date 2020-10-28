scriptencoding utf-8

let g:terminal_color_background     = '#000000'
let g:terminal_color_foreground     = '#dcdccc'
let g:terminal_color_cursorColor    = '#ccffcc'
let g:terminal_color_colorUL        = '#dfaf8f'
let g:terminal_color_underlineColor = '#dfaf8f'
let g:terminal_color_0              = '#3f3f3f'
let g:terminal_color_1              = '#cc9393'
let g:terminal_color_2              = '#7f9f7f'
let g:terminal_color_3              = '#d0bf8f'
let g:terminal_color_4              = '#6ca0a3'
let g:terminal_color_5              = '#dc8cc3'
let g:terminal_color_6              = '#93e0e3'
let g:terminal_color_7              = '#dcdcdc'
let g:terminal_color_8              = '#686868'
let g:terminal_color_9              = '#dca3a3'
let g:terminal_color_10             = '#bfebbf'
let g:terminal_color_11             = '#f0dfaf'
let g:terminal_color_12             = '#8cd0d3'
let g:terminal_color_13             = '#dc8cc3'
let g:terminal_color_14             = '#93e0e3'
let g:terminal_color_15             = '#ffffff'

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
