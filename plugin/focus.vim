if exists('g:loaded_focus') | finish | endif

let g:loaded_focus = 1 "Don't Reload Twice"
let g:enabled_focus = 1 "Focus is enabled when setup is run, we use this var to enable/disable/toggle

"A vim best practise
let s:save_cpo = &cpo
set cpo&vim

let &cpo = s:save_cpo
unlet s:save_cpo
