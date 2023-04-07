local vim = vim
local M = {}

M.setup = function()
    vim.cmd([[
command! -nargs=0 FocusDisable lua require('focus').focus_disable()
command! -nargs=0 FocusEnable lua require('focus').focus_enable()
command! -nargs=0 FocusToggle lua require('focus').focus_toggle()
command! -nargs=0 FocusDisableWindow lua require('focus').focus_disable_window()
command! -nargs=0 FocusEnableWindow lua require('focus').focus_enable_window()
command! -nargs=0 FocusToggleWindow lua require('focus').focus_toggle_window()
command! -nargs=0 FocusGetDisabledWindows lua require('focus').focus_get_disabled_windows()
command! -nargs=0 FocusEqualise lua require('focus').focus_equalise()
command! -nargs=0 FocusMaximise lua require('focus').focus_maximise()
command! -nargs=0 FocusMaxOrEqual lua require('focus').focus_max_or_equal()
command! -nargs=? -complete=file FocusSplitNicely lua require('focus').split_nicely(<q-args>)
command! -nargs=? FocusSplitCycle lua require('focus').split_cycle(<q-args>)
command! -nargs=? -complete=file FocusSplitLeft lua require('focus').split_command("h", <q-args>)
command! -nargs=? -complete=file FocusSplitDown lua require('focus').split_command("j", <q-args>)
command! -nargs=? -complete=file FocusSplitUp lua require('focus').split_command("k", <q-args>)
command! -nargs=? -complete=file FocusSplitRight lua require('focus').split_command("l", <q-args>)
]])
end

return M
