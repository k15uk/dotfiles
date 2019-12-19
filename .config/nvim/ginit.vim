if hostname() ==# 'cocco'
  call rpcnotify(1, 'Gui', 'Font', 'Cica 9')
else
  call rpcnotify(1, 'Gui', 'Font', 'Cica 12')
endif

call rpcnotify(1, 'Gui', 'Option', 'Popupmenu', 0)
call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
