if exists('g:loaded_focus') | finish | endif

let g:loaded_focus = 1 "Don't Reload Twice"
let g:enabled_focus = 1

"A vim best practise
let s:save_cpo = &cpo
set cpo&vim

"Export commands so we can do :DisableFocus etc
command! -nargs=0 DisableFocus call DisableFocus()
command! -nargs=0 EnableFocus call EnableFocus()
command! -nargs=0 ToggleFocus call ToggleFocus()
command! -nargs=0 FocusSplitNicely lua require('focus').split_nicely()

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

function! EnableFocus() abort
    if g:enabled_focus == 1
        return
    else
        let g:enabled_focus = 1
        runtime autoload/focus.vim
endif
endfunction

function! ToggleFocus() abort
    if g:enabled_focus == 0
        call EnableFocus()
        return
    else
        let g:enabled_focus = 1
        call DisableFocus()
endif
endfunction


"So that we can resize windows such as NvimTree correctly, we run init when we
"open a buffer
au BufEnter,WinEnter NvimTree lua require'focus'.init()

"don't require our files until we need them, hopefully it prevents lua file being
"loaded if we run vim with focus disabled i.e `nvim +DisableFocus`
if g:enabled_focus == 1
runtime autoload/focus.vim
endif



let &cpo = s:save_cpo
unlet s:save_cpo
