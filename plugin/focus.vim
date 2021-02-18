if exists('g:loaded_focus') | finish | endif

let g:loaded_focus = 1 "Don't Reload Twice"
let g:enabled_focus = 1

"A vim best practise
let s:save_cpo = &cpo
set cpo&vim

"Adding command to DISABLE focus.
"TODO--> [beauwilliams] --> Add hot toggling. The issue is, how do we know
"what size to normalise the splits back to? If we run DisableToggle before
"setting up spilts we are all good. Need to think about what to do when splits
"already maximised. Perhaps decide on default width + height to return them to
"but that is screen size dependent. Maybe store screen sizes but idk..
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

runtime autoload/focus.vim



let &cpo = s:save_cpo
unlet s:save_cpo
