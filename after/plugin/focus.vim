if exists('g:loaded_focus') | finish | endif

let g:loaded_focus = 1 "Don't Reload Twice"
let g:enabled_focus = 1

"A vim best practise
let s:save_cpo = &cpo
set cpo&vim

"Adding command do DISABLE focus.
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
endif
endfunction

"If we do not do on vimenter enabled_focus will not be read
au VimEnter * call v:lua.require('focus').init()



let &cpo = s:save_cpo
unlet s:save_cpo
