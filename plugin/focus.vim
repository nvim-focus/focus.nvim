if exists('g:loaded_focus') | finish | endif

let g:loaded_focus = 1 "Don't Reload Twice"
let g:enabled_focus = 1

"A vim best practise
let s:save_cpo = &cpo
set cpo&vim


"hopefully focus is not loaded if we run vim with focus disabled i.e `nvim +DisableFocus`
if g:enabled_focus == 1
    runtime autoload/focus.vim
endif



let &cpo = s:save_cpo
unlet s:save_cpo
