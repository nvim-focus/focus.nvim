if exists('g:loaded_focus') | finish | endif

silent lua require 'focus'.focus_init()

let g:loaded_focus = 1

