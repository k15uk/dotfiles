scriptencoding utf-8

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
