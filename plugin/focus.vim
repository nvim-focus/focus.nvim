if exists('g:loaded_focus') | finish | endif

let g:loaded_focus = 1 "Don't Reload Twice"
let g:enabled_focus = 1

"A vim best practise
let s:save_cpo = &cpo
set cpo&vim


function! FocusDisable() abort
    if g:enabled_focus == 0
        return
    else
        let g:enabled_focus = 0
        "Return win width to default to prevent it from resizing after disable
        lua vim.o.winminwidth = 0
        lua vim.o.winwidth = 20
        lua vim.o.winminheight = 1
        lua vim.o.winheight = 1
        "normalise the splits back evenly
        wincmd=
    endif
endfunction

function! FocusEnable() abort
    if g:enabled_focus == 1
        return
    else
        let g:enabled_focus = 1
        runtime autoload/focus.vim
    endif
endfunction

function! FocusToggle() abort
    if g:enabled_focus == 0
        call FocusEnable()
        return
    else
        call FocusDisable()
    endif
endfunction



"hopefully focus is not loaded if we run vim with focus disabled i.e `nvim +DisableFocus`
if g:enabled_focus == 1
    runtime autoload/focus.vim
endif



let &cpo = s:save_cpo
unlet s:save_cpo
