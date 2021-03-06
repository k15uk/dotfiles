scriptencoding utf-8

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

filetype plugin indent on " ファイルタイプ識別をオン
