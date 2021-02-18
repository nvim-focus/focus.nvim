if exists('g:loaded_focus') | finish | endif

let g:loaded_focus = 1 "Don't Reload Twice"
let g:enabled_focus = 1

"A vim best practise
let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 DisableFocus call DisableFocus()

function! DisableFocus() abort
    if g:enabled_focus == 0
        return
    else
        let g:enabled_focus = 0
        "Return win width to default to prevent it from resizing after disable
        lua vim.o.winwidth = 20
        lua vim.o.winheight = 1
        "normalise the splits back evenly
        wincmd=
endif
endfunction

"don't require our files until we need them
runtime autoload/focus.vim



let &cpo = s:save_cpo
unlet s:save_cpo
