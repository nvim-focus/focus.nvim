if exists('g:loaded_focus') | finish | endif

let g:loaded_focus = 1 "Don't Reload Twice"
let g:enabled_focus = 1

"A vim best practise
let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 DisableFocus echo "Deprecated -> Use :FocusDisable"
command! -nargs=0 EnableFocus echo "Deprecated -> Use :FocusEnable"
command! -nargs=0 ToggleFocus echo "Deprecated -> Use :FocusToggle"


"Export commands so we can do :DisableFocus etc
command! -nargs=0 FocusDisable call FocusDisable()
command! -nargs=0 FocusEnable call FocusEnable()
command! -nargs=0 FocusToggle call FocusToggle()
command! -nargs=0 FocusSplitNicely lua require('focus').split_nicely()
command! -nargs=0 FocusSplitLeft lua require('focus').split_command("h")
command! -nargs=0 FocusSplitDown lua require('focus').split_command("j")
command! -nargs=0 FocusSplitUp lua require('focus').split_command("k")
command! -nargs=0 FocusSplitRight lua require('focus').split_command("l")


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
